//
//  yzMessageController.m
//  悦宅云
//
//  Created by 尚广杰 on 2019/4/15.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import "yzMessageController.h"
#import "yzMessageCell.h"
@interface yzMessageController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UILabel* titleLab;    //顶部标题
@property(nonatomic,strong)UITableView* tableV;  //列表
@property(nonatomic,assign)int pageNo;
@property(nonatomic,strong)NSMutableArray* list;
@end

@implementation yzMessageController

-(UITableView*)tableView{
    if (!_tableV) {
        _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, mDeviceWidth, mDeviceHeight) style:UITableViewStyleGrouped];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableV.sectionHeaderHeight = 10;
        _tableV.tableFooterView = [UIView new];
        [_tableV setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
        [self.view addSubview:_tableV];
    }
    
    
    return _tableV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self tableView];
    
    self.pageNo = 0;
    
    
    [self.tableV setMj_header:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageNo = 0;
        [self getMessageList];
        [self.tableV.mj_header endRefreshing];
    }]];
    self.tableV.mj_header.automaticallyChangeAlpha = YES;
    [self.tableV setMj_footer:[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageNo++;
        [self getMessageList];
        [self.tableV.mj_footer endRefreshing];
    }]];
    
    //显示空数据或者无网络
    [yzProductPubObject EmptyUITableViewData:self.tableV isShowNoNetWork:NO isShowEmptyData:YES refreshBtnClickBlock:^{
        [self.tableV.mj_header beginRefreshing];
    } isShowRefreshBtn:YES];
    
    [self getMessageList];
    
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
    [backBtn.titleLabel setFont:[UIFont fontWithName:@"HYJinChangTiJ" size:16]];
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
    self.titleLab.text = @"消息";
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    [self.titleLab setFont:[UIFont fontWithName:@"HYJinChangTiJ" size:18]];
    
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.list.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    yzMessageCell* cell = [[yzMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    [cell getMessageByDic:self.list[indexPath.section]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        CGFloat finalH = 0.0;
        yzMessageCell* cell = (yzMessageCell*)[self tableView:(UITableView*)tableView cellForRowAtIndexPath:indexPath];
    
        finalH = cell.finalH;
        return finalH;
//    return 70;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

#pragma mark -- 消息列表
-(void)getMessageList{
    [DDProgressHUD show];
    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/message/getlist",postUrl] version:Token parameters:@{@"page":@(self.pageNo),@"size":@"10",@"appUserId":[yzUserInfoModel getLoginUserInfo:@"userId"]} success:^(id object) {
        [DDProgressHUD dismiss];
        NSDictionary *json = object;
        
        if ([[json objectForKey:@"code"] intValue] == 200) {
            NSDictionary* contentDic = [json objectForKey:@"data"];
            NSArray* arr = [contentDic objectForKey:@"content"];
            
         
            
            if (arr.count>0) {
                if (self.pageNo==0) {
                    self.list = [NSMutableArray array];
                    [self.list addObjectsFromArray:arr];
                }else{
                    [self.list addObjectsFromArray:arr];
                }
            }else{
                [self.tableV.mj_footer endRefreshingWithNoMoreData];
            }
            
            
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

@end
