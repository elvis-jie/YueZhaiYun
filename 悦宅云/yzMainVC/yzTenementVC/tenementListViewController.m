//
//  tenementListViewController.m
//  yzProduct
//
//  Created by LiuHQ on 2018/9/27.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "tenementListViewController.h"
#import "tenementHeaderView.h" //头部信息
#import "tenementListViewCell.h"
#import "tenementInfoModel.h"
#import "tenementDetailViewController.h"

@interface tenementListViewController ()
@property (nonatomic, strong) NSMutableArray *jsonArray;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, strong) tenementHeaderView *headerView;
@property (nonatomic, strong) NSString *ten_id;
@property (nonatomic, strong) UITableView* listTableView;
@end

@implementation tenementListViewController

-(UITableView*)tableV{
    if (!_listTableView) {
        _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarHeight + 47, mDeviceWidth, mDeviceHeight - kNavBarHeight - kSaveBottomSpace - 47) style:UITableViewStyleGrouped];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        //解决滑动视图顶部空出状态栏高度的问题
        if (@available(iOS 11.0, *)) {
            _listTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            //            _tableV.estimatedRowHeight = 0;
            _listTableView.estimatedSectionHeaderHeight = 0;
            _listTableView.estimatedSectionFooterHeight = 0;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
            
        }
        _listTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _listTableView.separatorInset = UIEdgeInsetsZero;
        [self.view addSubview:_listTableView];
    }
    return _listTableView;
}

-(NSMutableArray *)jsonArray{
    if (!_jsonArray) {
        _jsonArray = [[NSMutableArray alloc] init];
    }
    return _jsonArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.headerView = [[tenementHeaderView alloc] init];
    self.headerView.frame = CGRectMake(0, kNavBarHeight, mDeviceWidth, 47);
    WEAKSELF
    [self.headerView setTypeClickBlock:^(NSString *currentIndex) {
        weakSelf.ten_id = currentIndex;
        [weakSelf.listTableView.mj_header beginRefreshing];
    }];
    [self.view addSubview:self.headerView];
    
    
    [self tableV];
    
    [self.listTableView registerNib:[UINib nibWithNibName:@"tenementListViewCell" bundle:nil] forCellReuseIdentifier:@"tenementListViewCell"];
    [self.listTableView setMj_header:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageNo = 0;
        [self tenementListData];
        [self.listTableView.mj_header endRefreshing];
    }]];
    self.listTableView.mj_header.automaticallyChangeAlpha = YES;
    [self.listTableView setMj_footer:[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageNo++;
        [self tenementListData];
        [self.listTableView.mj_footer endRefreshing];
    }]];
    
    //显示空数据或者无网络
    [yzProductPubObject EmptyUITableViewData:self.listTableView isShowNoNetWork:NO isShowEmptyData:YES refreshBtnClickBlock:^{
        [self.listTableView.mj_header beginRefreshing];
    } isShowRefreshBtn:YES];
    
    
    [self getOrderState];
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
    [titleLabel setText:@"我的报修"];
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
    return self.jsonArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat finalH = 0.0;
    tenementListViewCell* cell = (tenementListViewCell*)[self tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath];
    finalH = cell.finalH;
    return finalH;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    tenementListViewCell *cell = [[tenementListViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell setTenementModel:(tenementInfoModel *)[self.jsonArray objectAtIndex:indexPath.section]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    tenementInfoModel *infoModel = (tenementInfoModel *)[self.jsonArray objectAtIndex:indexPath.section];
    tenementDetailViewController *detailView = [[tenementDetailViewController alloc] init];
    detailView.ten_id = infoModel.list_id;
    [self.navigationController pushViewController:detailView animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000001;
}


-(void)tenementListData{
    [DDProgressHUD show];
    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/probaoxiu/getProBaoxiuList",postUrl] version:Token parameters:@{@"appUserId":[yzUserInfoModel getLoginUserInfo:@"userId"],@"size":@"10",@"page":[NSNumber numberWithInteger:self.pageNo],@"ziDianStateId":self.ten_id} success:^(id object) {
        
        NSDictionary *json = object;
        if (self.pageNo == 0) {
            [self.jsonArray removeAllObjects];
        }
        if ([[json objectForKey:@"code"] intValue] == 200) {
            [DDProgressHUD dismiss];
            
//            NSDictionary* dic = [[json objectForKey:@"data"] JSONValue];
//            NSLog(@"%@",[dic objectForKey:@"size"]);
            
            NSMutableArray *detail = [[[json objectForKey:@"data"] JSONValue] objectForKey:@"content"];
            for (int i = 0; i < detail.count; i ++) {
                tenementInfoModel *keepModel = [[tenementInfoModel alloc] init:detail[i]];
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
        [self.listTableView reloadData];
    } failure:^(NSError *error) {
        [DDProgressHUD showErrorImageWithInfo:error.localizedDescription];
    }];
}
//获取报修订单状态
-(void)getOrderState{
    ///
    [CCAFNetWork get:[NSString stringWithFormat:@"%@app/probaoxiu/getBaoxiuState",postUrl] version:Token parameters:nil success:^(id object) {
        NSDictionary *json = object;
        NSMutableArray *classArray = [[NSMutableArray alloc] init];
        if ([[json objectForKey:@"code"] intValue] == 200) {
            [DDProgressHUD dismiss];
            
            NSMutableArray *itemClass = [json objectForKey:@"data"];
            for (int i = 0; i < itemClass.count; i ++) {
                tenementClassModel *classModel = [[tenementClassModel alloc] init:itemClass[i]];
                if (i == 0) {
                    self.ten_id = classModel.t_id;
                }
                [classArray addObject:classModel];
            }
        }else if ([[json objectForKey:@"code"] intValue] == -6){
            [DDProgressHUD dismiss];
            [yzUserInfoModel userLoginOut];
            [yzUserInfoModel setLoginState:NO];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
            
        }else{
            [DDProgressHUD showErrorImageWithInfo:[json objectForKey:@"message"]];
        }
        self.pageNo = 0;
        [self tenementListData];
        [self.headerView setStateClassArray:classArray];
    } failure:^(NSError *error) {
        [DDProgressHUD showErrorImageWithInfo:error.localizedDescription];
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
