//
//  yzIndexGoodsAttrModel.h
//  yzProduct
//
//  Created by LiuHQ on 2018/9/21.
//  Copyright © 2018年 CC. All rights reserved.
// 规格model

#import <Foundation/Foundation.h>

@interface yzIndexGoodsAttrModel : NSObject
-(instancetype)init:(NSDictionary *)dict;
/** id */
@property (nonatomic, strong) NSString *biku_goods_attr_id;
/** 名称 */
@property (nonatomic, strong) NSString *biku_goods_attr_name;
/** 规格数量 */
@property (nonatomic, assign) int biku_goods_attr_count;
/** 描述 */
@property (nonatomic, strong) NSString *biku_goods_attr_info;
/** 是否选中 */
@property (nonatomic, assign) BOOL isSelected;
@end
