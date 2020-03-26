//
//  yzIndexGoodsAttrModel.m
//  yzProduct
//
//  Created by LiuHQ on 2018/9/21.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "yzIndexGoodsAttrModel.h"

@implementation yzIndexGoodsAttrModel
-(instancetype)init:(NSDictionary *)dict{
    if (self = [super init]) {
        self.biku_goods_attr_id = [yzProductPubObject withStringReturn:dict[@"biku_goods_attr_id"]];
        self.biku_goods_attr_info = [yzProductPubObject withStringReturn:dict[@"biku_goods_attr_info"]];
        self.biku_goods_attr_name = [yzProductPubObject withStringReturn:dict[@"biku_goods_attr_name"]];
        self.biku_goods_attr_count = [yzProductPubObject withIntReturn:dict[@"biku_goods_attr_count"]];
    }
    return self;
}
@end
