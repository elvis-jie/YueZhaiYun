//
//  orderFuWuModel.m
//  yzProduct
//
//  Created by 尚广杰 on 2019/1/23.
//  Copyright © 2019 CC. All rights reserved.
//

#import "orderFuWuModel.h"

@implementation orderFuWuModel
-(instancetype)init:(NSDictionary *)dict{
    if (self = [super init]) {
        self.t_orderId = [yzProductPubObject withStringReturn:dict[@"orderId"]];
        self.t_orderName = [yzProductPubObject withStringReturn:dict[@"orderName"]];
        self.t_price = [yzProductPubObject withStringReturn:dict[@"price"]];
        self.t_count = [yzProductPubObject withStringReturn:dict[@"count"]];
        self.t_shopName = [yzProductPubObject withStringReturn:dict[@"shopName"]];
        self.t_remarks = [yzProductPubObject withStringReturn:dict[@"remarks"]];
        self.t_time = [yzProductPubObject withStringReturn:dict[@"orderTime"]];
        self.t_payStatus = [yzProductPubObject withStringReturn:dict[@"payStatus"]];
        self.t_image = [yzProductPubObject withStringReturn:dict[@"orderImg"]];
    }
    return self;
}


@end
