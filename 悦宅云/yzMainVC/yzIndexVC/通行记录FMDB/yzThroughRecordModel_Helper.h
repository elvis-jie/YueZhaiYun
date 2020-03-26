//
//  EN_FriendApplyModel_Helper.h
//  JingXinTong
//
//  Created by apple on 2018/7/3.
//  Copyright © 2018年 赵帅. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "yzThroughRecordModel.h"
#import "FMDatabase.h"
@interface yzThroughRecordModel_Helper : NSObject
+(yzThroughRecordModel_Helper*)getInstance;

-(BOOL)insertOneData:(yzThroughRecordModel*)enData;
-(NSMutableArray*)queryData;
-(NSMutableArray*)queryDataWithFriendState:(NSString*)state;
-(BOOL)deleteAllData;

-(BOOL)updateOneData:(yzThroughRecordModel*)enData;

@end
