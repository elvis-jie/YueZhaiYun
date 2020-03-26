//
//  yzAddSuccessController.m
//  悦宅云
//
//  Created by 尚广杰 on 2019/4/25.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import "yzAddSuccessController.h"

@interface yzAddSuccessController ()
@property(nonatomic,strong)UIButton* doneBtn;
@property(nonatomic,strong)UIButton* goHomeBtn;
@end

@implementation yzAddSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(255, 111, 74);
//    UIView* topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mDeviceWidth, mDeviceHeight/2 + 50)];
//    topView.backgroundColor = RGB(255, 111, 74);
//    
//    [self.view addSubview:topView];
    
    
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, mDeviceHeight/2, mDeviceWidth, mDeviceHeight/2)];
    imageView.image = [UIImage imageNamed:@"波纹"];
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    
    
    self.doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 60, mDeviceWidth - 20, 50)];
    [self.doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self.doneBtn setBackgroundColor:[UIColor redColor]];
    self.doneBtn.layer.cornerRadius = 5;
    [self.doneBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:self.doneBtn];
    
    self.goHomeBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.doneBtn.frame) + 20, mDeviceWidth - 20, 50)];
    [self.goHomeBtn setTitle:@"返回首页" forState:UIControlStateNormal];
    [self.goHomeBtn setBackgroundColor:[UIColor whiteColor]];
    [self.goHomeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.goHomeBtn.layer.cornerRadius = 5;
    [self.goHomeBtn addTarget:self action:@selector(goHomeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:self.goHomeBtn];
    
    
    UIImageView* keyImage = [[UIImageView alloc]initWithFrame:CGRectMake(mDeviceWidth/2 - 70, 70, 120, 130)];
    keyImage.image = [UIImage imageNamed:@"钥匙"];
    [self.view addSubview:keyImage];
    
    UILabel* successLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(keyImage.frame) + 20, mDeviceWidth - 20, 20)];
    successLabel.text = @"添加成功！";
    successLabel.font = YSize(18.0);
    successLabel.textAlignment = NSTextAlignmentCenter;
    successLabel.textColor = [UIColor whiteColor];
    
    [self.view addSubview:successLabel];
    
    
    UILabel* remaindLab = [[UILabel alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(successLabel.frame) + 20, mDeviceWidth - 100, 60)];
        remaindLab.textColor = [UIColor whiteColor];
    NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"您成功添加了一把钥匙，并在%@前被手机号%@的用户在%@使用",self.timeStr,self.telStr,self.quStr]];
    //找出特定字符在整个字符串中的位置
    NSRange redRange = NSMakeRange([[contentStr string] rangeOfString:self.timeStr].location, [[contentStr string] rangeOfString:self.timeStr].length);
     NSRange redRange1 = NSMakeRange([[contentStr string] rangeOfString:self.telStr].location, [[contentStr string] rangeOfString:self.telStr].length);
     NSRange redRange2 = NSMakeRange([[contentStr string] rangeOfString:self.quStr].location, [[contentStr string] rangeOfString:self.quStr].length);
    
    //修改特定字符的颜色
    [contentStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
    //修改特定字符的字体大小
    [contentStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:redRange];
    
    //修改特定字符的颜色
    [contentStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange1];
    //修改特定字符的字体大小
    [contentStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:redRange1];
    
    //修改特定字符的颜色
    [contentStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange2];
    //修改特定字符的字体大小
    [contentStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:redRange2];
    
    
    
    [remaindLab setAttributedText:contentStr];
    
  
    remaindLab.font = YSize(14.0);
    remaindLab.numberOfLines = 0;
    remaindLab.textAlignment = NSTextAlignmentCenter;

    
    [self.view addSubview:remaindLab];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    [self setStatusBarBackgroundColor:RGBA(255, 111, 74, 1)];
    [self.navigationController.navigationBar setBackgroundColor:RGBA(255, 111, 74, 1)];
    [self.navigationController.visibleViewController.navigationItem setLeftBarButtonItem:nil];
    
    //左侧返回
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [backBtn setBackgroundColor:[UIColor clearColor]];
    
    [backBtn addTarget:self action:@selector(nullClick:) forControlEvents:UIControlEventTouchUpInside];

    [backBtn setTitleColor:AppBackTitleColor forState:UIControlStateNormal];
    [backBtn setFrame:CGRectMake(0, 0, AutoWitdh(32), AutoWitdh(32))];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationController.visibleViewController.navigationItem setLeftBarButtonItem:backItem];

}
//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}
-(void)nullClick:(id)sender{
    NSLog(@"1234");
}

-(void)goBack:(UIButton*)sender{
  
    NSInteger index = (NSInteger)[[self.navigationController viewControllers] indexOfObject:self];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index-2)] animated:YES];
    
    NSNotification *notifacation = [[NSNotification alloc]initWithName:@"refresh" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter]postNotification:notifacation];
 
}
-(void)goHomeBtn:(UIButton*)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
