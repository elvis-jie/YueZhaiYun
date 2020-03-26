//
//  yzIndexShopGoodsModel.m
//  yzProduct
//
//  Created by LiuHQ on 2018/9/21.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "yzIndexShopGoodsModel.h"

@implementation yzIndexShopGoodsModel
-(instancetype)init:(NSDictionary *)dict{
    if (self = [super init]) {
        self.goodsId = [yzProductPubObject withStringReturn:dict[@"biku_goods_id"]];
        self.goodsName = [yzProductPubObject withStringReturn:dict[@"biku_goods_name"]];
        self.goodsUrl = [yzProductPubObject withStringReturn:dict[@"biku_goods_img1"]];
        self.goodsPrice = [yzProductPubObject withFloatReturn:dict[@"biku_goods_shop_price"]];
        self.goodsMarketPrice = [yzProductPubObject withFloatReturn:dict[@"biku_goods_market_price"]];
        self.have_attr = [yzProductPubObject withBoolReturn:dict[@"have_attr"]];
    }
    return self;
}
@end
