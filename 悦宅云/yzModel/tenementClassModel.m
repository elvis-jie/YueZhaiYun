//
//  tenementClassModel.m
//  yzProduct
//
//  Created by LiuHQ on 2018/9/27.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "tenementClassModel.h"

@implementation tenementClassModel
-(instancetype)init:(NSDictionary *)dict{
    if (self = [super init]) {
        self.t_id = [yzProductPubObject withStringReturn:dict[@"id"]];
        self.t_display = [yzProductPubObject withStringReturn:dict[@"display"]];
        self.t_column = [yzProductPubObject withStringReturn:dict[@"column"]];
        self.t_code = [yzProductPubObject withStringReturn:dict[@"code"]];
        self.t_value = [yzProductPubObject withIntReturn:dict[@"value"]];
    }
    return self;
}
@end
