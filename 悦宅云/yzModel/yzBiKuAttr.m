//
//  yzBiKuAttr.m
//  yzProduct
//
//  Created by 尚广杰 on 2019/2/23.
//  Copyright © 2019 CC. All rights reserved.
//

#import "yzBiKuAttr.h"

@implementation yzBiKuAttr
-(instancetype)init:(NSDictionary *)dict{
    if (self = [super init]) {
        self.biku_goods_attr_id = [yzProductPubObject withStringReturn:dict[@"biku_goods_attr_id"]];
        self.biku_goods_attr_name = [yzProductPubObject withStringReturn:dict[@"biku_goods_attr_name"]];
        self.biku_goods_attr_count = [yzProductPubObject withStringReturn:dict[@"biku_goods_attr_count"]];
        self.biku_goods_attr_info = [yzProductPubObject withStringReturn:dict[@"biku_goods_attr_info"]];
    }
    return self;
}
@end
