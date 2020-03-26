//
//  yzCartGoodsModel.h
//  yzProduct
//
//  Created by LiuHQ on 2018/9/21.
//  Copyright © 2018年 CC. All rights reserved.
// 购物车信息

#import <Foundation/Foundation.h>
@class yzCartCountModel;
@class yzCartShopGoodsModel;

@interface yzCartGoodsModel : NSObject

-(instancetype)init:(NSDictionary *)dict;
/** 店铺id */
@property (nonatomic, assign) int biku_store_id;
/** 店铺名称 */
@property (nonatomic, strong) NSString *biku_store_name;
/** 店铺logo */
@property (nonatomic, strong) NSString *biku_store_img;
/** 是否选中 */
@property (nonatomic, assign) BOOL checked;
/** 价格 */
@property (nonatomic, assign) float price;
/** 数量 */
@property (nonatomic, assign) int count;
/** 总选中状态 */
@property (nonatomic, assign) BOOL allCheck;
@property (nonatomic, strong) NSMutableArray<yzCartShopGoodsModel *> *goodsArray;
@end

/** 总数 */
@interface yzCartCountModel:NSObject
-(instancetype)init:(NSDictionary *)dict;
/** 总数量 */
@property (nonatomic, assign) int count;
/** 总金额 */
@property (nonatomic, assign) float price;
/** 全选 */
@property (nonatomic, assign) BOOL allCheck;

@end

/** 购物车店铺产品 */
@interface yzCartShopGoodsModel:NSObject
-(instancetype)init:(NSDictionary *)dict;
/** 购物车id */
@property (nonatomic, strong) NSString *biku_car_id;
/** 产品规格id */
@property (nonatomic, strong) NSString *biku_goods_attr_id;
/** 产品规格名称 */
@property (nonatomic, strong) NSString *biku_goods_attr_name;
/** 产品数量 */
@property (nonatomic, assign) int biku_goods_count;
/** 产品id */
@property (nonatomic, strong) NSString* biku_goods_id;
/** 产品图片 */
@property (nonatomic, strong) NSString *biku_goods_img1;
/** 必酷产品市场价格 */
@property (nonatomic, assign) float biku_goods_market_price;
/** 必酷产品店铺价格 */
@property (nonatomic, assign) float biku_goods_shop_price;
/** 产品名称 */
@property (nonatomic, strong) NSString *biku_goods_name;
/** 是否选中 */
@property (nonatomic, assign) BOOL checked;
@end
