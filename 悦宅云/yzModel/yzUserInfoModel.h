//
//  yzUserInfoModel.h
//  yzProduct
//
//  Created by LiuHQ on 2018/9/20.
//  Copyright © 2018年 CC. All rights reserved.
// 用户数据model

#import <Foundation/Foundation.h>


@interface yzUserInfoModel : NSObject
-(instancetype)init:(NSDictionary *)dict;

/** 用户id */
@property (nonatomic, copy) NSString *appUserId;
/** 用户手机号 */
@property (nonatomic, copy) NSString *appUserPhone;
/** 性别 */
@property (nonatomic, copy) NSString *appUserSex;
/** 用户账号 */
@property (nonatomic, copy) NSString *appUserName;
/** 小区列表 */
@property (nonatomic, strong) NSMutableArray *xiaoQuVoList;
/** token */
@property (nonatomic, copy) NSString *token;

/**
 记录用户登录状态
 
 @param selected 状态
 */
+(void)setLoginState:(BOOL)selected;
/**
 获取用户登录状态
 
 @return 状态
 */
+(BOOL)getisLogin;
/**
 退出登录
 */
+(void)userLoginOut;
/**
 存储用户登录信息
 
 @param model 用户数据
 */
+(void)setLoginUserInfo:(yzUserInfoModel *)model;
/**
 获取用户登录信息
 
 @return 获取到的信息
 */
+(NSString *)getLoginUserInfo:(NSString *)name;

@end
