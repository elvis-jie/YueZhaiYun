//
//  yzAboutController.m
//  yzProduct
//
//  Created by 尚广杰 on 2019/2/20.
//  Copyright © 2019 CC. All rights reserved.
//

#import "yzAboutController.h"

@interface yzAboutController ()
@property(nonatomic,strong)UIImageView* logoImage;
@property(nonatomic,strong)UILabel* contentLabel;
//@property(nonatomic,strong)UIImageView* bottomImage;
@end

@implementation yzAboutController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self setStatusBarBackgroundColor:RGBA(255, 255, 255, 1)];
    [self.navigationController.navigationBar setBackgroundColor:RGBA(255, 255, 255, 1)];
    //左侧返回
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"blackBack"] forState:UIControlStateNormal];
    [backBtn setBackgroundColor:[UIColor clearColor]];
//    [backBtn setTitle:@" 返回" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
//    [backBtn.titleLabel setFont:[UIFont fontWithName:@"HYJinChangTiJ" size:16]];
    [backBtn setTitleColor:AppBackTitleColor forState:UIControlStateNormal];
    [backBtn setFrame:CGRectMake(0, 0, AutoWitdh(32), AutoWitdh(32))];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationController.visibleViewController.navigationItem setLeftBarButtonItem:backItem];
    
    //顶部信息
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setText:@"关于我们"];
    [titleLabel setFrame:CGRectMake(0, 0, mDeviceWidth/2, NavTopHeight)];
    [titleLabel setFont:[UIFont fontWithName:@"HYJinChangTiJ" size:18]];
    [titleLabel setTextColor:RGB(22, 22, 22)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.navigationController.visibleViewController.navigationItem setTitleView:titleLabel];
    
    [self.navigationController.visibleViewController.navigationItem setRightBarButtonItem:nil];
}
//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}
-(void)backClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
//创建页面
-(void)setUI{
    NSDictionary* infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString* app_Version = [infoDic objectForKey:@"CFBundleShortVersionString"];

    self.logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(mDeviceWidth/2 - 50, 64 + 40, 100, 100)];
    self.logoImage.image = [UIImage imageNamed:@"aboutLogo"];
    [self.view addSubview:self.logoImage];
    
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(self.logoImage.frame) + 25, mDeviceWidth - 50, 240)];
    
     self.contentLabel.text = [NSString stringWithFormat:@"悦宅云产品介绍：\n        悦宅云是一款基于社区的智慧生活一站式解决方案，提供物业管理、物业服务、周边商品和服务以及供应链仓储配送等，为业主提供方便快捷的智慧社区生活服务，足不出户即可享受互联网科技带来的生活新体验。\n版本号：%@",app_Version];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.textAlignment = NSTextAlignmentLeft;
    self.contentLabel.font = [UIFont systemFontOfSize:15.0];
    
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 15 - (self.contentLabel.font.lineHeight - self.contentLabel.font.pointSize);
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    self.contentLabel.attributedText = [[NSAttributedString alloc] initWithString:self.contentLabel.text attributes:attributes];
   
    
    [self.view addSubview:self.contentLabel];
    
//    self.bottomImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, mDeviceHeight - mDeviceWidth/2.45, mDeviceWidth, mDeviceWidth/2.45)];
//    self.bottomImage.image = [UIImage imageNamed:@"aboutBottom"];
//    [self.view addSubview:self.bottomImage];
}
@end
