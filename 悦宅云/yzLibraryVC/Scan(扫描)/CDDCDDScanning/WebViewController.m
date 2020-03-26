//
//  WebViewController.m
//  悦宅云
//
//  Created by 尚广杰 on 2019/4/15.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>
@interface WebViewController ()<WKUIDelegate,WKNavigationDelegate>
@property(nonatomic,strong)WKWebView* webView;
@property(nonatomic,strong)UILabel* titleLabel;   //标题
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, mDeviceWidth, mDeviceHeight)];
    // UI代理
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    // 导航代理
    NSLog(@"====%@",self.urlStr);
//    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];

    [self.view addSubview:_webView];
    
    
    //TODO:kvo监听，获得页面title和加载进度值
    
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [self.navigationController.navigationBar setTranslucent:YES];
    [self setStatusBarBackgroundColor:RGBA(255, 255, 255, 1)];
    [self.navigationController.navigationBar setBackgroundColor:RGBA(255, 255, 255, 1)];
    //左侧返回
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
    [backBtn setBackgroundColor:[UIColor clearColor]];
//    [backBtn setTitle:@" 返回" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn.titleLabel setFont:[UIFont fontWithName:@"HYJinChangTiJ" size:16]];
    [backBtn setTitleColor:AppBackTitleColor forState:UIControlStateNormal];
    [backBtn setFrame:CGRectMake(0, 0, AutoWitdh(32), AutoWitdh(32))];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationController.visibleViewController.navigationItem setLeftBarButtonItem:backItem];
    
    
    //顶部信息
    _titleLabel = [[UILabel alloc] init];
    [_titleLabel setFrame:CGRectMake(0, 0, mDeviceWidth/2, NavTopHeight)];
    [_titleLabel setFont:[UIFont fontWithName:@"HYJinChangTiJ" size:18]];
    [_titleLabel setTextColor:RGB(22, 22, 22)];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.navigationController.visibleViewController.navigationItem setTitleView:_titleLabel];
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
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    [webView reload];
}

#pragma mark KVO的监听代理
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    if ([keyPath isEqualToString:@"title"])
    {
        if (object == self.webView)
        {
            self.titleLabel.text = self.webView.title;
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark 移除观察者
- (void)dealloc
{
    
    [self.webView removeObserver:self forKeyPath:@"title"];
}

@end
