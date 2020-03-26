//
//  GKPhotoBrowser.h
//  GKPhotoBrowser
//
//  Created by QuintGao on 2017/10/20.
//  Copyright © 2017年 QuintGao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKPhotoView.h"

NS_ASSUME_NONNULL_BEGIN

#define IS_IPHONE_5S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE_7 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE_7P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iPhoneX，Xs（iPhoneX，iPhoneXs）
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iPhoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iPhoneXsMax
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iPhoneX所有系列
#define IS_PhoneXAll (IS_IPHONE_X || IS_IPHONE_Xr || IS_IPHONE_Xs_Max)
#define kSaveTopSpace       (IS_PhoneXAll ? 24.0f : 0)   // iPhone X顶部多出的距离（刘海）
#define kSaveBottomSpace    (IS_PhoneXAll ? 34.0f : 0)   // iPhone X底部多出的距离

@class GKPhotoBrowser;

typedef void(^layoutBlock)(GKPhotoBrowser *photoBrowser, CGRect superFrame);

@protocol GKPhotoBrowserDelegate<NSObject>

@optional

// 滚动到一半时索引改变
- (void)photoBrowser:(GKPhotoBrowser *)browser didChangedIndex:(NSInteger)index;

// 滚动结束时索引改变
- (void)photoBrowser:(GKPhotoBrowser *)browser scrollEndedIndex:(NSInteger)index;

// 单击事件
- (void)photoBrowser:(GKPhotoBrowser *)browser singleTapWithIndex:(NSInteger)index;

// 长按事件
- (void)photoBrowser:(GKPhotoBrowser *)browser longPressWithIndex:(NSInteger)index;

// 旋转事件
- (void)photoBrowser:(GKPhotoBrowser *)browser onDeciceChangedWithIndex:(NSInteger)index isLandspace:(BOOL)isLandspace;

// 上下滑动消失
// 开始滑动时
- (void)photoBrowser:(GKPhotoBrowser *)browser panBeginWithIndex:(NSInteger)index;

// 结束滑动时 disappear：是否消失
- (void)photoBrowser:(GKPhotoBrowser *)browser panEndedWithIndex:(NSInteger)index willDisappear:(BOOL)disappear;


- (void)photoBrowser:(GKPhotoBrowser *)browser willLayoutSubViews:(NSInteger)index;

@end

@interface GKPhotoBrowser : UIViewController

/** 底部内容试图 */
@property (nonatomic, strong, readonly) UIView        *contentView;
/** 图片模型数组 */
@property (nonatomic, strong, readonly) NSArray       *photos;
/** 当前索引 */
@property (nonatomic, assign, readonly) NSInteger     currentIndex;
/** 是否是横屏 */
@property (nonatomic, assign, readonly) BOOL          isLandspace;
/** 当前设备的方向 */
@property (nonatomic, assign, readonly) UIDeviceOrientation currentOrientation;
/** 显示方式 */
@property (nonatomic, assign) GKPhotoBrowserShowStyle showStyle;
/** 隐藏方式 */
@property (nonatomic, assign) GKPhotoBrowserHideStyle hideStyle;
/** 图片加载方式 */
@property (nonatomic, assign) GKPhotoBrowserLoadStyle loadStyle;
/** 代理 */
@property (nonatomic, weak) id<GKPhotoBrowserDelegate> delegate;

/** 是否禁止屏幕旋转监测 */
@property (nonatomic, assign) BOOL isScreenRotateDisabled;

/** 是否禁用默认单击事件 */
@property (nonatomic, assign) BOOL isSingleTapDisabled;

/** 是否显示状态栏，默认NO：不显示状态栏 */
@property (nonatomic, assign) BOOL isStatusBarShow;

/** 滑动消失时是否隐藏原来的视图：默认YES */
@property (nonatomic, assign) BOOL isHideSourceView;

/** 滑动切换图片时，是否恢复上（下）一张图片的缩放程度，默认是NO */
@property (nonatomic, assign) BOOL isResumePhotoZoom;

// 初始化方法

/**
 创建图片浏览器

 @param photos 包含GKPhoto对象的数组
 @param currentIndex 当前的页码
 @return 图片浏览器对象
 */
+ (instancetype)photoBrowserWithPhotos:(NSArray<GKPhoto *> *)photos currentIndex:(NSInteger)currentIndex;

- (instancetype)initWithPhotos:(NSArray<GKPhoto *> *)photos currentIndex:(NSInteger)currentIndex;

/**
 为浏览器添加自定义遮罩视图

 @param coverViews  视图数组
 @param layoutBlock 布局
 */
- (void)setupCoverViews:(NSArray *)coverViews layoutBlock:(layoutBlock)layoutBlock;

/**
 显示图片浏览器

 @param vc 控制器
 */
- (void)showFromVC:(UIViewController *)vc;

+ (void)setImageManagerClass:(Class<GKWebImageProtocol>)cls;

@end

NS_ASSUME_NONNULL_END
