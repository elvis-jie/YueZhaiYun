//
//  yzIndexShopGoodDetailModel.h
//  yzProduct
//
//  Created by 尚广杰 on 2019/2/26.
//  Copyright © 2019 CC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface yzIndexShopGoodDetailModel : NSObject
-(instancetype)init:(NSDictionary *)dict;
/** 产品id */
@property (nonatomic, strong) NSString *goodsId;
/** 产品名称 */
@property (nonatomic, strong) NSString *goodsName;
/** 产品价格 */
@property (nonatomic, assign) float goodsPrice;
/** 产品市场价 */
@property (nonatomic, assign) float goodsMarketPrice;
/** 产品图片 */
@property (nonatomic, strong) NSString *goodsUrl;
/** 店铺名 */
@property (nonatomic, strong) NSString *shopName;
@end

NS_ASSUME_NONNULL_END
