//
//  AppDelegate.m
//  悦宅云
//
//  Created by 尚广杰 on 2019/4/16.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import "AppDelegate.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "yzNavViewController.h"
#import "yzIndexViewController.h"
#import "BBChooseRootVC.h"
#import <CloudPushSDK/CloudPushSDK.h>
#import "yzMessageController.h"
#import <UserNotifications/UserNotifications.h>
#import "yzThroughRecordModel_Helper.h"
@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor whiteColor]];
//     [BBChooseRootVC chooseRootViewController];
    
    if ([yzUserInfoModel getisLogin] == YES) {
        yzIndexViewController *tabbar = [[yzIndexViewController alloc] init];
        yzNavViewController *nav = [[yzNavViewController alloc] initWithRootViewController:tabbar];
        self.window.rootViewController = nav;
    }else{
        yzLoginViewController *tabbar = [[yzLoginViewController alloc] init];
        yzNavViewController *nav = [[yzNavViewController alloc] initWithRootViewController:tabbar];
        self.window.rootViewController = nav;
    }

  
    [self.window makeKeyAndVisible];
    
   [yzThroughRecordModel_Helper getInstance];
    
    
    //高德地图
    [AMapServices sharedServices].apiKey = GDAppKey;
    [[AMapServices sharedServices] setEnableHTTPS:YES];
    
    
    [UMConfigure initWithAppkey:UMAppKey channel:@""];
    [self configUSharePlatforms];
    [self confitUShareSettings];
    
    
     [WXApi registerApp:WXAppKey];
    
    // APNs注册，获取deviceToken并上报
    [self registerAPNS:application];
    // 初始化SDK
    [self initCloudPush];
    // 监听推送通道打开动作
    [self listenerOnChannelOpened];
    // 监听推送消息到达
    [self registerMessageReceive];
    // 点击通知将App从关闭状态启动时，将通知打开回执上报
    // [CloudPushSDK handleLaunching:launchOptions];(Deprecated from v1.8.1)
    
   
    
    [CloudPushSDK sendNotificationAck:launchOptions];
    
    return YES;
}



- (void)initCloudPush {
    // SDK初始化
    
    [CloudPushSDK asyncInit:aLiAppKey appSecret:aLiAppSecret callback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"Push SDK init success, deviceId: %@.", [CloudPushSDK getDeviceId]);
            [CloudPushSDK bindAccount:[yzUserInfoModel getLoginUserInfo:@"mobile"] withCallback:^(CloudPushCallbackResult *res) {
                if (res.success) {
                    NSLog(@"绑定成功");
                }else{
                    NSLog(@"绑定失败");
                }
                
            }];
        } else {
            NSLog(@"Push SDK init failed, error: %@", res.error);
        }
    }];
    
   
}

/**
 *    注册苹果推送，获取deviceToken用于推送
 *
 *    @param     application
 */
- (void)registerAPNS:(UIApplication *)application {
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
//        // iOS 8 Notifications
//        [application registerUserNotificationSettings:
//         [UIUserNotificationSettings settingsForTypes:
//          (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
//                                           categories:nil]];
//        [application registerForRemoteNotifications];
//    }
//    else {
//        // iOS < 8 Notifications
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
//         (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
//    }
    
    /*
     注册通知(推送)
     申请App需要接受来自服务商提供推送消息
     */
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        //iOS10特有
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        // 必须写代理，不然无法监听通知的接收与点击
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                // 点击允许
                NSLog(@"注册成功");
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                    NSLog(@"%@", settings);
                }];
            } else {
                
                // 点击不允许
                NSLog(@"注册失败");
            }
        }];
    }else if ([[UIDevice currentDevice].systemVersion floatValue] >=8.0){
        //iOS8 - iOS10
        UIUserNotificationType types = (UIUserNotificationTypeAlert |
                                        UIUserNotificationTypeSound |
                                        UIUserNotificationTypeBadge);
        
        UIUserNotificationSettings *settings;
        settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
    }else if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
        //iOS8系统以下
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    }
    // 注册获得device Token
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
}
/*
 *  苹果推送注册成功回调，将苹果返回的deviceToken上传到CloudPush服务器
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"deviceToken==%@",deviceToken);
    [CloudPushSDK registerDevice:deviceToken withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"Register deviceToken success.");
        } else {
            NSLog(@"Register deviceToken failed, error: %@", res.error);
        }
    }];
}
/*
 *  苹果推送注册失败回调
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError %@", error);
}
/**
 *    注册推送消息到来监听
 */
- (void)registerMessageReceive {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onMessageReceived:)
                                                 name:@"CCPDidReceiveMessageNotification"
                                               object:nil];
}
#pragma mark Channel Opened
/**
 *    注册推送通道打开监听
 */
- (void)listenerOnChannelOpened {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onChannelOpened:)
                                                 name:@"CCPDidChannelConnectedSuccess"
                                               object:nil];
}
/**
 *    推送通道打开回调
 *
 *    @param     notification
 */
- (void)onChannelOpened:(NSNotification *)notification {
    NSLog(@"点击消息跳转页面==%@",notification.userInfo);
    
   
    

}
/**
 *    处理到来推送消息
 *
 *    @param     notification
 */
- (void)onMessageReceived:(NSNotification *)notification {
    CCPSysMessage *message = [notification object];
    NSString *title = [[NSString alloc] initWithData:message.title encoding:NSUTF8StringEncoding];
    NSString *body = [[NSString alloc] initWithData:message.body encoding:NSUTF8StringEncoding];
    NSLog(@"Receive message title: %@, content: %@.", title, body);
}

/*
 *  App处于启动状态时，通知打开回调
 */
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo {
    NSLog(@"Receive one notification.");
    // 取得APNS通知内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    // 内容
    NSString *content = [aps valueForKey:@"alert"];
    // badge数量
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue];
    // 播放声音
    NSString *sound = [aps valueForKey:@"sound"];
    // 取得Extras字段内容
    NSString *Extras = [userInfo valueForKey:@"Extras"]; //服务端中Extras字段，key是自己定义的
    NSLog(@"content = [%@], badge = [%ld], sound = [%@], Extras = [%@]", content, (long)badge, sound, Extras);
//    yzMessageController *_viewController =  [[yzMessageController alloc]init];
//    UINavigationController *nav= (UINavigationController *)self.window.rootViewController;
//    [nav pushViewController:_viewController animated:YES];
    // iOS badge 清0
    application.applicationIconBadgeNumber = 0;
    // 通知打开回执上报
    // [CloudPushSDK handleReceiveRemoteNotification:userInfo];(Deprecated from v1.8.1)
    [CloudPushSDK sendNotificationAck:userInfo];
    
   
    
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
//    yzMessageController *_viewController =  [[yzMessageController alloc]init];
//    UINavigationController *nav= (UINavigationController *)self.window.rootViewController;
//    [nav pushViewController:_viewController animated:YES];
//    application.applicationIconBadgeNumber = 0;
}

/**
 *  处理iOS 10通知(iOS 10+)
 */
- (void)handleiOS10Notification:(UNNotification *)notification {
    UNNotificationRequest *request = notification.request;
    UNNotificationContent *content = request.content;
    NSDictionary *userInfo = content.userInfo;
    // 通知时间
    NSDate *noticeDate = notification.date;
    // 标题
    NSString *title = content.title;
    // 副标题
    NSString *subtitle = content.subtitle;
    // 内容
    NSString *body = content.body;
    // 角标
    int badge = [content.badge intValue];
    // 取得通知自定义字段内容，例：获取key为"Extras"的内容
    NSString *extras = [userInfo valueForKey:@"Extras"];
    // 通知打开回执上报
    [CloudPushSDK handleReceiveRemoteNotification:userInfo];
    NSLog(@"Notification, date: %@, title: %@, subtitle: %@, body: %@, badge: %d, extras: %@.", noticeDate, title, subtitle, body, badge, extras);
}
/**
 *  App处于前台时收到通知(iOS 10+)
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSLog(@"Receive a notification in foregound.");
    // 处理iOS 10通知相关字段信息
    [self handleiOS10Notification:notification];
    // 通知不弹出
    //completionHandler(UNNotificationPresentationOptionNone);
    // 通知弹出，且带有声音、内容和角标（App处于前台时不建议弹出通知）
    completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge);
}















-(void)onResp:(BaseResp *)resp
{
    NSString *strMsg=[NSString stringWithFormat:@"errcode:%d  code:%d",resp.errCode,resp.errCode];
    NSString *strTitle;
    NSLog(@"respClass:%@",[resp class]);
    if ([resp isKindOfClass:[PayResp class]]) {
        strTitle=[NSString stringWithFormat:@"支付结果"];
        switch (resp.errCode) {
            case WXSuccess:{
                strMsg=@"支付结果：成功！";
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"ORDER_PAY_SUCCESSNOTIFICATION" object:@"success"];
                break;
            }
            case WXErrCodeUserCancel:{
                strMsg=@"用户取消支付";
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"ORDER_PAY_CANCEL" object:strMsg];
                break;
            }
                
            default:{
                strMsg=[NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@",resp.errCode,resp.errStr];
                
                NSLog(@"微信支付失败=%@",strMsg);
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"ORDER_PAY_NOTIFICATION" object:@"fail"];
                
                break;
            }
        }
    }
    if ([resp isKindOfClass:[SendAuthResp class]]) //判断是否为授权请求，否则与微信支付等功能发生冲突
    {
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (aresp.errCode== 0)
        {
            NSLog(@"code %@",aresp.code);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"wechatDidLoginNotification" object:self userInfo:@{@"code":aresp.code}];
        }
    }
    
    
}

- (void)confitUShareSettings
{
    
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
}
- (void)configUSharePlatforms
{
    /* 设置微信的appKey和appSecret */
    
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WXAppKey appSecret:WXAppSecret redirectURL:@"http://mobile.umeng.com/social"];
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
        NSLog(@"分享成功");
    }
    return result;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"%@",resultDic);
            NSNotification *notifacation = [[NSNotification alloc]initWithName:@"AlipaySDKYDD" object:nil userInfo:resultDic];
            [[NSNotificationCenter defaultCenter]postNotification:notifacation];

        }];
    }

    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode

        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"%@",resultDic);
            NSNotification *notifacation = [[NSNotification alloc]initWithName:@"AlipaySDKYDD" object:nil userInfo:resultDic];
            [[NSNotificationCenter defaultCenter]postNotification:notifacation];
            //       NSLog(@"result12 = %@",resultDic);
        }];
    }
    
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    //微信的支付回调
    if ([url.host isEqualToString:@"pay"]) {
        return [WXApi handleOpenURL:url delegate:(id<WXApiDelegate>)self];
    }
    
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
        
        NSLog(@"%@===%@",options,url);
    }else{
        NSLog(@"分享成功");
    }
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {

            NSLog(@"%@",resultDic);

            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSNotification *notifacation = [[NSNotification alloc]initWithName:@"AlipaySDKYDD" object:nil userInfo:resultDic];
            [[NSNotificationCenter defaultCenter]postNotification:notifacation];

        }];
    }

    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode

        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"%@",resultDic);
            NSNotification *notifacation = [[NSNotification alloc]initWithName:@"AlipaySDKYDD" object:nil userInfo:resultDic];
            [[NSNotificationCenter defaultCenter]postNotification:notifacation];
            //       NSLog(@"result12 = %@",resultDic);
        }];
    }
    

    
    return YES;
}
//- (BOOL)application:(UIApplication *)application
//shouldAllowExtensionPointIdentifier:(NSString *)extensionPointIdentifier
//{
//    if ([extensionPointIdentifier isEqualToString:@"com.apple.keyboard-service"]) {
//        return NO;
//    }
//    return YES;
//}

@end
