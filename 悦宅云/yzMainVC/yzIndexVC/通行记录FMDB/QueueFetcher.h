//
//  QueueFetcher.h
//  TestForFMDB
//
//  Created by  apple on 16/2/29.
//  Copyright © 2016年  apple. All rights reserved.
//

/*!
 @class         QueueFetcher
 @author        刘圣杰
 @version       1.0
 @discussion	队列获取的单例。
 */
#import <Foundation/Foundation.h>

@interface QueueFetcher : NSObject
@property (nonatomic,strong) dispatch_queue_t dbQueue;//数据库操作所使用的队列
/**
 *  获取本类的单例对象
 *
 *  @return 单例对象
 */
+(QueueFetcher*)getInstance;

@end
