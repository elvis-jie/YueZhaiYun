//
//  BBUserData.m
//  BearWeding
//
//  Created by Tom on 16/5/7.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import "BBUserData.h"
#import <CommonCrypto/CommonDigest.h>


@interface BBUserData()


@end
@implementation BBUserData
@synthesize userData = _userData;
@synthesize isLogin = _isLogin;
@synthesize userPlanData = _userPlanData;
@synthesize userPlanMainData = _userPlanMainData;
@synthesize cityData = _cityData;
@synthesize activitData = _activitData;
+(instancetype)shareData{

    static dispatch_once_t onceToken;
    static BBUserData *uuserData;
    dispatch_once(&onceToken, ^{
        uuserData = [[BBUserData alloc]init];
    });
    return uuserData;
}




#pragma mark -- 城市选择器里面的数据
-(NSDictionary *)cityChoose{

    if (!_cityChoose) {
        
        NSString *path=[[NSBundle mainBundle] pathForResource:@"CityChooser"ofType:@"plist"];

        _cityChoose = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    return _cityChoose;
}
#pragma mark -- 判断字典里是否有空数据，有空则替换
+(NSDictionary *)dicChangeNull:(NSDictionary *)nullDic replaceWith:(NSString *)reStr{

    return [[BBUserData shareData]dicChangeNull:nullDic replaceWith:reStr];
}
-(NSDictionary *)dicChangeNull:(NSDictionary *)nullDic replaceWith:(NSString *)reStr{

    if (nullDic&&[nullDic allKeys].count>0) {
        NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc]initWithDictionary:nullDic];
        NSArray *keyArr = [nullDic allKeys];
        for (NSString *key in keyArr) {
            NSString *value = [NSString stringWithFormat:@"%@",[nullDic objectForKey:key]];
            if ([[value class]isSubclassOfClass:[NSNull class]]||[value isEqualToString:@"(null)"]||[value isEqualToString:@"<null>"]) {
                [mutableDic setObject:reStr forKey:key];
            }
        }
        return mutableDic;
    }else{
        return [NSDictionary dictionary];
    }
}
#pragma mark -- 判断字符串是否为空，是空则替换
+(NSString *)stringChangeNull:(NSString *)changeString replaceWith:(NSString *)replaceStr{

    return [[BBUserData shareData]stringChangeNull:changeString replaceWith:replaceStr];
}
-(NSString *)stringChangeNull:(NSString *)changeString replaceWith:(NSString *)replaceStr{
    
    NSString *value = [NSString stringWithFormat:@"%@",changeString];
    
    if ([[value class]isSubclassOfClass:[NSNull class]]||[value isEqualToString:@"(null)"]||[value isEqualToString:@"<null>"]||value.length<1) {
        return replaceStr;
    }else{
        return value;
    }
        
}
#pragma mark -- 判断是否是偏远地区
+(BOOL)isPianYuanWithDress:(NSString *)dress{

    return [[BBUserData shareData] isPianYuanWithDress:dress];
}
-(BOOL)isPianYuanWithDress:(NSString *)dress{

    NSDictionary *cityDataDic = [NSDictionary dictionaryWithDictionary:[BBUserData shareData].cityChoose[dress]];
    if ([cityDataDic allKeys].count>1) {
        BOOL isPianYuan;
        NSString *pianStr= [BBUserData stringChangeNull:cityDataDic[@"is_PianYuan"] replaceWith:@"0"];
        isPianYuan= [pianStr isEqualToString:@"0"]?NO:YES;
        //NSLog(@"isPianYuan:%d dress:%@",isPianYuan,dress);
        return isPianYuan;
    }else{
        return NO;
    }
}
#pragma mark -- 判断图片的路径
+(NSURL *)imageIssdGetFromImageStr:(NSString *)imageStr{

    return [[BBUserData shareData]imageIssdGetFromImageStr:imageStr];
}
-(NSURL *)imageIssdGetFromImageStr:(NSString *)imageStr{

    NSString *string = [BBUserData stringChangeNull:imageStr replaceWith:@""];
    if (string.length>1) {
        NSArray *strArray = [string componentsSeparatedByString:@"/"];
        if ([strArray[0] isEqualToString:@"images"]) {
            NSString *urlStr = [NSString stringWithFormat:@"http://www.66wedding.com/%@",string];
            return [NSURL URLWithString:urlStr];
        }else{
            return [NSURL URLWithString:string];
        }
    }else{
        return [NSURL URLWithString:string];
    }
}



+(NSString *)getMD5StrWithStr:(NSString *)MD5Str{

    return [[BBUserData shareData] getMD5StrWithStr:MD5Str];
}

-(NSString *)getMD5StrWithStr:(NSString *)srcString{

    const char *cStr = [srcString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    [result appendFormat:@"%02x", digest[i]];
    
    return result;
}

+ (BOOL)isValid:(id)data
{
    if ([data isKindOfClass:[NSString class]])
    {
        return (![data isEqual:[NSNull null]] && data && ![data isEqualToString:@""]);
    }
    else if ([data isKindOfClass:[NSArray class]])
    {
        NSArray * array = data;
        return (array != nil && ![array isKindOfClass:[NSNull class]] && array.count !=0);
    }
    else if ([data isKindOfClass:[NSDictionary class]]){
        NSDictionary *dic = (NSDictionary *)data;
        return (dic !=nil && ![dic isKindOfClass:[NSNull class]]);
    }
    else
    {
        return (![data isEqual:[NSNull null]] && data);
    }
}

+ (NSInteger)compareDate:(NSString*)aDate withDate:(NSString*)bDate
{
    
   
    
    NSInteger aa = 0;

    NSComparisonResult result = [aDate compare:bDate];
    if (result==NSOrderedSame)
    {
        //相等
        aa = 0;
    }else if (result==NSOrderedAscending) {
        //bDate比aDate大
        aa = 1;
    }else if (result==NSOrderedDescending) {
        //bDate比aDate小
        aa = -1;
    }
    return aa;
    
}
//获取周几
+ (NSString *) getweekDayStringWithDate:(NSDate *) date

{
    
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]; // 指定日历的算法
    
    NSDateComponents *comps = [calendar components:NSWeekdayCalendarUnit fromDate:date];
    
    // 1 是周日，2是周一 3.以此类推
    
    NSNumber * weekNumber = @([comps weekday]);
    
    NSInteger weekInt = [weekNumber integerValue];
    
    NSString *weekDayString = @"01";
    
    switch (weekInt) {
            
        case 1:
            
        {
            
            weekDayString = @"07";
            
        }
            
            break;
            
        case 2:
            
        {
            
            weekDayString = @"01";
            
        }
            
            break;
            
        case 3:
            
        {
            
            weekDayString = @"02";
            
        }
            
            break;
            
        case 4:
            
        {
            
            weekDayString = @"03";
            
        }
            
            break;
            
        case 5:
            
        {
            
            weekDayString = @"04";
            
        }
            
            break;
            
        case 6:
            
        {
            
            weekDayString = @"05";
            
        }
            
            break;
            
        case 7:
            
        {
            
            weekDayString = @"06";
            
        }
            
            break;
            
        default:
            
            break;
            
    }
    
    return weekDayString;
    
}


@end
