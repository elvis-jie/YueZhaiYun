//
//  yzHouseKeepModel.m
//  yzProduct
//
//  Created by LiuHQ on 2018/9/26.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "yzHouseKeepModel.h"

@implementation yzHouseKeepModel
-(instancetype)init:(NSDictionary *)dict{
    if (self = [super init]) {
        self.keep_id = [yzProductPubObject withStringReturn:dict[@"id"]];
        self.keep_name = [yzProductPubObject withStringReturn:dict[@"managerName"]];
        self.keep_tel = [yzProductPubObject withStringReturn:dict[@"managerTel"]];
        self.keep_cdate = [yzProductPubObject withStringReturn:dict[@"cdate"]];
        self.keep_state = [dict objectForKey:@"managerState"];
        self.keep_remarks = [yzProductPubObject withStringReturn:dict[@"remarks"]];
        self.keep_workInfo = [yzProductPubObject withStringReturn:dict[@"managerWorkinfo"]];
        self.keep_xiaoquId = [yzProductPubObject withStringReturn:dict[@"proXiaoquId"]];
    }
    return self;
}
@end
