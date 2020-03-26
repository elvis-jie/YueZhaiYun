//
//  QueueFetcher.m
//  TestForFMDB
//
//  Created by  apple on 16/2/29.
//  Copyright © 2016年  apple. All rights reserved.
//

#import "QueueFetcher.h"

@implementation QueueFetcher

+(QueueFetcher*)getInstance
{
    static QueueFetcher* instance = nil;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        
        instance = [[self alloc]init];

    });
    
    return instance;
}
/**
 *  初始化
 *
 *  @return @""
 */
-(instancetype)init
{
    self = [super init];
    
    if(self)
    {
        _dbQueue = dispatch_queue_create("com.dispatch.DBQueue",DISPATCH_QUEUE_SERIAL);
    }
    
    return self;
}
/**
 *  获取数据库操作队列
 *
 *  @return 返回数据库操作队列
 */
-(dispatch_queue_t)dbQueue
{
    if(_dbQueue == nil)
    {
        _dbQueue = dispatch_queue_create("com.dispatch.DBQueue",DISPATCH_QUEUE_SERIAL);
    }
    
    return _dbQueue;
}
@end
