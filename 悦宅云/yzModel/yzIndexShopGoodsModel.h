//
//  yzIndexShopGoodsModel.h
//  yzProduct
//
//  Created by LiuHQ on 2018/9/21.
//  Copyright © 2018年 CC. All rights reserved.
// 物业店铺商品信息

#import <Foundation/Foundation.h>

@interface yzIndexShopGoodsModel : NSObject
-(instancetype)init:(NSDictionary *)dict;
/** 产品id */
@property (nonatomic, strong) NSString *goodsId;
/** 产品名称 */
@property (nonatomic, strong) NSString *goodsName;
/** 优惠价 */
@property (nonatomic, assign) float goodsPrice;
/** 原价 */
@property (nonatomic, assign) float goodsMarketPrice;
/** 产品图片 */
@property (nonatomic, strong) NSString *goodsUrl;

@property (nonatomic, assign) BOOL have_attr;

@end
