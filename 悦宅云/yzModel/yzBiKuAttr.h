//
//  yzBiKuAttr.h
//  yzProduct
//
//  Created by 尚广杰 on 2019/2/23.
//  Copyright © 2019 CC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface yzBiKuAttr : NSObject
-(instancetype)init:(NSDictionary *)dict;
@property(nonatomic,strong)NSString* biku_goods_attr_id;
@property(nonatomic,strong)NSString* biku_goods_attr_name;
@property(nonatomic,strong)NSString* biku_goods_attr_count;
@property(nonatomic,strong)NSString* biku_goods_attr_info;
@end

NS_ASSUME_NONNULL_END
