//
//  CCAFNetWork.m
//  tjcclzShopC
//
//  Created by LiuHQ on 2018/4/25.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "CCAFNetWork.h"

@implementation CCAFNetWork

/** 封装初始化一下AFHTTPSessionManager */
+(AFHTTPSessionManager *)afManager:(NSString *)version{
    AFHTTPSessionManager *manager=[AFHTTPSessionManager   manager];
    //无条件的信任服务器上的证书
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    // 客户端是否信任非法证书
    securityPolicy.allowInvalidCertificates = YES;
    // 是否在证书域字段中验证域名
    securityPolicy.validatesDomainName = NO;
    manager.securityPolicy = securityPolicy;
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    //如果报接受类型不一致请替换一致text/html或别的
    manager.requestSerializer= [AFHTTPRequestSerializer serializer];
    manager.responseSerializer= [AFHTTPResponseSerializer serializer];
//    //设置请求头
    if ([BBUserData isValid:version]) {
//        [manager.requestSerializer setValue:[DPDeviceInfo dp_getDeviceIDFA] forHTTPHeaderField:@"device-udid"];
//        [manager.requestSerializer setValue:@"iphone" forHTTPHeaderField:@"device-client"];
//        [manager.requestSerializer setValue:@"6002" forHTTPHeaderField:@"device-code"];
        [manager.requestSerializer setValue:version forHTTPHeaderField:@"Authorization"];
    }
//
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
//    [serializer setRemovesKeysWithNullValues:YES];
    [manager setResponseSerializer:serializer];
    
    if ([version intValue] == 10) {
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html",nil];
    }else{
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json",@"text/plain", nil];
    }
    return manager;
}
/**
 get请求数据
 
 @param url 地址
 @param params 参数
 @param success 成功返回
 @param failure 失败返回
 */
+(void)get:(NSString *)url version:(NSString *)version parameters:(id)params success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    NSLog(@"url==%@,%@",url,params);
    
    AFHTTPSessionManager *manager = [self afManager:version];
    [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"------%@",responseObject);
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
}
/**
 post请求数据
 
 @param url 地址
 @param params 参数
 @param success 成功返回
 @param failure 失败返回
 */
+(void)post:(NSString *)url version:(NSString *)version parameters:(id)params success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    AFHTTPSessionManager *manager = [self afManager:version];
//    [manager.requestSerializer setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    NSLog(@"请求地址===%@和%@",url,params);
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      

        
        
        
        
        NSLog(@"url=%@+++++%@",url,responseObject);
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
}

/**
 post 带图片的上传数据

 @param url 地址
 @param params 参数
 @param formaData 文件信息
 @param progress 进度
 @param success 成功
 @param failure 失败
 */
+(void)post:(NSString *)url version:(NSString *)version parameters:(id)params constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))formaData progress:(void (^)(NSProgress *))progress success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    AFHTTPSessionManager *manager = [self afManager:version];
    
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (formaData) {
            formaData(formData);
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}
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
+(void)unload:(NSString *)uploadUrl version:(NSString *)version parameters:(id)params filePath:(NSArray *)filePath name:(NSArray *)name progress:(void (^)(NSProgress *))progress success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    AFHTTPSessionManager *manager = [self afManager:version];
    
    [manager POST:uploadUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i=0; i<filePath.count; i++) {
            UIImage * image =[UIImage imageWithContentsOfFile:filePath[i]];
            NSDate *date = [NSDate date];
            NSDateFormatter *formormat = [[NSDateFormatter alloc]init];
            [formormat setDateFormat:@"HHmmss"];
            NSString *dateString = [formormat stringFromDate:date];
            
            NSString *fileName = [NSString  stringWithFormat:@"%@.png",dateString];
            NSData *imageData = UIImageJPEGRepresentation(image, 1);
            double scaleNum = (double)300*1024/imageData.length;
            NSLog(@"图片压缩率：%f",scaleNum);
            if(scaleNum <1){
                imageData = UIImageJPEGRepresentation(image, scaleNum);
            }else{
                imageData = UIImageJPEGRepresentation(image, 0.1);
            }
            [formData  appendPartWithFileData:imageData name:@"files" fileName:fileName mimeType:@"image/jpg/png/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (progress) {
            progress(uploadProgress);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
}
+(void)download:(NSString *)url version:(NSString *)version progress:(void (^)(NSProgress *))progress destination:(NSURL *(^)(NSURL *, NSURLResponse *))destination failure:(void (^)(NSURLResponse *, NSURL *, NSError *))failure{
    // 1 创建会话管理者
    AFHTTPSessionManager *manager = [self afManager:version];
    
    // 2 创建请求路径 请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    // 3 创建请求下载操作对象
    NSURLSessionDownloadTask *downTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        // // 计算进度 NSLog(@"downloading --- %f", 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        if (progress) {
            progress(downloadProgress);
        }
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
//        // 获得文件下载保存的全路径
//        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
//        NSLog(@"fullPath --- %@, tmpPath --- %@", fullPath, targetPath); // 打印需要修改的全路径 & 临时路径
//        
//        // 该方法会拼接上协议头 file:// 成为一个完整的URL，而URLWithString不会自动拼接协议头
//        return [NSURL fileURLWithPath:fullPath];  
        if (destination) {
            return  destination(targetPath, response);
        } else {
            return nil;
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (failure) {
            failure(response, filePath, error);
        }
    }];
    
    // 4 执行任务发送下载操作请求
    [downTask resume];
}

/**
 进行判断错误信息

 @param msg 信息
 @return 判断完的信息
 */
+(NSString *)ResultDesc:(NSString *)msg{
    if ([msg isEqualToString:@"Invalid session"]) {
        return @"登录信息已过期";
    }else{
        return msg;
    }
}
/** 数据 */
+(NSDictionary *)objectDictionary:(id)object{
//    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:object options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves  error:nil];
    return object;
}
/*!
 
 * @brief 把格式化的JSON格式的字符串转换成字典
 
 * @param jsonString JSON格式的字符串
 
 * @return 返回字典
 
 */

//json格式字符串转字典：

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
/** 获取shop/token  access_token */
+(void)getToken{
    [self post:[NSString stringWithFormat:@"%@shop/token",postUrl] version:@"" parameters:nil success:^(id object) {
        NSDictionary *json = object;
        if ([[[json objectForKey:@"status"] objectForKey:@"succeed"] intValue]) {
            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@",json[@"data"][@"access_token"]] forKey:@"userShopToken"];
        }
    } failure:^(NSError *error) {
        
    }];
}

/**
 验证码手机号
 
 @param mobileNum 手机号
 @return YES 通过 NO 不通过
 */
+ (BOOL)validateContactNumber:(NSString *)mobileNum
{
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 16[6], 17[5, 6, 7, 8], 18[0-9], 170[0-9], 19[89]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705,198
     * 联通号段: 130,131,132,155,156,185,186,145,175,176,1709,166
     * 电信号段: 133,153,180,181,189,177,1700,199
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|6[6]|7[05-8]|8[0-9]|9[89])\\d{8}$";
    
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478]|9[8])\\d{8}$)|(^1705\\d{7}$)";
    
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|66|7[56]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    
    NSString *CT = @"(^1(33|53|77|8[019]|99)\\d{8}$)|(^1700\\d{7}$)";
    
    /**
     * 大陆地区固话及小灵通
     * 区号：010,020,021,022,023,024,025,027,028,029
     * 号码：七位或八位
     */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    // NSPredicate *regextestPHS = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    if(([regextestmobile evaluateWithObject:mobileNum] == YES)
       || ([regextestcm evaluateWithObject:mobileNum] == YES)
       || ([regextestct evaluateWithObject:mobileNum] == YES)
       || ([regextestcu evaluateWithObject:mobileNum] == YES)) {
        return YES;
    } else {
        return NO;
    }
}
///验证车牌号

+ (BOOL)isValidCarID:(NSString *)carID {
  
    NSString *carRegex = @"([京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}(([0-9]{5}[DF])|([DF]([A-HJ-NP-Z0-9])[0-9]{4})))|([京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}[A-HJ-NP-Z0-9]{4}[A-HJ-NP-Z0-9挂学警港澳]{1})";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    return [carTest evaluateWithObject:carID];

}
@end
