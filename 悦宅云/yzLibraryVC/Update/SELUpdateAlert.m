//
//  SELUpdateAlert.m
//  SelUpdateAlert
//
//  Created by zhuku on 2018/2/7.
//  Copyright © 2018年 selwyn. All rights reserved.
//

#import "SELUpdateAlert.h"
#import "SELUpdateAlertConst.h"



@interface SELUpdateAlert()

/** 版本号 */
@property (nonatomic, copy) NSString *version;
/** 版本更新内容 */
@property (nonatomic, copy) NSString *desc;

@end

@implementation SELUpdateAlert

/**
 添加版本更新提示

 @param version 版本号
 @param descriptions 版本更新内容（数组）
 
 descriptions 格式如 @[@"1.xxxxxx",@"2.xxxxxx"]
 */
+ (void)showUpdateAlertWithVersion:(NSString *)version Descriptions:(NSArray *)descriptions
{
    if (!descriptions || descriptions.count == 0) {
        return;
    }
    
    //数组转换字符串，动态添加换行符\n
    NSString *description = @"";
    for (NSInteger i = 0;  i < descriptions.count; ++i) {
        id desc = descriptions[i];
        if (![desc isKindOfClass:[NSString class]]) {
            return;
        }
        description = [description stringByAppendingString:desc];
        if (i != descriptions.count-1) {
            description = [description stringByAppendingString:@"\n"];
        }
    }
    NSLog(@"====%@",description);
    SELUpdateAlert *updateAlert = [[SELUpdateAlert alloc]initVersion:version description:description];
    [[UIApplication sharedApplication].delegate.window addSubview:updateAlert];
}

/**
 添加版本更新提示

 @param version 版本号
 @param description 版本更新内容（字符串）
 
description 格式如 @"1.xxxxxx\n2.xxxxxx"
 */
+ (void)showUpdateAlertWithVersion:(NSString *)version Description:(NSString *)description
{
    SELUpdateAlert *updateAlert = [[SELUpdateAlert alloc]initVersion:version description:description];
    [[UIApplication sharedApplication].delegate.window addSubview:updateAlert];
}

- (instancetype)initVersion:(NSString *)version description:(NSString *)description
{
    self = [super init];
    if (self) {
        self.version = version;
        self.desc = description;
        
        [self _setupUI];
    }
    return self;
}

- (void)_setupUI
{
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3/1.0];
    
    //获取更新内容高度
    CGFloat descHeight = [self _sizeofString:self.desc font:[UIFont systemFontOfSize:SELDescriptionFont] maxSize:CGSizeMake(self.frame.size.width - Ratio(80) - Ratio(56), 1000)].height;


 
    
    //backgroundView
    UIView *bgView = [[UIView alloc]init];
    bgView.center = self.center;
    bgView.bounds = CGRectMake(0, 0, self.frame.size.width - Ratio(40), self.frame.size.width - Ratio(40));
    [self addSubview:bgView];
    
    //添加更新提示
    UIView *updateView = [[UIView alloc]initWithFrame:CGRectMake(Ratio(20), Ratio(18), bgView.frame.size.width - Ratio(40), self.frame.size.width - Ratio(60))];
    updateView.backgroundColor = [UIColor whiteColor];
    updateView.layer.masksToBounds = YES;
    updateView.layer.cornerRadius = 4.0f;
    [bgView addSubview:updateView];
    
    //20+166+10+28+10+descHeight+20+40+20 = 314+descHeight 内部元素高度计算bgView高度
    UIImageView *updateIcon = [[UIImageView alloc]initWithFrame:CGRectMake((updateView.frame.size.width - Ratio(100))/2, Ratio(25), 100, 100)];
    updateIcon.image = [UIImage imageNamed:@"VersionUpdate_Icon"];
    [updateView addSubview:updateIcon];
    
    //版本更新
    UILabel *versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10 + CGRectGetMaxY(updateIcon.frame), updateView.frame.size.width, 28)];
    versionLabel.font = [UIFont boldSystemFontOfSize:18];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.text = @"版本更新";

    [updateView addSubview:versionLabel];
    
    //更新内容
    UILabel *descLabel = [[UILabel alloc]initWithFrame:CGRectMake(Ratio(28), CGRectGetMaxY(versionLabel.frame) + 10, updateView.frame.size.width - 56, descHeight)];
    descLabel.font = [UIFont boldSystemFontOfSize:15];
    descLabel.textAlignment = NSTextAlignmentLeft;
    descLabel.numberOfLines = 0;
    descLabel.text = self.desc;

    [updateView addSubview:descLabel];
    
    //横线
    UILabel* line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, updateView.frame.size.height - Ratio(50) - 1, updateView.frame.size.width, 1)];
    [line1 setBackgroundColor:[UIColor lightGrayColor]];
    [updateView addSubview:line1];
    
    UILabel* line2 = [[UILabel alloc]initWithFrame:CGRectMake(updateView.frame.size.width/2 - 0.5, updateView.frame.size.height - Ratio(50), 1, Ratio(50))];
    [line2 setBackgroundColor:[UIColor lightGrayColor]];
    [updateView addSubview:line2];
    
    //更新按钮
    UIButton *updateButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    updateButton.backgroundColor = SELColor(34, 153, 238);
    updateButton.frame = CGRectMake(updateView.frame.size.width/2 + 0.5, CGRectGetMaxY(line1.frame), updateView.frame.size.width/2 - 0.5, Ratio(50));
    updateButton.clipsToBounds = YES;
    updateButton.layer.cornerRadius = 2.0f;
    [updateButton addTarget:self action:@selector(updateVersion) forControlEvents:UIControlEventTouchUpInside];
    [updateButton setTitle:@"立即更新" forState:UIControlStateNormal];
    [updateButton setTitleColor:SELColor(209, 92, 57) forState:UIControlStateNormal];
    [updateView addSubview:updateButton];
    
    //取消按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelButton.frame = CGRectMake(0, CGRectGetMaxY(line1.frame), updateView.frame.size.width/2 - 0.5, Ratio(50));
//    cancelButton.backgroundColor = SELColor(134, 13, 238);
    [cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [cancelButton setTitle:@"稍后再说" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [updateView addSubview:cancelButton];
    
    //显示更新
    [self showWithAlert:bgView];
}

/** 更新按钮点击事件 跳转AppStore更新 */
- (void)updateVersion
{
    NSString *str = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%@", APP_ID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    [self dismissAlert];
}

/** 取消按钮点击事件 */
- (void)cancelAction
{
    [self dismissAlert];
}

/**
 添加Alert入场动画
 @param alert 添加动画的View
 */
- (void)showWithAlert:(UIView*)alert{
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = SELAnimationTimeInterval;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [alert.layer addAnimation:animation forKey:nil];
}


/** 添加Alert出场动画 */
- (void)dismissAlert{
    
    [UIView animateWithDuration:SELAnimationTimeInterval animations:^{
        self.transform = (CGAffineTransformMakeScale(1.5, 1.5));
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    } ];
    
}

/**
 计算字符串高度
 @param string 字符串
 @param font 字体大小
 @param maxSize 最大Size
 @return 计算得到的Size
 */
- (CGSize)_sizeofString:(NSString *)string font:(UIFont *)font maxSize:(CGSize)maxSize
{
    return [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
}




@end
