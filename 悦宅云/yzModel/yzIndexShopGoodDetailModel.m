//
//  yzIndexShopGoodDetailModel.m
//  yzProduct
//
//  Created by 尚广杰 on 2019/2/26.
//  Copyright © 2019 CC. All rights reserved.
//

#import "yzIndexShopGoodDetailModel.h"

@implementation yzIndexShopGoodDetailModel
-(instancetype)init:(NSDictionary *)dict{
    if (self = [super init]) {
        self.goodsId = [yzProductPubObject withStringReturn:dict[@"id"]];
        self.goodsName = [yzProductPubObject withStringReturn:dict[@"info"]];
        self.goodsUrl = [yzProductPubObject withStringReturn:dict[@"img1"]];
        self.goodsPrice = [yzProductPubObject withFloatReturn:dict[@"price"]];
        self.goodsMarketPrice = [yzProductPubObject withFloatReturn:dict[@"marketPrice"]];
        self.shopName = [yzProductPubObject withStringReturn:dict[@"name"]];

    }
    return self;
}
@end
