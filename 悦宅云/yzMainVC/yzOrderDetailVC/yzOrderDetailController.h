//
//  yzOrderDetailController.h
//  yzProduct
//
//  Created by 尚广杰 on 2019/2/14.
//  Copyright © 2019 CC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "yzLinShiOrderModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface yzOrderDetailController : yzBaseUIViewController
@property(nonatomic,strong)NSString* orderId;       //订单ID
@property(nonatomic,strong)void (^successBlock)(NSString* payState);
@property(nonatomic,strong)yzLinShiOrderModel* linshiModel;
@end

NS_ASSUME_NONNULL_END
