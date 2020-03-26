//
//  yzInviteController.m
//  yzProduct
//
//  Created by 尚广杰 on 2019/4/12.
//  Copyright © 2019 CC. All rights reserved.
//

#import "yzInviteController.h"
#import "OneViewController.h"
#import "TwoViewController.h"
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define titleWidth SCREEN_WIDTH/_titleArray.count
#define titleHeight 40
#define backColor [UIColor colorWithWhite:0.300 alpha:1.000]
@interface yzInviteController ()<UIScrollViewDelegate> {
    
    UIButton *selectButton;
    UIView *_sliderView;
    UIViewController *_viewController;
    UIScrollView *_scrollView;
}
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property(nonatomic,strong)UILabel* titleLab;    //顶部标题
@end

@implementation yzInviteController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"固定的";
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.400 green:0.800 blue:1.000 alpha:1.000]];
    // 标题字体和颜色
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor], NSForegroundColorAttributeName,
                                [UIFont boldSystemFontOfSize:21], NSFontAttributeName,
                                nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    _buttonArray = [NSMutableArray array];
    
    
    self.titleArray = @[@"邀请",@"访客记录"];
    [self initWithTitleButton];
    OneViewController *oneVC = [[OneViewController alloc] init];
    TwoViewController *twoVC = [[TwoViewController alloc] init];
    
    
    self.controllerArray = @[oneVC,twoVC];
    [self initWithController];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self setStatusBarBackgroundColor:RGBA(255, 255, 255, 1)];
    [self.navigationController.navigationBar setBackgroundColor:RGBA(255, 255, 255, 1)];
    //左侧返回
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
    [backBtn setBackgroundColor:[UIColor clearColor]];
//    [backBtn setTitle:@" 返回" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn.titleLabel setFont:YSize(16)];
    [backBtn setTitleColor:AppBackTitleColor forState:UIControlStateNormal];
    [backBtn setFrame:CGRectMake(0, 0, AutoWitdh(32), AutoWitdh(32))];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationController.visibleViewController.navigationItem setLeftBarButtonItem:backItem];
    
    //顶部信息
    //    self.titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [self.titleButton setTitle:@"钥匙管理" forState:UIControlStateNormal];
    //    [self.titleButton.titleLabel setFont:[UIFont fontWithName:@"HYJinChangTiJ" size:18]];
    //    [self.titleButton addTarget:self action:@selector(showTopView:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.titleButton setTitleColor:AppNavTitleColor forState:UIControlStateNormal];
    //    [self.navigationController.visibleViewController.navigationItem setTitleView:self.titleButton];
    
    self.titleLab = [[UILabel alloc]init];
    self.titleLab.text = @"访客邀请";
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    [self.titleLab setFont:YSize(18)];
    
    [self.navigationController.visibleViewController.navigationItem setTitleView:self.titleLab];
    
    
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
- (void)initWithTitleButton
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, titleHeight)];
    titleView.backgroundColor = [UIColor whiteColor];
    titleView.layer.shadowColor = [UIColor orangeColor].CGColor;

    
    [self.view addSubview:titleView];
    if (self.navigationController.navigationBar) {
        titleView.frame = CGRectMake(0, kNavBarHeight, SCREEN_WIDTH, titleHeight);
    } else {
        titleView.frame = CGRectMake(0, 0, SCREEN_WIDTH, titleHeight);
    }
    
    for (int i = 0; i < _titleArray.count; i++) {
        
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        titleButton.frame = CGRectMake(titleWidth*i, 0, titleWidth, titleHeight);
        [titleButton setTitle:_titleArray[i] forState:UIControlStateNormal];
        [titleButton setTitleColor:backColor forState:UIControlStateNormal];
        titleButton.titleLabel.font = YSize(14.0);
        titleButton.tag = 100+i;
        [titleButton addTarget:self action:@selector(scrollViewSelectToIndex:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:titleButton];
        if (i == 0) {
            selectButton = titleButton;
            [selectButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        }
        [_buttonArray addObject:titleButton];
        
    }
    
    //滑块
    UIView *sliderV=[[UIView alloc]initWithFrame:CGRectMake(titleWidth/4, titleHeight-1, titleWidth/2, 1)];
    sliderV.backgroundColor = [UIColor redColor];
    [titleView addSubview:sliderV];
    _sliderView=sliderV;
    
}

- (void)scrollViewSelectToIndex:(UIButton *)button
{
    
    [self selectButton:button.tag-100];
    [UIView animateWithDuration:0 animations:^{
        _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH*(button.tag-100), 0);
    }];
}

//选择某个标题
- (void)selectButton:(NSInteger)index
{
    
    [selectButton setTitleColor:backColor forState:UIControlStateNormal];
    selectButton = _buttonArray[index];
    [selectButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 animations:^{
        _sliderView.frame = CGRectMake(index == 0 ? titleWidth/4 : titleWidth*index + titleWidth/4, titleHeight-1, titleWidth/2, 1);
    }];
    
}

//监听滚动事件判断当前拖动到哪一个了
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger index = scrollView.contentOffset.x / SCREEN_WIDTH;
    [self selectButton:index];
    
}

- (void)initWithController
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (self.navigationController.navigationBar) {
        scrollView.frame = CGRectMake(0, titleHeight+kNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-titleHeight-kNavBarHeight);
    } else {
        scrollView.frame = CGRectMake(0, titleHeight, SCREEN_WIDTH, SCREEN_HEIGHT-titleHeight);
    }
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor colorWithWhite:0.900 alpha:1.000];
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = YES;
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*_controllerArray.count, 0);
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    
    for (int i = 0; i < _controllerArray.count; i++) {
        UIView *viewcon = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        UIViewController *viewcontroller = _controllerArray[i];
        viewcon = viewcontroller.view;
        viewcon.frame = CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        [scrollView addSubview:viewcon];
        
    }
    
}


















@end
