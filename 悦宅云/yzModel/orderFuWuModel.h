//
//  orderFuWuModel.h
//  yzProduct
//
//  Created by 尚广杰 on 2019/1/23.
//  Copyright © 2019 CC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface orderFuWuModel : NSObject
-(instancetype)init:(NSDictionary *)dict;
/** orderId */
@property (nonatomic, strong) NSString *t_orderId;
/** orderName */
@property (nonatomic, strong) NSString *t_orderName;
/** price */
@property (nonatomic, strong) NSString *t_price;
/** count */
@property (nonatomic, strong) NSString *t_count;
/** shopName */
@property (nonatomic, strong) NSString *t_shopName;
/** remarks */
@property (nonatomic, strong) NSString *t_remarks;
/** time */
@property (nonatomic, strong) NSString *t_time;
/** payStatus */
@property (nonatomic, strong) NSString *t_payStatus;
/** image */
@property (nonatomic, strong) NSString *t_image;
@end

NS_ASSUME_NONNULL_END
