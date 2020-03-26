//
//  yzOrderDetailModel.m
//  yzProduct
//
//  Created by 尚广杰 on 2019/2/21.
//  Copyright © 2019 CC. All rights reserved.
//

#import "yzOrderDetailModel.h"

@implementation yzOrderDetailModel
-(instancetype)init:(NSDictionary *)dict{
    if (self = [super init]) {
        self.idS = [yzProductPubObject withStringReturn:dict[@"id"]];
        self.biku_order_no = [yzProductPubObject withStringReturn:dict[@"biku_order_no"]];
        self.app_user_id = [yzProductPubObject withStringReturn:dict[@"app_user_id"]];
        self.sys_app_user_address_id = [yzProductPubObject withStringReturn:dict[@"sys_app_user_address_id"]];
        self.biku_store_id = [yzProductPubObject withStringReturn:dict[@"biku_store_id"]];
        
        
        self.biku_store_name = [yzProductPubObject withStringReturn:dict[@"biku_store_name"]];
        self.biku_goods_id = [yzProductPubObject withStringReturn:dict[@"biku_goods_id"]];
        self.biku_goods_name = [yzProductPubObject withStringReturn:dict[@"biku_goods_name"]];
     
        
        self.biku_goods_count = [yzProductPubObject withStringReturn:dict[@"biku_goods_count"]];
        self.biku_goods_price = [yzProductPubObject withStringReturn:dict[@"biku_goods_price"]];
        self.biku_order_price = [yzProductPubObject withStringReturn:dict[@"biku_order_price"]];
        self.biku_goods_img1 = [yzProductPubObject withStringReturn:dict[@"biku_goods_img1"]];
        self.pay_status = [yzProductPubObject withStringReturn:dict[@"pay_status"]];
        
         self.remarks = [yzProductPubObject withStringReturn:dict[@"remarks"]];
         self.ctime = [yzProductPubObject withStringReturn:dict[@"ctime"]];
        
    }
    return self;
}
@end
