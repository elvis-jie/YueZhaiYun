//
//  yzPxCookInfoModel.m
//  yzProduct
//
//  Created by LiuHQ on 2018/9/26.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "yzPxCookInfoModel.h"

@implementation yzPxCookInfoModel
-(instancetype)init:(NSDictionary *)dict{
    if (self = [super init]) {
        self.cook_id = [yzProductPubObject withStringReturn:dict[@"id"]];
        self.room_id = [yzProductPubObject withStringReturn:dict[@"roomId"]];
        self.xiaoqu_id = [yzProductPubObject withStringReturn:dict[@"xiaoQuId"]];
        self.room_msg = [yzProductPubObject withStringReturn:dict[@"roomMsg"]];
        self.user_state = [yzProductPubObject withStringReturn:dict[@"userState"]];
        self.is_main = [yzProductPubObject withStringReturn:dict[@"isMain"]];//是，否
        self.end_time = [yzProductPubObject withStringReturn:dict[@"endTime"]];
        self.mainEndDate = [yzProductPubObject withStringReturn:dict[@"mainEndDate"]];
        self.xinYongTianShu = [yzProductPubObject withStringReturn:dict[@"xinYongTianShu"]];
        self.key_type = [yzProductPubObject withIntReturn:dict[@"keyType"]];
        self.count = [yzProductPubObject withIntReturn:dict[@"count"]];
        self.phone = [yzProductPubObject withStringReturn:dict[@"phone"]];
        self.appUserName = [BBUserData stringChangeNull:[yzProductPubObject withStringReturn:dict[@"proUserName"]] replaceWith:@""];
    }
    return self;
}
@end
