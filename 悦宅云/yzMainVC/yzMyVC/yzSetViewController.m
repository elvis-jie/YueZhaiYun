//
//  yzSetViewController.m
//  悦宅云
//
//  Created by 尚广杰 on 2019/5/6.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import "yzSetViewController.h"
#import "addressListViewController.h"
@interface yzSetViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIButton* loginOut;    //退出登录
@property(nonatomic,strong)UITableView* tableV;

@end

@implementation yzSetViewController
-(UITableView *)tableView{
    if (!_tableV) {
        _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, mDeviceWidth, mDeviceHeight - kNavBarHeight - KSAFEBAR_HEIGHT - 50) style:UITableViewStyleGrouped];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        
        if (@available(iOS 11.0, *)) {
            _tableV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
            
        }
        _tableV.estimatedRowHeight = 0;
        _tableV.estimatedSectionHeaderHeight = 0;
        _tableV.estimatedSectionFooterHeight = 0;
        _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.tableV];
    }
    return _tableV;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self tableView];
    
    self.loginOut = [[UIButton alloc]initWithFrame:CGRectMake(0, mDeviceHeight - 50 - KSAFEBAR_HEIGHT, mDeviceWidth, 50)];
    [self.loginOut setBackgroundColor:[UIColor orangeColor]];
    [self.loginOut setTitle:@"退出登录" forState:UIControlStateNormal];
    [self.loginOut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginOut.titleLabel.font = YSize(15.0);
    [self.loginOut addTarget:self action:@selector(loginOut:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginOut];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (@available(iOS 11.0, *)) {
        _tableV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        if([UIViewController instancesRespondToSelector:@selector(edgesForExtendedLayout)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        
    }
    
    
    [self.navigationController.navigationBar setTranslucent:YES];
    [self setStatusBarBackgroundColor:RGBA(255, 255, 255, 1)];
    [self.navigationController.navigationBar setBackgroundColor:RGBA(255, 255, 255, 1)];
    //左侧返回
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
    [backBtn setBackgroundColor:[UIColor clearColor]];
    
    [backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn.titleLabel setFont:[UIFont fontWithName:@"HYJinChangTiJ" size:16]];
    [backBtn setTitleColor:AppBackTitleColor forState:UIControlStateNormal];
    [backBtn setFrame:CGRectMake(0, 0, AutoWitdh(32), AutoWitdh(32))];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationController.visibleViewController.navigationItem setLeftBarButtonItem:backItem];
    
    //顶部信息
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setText:@"设置"];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identifire = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifire];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifire];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = [UIImage imageNamed:@"收藏"];
    cell.textLabel.text = @"收货地址";
    cell.textLabel.font = YSize(15.0);
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000001;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    addressListViewController *addressVC = [[addressListViewController alloc] init];
    [self.navigationController pushViewController:addressVC animated:YES];
}


#pragma mark -- 退出登录
-(void)loginOut:(UIButton*)sender{
    [yzUserInfoModel userLoginOut];
    [yzUserInfoModel setLoginState:NO];
    [DDProgressHUD showSuccessImageWithInfo:@"退出成功"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.loginOutBlock) {
            self.loginOutBlock();
        }
//        [self.navigationController popViewControllerAnimated:YES];
        
        yzLoginViewController *loginView = [[yzLoginViewController alloc] init];
        [self.navigationController presentViewController:[yzProductPubObject navc:loginView] animated:YES completion:nil];
        
        [CloudPushSDK unbindAccount:^(CloudPushCallbackResult *res) {
            if (res.success) {
                NSLog(@"解绑成功");
            }
        }];
        
    });
}
@end
