//
//  BBUserData.h
//  BearWeding
//
//  Created by Tom on 16/5/7.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBUserData : NSObject
@property(nonatomic,strong)NSDictionary *userData;//用户信息
@property(nonatomic,strong)NSMutableArray *userPlanData;//计划书信息
@property(nonatomic,strong)NSMutableDictionary *userPlanMainData;//用户结婚计划总预算信息
@property(nonatomic,assign)BOOL isLogin;//用户资料
@property(nonatomic,strong)NSDictionary *cityData;//城市资料
@property(nonatomic,strong)NSDictionary *cityChoose;//城市选择器

@property(nonatomic,strong)NSDictionary *activitData;//活动的数据
+(instancetype)shareData;
/**
 *  判断字符串是否为空，是空则替换
 *
 *  @param changeString <#changeString description#>
 *  @param replaceStr   <#replaceStr description#>
 *
 *  @return <#return value description#>
 */
+(NSString *)stringChangeNull:(NSString *)changeString replaceWith:(NSString *)replaceStr;
/**
 *  判断字典里是否有空数据，有空则替换
 *
 *  @param nullDic <#nullDic description#>
 *  @param reStr   <#reStr description#>
 *
 *  @return <#return value description#>
 */
+(NSDictionary *)dicChangeNull:(NSDictionary*)nullDic replaceWith:(NSString *)reStr;;
/**
 *  是否是偏远地区
 *
 *  @param dress <#dress description#>
 *
 *  @return <#return value description#>
 */
+(BOOL)isPianYuanWithDress:(NSString *)dress;
/**
 *  判断图片是不是66结婚网上的图片
 */
+(NSURL *)imageIssdGetFromImageStr:(NSString *)imageStr;


+(NSString *)getMD5StrWithStr:(NSString *)MD5Str;

+ (BOOL)isValid:(id)data;

+ (NSInteger)compareDate:(NSString*)aDate withDate:(NSString*)bDate;
//获取周几
+ (NSString *) getweekDayStringWithDate:(NSDate *) date;
@end
