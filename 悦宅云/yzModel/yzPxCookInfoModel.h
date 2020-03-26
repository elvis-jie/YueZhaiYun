//
//  yzPxCookInfoModel.h
//  yzProduct
//
//  Created by LiuHQ on 2018/9/26.
//  Copyright © 2018年 CC. All rights reserved.
// 钥匙管理数据model

#import <Foundation/Foundation.h>

@interface yzPxCookInfoModel : NSObject
-(instancetype)init:(NSDictionary *)dict;
/** id */
@property (nonatomic, strong) NSString *cook_id;
/** 房屋id */
@property (nonatomic, strong) NSString *room_id;
/** 小区id */
@property (nonatomic, strong) NSString *xiaoqu_id;
/** 房间名称 */
@property (nonatomic, strong) NSString *room_msg;
/** 用户状态 */
@property (nonatomic, strong) NSString *user_state;
/** 是否为主钥匙 */
@property (nonatomic, strong) NSString *is_main;
/** 结束时间 */
@property (nonatomic, strong) NSString *end_time;
/** 物业到期时间 */
@property (nonatomic, strong) NSString *mainEndDate;
/** 信用天数 */
@property (nonatomic, strong) NSString *xinYongTianShu;
/** 钥匙类型 */
@property (nonatomic, assign) int key_type;
/** 钥匙数量 */
@property (nonatomic, assign) int count;
/** 名字 */
@property (nonatomic, strong) NSString *appUserName;
/** 选中状态 */
@property (nonatomic, assign) BOOL isSelected;
/** 手机号 */
@property (nonatomic, strong) NSString *phone;
@end
