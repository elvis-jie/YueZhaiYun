//
//  yzAddressModel.m
//  yzProduct
//
//  Created by LiuHQ on 2018/9/25.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "yzAddressModel.h"

@implementation yzAddressModel
-(instancetype)init:(NSDictionary *)dict{
    if (self = [super init]) {
        self.address_id = [yzProductPubObject withStringReturn:dict[@"id"]];
        self.address_info = [[yzProductPubObject withStringReturn:dict[@"address"]] length] == 0?[yzProductPubObject withStringReturn:dict[@"info"]]:[yzProductPubObject withStringReturn:dict[@"address"]];
        self.address_name = [yzProductPubObject withStringReturn:dict[@"name"]];
        self.address_mobile = [yzProductPubObject withStringReturn:dict[@"phone"]];
        self.isDefault = [[dict objectForKey:@"default_"] boolValue];
        self.provine = [yzProductPubObject withStringReturn:dict[@"country"]];
        self.city = [yzProductPubObject withStringReturn:dict[@"city"]];
        self.area = [yzProductPubObject withStringReturn:dict[@"qu"]];
    }
    return self;
}
@end
//appUserId = 2c948438647e34d201647e38b3d00000;
//city = "\U897f\U9752";
//code = "<null>";
//country = "\U5929\U6d25";
//"default_" = 1;
//id = 15378615454508784581774389844196;
//info = "\U54c8\U54c8\U9053\U54c8\U54c8\U885711\U53f7\U697c";
//isYueZhai = "<null>";
//jiedao = "<null>";
//name = "\U6d4b\U8bd5";
//phone = 15122222222;
//qu = "";
//remarks = "<null>";
//x = "<null>";
//y = "<null>";

