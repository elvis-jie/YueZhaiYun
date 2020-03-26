//
//  yzIndexGoodsModel.h
//  yzProduct
//
//  Created by LiuHQ on 2018/9/21.
//  Copyright © 2018年 CC. All rights reserved.
// 首页产品数据model

#import <Foundation/Foundation.h>

@interface yzIndexGoodsModel : NSObject
-(instancetype)init:(NSDictionary *)dict;
/** 产品id */
@property (nonatomic, assign) int biku_goods_id;
/** 名称 */
@property (nonatomic, strong) NSString *biku_goods_name;
/** 市场价格 */
@property (nonatomic, assign) float biku_goods_market_price;
/** 店铺售价 */
@property (nonatomic, assign) float biku_goods_shop_price;
/** 产品图片1 */
@property (nonatomic, strong) NSString *biku_goods_img1;
/** 产品图片2 */
@property (nonatomic, strong) NSString *biku_goods_img2;
/** 产品图片3 */
@property (nonatomic, strong) NSString *biku_goods_img3;
/** 是否有规格 */
@property (nonatomic, assign) BOOL have_attr;
/** 库存 */
@property (nonatomic, assign) int biku_goods_kucun;
/** 产品描述 */
@property (nonatomic, strong) NSString *biku_goods_details;
/** 产品图文信息 */
@property (nonatomic, strong) NSString *biku_goods_info;
/** 产品店铺id */
@property (nonatomic, assign) int biku_store_id;
/** 产品店铺名称 */
@property (nonatomic, strong) NSString *biku_store_name;
/** 店铺头像 */
@property (nonatomic, strong) NSString *biku_store_logo;

/** 购物车数量 */
@property (nonatomic, assign) int biku_store_count;

/** 购物车总价格 */
@property (nonatomic, assign) float biku_store_allPrice;
@end
