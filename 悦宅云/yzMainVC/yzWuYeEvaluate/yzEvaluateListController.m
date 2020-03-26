//
//  yzEvaluateListController.m
//  yzProduct
//
//  Created by 尚广杰 on 2019/3/6.
//  Copyright © 2019 CC. All rights reserved.
//

#import "yzEvaluateListController.h"
#import "yzEvaluateController.h"
#import "yzEvaluateListCell.h"
@interface yzEvaluateListController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView* tableV;
@property(nonatomic,strong)NSArray* listArr;

@end

@implementation yzEvaluateListController
-(UITableView *)tableV{
    if (!_tableV) {
             _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, mDeviceWidth, mDeviceHeight - kNavBarHeight) style:UITableViewStyleGrouped];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        //解决滑动视图顶部空出状态栏高度的问题
        if (@available(iOS 11.0, *)) {
            _tableV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
           self.automaticallyAdjustsScrollViewInsets = NO;
            
        }
        _tableV.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _tableV.sectionFooterHeight = 0;
        _tableV.separatorInset = UIEdgeInsetsZero;
        [self.view addSubview:self.tableV];
    }
    return _tableV;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.listArr = [NSArray array];
    [self tableV];
    [self getPublicData];
}

-(void)getPublicData{
    //创建信号量
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(2);
    // 创建全局并行
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //任务 获取产品详细信息
    dispatch_async(quene, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        [self getList];
        dispatch_semaphore_signal(semaphore);
    });
    
}
-(void)getList{
    [DDProgressHUD show];
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"XiaoQuModel"];
    yzXiaoQuModel* quModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/paper/listProPaper",postUrl] version:Token parameters:@{@"page":@1,@"size":@10,@"xiaoQuId":quModel.xiaoqu_id} success:^(id object) {
        [DDProgressHUD dismiss];
        NSDictionary *json = object;
        
        if ([[json objectForKey:@"code"] intValue] == 200) {
            NSDictionary* contentDic = [[json objectForKey:@"data"] JSONValue];
            self.listArr = [contentDic objectForKey:@"content"];
            
            [self.tableV reloadData];
            
        }else if ([[json objectForKey:@"code"] intValue] == -6){
            [DDProgressHUD dismiss];
            
            [yzUserInfoModel userLoginOut];
            [yzUserInfoModel setLoginState:NO];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
            
        }else{
            [DDProgressHUD showErrorImageWithInfo:[json objectForKey:@"message"]];
        }
        
        
    } failure:^(NSError *error) {
        
    }];
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
    [titleLabel setText:@"我的评价"];
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   yzEvaluateListCell * cell = [[yzEvaluateListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.listArr.count>0) {
        [cell getMessageByDic:self.listArr[indexPath.row]];
    }
//    cell.textLabel.text = @"评价列表";

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    yzEvaluateController* vc = [[yzEvaluateController alloc]init];
    NSDictionary* dic = self.listArr[indexPath.row];
    vc.dic = dic;
    [self.navigationController pushViewController:vc animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}
@end
