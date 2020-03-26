//
//  yzHouseKeepModel.h
//  yzProduct
//
//  Created by LiuHQ on 2018/9/26.
//  Copyright © 2018年 CC. All rights reserved.
// 呼叫管家model

#import <Foundation/Foundation.h>

@interface yzHouseKeepModel : NSObject
-(instancetype)init:(NSDictionary *)dict;
/** 管家id */
@property (nonatomic, strong) NSString *keep_id;
/** 管家名称 */
@property (nonatomic, strong) NSString *keep_name;
/** 管家电话 */
@property (nonatomic, strong) NSString *keep_tel;
/** 管家状态  code,column,display,id,remarks,value*/
@property (nonatomic, strong) NSDictionary *keep_state;
/** 创建时间 */
@property (nonatomic, strong) NSString *keep_cdate;
/** 管家简介 */
@property (nonatomic, strong) NSString *keep_workInfo;
/** 小区id */
@property (nonatomic, strong) NSString *keep_xiaoquId;
/** 备注 */
@property (nonatomic, strong) NSString *keep_remarks;
@end
