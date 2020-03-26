//
//  tenementInfoModel.m
//  yzProduct
//
//  Created by LiuHQ on 2018/9/27.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "tenementInfoModel.h"

@implementation tenementInfoModel
-(instancetype)init:(NSDictionary *)dict{
    if (self = [super init]) {
        self.list_id = [yzProductPubObject withStringReturn:dict[@"id"]];
        /** 报修名称 */
        self.list_baoxiuName = [yzProductPubObject withStringReturn:dict[@"baoxiuName"]];
        /** 报修手机号 */
        self.list_baoxiuPhone = [yzProductPubObject withStringReturn:dict[@"baoxiuPhone"]];
        /** 用户id */
        self.list_appUserId = [yzProductPubObject withStringReturn:dict[@"appUserId"]];
        /** 小区id */
        self.list_proXiaoquId = [yzProductPubObject withStringReturn:dict[@"proXiaoquId"]];
        /** 报修内容 */
        self.list_baoxiuInfo = [yzProductPubObject withStringReturn:dict[@"baoxiuInfo"]];
        /** 报修图片1 */
        self.list_baoxiuPic1 = [yzProductPubObject withStringReturn:dict[@"baoxiuPic1"]];
        /** 报修图片2 */
        self.list_baoxiuPic2 = [yzProductPubObject withStringReturn:dict[@"baoxiuPic2"]];
        /** 报修图片3 */
        self.list_baoxiuPic3 = [yzProductPubObject withStringReturn:dict[@"baoxiuPic3"]];
        /** 报修状态，id,column,code,value,display状态,remarks */
        self.list_baoxiuState = [[tenementClassModel alloc] init:dict[@"baoxiuState"]];
        /** 报修时间 */
        self.list_baoxiuTime = [yzProductPubObject withStringReturn:dict[@"baoxiuTime"]];
        /** 报修结束时间 */
        self.list_baoxiuEndTime = [yzProductPubObject withStringReturn:dict[@"baoxiuEndTime"]];
        /** 报修类型 */
        self.list_baoxiuType = [[tenementClassModel alloc] init:dict[@"baoxiuType"]];
        /** 报修方式 */
        self.list_baoxiuWay = [[tenementClassModel alloc] init:dict[@"baoxiuWay"]];
    
        self.xiaoQuDic = [dict objectForKey:@"xiaoQu"];
    }
    return self;
}
-(tenementClassModel *)list_baoxiuState{
    if (!_list_baoxiuState) {
        _list_baoxiuState = [[tenementClassModel alloc] init];
    }
    return _list_baoxiuState;
}
-(tenementClassModel *)list_baoxiuType{
    if (!_list_baoxiuType) {
        _list_baoxiuType = [[tenementClassModel alloc] init];
    }
    return _list_baoxiuType;
}
-(tenementClassModel *)list_baoxiuWay{
    if (!_list_baoxiuWay) {
        _list_baoxiuWay = [[tenementClassModel alloc] init];
    }
    return _list_baoxiuWay;
}
@end
