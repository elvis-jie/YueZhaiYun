//
//  yzLinShiOrderModel.h
//  yzProduct
//
//  Created by 尚广杰 on 2019/2/26.
//  Copyright © 2019 CC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface yzLinShiOrderModel : NSObject
-(instancetype)init:(NSDictionary *)dict;

/** 临时订单号 */
@property (nonatomic, copy) NSString *orderNo;



@end

NS_ASSUME_NONNULL_END
