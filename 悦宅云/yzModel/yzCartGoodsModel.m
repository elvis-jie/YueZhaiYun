//
//  yzCartGoodsModel.m
//  yzProduct
//
//  Created by LiuHQ on 2018/9/21.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "yzCartGoodsModel.h"

@implementation yzCartGoodsModel
-(instancetype)init:(NSDictionary *)dict{
    if (self = [super init]) {
        self.biku_store_id = [yzProductPubObject withIntReturn:dict[@"biku_store_id"]];
        self.biku_store_name = [yzProductPubObject withStringReturn:dict[@"biku_store_name"]];
        self.biku_store_img = [yzProductPubObject withStringReturn:dict[@"biku_store_img"]];
        self.checked = [dict[@"checked"] boolValue];
    }
    return self;
}
-(NSMutableArray<yzCartShopGoodsModel *> *)goodsArray{
    if (!_goodsArray) {
        _goodsArray = [[NSMutableArray<yzCartShopGoodsModel *> alloc] init];
    }
    return _goodsArray;
}
@end


@implementation yzCartCountModel
-(instancetype)init:(NSDictionary *)dict{
    if (self = [super init]) {
        self.count = [yzProductPubObject withIntReturn:dict[@"count"]];
        self.price = [yzProductPubObject withFloatReturn:dict[@"price"]];
        self.allCheck = [dict[@"allCheck"] boolValue];
    }
    return self;
}

@end

@implementation yzCartShopGoodsModel
-(instancetype)init:(NSDictionary *)dict{
    if (self = [super init]) {
        self.biku_car_id = [yzProductPubObject withStringReturn:dict[@"biku_car_id"]];
        self.biku_goods_id = [yzProductPubObject withStringReturn:dict[@"biku_goods_id"]];
        self.biku_goods_attr_id = [yzProductPubObject withStringReturn:dict[@"biku_goods_attr_id"]];
        self.biku_goods_attr_name = [yzProductPubObject withStringReturn:dict[@"biku_goods_attr_name"]];
        self.biku_goods_count = [yzProductPubObject withIntReturn:dict[@"biku_goods_count"]];
        NSString *imageUrls = dict[@"biku_goods_img1"];
       
        NSLog(@"%@",imageUrls);
        if ([imageUrls isEqual:[NSNull null]]) {
            imageUrls = @"";
        }
        
        if (imageUrls.length != 0) {
            if ([imageUrls hasPrefix:@"http"]) {
                self.biku_goods_img1 = [yzProductPubObject withStringReturn:imageUrls];
            }else{
                self.biku_goods_img1 = [yzProductPubObject withStringReturn:[NSString stringWithFormat:@"%@%@",imageUrl,imageUrls]];
            }
        }
        self.biku_goods_shop_price = [yzProductPubObject withFloatReturn:dict[@"biku_goods_shop_price"]];
        self.biku_goods_market_price = [yzProductPubObject withFloatReturn:dict[@"biku_goods_market_price"]];
        self.biku_goods_name = [yzProductPubObject withStringReturn:dict[@"biku_goods_name"]];
        self.checked = [dict[@"checked"] boolValue];
    }
    return self;
}
@end
