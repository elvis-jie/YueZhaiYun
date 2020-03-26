//
//  yzHouseKeepController.m
//  悦宅云
//
//  Created by 尚广杰 on 2019/4/19.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import "yzHouseKeepController.h"
#import "yzHouseKeepCell.h"
#import "yzHouseKeepModel.h"
@interface yzHouseKeepController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView* tableV;
@property (nonatomic, strong) NSMutableArray *jsonArray;
@property (nonatomic, assign) NSInteger pageNo;
@end

@implementation yzHouseKeepController
-(NSMutableArray *)jsonArray{
    if (!_jsonArray) {
        _jsonArray = [[NSMutableArray alloc] init];
    }
    return _jsonArray;
}
-(UITableView*)tableView{
    if (!_tableV) {
        _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, mDeviceWidth, mDeviceHeight - kNavBarHeight - KSAFEBAR_HEIGHT) style:UITableViewStyleGrouped];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        //解决滑动视图顶部空出状态栏高度的问题
        if (@available(iOS 11.0, *)) {
            _tableV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            //            _tableV.estimatedRowHeight = 0;
            _tableV.estimatedSectionHeaderHeight = 0;
            _tableV.estimatedSectionFooterHeight = 0;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
            
        }
        _tableV.separatorInset = UIEdgeInsetsZero;
        [self.view addSubview:self.tableV];
    }
    return _tableV;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self tableView];
    
    [self.tableV setMj_header:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageNo = 0;
        [self pxHouseKeepListData];
        [self.tableV.mj_header endRefreshing];
    }]];
    self.tableV.mj_header.automaticallyChangeAlpha = YES;
    [self.tableV setMj_footer:[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageNo++;
        [self pxHouseKeepListData];
        [self.tableV.mj_footer endRefreshing];
    }]];
    
    //显示空数据或者无网络
    [yzProductPubObject EmptyUITableViewData:self.tableV isShowNoNetWork:NO isShowEmptyData:YES refreshBtnClickBlock:^{
        [self.tableV.mj_header beginRefreshing];
    } isShowRefreshBtn:YES];
    self.pageNo = 0;
    [self pxHouseKeepListData];
    
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
    [backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn.titleLabel setFont:[UIFont fontWithName:@"HYJinChangTiJ" size:16]];
    [backBtn setTitleColor:AppBackTitleColor forState:UIControlStateNormal];
    [backBtn setFrame:CGRectMake(0, 0, AutoWitdh(32), AutoWitdh(32))];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationController.visibleViewController.navigationItem setLeftBarButtonItem:backItem];
    
    //顶部信息
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setText:@"管家"];
    [titleLabel setFrame:CGRectMake(0, 0, mDeviceWidth/2, NavTopHeight)];
    [titleLabel setFont:[UIFont fontWithName:@"HYJinChangTiJ" size:18]];
    [titleLabel setTextColor:RGB(22, 22, 22)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.navigationController.visibleViewController.navigationItem setTitleView:titleLabel];
    
    [self.navigationController.visibleViewController.navigationItem setRightBarButtonItem:nil];
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


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.jsonArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identifire = @"Cell";
    yzHouseKeepCell* cell = [tableView dequeueReusableCellWithIdentifier:identifire];
    if (!cell) {
        cell = [[yzHouseKeepCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifire];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell getMessageByModel:(yzHouseKeepModel*)self.jsonArray[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000001;
}


-(void)pxHouseKeepListData{
    [DDProgressHUD show];
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"XiaoQuModel"];
    yzXiaoQuModel* quModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/callmanager/getlist",postUrl] version:Token parameters:@{@"xiaoQuId":quModel.xiaoqu_id,@"size":@"10",@"page":[NSNumber numberWithInteger:self.pageNo]} success:^(id object) {
        
        NSDictionary *json = object;
//        if (self.pageNo == 0) {
            [self.jsonArray removeAllObjects];
//        }
        if ([[json objectForKey:@"code"] intValue] == 200) {
            [DDProgressHUD dismiss];
            NSMutableArray *detail = [[json objectForKey:@"data"] JSONValue];
            for (int i = 0; i < detail.count; i ++) {
                yzHouseKeepModel *keepModel = [[yzHouseKeepModel alloc] init:detail[i]];
                [self.jsonArray addObject:keepModel];
            }
        }else if ([[json objectForKey:@"code"] intValue] == -6){
            [DDProgressHUD dismiss];
            [yzUserInfoModel userLoginOut];
            [yzUserInfoModel setLoginState:NO];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
            
        }else{
            [DDProgressHUD showErrorImageWithInfo:[json objectForKey:@"message"]];
        }
        [self.tableV reloadData];
    } failure:^(NSError *error) {
        [DDProgressHUD showErrorImageWithInfo:error.localizedDescription];
    }];
}
@end
