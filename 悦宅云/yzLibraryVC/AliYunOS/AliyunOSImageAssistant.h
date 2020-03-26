//
//  AliyunOSImageAssistant.h
//  tjcclzShopC
//
//  Created by LiuHQ on 2018/6/6.
//  Copyright © 2018年 CC. All rights reserved.
//

#import <Foundation/Foundation.h>
#define SHARE_ALIYUN_IMG [AliyunOSImageAssistant sharedAliyunOSImageAssistant]

@interface AliyunOSImageAssistant : NSObject
+(AliyunOSImageAssistant *)sharedAliyunOSImageAssistant;

/**
 *  @brief 下载指定图片
 *
 *  @param imgUrl 服务器图片地址
 *  @param result 返回图片数据流
 */
-(void)downImage:(NSString *)imgUrl block:(void (^)(bool state,id objc))result;


/**
 *  @brief 上传图片  图片全名方法：时间戳_随机数
 *
 *  @param image 数据流
 *  @param type    0:news 1:users 2:app 3:others
 *  @param result  是否上传成功
 */
-(void)upImage:(UIImage *)image typeConfig:(NSInteger)type block:(void(^)(bool state,id objc))result;


#pragma mark ---递归法实现批量上传
/**
 递归法实现批量上传
 
 @param imgArr 图片数组
 */
-(void)uploadImageArr:(NSArray *)imgArr;

/**
 选择多种方式批量上传图片
 
 @param imgArr 图片数组
 @param type 0：递归 1：NSThread 2:NSOperation 3:GCD
 */

-(void)uploadImageArr:(NSArray *)imgArr type:(NSInteger)type;

@property (copy,nonatomic)void (^imageUrlBlock)(NSArray *imgUrl);
@end
