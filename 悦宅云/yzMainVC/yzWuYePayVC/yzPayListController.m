//
//  yzPayListController.m
//  悦宅云
//
//  Created by 尚广杰 on 2019/11/19.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import "yzPayListController.h"
#import "yaPayListCell.h"
#import "yzWuYePayController.h"
#import "yzPayOrderController.h"
#import "indexTopLocationView.h" //顶部选择view
@interface yzPayListController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView* tableV;
@property(nonatomic,strong)UIImageView* headerImage;   //顶部橙色图片

@property(nonatomic,strong)NSMutableArray* listArr;
@property(nonatomic,strong)NSString* beginTime;

@property (nonatomic, strong) indexTopLocationView *topLocationView;//社区选择view

@property (nonatomic, assign) BOOL isShowTop;//是否显示顶部view

@property (nonatomic, strong) UIButton *titleBtn;
@end

@implementation yzPayListController
-(UITableView*)tableView{
    if (!_tableV) {
        _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, mDeviceWidth, mDeviceHeight - KSAFEBAR_HEIGHT - kNavBarHeight) style:UITableViewStyleGrouped];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        //解决滑动视图顶部空出状态栏高度的问题
        if (@available(iOS 11.0, *)) {
            _tableV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableV.estimatedSectionHeaderHeight = 0;
            _tableV.estimatedSectionFooterHeight = 0;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
            
        }
        _tableV.separatorStyle = UITableViewCellSelectionStyleNone;
        //        _tableView.separatorInset = UIEdgeInsetsZero;
        
        [_tableV setBackgroundView:nil];
        
        [_tableV setBackgroundView:[[UIView alloc] init]];
        
        _tableV.backgroundView.backgroundColor = [UIColor clearColor];
        
        _tableV.backgroundColor = [UIColor clearColor];

        [self.view addSubview:self.tableV];
    }
    return _tableV;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1]];
    
    self.headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, kSaveTopSpace + 64, mDeviceWidth, mDeviceWidth/2.5)];
    self.headerImage.image = [UIImage imageNamed:@"payHeader"];
    [self.view addSubview:self.headerImage];
    
  
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    // 得到当前时间（世界标准时间 UTC/GMT）
    NSDate *nowDate = [NSDate date];
    // 设置系统时区为本地时区
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    // 计算本地时区与 GMT 时区的时间差
    NSInteger interval = [zone secondsFromGMT];
    // 在 GMT 时间基础上追加时间差值，得到本地时间
    nowDate = [nowDate dateByAddingTimeInterval:interval];
    
    
    
    
    self.beginTime = [dateFormatter stringFromDate:nowDate];

    NSLog(@"==%@",self.beginTime);
    
    
    
    [self tableView];
    
    [self.tableV setMj_header:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getList];
        [self.tableV.mj_header endRefreshing];
    }]];
    self.tableV.mj_header.automaticallyChangeAlpha = YES;
//    [self.tableV setMj_footer:[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//
//
//        [self.tableV.mj_footer endRefreshing];
//    }]];
    
    //显示空数据或者无网络
    [yzProductPubObject EmptyUITableViewData:self.tableV isShowNoNetWork:NO isShowEmptyData:YES refreshBtnClickBlock:^{
        [self.tableV.mj_header beginRefreshing];
    } isShowRefreshBtn:YES];
    [self getList];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    [self setStatusBarBackgroundColor:RGBA(255, 255, 255, 1)];
    [self.navigationController.navigationBar setBackgroundColor:RGBA(255, 255, 255, 1)];
    [self.navigationController.visibleViewController.navigationItem setLeftBarButtonItem:nil];
    
    //左侧返回
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"blackBack"] forState:UIControlStateNormal];
    [backBtn setBackgroundColor:[UIColor clearColor]];
    
    [backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setTitleColor:AppBackTitleColor forState:UIControlStateNormal];
    [backBtn setFrame:CGRectMake(0, 0, AutoWitdh(32), AutoWitdh(32))];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationController.visibleViewController.navigationItem setLeftBarButtonItem:backItem];
    //顶部信息
    self.titleBtn = [[UIButton alloc] init];
    [self.titleBtn setTitle:self.title forState:UIControlStateNormal];
    [self.titleBtn setFrame:CGRectMake(0, 0, mDeviceWidth/2, NavTopHeight)];
    [self.titleBtn.titleLabel setFont:YSize(15.0)];
    [self.titleBtn setTitleColor:RGB(22, 22, 22) forState:UIControlStateNormal];
    [self.titleBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [self.titleBtn addTarget:self action:@selector(showTopView:) forControlEvents:UIControlEventTouchUpInside];
    self.titleBtn.titleLabel.adjustsFontSizeToFitWidth = YES;;
    [self.navigationController.visibleViewController.navigationItem setTitleView:self.titleBtn];

    
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"缴费记录" style:UIBarButtonItemStylePlain target:self action:@selector(record)];
    [rightBarItem setTintColor:[UIColor blackColor]];
    [rightBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:YSize(15.0), NSFontAttributeName,nil] forState:(UIControlStateNormal)];
    [self.navigationController.visibleViewController.navigationItem setRightBarButtonItem:rightBarItem];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
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


#pragma mark -- tableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    yaPayListCell* cell = [[yaPayListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    if (self.listArr.count>0) {
        [cell getMessageByDic:self.listArr[indexPath.section] beginTime:self.beginTime];
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* dic = self.listArr[indexPath.section];
    yzWuYePayController* wuyeVC = [[yzWuYePayController alloc]init];
    wuyeVC.title = [dic objectForKey:@"type"];
    wuyeVC.Id = [dic objectForKey:@"id"];
    [self.navigationController pushViewController:wuyeVC animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (mDeviceWidth - 20)/2.5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 40;
    }else{
        return 10;
    }
    return 0.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00000001;
}

#pragma mark -- 请求数据
-(void)getList{
    [DDProgressHUD show];
    [CCAFNetWork get:[NSString stringWithFormat:@"%@app/paymanage/getRoomActive",postUrl] version:Token parameters:@{@"roomId":self.roomId} success:^(id object) {
        NSDictionary *json = object;
        self.listArr = [NSMutableArray array];
        if ([[json objectForKey:@"code"] intValue] == 200) {
            NSArray* arr = [[json  objectForKey:@"data"] objectForKey:@"cheweiList"];
            
            for (NSDictionary* dic in arr) {
                NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                [mutDic setObject:@"车位费" forKey:@"type"];
                [self.listArr addObject:mutDic];
            }
            NSMutableDictionary* wuDic = [NSMutableDictionary dictionary];
            [wuDic setObject:[[json  objectForKey:@"data"]  objectForKey:@"activeTime"] forKey:@"atime"];
            [wuDic setObject:[[json  objectForKey:@"data"]  objectForKey:@"activeTimePlus"] forKey:@"activeTimePlus"];
            [wuDic setObject:[[json  objectForKey:@"data"] objectForKey:@"roomId"] forKey:@"id"];
            [wuDic setObject:self.title forKey:@"name"];
            [wuDic setObject:@"物业费" forKey:@"type"];
            [self.listArr insertObject:wuDic atIndex:0];
            
            
            
            [self.tableV reloadData];
            [DDProgressHUD dismiss];
        }else if ([[json objectForKey:@"code"] intValue] == -6){
            [DDProgressHUD dismiss];
            [yzUserInfoModel userLoginOut];
            [yzUserInfoModel setLoginState:NO];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
            
        }else{
            [DDProgressHUD showErrorImageWithInfo:[json objectForKey:@"message"]];
        }
        
    } failure:^(NSError *error) {
        [DDProgressHUD showErrorImageWithInfo:error.localizedDescription];
    }];
}

#pragma mark -- 消费记录
-(void)record{
    yzPayOrderController* payVC = [[yzPayOrderController alloc]init];
    [self.navigationController pushViewController:payVC animated:YES];
}

#pragma mark  -- 小区下拉选项
//显示topView
-(void)showTopView:(UIButton*)sender{
   
    if (self.xiaoquArray.count<=0) {
        
        return;
    }
    
    WEAKSELF
    if (self.isShowTop) {
        //隐藏
        [self.topLocationView _tapGesturePressed];
    }else{
        self.topLocationView = [[indexTopLocationView alloc] initWithFrame:CGRectMake(0, DCTopNavHeight, mDeviceWidth, self.xiaoquArray.count*44 <= (mDeviceHeight - kSaveTopSpace - 64)?self.xiaoquArray.count*44:mDeviceHeight - kSaveTopSpace - 64)];
        [self.topLocationView option_show];
        [self.topLocationView setPxCookModel:self.xiaoquArray];
        
        [self.topLocationView setSelectedQuBlock:^(yzXiaoQuModel *model) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject: model] forKey:@"XiaoQuModel"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [weakSelf.titleBtn setTitle:[NSString stringWithFormat:@"%@-%@-%@-%@",model.xiaoqu_name,model.louYu,model.danYuan,model.room] forState:UIControlStateNormal];
            weakSelf.title = [NSString stringWithFormat:@"%@-%@-%@-%@",model.xiaoqu_name,model.louYu,model.danYuan,model.room];
            weakSelf.roomId = model.roomId;
            
            [weakSelf.tableV.mj_header beginRefreshing];
        }];
        
        
    }
    self.isShowTop = !self.isShowTop;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.isShowTop) {
        //隐藏
        [self.topLocationView _tapGesturePressed];
    }
    self.isShowTop = !self.isShowTop;
}
@end
