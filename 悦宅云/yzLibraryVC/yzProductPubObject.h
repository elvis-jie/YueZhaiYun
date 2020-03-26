//
//  yzProductPubObject.h
//  yzProduct
//
//  Created by LiuHQ on 2018/9/20.
//  Copyright © 2018年 CC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface yzProductPubObject : NSObject
/** 复原动画 */
+(void)CatransHidden:(UIViewController *)controller;
/** 显示动画 */
+(void)CatransShow:(UIViewController *)controller;

/**
 添加navigation
 
 @param viewController 控制器
 @return 添加完成的
 */
+(UINavigationController *)navc:(UIViewController *)viewController;
/**
 计算字体宽度
 
 @param value 文字
 @param fontSize 字体大小
 @param height 高度
 @return 返回宽度
 */
+(float) widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height;
/**
 计算字体高度
 
 @param value 文字
 @param fontSize 字体大小
 @param width 宽度
 @return 返回高度
 */
+(float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width;
/**
 验证手机号是否合法
 
 @param mobileNum 手机号数据
 @return yes or no
 */
+ (BOOL)validateContactNumber:(NSString *)mobileNum;

/**
 邮箱验证
 
 @param emailnum 邮箱
 @return bool
 */
+ (BOOL)validateEmailNumber:(NSString *)emailnum;
/**
 数字验证
 *  『正则表达式；推荐使用，不用循环遍历，控制更灵活』判断字符串内容是否是有效数字
 *
 *  @param string 需要验证的字符串
 *
 *  @return 字符串内容是否是有效数字
 */
- (BOOL)validateNumberByRegExp:(NSString *)string;
/**
 uitableview显示空数据视图和无网络视图
 
 @param tableview 容器
 @param isShow 是否显示无网络view
 @param isShowData 是否显示无数据view
 @param isShowBtn 是否显示重新加载按钮
 */
+(void)EmptyUITableViewData:(UITableView *)tableview isShowNoNetWork:(BOOL)isShow isShowEmptyData:(BOOL)isShowData refreshBtnClickBlock:(void (^)(void))refreshBtnClickBlock isShowRefreshBtn:(BOOL)isShowBtn;



/** 返回int，float */
+(int)withIntReturn:(id)string;
/** 返回float */
+(float)withFloatReturn:(id)string;
/** 返回string */
+(NSString *)withStringReturn:(id)string;

/** 返回BOOL */
+(BOOL)withBoolReturn:(id)string;

//设置状态栏颜色
+ (void)setStatusBarBackgroundColor:(UIColor *)color;
/** 给html添加标签 */
+(NSString *)addHtmlString:(NSString *)html;
+(NSString *)returnYYYYMMMDD:(NSString *)datestr;
+(NSString *)returnYYYYMMDD:(NSString *)datestr;
/** 系统错误--信息修改提示 */
+(NSString *)netWorkingStatus:(NSString *)code message:(NSString *)message;
@end
