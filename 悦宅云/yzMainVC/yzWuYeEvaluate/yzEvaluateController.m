
//
//  yzEvaluateController.m
//  yzProduct
//
//  Created by 尚广杰 on 2019/3/5.
//  Copyright © 2019 CC. All rights reserved.
//

#import "yzEvaluateController.h"
#import <JavaScriptCore/JavaScriptCore.h>
@interface yzEvaluateController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView* webView;

@end

@implementation yzEvaluateController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
  

    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, mDeviceWidth, mDeviceHeight - 64)];
    self.webView.delegate = self;

    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://app.yuezhaiyun.com/question/index.html#/about?paperid=%@&appuserid=%@",[self.dic objectForKey:@"id"],[yzUserInfoModel getLoginUserInfo:@"userId"]]]]];
    NSLog(@"%@",[NSString stringWithFormat:@"http://app.yuezhaiyun.com/question/index.html#/about?paperid=%@&appuserid=%@",[self.dic objectForKey:@"id"],[yzUserInfoModel getLoginUserInfo:@"userId"]]);
    
    [self.view addSubview:self.webView];

    
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
    [titleLabel setText:@"物业评价"];
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


#pragma mark - UIWebViewDelegate

//! UIWebView在每次加载请求完成后会调用此方法
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    //! 获取JS代码的执行环境/上下文/作用域
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    context[@"goBack"] = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    };
}

@end
