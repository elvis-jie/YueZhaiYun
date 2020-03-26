//
//  EN_FriendApplyModel_Helper.m
//  JingXinTong
//
//  Created by apple on 2018/7/3.
//  Copyright © 2018年 赵帅. All rights reserved.
//
#define _NAME_DATABASE @"jxt.db"
#import "yzThroughRecordModel_Helper.h"
#import "FMDatabaseAdditions.h"
#import "QueueFetcher.h"
@implementation yzThroughRecordModel_Helper
{
    FMDatabase* db;
    NSString* TABLE_NAME;           //表名字
    NSString* ID_SELF;
    
    NSString *currenttime;
    NSString *currentType;
    NSString *currenterType;
    NSString *currentState;
    NSString *phoneSystem;
    NSString *remarks;
    NSString *platenumber;
    NSString *accessObject;
    NSString *proXiaoquId;
    NSString *appUserId;
    NSString *openState;

}
+(yzThroughRecordModel_Helper*)getInstance{
    static yzThroughRecordModel_Helper* instance = nil;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        
        instance = [[self alloc]init];
        [instance onCreate];
        [instance onCreateTable];
    });
    
    return instance;
}
-(instancetype)init
{
    self = [super init];
    
    if(self)
    {
        TABLE_NAME = @"throughRecord";
        ID_SELF = @"id_self";
        currenttime = @"currenttime";
        currentType = @"currentType";
        currenterType = @"currenterType";
        currentState = @"currentState";
        phoneSystem = @"phoneSystem";
        remarks = @"remarks";
        platenumber = @"platenumber";
        accessObject = @"accessObject";
        proXiaoquId = @"proXiaoquId";
        appUserId = @"appUserId";
        openState = @"openState";

    }
    
    return self;
}
/**
 *  创建数据库
 */
-(void)onCreate
{
    NSString* docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString* dpPath = [docsPath stringByAppendingPathComponent:_NAME_DATABASE];
    db = [FMDatabase databaseWithPath:dpPath];
}
/**
 *  创建表
 *
 *  @return YES:创建表成功 NO:创建表失败
 */
-(BOOL)onCreateTable
{
    __block BOOL res = NO;
    
    dispatch_sync([QueueFetcher getInstance].dbQueue, ^{
        if([db open])
        {
            NSString* sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS  '%@' (id_self INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT)", TABLE_NAME,currenttime,currentType,currenterType,currentState,phoneSystem,remarks,platenumber,accessObject,proXiaoquId,appUserId,openState];
            [db beginTransaction];
            res = [db executeUpdate:sqlCreateTable];
            if(res)
            {
                NSLog(@"创建表成功 %d",db.lastInsertRowId);
            }
            else
            {
                NSLog(@"创建表失败 %@",TABLE_NAME);
            }
            [db commit];
            [db close];
        }
    });
    
    return res;
}
-(BOOL)insertOneData:(yzThroughRecordModel*)enData{
    
  
    __block BOOL res = NO;
    dispatch_sync([QueueFetcher getInstance].dbQueue, ^{
        
        if ([db open])
        {
            NSString *insertSql= [NSString stringWithFormat:
                                  @"INSERT INTO '%@' ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@') VALUES ('%@', '%@', '%@', '%@','%@', '%@', '%@', '%@', '%@', '%@', '%@')",
                            TABLE_NAME,
                            currenttime,currentType,currenterType,currentState,phoneSystem,remarks,platenumber,accessObject,proXiaoquId,appUserId,openState,enData.currenttime,enData.currentType,enData.currenterType,enData.currentState,enData.phoneSystem,enData.remarks,enData.platenumber,enData.accessObject,enData.proXiaoquId,enData.appUserId,enData.openState];
            [db beginTransaction];
            
            res = [db executeUpdate:insertSql];
            if (res)
            {
                NSLog(@"insertOneData成功 %@",TABLE_NAME);
            }
            else
            {
                NSLog(@"insertOneData失败 %@",TABLE_NAME);
            }
            [db commit];
            [db close];
        }
    });
    
    return res;
}

-(NSMutableArray*)queryData
{
    NSMutableArray*dataArr=[NSMutableArray array];
    dispatch_sync([QueueFetcher getInstance].dbQueue, ^{
        
        if ([db open])
        {
            NSString *queryAllSql = [NSString stringWithFormat:@"SELECT * FROM %@", TABLE_NAME];
            FMResultSet *resultSet = [db executeQuery:queryAllSql];
            while ([resultSet next])
            {
                yzThroughRecordModel *result = [[yzThroughRecordModel alloc]init];
                
                result.id_self = [resultSet intForColumn:ID_SELF];
                
//                NSMutableDictionary* mut1 = [NSMutableDictionary dictionary];
//                [mut1 setObject:[resultSet stringForColumn:currentType] forKey:@"value"];
//                [result.currentType setObject:mut1 forKey:@"currentType"];
//                
//                NSMutableDictionary* mut2 = [NSMutableDictionary dictionary];
//                [mut2 setObject:[resultSet stringForColumn:currenterType] forKey:@"value"];
//                [result.currenterType setObject:mut2 forKey:@"currenterType"];
//                
//                NSMutableDictionary* mut3 = [NSMutableDictionary dictionary];
//                [mut3 setObject:[resultSet stringForColumn:currentState] forKey:@"value"];
//                [result.currentState setObject:mut3 forKey:@"currentState"];
                
                result.currenttime = [resultSet stringForColumn:currenttime];
                result.currentType = [resultSet stringForColumn:currentType];
                result.currenterType = [resultSet stringForColumn:currenterType];
                result.currentState = [resultSet stringForColumn:currentState];
                result.phoneSystem = [resultSet stringForColumn:phoneSystem];
                result.remarks = [resultSet stringForColumn:remarks];
                result.platenumber = [resultSet stringForColumn:platenumber];
                result.accessObject = [resultSet stringForColumn:accessObject];
                result.proXiaoquId = [resultSet stringForColumn:proXiaoquId];
                result.appUserId = [resultSet stringForColumn:appUserId];
                result.openState = [resultSet stringForColumn:openState];
                [dataArr insertObject:result atIndex:0];
            }
            [db close];
        }
    });
    return dataArr;
}




-(BOOL)deleteAllData{
    __block BOOL res = NO;
    dispatch_sync([QueueFetcher getInstance].dbQueue, ^{
        
        if ([db open])
        {
            NSString *deleteAllSql = [NSString stringWithFormat:@"DELETE FROM '%@'", TABLE_NAME];
            [db beginTransaction];
            res = [db executeUpdate:deleteAllSql];
            [db commit];
            [db close];
        }
    });
    
    return res;
    
}

@end
