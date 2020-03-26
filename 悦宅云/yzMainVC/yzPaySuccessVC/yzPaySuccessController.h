//
//  yzPaySuccessController.h
//  yzProduct
//
//  Created by 尚广杰 on 2019/2/22.
//  Copyright © 2019 CC. All rights reserved.
//

#import "yzBaseUIViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface yzPaySuccessController : yzBaseUIViewController
@property(nonatomic,assign)float totalMoney;
@property(nonatomic,strong)NSString* type;     // 1成功   0失败
@property(nonatomic,strong)NSString* orderNo;  //订单号
@property(nonatomic,strong)NSString* detailType;  //1 商品订单  0 缴费订单

@property(nonatomic,strong)NSString* centenType;
@end

NS_ASSUME_NONNULL_END
