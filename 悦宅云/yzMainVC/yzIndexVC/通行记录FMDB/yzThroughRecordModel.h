//
//  EN_FriendApplyModel.h
//  JingXinTong
//
//  Created by apple on 2018/7/3.
//  Copyright © 2018年 赵帅. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface yzThroughRecordModel : NSObject
@property (nonatomic,assign) int id_self;

@property (nullable, nonatomic, copy) NSString *currenttime;
//@property (nullable, nonatomic, copy) NSMutableDictionary *currentType;
//@property (nullable, nonatomic, copy) NSMutableDictionary *currenterType;
//@property (nullable, nonatomic, copy) NSMutableDictionary *currentState;
@property (nullable, nonatomic, copy) NSString *currentType;
@property (nullable, nonatomic, copy) NSString *currenterType;
@property (nullable, nonatomic, copy) NSString *currentState;
@property (nullable, nonatomic, copy) NSString *phoneSystem;
@property (nullable, nonatomic, copy) NSString *remarks;
@property (nullable, nonatomic, copy) NSString *platenumber;
@property (nullable, nonatomic, copy) NSString *accessObject;
@property (nullable, nonatomic, copy) NSString *proXiaoquId;
@property (nullable, nonatomic, copy) NSString *appUserId;
@property (nullable, nonatomic, copy) NSString *openState;
@end
