//
//  CCAFNetWork.h
//  tjcclzShopC
//
//  Created by LiuHQ on 2018/4/25.
//  Copyright © 2018年 CC. All rights reserved.
// 封装的网络请求

#import <Foundation/Foundation.h>
//#import "DPDeviceInfo.h"

@interface CCAFNetWork : NSObject

/**
 初始化manager

 @param version 版本号
 @return manager
 */
+(AFHTTPSessionManager *)afManager:(NSString *)version;

/**
 get请求数据
 
 @param url 地址
 @param params 参数
 @param success 成功返回
 @param failure 失败返回
 */
+ (void)get:(NSString *)url version:(NSString *)version parameters:(id)params success:(void (^)(id object))success failure:(void (^)(NSError *error))failure;

/**
 post请求数据
 
 @param url 地址
 @param params 参数
 @param success 成功返回
 @param failure 失败返回
 */
+ (void)post:(NSString *)url version:(NSString *)version parameters:(id)params success:(void (^)(id object))success failure:(void (^)(NSError *error))failure;
/**
 post 带图片的上传数据
 
 @param url 地址
 @param params 参数
 @param formaData 文件信息
 @param progress 进度
 @param success 成功
 @param failure 失败
 */
+(void)post:(NSString *)url version:(NSString *)version parameters:(id)params constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))formaData progress:(void (^)(NSProgress *progress))progress success:(void (^)(id object))success failure:(void (^)(NSError *error))failure;
/**
 上传图片
 
 @param uploadUrl 地址
 @param params 参数
 @param filePath 本地图片地址
 @param name 名字
 @param progress 上传进入
 @param success 成功返回
 @param failure 失败返回
 */
+ (void)unload:(NSString *)uploadUrl version:(NSString *)version parameters:(id)params filePath:(NSArray *)filePath name:(NSArray *)name progress:(void (^)(NSProgress *))progress success:(void (^)(id object))success failure:(void (^)(NSError *))failure;

/**
 下载
 
 @param url 地址
 @param progress 进入
 @param destination destination URL处理的回调
 targetPath:文件下载到沙盒中的临时路径
 response:响应头信息
 @param failure 告诉AFN文件应该剪切到什么地方
 */
+ (void)download:(NSString *)url version:(NSString *)version progress:(void (^)(NSProgress *progress))progress destination:(NSURL *(^)(NSURL *targetPath, NSURLResponse *response))destination failure:(void (^)(NSURLResponse * response, NSURL * filePath, NSError * error))failure;
/**
 进行判断错误信息
 
 @param msg 信息
 @return 判断完的信息
 */
+(NSString *)ResultDesc:(NSString *)msg;
/**
 网络数据转换

 @param object 源数据
 @return 转换的数据
 */
+(NSDictionary *)objectDictionary:(id)object;
/*!
 
 * @brief 把格式化的JSON格式的字符串转换成字典
 
 * @param jsonString JSON格式的字符串
 
 * @return 返回字典
 
 */

//json格式字符串转字典：

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
/** 获取shop/token  access_token */
+(void)getToken;


/**
 验证码手机号
 
 @param mobileNum 手机号
 @return YES 通过 NO 不通过
 */
+ (BOOL)validateContactNumber:(NSString *)mobileNum;

/**
 验证车牌号
 
 @param carID 车牌号
 @return YES 通过 NO 不通过
 */
+ (BOOL)isValidCarID:(NSString *)carID;
@end
