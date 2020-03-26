//
//  yzAddressModel.h
//  yzProduct
//
//  Created by LiuHQ on 2018/9/25.
//  Copyright © 2018年 CC. All rights reserved.
// 收货地址model

#import <Foundation/Foundation.h>

@interface yzAddressModel : NSObject
-(instancetype)init:(NSDictionary *)dict;
/** id */
@property (nonatomic, strong) NSString *address_id;
/** 收货人 */
@property (nonatomic, strong) NSString *address_name;
/** 手机号 */
@property (nonatomic, strong) NSString *address_mobile;
/** 详细地址 */
@property (nonatomic, strong) NSString *address_info;
/** 是否默认 */
@property (nonatomic, assign) BOOL isDefault;
/** 省 */
@property (nonatomic, strong) NSString *provine;
/** 市 */
@property (nonatomic, strong) NSString *city;
/** 区 */
@property (nonatomic, strong) NSString *area;

@property (nonatomic, assign) BOOL isHaveData;//记录是否有默认地址
@end
