//
//  tenementClassModel.h
//  yzProduct
//
//  Created by LiuHQ on 2018/9/27.
//  Copyright © 2018年 CC. All rights reserved.
// 报修记录状态model

#import <Foundation/Foundation.h>

@interface tenementClassModel : NSObject
-(instancetype)init:(NSDictionary *)dict;
/** id */
@property (nonatomic, strong) NSString *t_id;
/** 名称 */
@property (nonatomic, strong) NSString *t_display;
/** 类型 */
@property (nonatomic, strong) NSString *t_column;
/** 类型码 */
@property (nonatomic, strong) NSString *t_code;
/** value */
@property (nonatomic, assign) int t_value;
@property (nonatomic, assign) BOOL isSelected;
@end
