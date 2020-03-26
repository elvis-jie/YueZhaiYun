//
//  yzUserInfoModel.m
//  yzProduct
//
//  Created by LiuHQ on 2018/9/20.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "yzUserInfoModel.h"

@implementation yzUserInfoModel
-(instancetype)init:(NSDictionary *)dict{
    if (self = [super init]) {
        self.appUserPhone = [yzProductPubObject withStringReturn:[dict objectForKey:@"appUserPhone"]];
        self.appUserSex = [yzProductPubObject withStringReturn:[dict objectForKey:@"appUserSex"]];
        self.xiaoQuVoList = [dict objectForKey:@"xiaoQuVoList"];
        self.appUserId = [yzProductPubObject withStringReturn:[dict objectForKey:@"appUserId"]];
        self.appUserName = [yzProductPubObject withStringReturn:[dict objectForKey:@"appUserName"]];
        self.token = [yzProductPubObject withStringReturn:[dict objectForKey:@"token"]];
    }
    return self;
}
-(NSMutableArray *)xiaoQuVoList{
    if (!_xiaoQuVoList) {
        _xiaoQuVoList = [[NSMutableArray alloc] init];
    }
    return _xiaoQuVoList;
}

/**
 记录用户登录状态
 
 @param selected 状态
 */
+(void)setLoginState:(BOOL)selected{
    [[NSUserDefaults standardUserDefaults] setBool:selected forKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
/**
 获取用户登录状态
 
 @return 状态
 */
+(BOOL)getisLogin{
    //判断是否token过期
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
}
/**
 退出登录
 */
+(void)userLoginOut{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userId"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mobile"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userSex"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"first"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self setLoginState:NO];
}
/**
 存储用户登录信息
 
 @param model 用户数据
 */
+(void)setLoginUserInfo:(yzUserInfoModel *)model{
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",model.appUserId] forKey:@"userId"];
    [[NSUserDefaults standardUserDefaults] setObject:model.appUserName forKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",model.token] forKey:@"token"];
    [[NSUserDefaults standardUserDefaults] setObject:model.appUserPhone forKey:@"mobile"];
    [[NSUserDefaults standardUserDefaults] setObject:model.appUserSex forKey:@"userSex"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self setLoginState:YES];
}
/**
 获取用户登录信息
 
 @param name 信息
 @return 获取到的信息
 */
+(NSString *)getLoginUserInfo:(NSString *)name{
    NSString *userInfo = ([[NSUserDefaults standardUserDefaults] objectForKey:name]==nil || [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:name]].length <= 0)?@"":[[NSUserDefaults standardUserDefaults] objectForKey:name];
    
    return userInfo;
}
@end
