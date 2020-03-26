//
//  AliyunOSImageAssistant.m
//  tjcclzShopC
//
//  Created by LiuHQ on 2018/6/6.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "AliyunOSImageAssistant.h"
#import <AliyunOSSiOS/OSSService.h>

//最多尝试上传次数
#define MAXTIME 100
@interface AliyunOSImageAssistant(){
    __block NSInteger _failTimes;    //如果失败次数太多则放弃
}
@property (strong,nonatomic)OSSClient *client;
@property (strong,nonatomic)NSMutableArray *imgContentArr;
@property (strong,nonatomic)NSMutableArray *imgUrl;
@end
static AliyunOSImageAssistant *assist;

@implementation AliyunOSImageAssistant
-(instancetype)init{
    self = [super init];
    if (self ) {
        [self initImage];
    }
    return self;
}

-(void)initImage{
//    NSString *endpoint = @"oss-cn-shanghai.aliyuncs.com";
    // 由阿里云颁发的AccessKeyId/AccessKeySecret构造一个CredentialProvider。
    // 明文设置secret的方式建议只在测试时使用，更多鉴权模式请参考后面的访问控制章节。
    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:OSSAceessKey secretKey:OSSSecret];
    self.client = [[OSSClient alloc] initWithEndpoint:OSSendPoint credentialProvider:credential];
}

+(AliyunOSImageAssistant *)sharedAliyunOSImageAssistant
{
    @synchronized(self){
        if (assist==nil) {
            assist = [[AliyunOSImageAssistant alloc] init];
        }
    }
    return assist;
}

/**
 *  @brief 下载指定图片
 *
 *  @param imgUrl 服务器图片地址
 *  @param result 返回图片数据流
 */
-(void)downImage:(NSString *)imgUrl block:(void (^)(bool state,id objc))result{
    OSSGetObjectRequest * request  = [OSSGetObjectRequest new];
    
    // 必填字段
    request.bucketName             = BUCKETNAME;
    request.objectKey              = imgUrl;
    
    // 可选字段
    request.downloadProgress       = ^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        // 当前下载段长度、当前已经下载总长度、一共需要下载的总长度
        NSLog(@"%lld, %lld, %lld", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    };
    // request.range = [[OSSRange alloc] initWithStart:0 withEnd:99]; // bytes=0-99，指定范围下载
    // request.downloadToFileURL = [NSURL fileURLWithPath:@"<filepath>"]; // 如果需要直接下载到文件，需要指明目标文件地址
    
    OSSTask * getTask              = [self.client getObject:request];
    
    [getTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"download object success!");
            OSSGetObjectResult * getResult = task.result;
            //            NSLog(@"download result: %@", getResult.downloadedData);
            result(YES,getResult.downloadedData);
        } else {
            NSLog(@"download object failed, error: %@" ,task.error);
            result(NO,task.error);
        }
        return nil;
    }];
}


/**
 *  @brief 上传图片  图片全名方法：时间戳_随机数
 *
 *  @param imgData 数据流
 *  @param type    0:news 1:users 2:app 3:others
 *  @param result  是否上传成功
 */
#define TYPECONFIG @[@"appzsf",@"appzsf",@"appzsf",@"appzsf"]
-(void)upImage:(UIImage *)image typeConfig:(NSInteger)type block:(void(^)(bool state,id objc))result{
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    // 必填字段
    put.bucketName = BUCKETNAME;
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    
    
    NSString *rangStr = [NSString stringWithFormat:@"%ld_%ld.jpg",(long)interval,(long)arc4random() %1000];
    put.uploadingFileURL = [AliyunOSImageAssistant saveImage:image withName:rangStr];
    
    put.objectKey = [NSString stringWithFormat:@"%@/%@",TYPECONFIG[type],rangStr];
    
    //    put.uploadingFileURL = [NSURL fileURLWithPath:@"<filepath>"];
    // put.uploadingData = <NSData *>; // 直接上传NSData
    //    本地图片加载
    //    NSString *path = [[NSBundle mainBundle] bundlePath];
    //    NSString *name = [NSString stringWithFormat:@"1.jpg"];
    //    NSString *finalPath = [path stringByAppendingPathComponent:name];
    //    NSData *imageData = [NSData dataWithContentsOfFile: finalPath];
    //    put.uploadingData = imgData;
    
    
    //    put.contentType = @"application/octet-stream";
    
    // 可选字段，可不设置
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        // 当前上传段长度、当前已经上传总长度、一共需要上传的总长度
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    
    // 以下可选字段的含义参考： https://docs.aliyun.com/#/pub/oss/api-reference/object&PutObject
    //     put.contentType        = @"";
    //     put.contentMd5         = @"";
    //     put.contentEncoding    = @"";
    //     put.contentDisposition = @"";
    
    // put.objectMeta = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"value1", @"x-oss-meta-name1", nil]; // 可以在上传时设置元信息或者其他HTTP头部
    
    OSSTask * putTask = [self.client putObject:put];
    
    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"upload object success!");
            result(YES, [NSString stringWithFormat:@"%@%@/%@",OSSImageUrl,TYPECONFIG[type],rangStr]);
            
        } else {
            NSLog(@"upload object failed, error: %@" , task.error);
            result(NO,task.error);
        }
        return nil;
    }];
    
    // [putTask waitUntilFinished];
    
    // [put cancel];
}

+ (NSURL *) saveImage:(UIImage *)currentImage withName:(NSString *)imageName{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
    return  [NSURL fileURLWithPath:fullPath];
}

#pragma mark ---递归法实现批量上传
/**
 递归法实现批量上传
 
 @param imgArr 图片数组
 */
-(void)uploadImageArr:(NSArray *)imgArr{
    _failTimes = 0;
    if (!_imgContentArr) {
        _imgContentArr = [NSMutableArray new];
        _imgUrl = [NSMutableArray new];
        
    }else{
        [_imgContentArr removeAllObjects];
        [_imgUrl removeAllObjects];
    }
    [_imgContentArr addObjectsFromArray:imgArr];
    [self addImage:_imgContentArr[0] index:0];
}

/**
 选择多种方式批量上传图片
 
 @param imgArr 图片数组
 @param type 0：递归 1：NSThread 2:NSOperation 3:GCD
 */

-(void)uploadImageArr:(NSArray *)imgArr type:(NSInteger)type{
    _failTimes = 0;
    if (!_imgContentArr) {
        _imgContentArr = [NSMutableArray new];
        _imgUrl = [NSMutableArray new];
        
    }else{
        [_imgContentArr removeAllObjects];
        [_imgUrl removeAllObjects];
    }
    [_imgContentArr addObjectsFromArray:imgArr];
    if (type == 0) {
        [self addImage:_imgContentArr[0] index:0];
    }else if(type == 1){
        [self uploadImageArrByNSThread:imgArr];
    }else if(type == 2){
        [self uploadImageArrByNSOperation:imgArr];
    }else if(type == 3){
        [self uploadImageArrByGCD:imgArr];
    }
    
}

-(void)addImage:(UIImage *)image index:(NSInteger )index{
    WEAKSELF
    [self upImage:image typeConfig:2 block:^(bool state, id objc) {
        if (state) {
            if (index < _imgContentArr.count - 1) {
                [weakSelf addImage:_imgContentArr[index + 1] index:index + 1];
                [_imgUrl addObject:objc];
            }else{
                [_imgUrl addObject:objc];
                [weakSelf endImageUrl:_imgUrl];
            }
        }else{
            if (++_failTimes == MAXTIME) {
                [weakSelf endImageUrl:nil];
            }else{
                [weakSelf addImage:_imgContentArr[index] index:index];
            }
        }
    }];
}

-(void)endImageUrl:(NSMutableArray *)imgUrlArr{
    NSLog(@"%@",imgUrlArr);
    NSLog(@"%@",_imgUrl);
    if (_imageUrlBlock) {
        _imageUrlBlock(imgUrlArr);
    }
}

#pragma mark ---NSThread
-(void)uploadImageArrByNSThread:(NSArray *)imgArr{
    for (NSInteger item = 0; item < imgArr.count; item++) {
        [_imgUrl addObject:@""];
        NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(uploadImageWithThread:) object:_imgContentArr[item]];
        [thread setName:[NSString stringWithFormat:@"%ld",(long)item]];
        [thread start];
    }
}

-(void)uploadImageWithThread:(UIImage *)image{
    [self upImage:image typeConfig:2 block:^(bool state, id objc) {
        NSInteger index = [_imgContentArr indexOfObject:image];
        if (state) {
            [self getImageUrlWithThread:objc index:index];
        }else{
            if (++_failTimes == MAXTIME) {
                [self getImageUrlWithThread:@"no" index:index];
            }else{
                [self uploadImageWithThread:image];
            }
        }
    }];
}

-(void)getImageUrlWithThread:(NSString *)imgUrl index:(NSInteger)index{
    NSLog(@"%@",[NSThread currentThread]);
    [_imgUrl replaceObjectAtIndex:index withObject:imgUrl];
    
    if ([_imgUrl containsObject:@""]) {
        return;
    }
    
    if ([_imgUrl containsObject:@"no"]) {
        [self performSelectorOnMainThread:@selector(endImageUrl:) withObject:nil waitUntilDone:YES];
    }else{
        [self performSelectorOnMainThread:@selector(endImageUrl:) withObject:_imgUrl waitUntilDone:YES];
    }
}

#pragma mark ---NSOperation,NSOperationQueue

//NSInvocationOperation
-(void)uploadImageArrByNSOperation:(NSArray *)imgArr{
    //创建操作队列
    NSOperationQueue *operationQueue=[[NSOperationQueue alloc]init];
    operationQueue.maxConcurrentOperationCount = imgArr.count;
    /*创建一个调用操作
     object:调用方法参数
     */
    for (NSInteger item = 0; item < imgArr.count; item++) {
        [_imgUrl addObject:@""];
        NSInvocationOperation *invocationOperation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(uploadImageUseOperation:) object:_imgContentArr[item]];
        
        //创建完NSInvocationOperation对象并不会调用，它由一个start方法启动操作，但是注意如果直接调用start方法，则此操作会在主线程中调用，一般不会这么操作,而是添加到NSOperationQueue中
        //    [invocationOperation start];
        
        //注意添加到操作队后，队列会开启一个线程执行此操作
        [operationQueue addOperation:invocationOperation];
    }
}

//NSBlockOperation
-(void)uploadImageArrByNSBlockOperation:(NSArray *)imgArr{
    //创建操作队列
    NSOperationQueue *operationQueue=[[NSOperationQueue alloc]init];
    operationQueue.maxConcurrentOperationCount = imgArr.count;
    /*创建一个调用操作
     object:调用方法参数
     */
    for (NSInteger item = 0; item < imgArr.count; item++) {
        [_imgUrl addObject:@""];
        NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
            [self uploadImageArrByNSOperation:_imgContentArr[item]];
        }];
        //注意添加到操作队后，队列会开启一个线程执行此操作
        [operationQueue addOperation:blockOperation];
    }
}

-(void)uploadImageUseOperation:(UIImage *)image{
    [self upImage:image typeConfig:2 block:^(bool state, id objc) {
        NSInteger index = [_imgContentArr indexOfObject:image];
        if (state) {
            [self getImageUrlWithThread:objc index:index];
        }else{
            if (++_failTimes == MAXTIME) {
                [self getImageUrlWithThread:@"no" index:index];
            }else{
                [self uploadImageUseOperation:image];
            }
        }
    }];
}

-(void)getImageUrlWithOperation:(NSString *)imgUrl index:(NSInteger)index{
    
    [_imgUrl replaceObjectAtIndex:index withObject:imgUrl];
    
    //还有未完成的线程
    if ([_imgUrl containsObject:@""]) {
        return;
    }
    //有上传失败的线程
    if ([_imgUrl containsObject:@"no"]) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self endImageUrl:nil];
        }];
    }else{
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self endImageUrl:_imgUrl];
        }];
    }
}

#pragma mark ---GCD
//创建串行队列完成
-(void)uploadImageArrByGCD:(NSArray *)imageArr{
    dispatch_queue_t serialQueue = dispatch_queue_create("uploadThread", DISPATCH_QUEUE_SERIAL);
    //并发队列完成
    //    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    for (NSInteger item = 0; item < imageArr.count; item++) {
        [_imgUrl addObject:@""];
        dispatch_async(serialQueue, ^{
            [self uploadImageUseGCD:_imgContentArr[item] index:item];
        });
    }
}

-(void)uploadImageUseGCD:(UIImage *)image index:(NSInteger)index{
    [self upImage:image typeConfig:2 block:^(bool state, id objc) {
        if (state) {
            [self getImageUrlWithThread:objc index:index];
        }else{
            if (++_failTimes == MAXTIME) {
                [self getImageUrlWithGCD:@"no" index:index];
            }else{
                [self uploadImageUseGCD:image index:index];
            }
        }
    }];
}

-(void)getImageUrlWithGCD:(NSString *)imgUrl index:(NSInteger)index{
    //还有未完成的线程
    [_imgUrl replaceObjectAtIndex:index withObject:imgUrl];
    if ([_imgUrl containsObject:@""]) {
        return;
    }
    //有上传失败的线程
    dispatch_queue_t mainqueue = dispatch_get_main_queue();
    if ([_imgUrl containsObject:@"no"]) {
        dispatch_sync(mainqueue, ^{
            [self endImageUrl:nil];
        });
    }else{
        dispatch_sync(mainqueue, ^{
            [self endImageUrl:nil];
        });
    }
}
@end
