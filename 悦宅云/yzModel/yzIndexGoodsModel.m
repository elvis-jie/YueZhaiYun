//
//  yzIndexGoodsModel.m
//  yzProduct
//
//  Created by LiuHQ on 2018/9/21.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "yzIndexGoodsModel.h"

@implementation yzIndexGoodsModel
-(instancetype)init:(NSDictionary *)dict{
    if (self = [super init]) {
        self.biku_goods_id = [yzProductPubObject withIntReturn:dict[@"biku_goods_id"]];
        self.biku_goods_name = [yzProductPubObject withStringReturn:dict[@"biku_goods_name"]];
        self.biku_goods_shop_price = [yzProductPubObject withFloatReturn:dict[@"biku_goods_shop_price"]];
        self.biku_goods_market_price = [yzProductPubObject withFloatReturn:dict[@"biku_goods_market_price"]];
        NSString *imageUrls = dict[@"biku_goods_img1"];
        if (imageUrls.length != 0) {
            if ([imageUrls hasPrefix:@"http"]) {
                self.biku_goods_img1 = [yzProductPubObject withStringReturn:imageUrls];
            }else{
                self.biku_goods_img1 = [yzProductPubObject withStringReturn:[NSString stringWithFormat:@"%@%@",imageUrl,imageUrls]];
            }
        }
        NSString *imageUrls2 = dict[@"biku_goods_img2"];
        if (imageUrls2.length != 0) {
            if ([imageUrls2 hasPrefix:@"http"]) {
                self.biku_goods_img2 = [yzProductPubObject withStringReturn:imageUrls2];
            }else{
                self.biku_goods_img2 = [yzProductPubObject withStringReturn:[NSString stringWithFormat:@"%@%@",imageUrl,imageUrls2]];
            }
        }
        NSString *imageUrls3 = dict[@"biku_goods_img3"];
        if (imageUrls3.length != 0) {
            if ([imageUrls3 hasPrefix:@"http"]) {
                self.biku_goods_img3 = [yzProductPubObject withStringReturn:imageUrls3];
            }else{
                self.biku_goods_img3 = [yzProductPubObject withStringReturn:[NSString stringWithFormat:@"%@%@",imageUrl,imageUrls3]];
            }
        }
        NSString *goods_info = dict[@"biku_goods_info"];
//        NSLog(@"%@",goods_info);
        if ([goods_info isKindOfClass:[NSNull class]]||[goods_info isEqual:[NSNull null]] || goods_info == nil || [goods_info isEqualToString:@"<null>"]) {
            NSLog(@"空空如也");
            self.biku_goods_info = @"";
        }else{
            NSMutableString * str3 = [[NSMutableString alloc]initWithString:goods_info];
            [str3 replaceOccurrencesOfString:@"\\" withString:@"" options:1 range:NSMakeRange(0, str3.length)];
            self.biku_goods_info = [yzProductPubObject withStringReturn:str3];
        }
        self.biku_goods_details = [yzProductPubObject withStringReturn:dict[@"biku_goods_details"]];
        self.biku_goods_kucun = [yzProductPubObject withIntReturn:dict[@"biku_goods_kucun"]];
        self.have_attr = [dict[@"have_attr"] boolValue];
        self.biku_store_id = [yzProductPubObject withIntReturn:dict[@"biku_store_id"]];
        self.biku_store_name = [yzProductPubObject withStringReturn:dict[@"biku_store_name"]];
        self.biku_store_logo = @"https://ecjia95079.oss-cn-beijing.aliyuncs.com/images/201807/thumb_img/1412_G_1531177758899.jpg";
        
        self.biku_store_count = [yzProductPubObject withIntReturn:dict[@"count"]];
        self.biku_store_allPrice = [yzProductPubObject withFloatReturn:dict[@"price"]];
    }
    return self;
}
@end
