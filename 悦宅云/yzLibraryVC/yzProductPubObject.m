//
//  yzProductPubObject.m
//  yzProduct
//
//  Created by LiuHQ on 2018/9/20.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "yzProductPubObject.h"

@interface yzProductPubObject()

@end


@implementation yzProductPubObject
+(UINavigationController *)navc:(UIViewController *)viewController{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    return nav;
}
//获取字符串的宽度
+(float) widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height
{
    CGRect rect = [[NSString stringWithFormat:@"%@",value] boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    return rect.size.width;
}

//获得字符串的高度
+(float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width

{
    CGRect rect = [value boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    return rect.size.height;
    
}
+(NSString *)returnYYYYMMMDD:(NSString *)datestr{
    NSDate * myDate=[NSDate dateWithTimeIntervalSince1970:([datestr floatValue]/1000.0)];
    //设置时间格式
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    //将时间转换为字符串
    NSString *timeStr=[formatter stringFromDate:myDate];
    return timeStr;
}
+(NSString *)returnYYYYMMDD:(NSString *)datestr{
    NSDate * myDate=[NSDate dateWithTimeIntervalSince1970:([datestr floatValue]/1000.0)];
    //设置时间格式
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //将时间转换为字符串
    NSString *timeStr=[formatter stringFromDate:myDate];
    return timeStr;
}
/**
 邮箱验证
 
 @param emailnum 邮箱
 @return bool
 */
+ (BOOL)validateEmailNumber:(NSString *)emailnum{
    NSString *emailRegex = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    return [pre evaluateWithObject:emailnum];//此处返回的是BOOL类型,YES or NO;
}
/**
 *  『正则表达式；推荐使用，不用循环遍历，控制更灵活』判断字符串内容是否是有效数字
 *
 *  @param string 需要验证的字符串
 *
 *  @return 字符串内容是否是有效数字
 */
+ (BOOL)validateNumberByRegExp:(NSString *)string {
    BOOL isValid = YES;
    NSUInteger len = string.length;
    if (len > 0) {
        NSString *numberRegex = @"^[0-9]*$";
        NSPredicate *numberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
        isValid = [numberPredicate evaluateWithObject:string];
    }
    return isValid;
}
/** 验证金额 */
+(BOOL)validateMoney:(NSString *)money
{
    NSString *phoneRegex = @"^\\-?([1-9]\\d*|0)(\\.\\d{0,2})?$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:money];
}
/**
 验证手机号是否合法
 
 @param mobileNum 手机号数据
 @return yes or no
 */
+ (BOOL)validateContactNumber:(NSString *)mobileNum{
    
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,170,182,187,188
     * 联通：130,131,132,152,155,156,176,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|4[0-9]|5[0-9]|6[0-9]|7[0-9]|8[0-9]|9[0-9])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    if([regextestmobile evaluateWithObject:mobileNum] == YES){
        return YES;
    }else{
        return NO;
    }
}
//-----------缩放动画
/** 设置旋转的3d效果 */
+(CATransform3D)firstTransform{
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = 1.0/-900;
    //带点缩小的效果
    t1 = CATransform3DScale(t1, 0.95, 0.95, 0.95);
    return t1;
    
}
+(CATransform3D)firstTransform2{
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = 1.0/-900;
    
    //带点缩小的效果
    t1 = CATransform3DScale(t1, 1, 1, 1);
    return t1;
    
}
/** 显示动画 */
+(void)CatransShow:(UIViewController *)controller{
    [UIView animateWithDuration:0.5 animations:^{
        [controller.view.layer setTransform:[self firstTransform]];//红色view调用了上面的旋转效果
    } completion:^(BOOL finished) {
    }];
}
/** 复原动画 */
+(void)CatransHidden:(UIViewController *)controller{
    [UIView animateWithDuration:0.5 animations:^{
        [controller.view.layer setTransform:[self firstTransform2]];
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            controller.view.transform = CGAffineTransformMakeScale(1, 1);
        }];
        
    }];
}
/** 得到缓存 */
+(NSString *)getCacheImage{
    NSUInteger tmpSize = [SDImageCache sharedImageCache].getSize;
    NSString *clearCacheName;
    if (tmpSize >= 1024*1024*1024) {
        clearCacheName = [NSString stringWithFormat:@"%0.2fG",tmpSize /(1024.f*1024.f*1024.f)];
    }else if (tmpSize >= 1024*1024) {
        clearCacheName = [NSString stringWithFormat:@"%0.2fM",tmpSize /(1024.f*1024.f)];
    }else{
        clearCacheName = [NSString stringWithFormat:@"%0.2fK",tmpSize / 1024.f];
    }
    return clearCacheName;
}
//////=============空列表数据==================////
/**
 uitableview显示空数据视图和无网络视图
 
 @param tableview 容器
 @param isShow 是否显示无网络view
 @param isShowData 是否显示无数据view
 @param isShowBtn 是否显示重新加载按钮
 */
+(void)EmptyUITableViewData:(UITableView *)tableview isShowNoNetWork:(BOOL)isShow isShowEmptyData:(BOOL)isShowData refreshBtnClickBlock:(void (^)(void))refreshBtnClickBlock isShowRefreshBtn:(BOOL)isShowBtn{
    JYEmptyView *noNetworkView = [JYEmptyView showTitle:@"" details:@"对不起,没有网络\n请检查网络网络是否打开" iconImag:@"no_search_record" isShowRefreshBtn:isShowBtn];
    noNetworkView.backgroundColor = [UIColor whiteColor];
    noNetworkView.refreshBtnClickBlock = ^() {
        refreshBtnClickBlock();
    };
    
    JYEmptyView *emptyView = [JYEmptyView showTitle:@"" details:@"" iconImag:@"no_search_record_t" isShowRefreshBtn:isShowBtn];
    emptyView.refreshBtnClickBlock = ^() {
        refreshBtnClickBlock();
    };

    if (isShowData) {
        tableview.emptyView = emptyView;
    }
}



//底部列表显示提示
-(void)setFooterListNoticView:(UITableView *)listtableview more:(int)more{
    //判断是否还有下一页
    if (more == 0) {
        [listtableview.mj_footer endRefreshingWithNoMoreData];
    }else{
        [listtableview.mj_footer resetNoMoreData];
    }
}

/** 返回int，float */
+(int)withIntReturn:(id)string{
    return [[NSString stringWithFormat:@"%@",string] intValue];
}
+(float)withFloatReturn:(id)string{
    return [[NSString stringWithFormat:@"%@",string] floatValue];
}
+(BOOL)withBoolReturn:(id)string{
    return [[NSString stringWithFormat:@"%@",string] boolValue];
}
+(NSString *)withStringReturn:(id)string{
    if ([[NSString stringWithFormat:@"%@",string] isEqualToString:@"(null)"] || [[NSString stringWithFormat:@"%@",string] isEqualToString:@"null"] || [string isEqual:nil] || string == nil) {
        return @"";
    }else{
        return [NSString stringWithFormat:@"%@",string];
    }
}

/** 给html添加标签 */
+(NSString *)addHtmlString:(NSString *)html{
    return [NSString stringWithFormat:@"<html> \n<head> \n<style type=\"text/css\"> \nbody {font-size:%dpx;}\n</style> \n</head> \n<body><script type='text/javascript'>window.onload = function(){\n var $img = document.getElementsByTagName('img');\n for(var p in  $img){\n $img[p].style.width = '100%%';\n $img[p].style.height ='auto'\n}\n}</script>%@</body></html>",18, html];
}
/** 系统错误--信息修改提示 */
+(NSString *)netWorkingStatus:(NSString *)code message:(NSString *)message{
    if ([[NSString stringWithFormat:@"%@",code] isEqualToString:@"-1000001"]) {
        return @"请登录";
    }
    return message;
}
@end
