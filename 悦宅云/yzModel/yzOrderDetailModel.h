//
//  yzOrderDetailModel.h
//  yzProduct
//
//  Created by 尚广杰 on 2019/2/21.
//  Copyright © 2019 CC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface yzOrderDetailModel : NSObject

-(instancetype)init:(NSDictionary *)dict;

/** 店铺 */
@property (nonatomic, strong) NSString *biku_store_name;
/** 支付状态 */
@property (nonatomic, strong) NSString *pay_status;
/** 数量 */
@property (nonatomic, strong) NSString *biku_goods_count;

/** 订单号 */
@property (nonatomic, strong) NSString *biku_order_no;

/** id */
@property (nonatomic, strong) NSString *idS;
/** 地址id */
@property (nonatomic, strong) NSString *sys_app_user_address_id;
/** 用户id */
@property (nonatomic, strong) NSString *app_user_id;


/** 店铺id */
@property (nonatomic, strong) NSString *biku_store_id;
/** 商品ID */
@property (nonatomic, strong) NSString *biku_goods_id;
/** 商品名称 */
@property (nonatomic, strong) NSString *biku_goods_name;

/** 商品价格 */
@property (nonatomic, strong) NSString *biku_goods_price;
/** 订单价格 */
@property (nonatomic, strong) NSString *biku_order_price;
/**  */
@property (nonatomic, strong) NSString *biku_goods_sn;

/** 产品图片 */
@property (nonatomic, strong) NSString *biku_goods_img1;
/** 备注 */
@property (nonatomic, strong) NSString *remarks;
/** 付款时间 */
@property (nonatomic, strong) NSString *ctime;
@end

NS_ASSUME_NONNULL_END
