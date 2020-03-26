//
//  yzSettlePayModel.m
//  yzProduct
//
//  Created by LiuHQ on 2018/9/25.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "yzSettlePayModel.h"

@implementation yzSettlePayModel
-(instancetype)init:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.pay_id = [dict[@"pay_id"] intValue];
        self.pay_name = dict[@"payName"];
        self.pay_img = dict[@"icon"];
    }
    return self;
}

@end
