//
//  yzLinShiOrderModel.m
//  yzProduct
//
//  Created by 尚广杰 on 2019/2/26.
//  Copyright © 2019 CC. All rights reserved.
//

#import "yzLinShiOrderModel.h"

@implementation yzLinShiOrderModel
-(instancetype)init:(NSDictionary *)dict{
    if (self = [super init]) {

        self.orderNo = [yzProductPubObject withStringReturn:[dict objectForKey:@"orderNo"]];
    }
    return self;
}
@end
