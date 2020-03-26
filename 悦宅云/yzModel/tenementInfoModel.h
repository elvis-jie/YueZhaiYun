//
//  tenementInfoModel.h
//  yzProduct
//
//  Created by LiuHQ on 2018/9/27.
//  Copyright © 2018年 CC. All rights reserved.
// 报修数据model

#import <Foundation/Foundation.h>
#import "tenementClassModel.h"


@interface tenementInfoModel : NSObject
-(instancetype)init:(NSDictionary *)dict;
@property (nonatomic, strong) NSString *list_id;
/** 报修名称 */
@property (nonatomic, strong) NSString *list_baoxiuName;
/** 报修手机号 */
@property (nonatomic, strong) NSString *list_baoxiuPhone;
/** 用户id */
@property (nonatomic, strong) NSString *list_appUserId;
/** 小区id */
@property (nonatomic, strong) NSString *list_proXiaoquId;
/** 报修内容 */
@property (nonatomic, strong) NSString *list_baoxiuInfo;
/** 报修图片1 */
@property (nonatomic, strong) NSString *list_baoxiuPic1;
/** 报修图片2 */
@property (nonatomic, strong) NSString *list_baoxiuPic2;
/** 报修图片3 */
@property (nonatomic, strong) NSString *list_baoxiuPic3;
/** 报修状态，id,column,code,value,display状态,remarks */
@property (nonatomic, strong) tenementClassModel *list_baoxiuState;
/** 报修时间 */
@property (nonatomic, strong) NSString *list_baoxiuTime;
/** 报修结束时间 */
@property (nonatomic, strong) NSString *list_baoxiuEndTime;
/** 报修类型 */
@property (nonatomic, strong) tenementClassModel *list_baoxiuType;
/** 报修方式 */
@property (nonatomic, strong) tenementClassModel *list_baoxiuWay;

//小区信息
@property(nonatomic,strong) NSDictionary* xiaoQuDic;

@end
