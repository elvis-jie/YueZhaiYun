//
//  yzNoticeViewController.m
//  yzProduct
//
//  Created by 尚广杰 on 2019/3/1.
//  Copyright © 2019 CC. All rights reserved.
//

#import "yzNoticeViewController.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <UShareUI/UShareUI.h>
@interface yzNoticeViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler,UIWebViewDelegate>
@property(nonatomic,strong)UILabel* titleLab;        //标题
@property(nonatomic,strong)UILabel* authorLab;       //作者
@property(nonatomic,strong)UILabel* timeLab;         //时间
@property(nonatomic,strong)UIWebView* webView;
@property(nonatomic,strong)NSString* shareUrl;
@end

@implementation yzNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
//     WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
//    //实例化对象
//    config.userContentController = [WKUserContentController new];
//    //调用JS方法
//    [config.userContentController addScriptMessageHandler:self name:@"goBack"];
    
    self.titleLab = [[UILabel alloc]init];
    self.titleLab.text = [BBUserData stringChangeNull:[self.dic objectForKey:@"tittle"] replaceWith:@""];
    self.titleLab.font = [UIFont boldSystemFontOfSize:16.0];
    CGRect rect = Rect(self.titleLab.text, mDeviceWidth - 20, self.titleLab.font);
    self.titleLab.numberOfLines = 0;
    self.titleLab.frame = CGRectMake(10, kNavBarHeight, rect.size.width, rect.size.height);
    [self.view addSubview:self.titleLab];
    
    self.authorLab = [[UILabel alloc]init];
    self.authorLab.text = [NSString stringWithFormat:@"作者：%@",[BBUserData stringChangeNull:[self.dic objectForKey:@"author"] replaceWith:@""]];
    self.authorLab.font = YSize(14.0);
    self.authorLab.textColor = RGB(119, 119, 119);
    CGRect rect1 = Rect(self.authorLab.text, mDeviceWidth - 20, self.authorLab.font);
    self.authorLab.numberOfLines = 0;
    self.authorLab.frame = CGRectMake(10, CGRectGetMaxY(self.titleLab.frame) + 5, rect1.size.width, rect1.size.height);
    [self.view addSubview:self.authorLab];
    
    self.timeLab = [[UILabel alloc]init];
    self.timeLab.text = [NSString stringWithFormat:@"发布时间：%@",[BBUserData stringChangeNull:[self.dic objectForKey:@"insertTime"] replaceWith:@""]];
    self.timeLab.font = YSize(14.0);
    self.timeLab.textColor = RGB(119, 119, 119);
    CGRect rect2 = Rect(self.timeLab.text, mDeviceWidth - 20, self.timeLab.font);
    self.timeLab.numberOfLines = 0;
    self.timeLab.frame = CGRectMake(10, CGRectGetMaxY(self.authorLab.frame) + 5, rect2.size.width, rect2.size.height);
    [self.view addSubview:self.timeLab];
    
    
    
    
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.timeLab.frame) + 5, mDeviceWidth, mDeviceHeight - kNavBarHeight - KSAFEBAR_HEIGHT - rect.size.height - rect1.size.height - rect2.size.height - 15)];
    self.webView.delegate = self;

    
    
    NSLog(@"%@",self.dic);
//      [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.shareUrl]]];
    [self.webView loadHTMLString:[BBUserData stringChangeNull:[self.dic objectForKey:@"content"] replaceWith:@""] baseURL:nil];
    [self.view addSubview:self.webView];

    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self setStatusBarBackgroundColor:RGBA(255, 255, 255, 1)];
    [self.navigationController.navigationBar setBackgroundColor:RGBA(255, 255, 255, 1)];
    //左侧返回
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"blackBack"] forState:UIControlStateNormal];
    [backBtn setBackgroundColor:[UIColor clearColor]];
//    [backBtn setTitle:@" 返回" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
//    [backBtn.titleLabel setFont:[UIFont fontWithName:@"HYJinChangTiJ" size:16]];
    [backBtn setTitleColor:AppBackTitleColor forState:UIControlStateNormal];
    [backBtn setFrame:CGRectMake(0, 0, AutoWitdh(32), AutoWitdh(32))];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationController.visibleViewController.navigationItem setLeftBarButtonItem:backItem];
    

    
    
    //顶部信息
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setText:@"最新资讯"];
    [titleLabel setFrame:CGRectMake(0, 0, mDeviceWidth/2, NavTopHeight)];
//    [titleLabel setFont:[UIFont fontWithName:@"HYJinChangTiJ" size:18]];
    [titleLabel setTextColor:RGB(22, 22, 22)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.navigationController.visibleViewController.navigationItem setTitleView:titleLabel];
    
//    [self.navigationController.visibleViewController.navigationItem setRightBarButtonItem:nil];

    //右侧分享
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareBtn setImage:[UIImage imageNamed:@"yz_pxcook_header_share"] forState:UIControlStateNormal];
        [shareBtn setBackgroundColor:[UIColor clearColor]];
        [shareBtn.titleLabel setFont:[UIFont fontWithName:@"HYJinChangTiJ" size:16]];
        [shareBtn setTitleColor:AppBackTitleColor forState:UIControlStateNormal];
        [shareBtn setFrame:CGRectMake(0, 0, AutoWitdh(32), AutoWitdh(32))];
        [shareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
        [self.navigationController.visibleViewController.navigationItem setRightBarButtonItem:shareItem];
    
}
//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}
-(void)backClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 分享
-(void)shareClick:(id)sender{
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [self getUserInfoForPlatform:platformType];
    }];
}


- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    
    
    UMSocialMessageObject* messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"火影帅不帅" descr:@"missyou" thumImage:[NSString stringWithFormat:@"%@",[self.dic objectForKey:@"img"]]];
    //设置网页地址
    shareObject.webpageUrl = self.shareUrl;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id result, NSError *error) {
      
        if (error) {
            [DDProgressHUD showErrorImageWithInfo:@"分享失败"];
            
        }else{
            [DDProgressHUD showSuccessImageWithInfo:@"分享成功"];
        }
    }];
    
    
}


//#pragma mark - WKScriptMessageHandler
//- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
//    NSLog(@"%@",NSStringFromSelector(_cmd));
//    NSLog(@"%@",message);
//    NSLog(@"%@",message.body);
//    NSLog(@"%@",message.name);
//
//    //这个是注入JS代码后的处理效果,尽管html已经有实现了,但是没用,还是执行JS中的实现
//    if ([message.name isEqualToString:@"goBack"]) {
//       [self.navigationController popViewControllerAnimated:YES];
//
//    }
//}

/*
#pragma mark - UIWebViewDelegate

//! UIWebView在每次加载请求完成后会调用此方法
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    //! 获取JS代码的执行环境/上下文/作用域
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    context[@"goBack"] = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    };
}
 */
@end
