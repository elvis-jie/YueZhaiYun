//
//  yzSettlePayModel.h
//  yzProduct
//
//  Created by LiuHQ on 2018/9/25.
//  Copyright © 2018年 CC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface yzSettlePayModel : NSObject
-(instancetype)init:(NSDictionary *)dict;
/** 方式id */
@property (nonatomic, assign) int pay_id;
/** 方式名称 */
@property (nonatomic, copy) NSString *pay_name;
/** 支付图片 */
@property (nonatomic, copy) NSString *pay_img;
/** 是否选中 */
@property (nonatomic, assign) BOOL isSelected;
@end
