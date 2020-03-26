//
//  yzOrderListController.m
//  悦宅云
//
//  Created by 尚广杰 on 2019/4/22.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import "yzOrderListController.h"
#import "yzOrderListCell.h"
#import "orderFuWuModel.h"
#import "yzOrderDetailController.h"
#import "yzGoPayOrderController.h"
#import "yzPaySuccessController.h"
@interface yzOrderListController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray* titleArray;
@property(nonatomic,strong)NSMutableArray *buttonArray;
@property(nonatomic,strong)NSMutableArray *jsonArray;
@property(nonatomic,strong)UILabel* line;
@property(nonatomic,strong)UITableView* tableV;
@property(nonatomic,assign)NSInteger pageNo;
@property(nonatomic,strong)NSString* status;

@property(nonatomic,strong)NSString* price;
@property(nonatomic,strong)NSString* orderNo;
@end

@implementation yzOrderListController
-(UITableView*)tableView{
    if (!_tableV) {
        _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarHeight + 45, mDeviceWidth, mDeviceHeight - KSAFEBAR_HEIGHT - kNavBarHeight - 45) style:UITableViewStyleGrouped];
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
        _tableV.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableV.separatorInset = UIEdgeInsetsZero;
        [self.view addSubview:self.tableV];
    }
    
    return _tableV;
}
-(NSMutableArray *)jsonArray{
    if (!_jsonArray) {
        _jsonArray = [[NSMutableArray alloc] init];
    }
    return _jsonArray;
}
-(NSMutableArray *)buttonArray{
    if (!_buttonArray) {
        _buttonArray = [[NSMutableArray alloc] init];
    }
    return _buttonArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
         [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appliSuccess:) name:@"AlipaySDKYDD" object:nil];
    self.titleArray = @[@"全部",@"待付款",@"已付款",@"已取消"];
    self.status = @"";
    //头部按钮
    [self headView];
    [self tableView];
    
    [self.tableV setMj_header:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageNo = 1;
        [self fuwuListDataByStatus:self.status];
        [self.tableV.mj_header endRefreshing];
    }]];
    self.tableV.mj_header.automaticallyChangeAlpha = YES;
    [self.tableV setMj_footer:[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageNo++;
        [self fuwuListDataByStatus:self.status];
        [self.tableV.mj_footer endRefreshing];
    }]];
    //显示空数据或者无网络
    [yzProductPubObject EmptyUITableViewData:self.tableV isShowNoNetWork:NO isShowEmptyData:YES refreshBtnClickBlock:^{
        [self.tableV.mj_header beginRefreshing];
    } isShowRefreshBtn:YES];
    self.pageNo = 1;
    [self fuwuListDataByStatus:@""];
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
    [titleLabel setText:@"我的订单"];
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


//设置头部按钮
-(void)headView{
    for (int i = 0; i < self.titleArray.count; i++) {
        UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(mDeviceWidth/4*i, kNavBarHeight, mDeviceWidth/4, 44)];
        [btn setTitle:self.titleArray[i] forState:UIControlStateNormal];
        btn.titleLabel.font = YSize(14.0);
        [btn setTitleColor:RGB(22, 22, 22) forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];

        
        if (i == 0) {
            btn.selected = YES;
        }
        btn.tag = i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
        [self.buttonArray addObject:btn];
      
    }
    self.line = [[UILabel alloc]initWithFrame:CGRectMake(5, 44 + kNavBarHeight, mDeviceWidth/4 - 10, 1)];
    [self.line setBackgroundColor:[UIColor redColor]];
    
    [self.view addSubview:self.line];
}
#pragma mark -- tableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.jsonArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identifire = @"Cell";
    yzOrderListCell* cell = [tableView dequeueReusableCellWithIdentifier:identifire];
    if (!cell) {
        cell = [[yzOrderListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifire];
    }
    if (self.jsonArray.count>0) {
        orderFuWuModel *fuWuModel = self.jsonArray[indexPath.section];
        [cell getDataByModel:fuWuModel];
    }
    
    [cell.leftBtn addTarget:self action:@selector(leftBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell.rightBtn addTarget:self action:@selector(rightBtn:) forControlEvents:UIControlEventTouchUpInside];
    cell.leftBtn.tag = indexPath.section;
    cell.rightBtn.tag = indexPath.section;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat finalH = 0.0;
    yzOrderListCell* cell = (yzOrderListCell*)[self tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath];
    finalH = cell.finalH;
    
    return finalH;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    yzOrderDetailController* detailVC = [[yzOrderDetailController alloc]init];
    orderFuWuModel* model = self.jsonArray[indexPath.row];
    detailVC.orderId = model.t_orderId;
    detailVC.successBlock = ^(NSString * _Nonnull payState) {
//        model.t_payStatus = payState;
        [self.tableV.mj_header beginRefreshing];
    };
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)btnClick:(UIButton*)sender{
    for (int i = 0; i < self.titleArray.count; i ++) {
        UIButton *button = (UIButton *)[self.buttonArray objectAtIndex:i];
        
        if (i == sender.tag) {
            
            CGRect rect = self.line.frame;
            rect.origin.x = mDeviceWidth/4*i + 5;
            
            self.line.frame = rect;
            button.selected = YES;
            if (i==0) {
               self.status = @"";
            }else if (i==1){
                self.status = @"0";
            }else if (i==2){
                self.status = @"1";
            }else{
                self.status = @"00";
            }
            
            
            [_tableV.mj_header beginRefreshing];
        }else{
            button.selected = NO;
        }
    }
}


//获取服务订单数据
-(void)fuwuListDataByStatus:(NSString*)status{
    [DDProgressHUD show];
    //     NSString *wuye_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"xiaoqu_wuyeid"];
    
    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/proorder/listProOrder",postUrl] version:Token parameters:@{@"size":@"10",@"page":[NSNumber numberWithInteger:self.pageNo],@"appUserId":[yzUserInfoModel getLoginUserInfo:@"userId"],@"status":status} success:^(id object) {
        //        @"wuYeId":wuye_id
        //        @"b3c7e5e188c411e8a77400163e03ee3b"
        NSDictionary *json = object;
     
        
        if (self.pageNo == 1) {
            [self.jsonArray removeAllObjects];
        }
        if ([[json objectForKey:@"code"] intValue] == 200) {
            [DDProgressHUD dismiss];
            NSMutableArray *detail = [[json objectForKey:@"data"] JSONValue];
            
            for (int i = 0; i < detail.count ; i ++) {
                NSDictionary *quDict = [detail objectAtIndex:i];
                orderFuWuModel *fuWuModel = [[orderFuWuModel alloc] init];
                
                fuWuModel.t_orderId = [yzProductPubObject withStringReturn:quDict[@"orderId"]];
                fuWuModel.t_orderName = [yzProductPubObject withStringReturn:quDict[@"orderName"]];
                fuWuModel.t_price = [yzProductPubObject withStringReturn:quDict[@"price"]];
                fuWuModel.t_count = [yzProductPubObject withStringReturn:quDict[@"count"]];
                fuWuModel.t_shopName = [yzProductPubObject withStringReturn:quDict[@"shopName"]];
                fuWuModel.t_remarks = [yzProductPubObject withStringReturn:quDict[@"remarks"]];
                fuWuModel.t_time = [yzProductPubObject withStringReturn:quDict[@"orderTime"]];
                fuWuModel.t_payStatus = [yzProductPubObject withStringReturn:quDict[@"payStatus"]];
                fuWuModel.t_image = [yzProductPubObject withStringReturn:quDict[@"orderImg"]];
                [self.jsonArray addObject:fuWuModel];
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
        [DDProgressHUD showErrorImageWithInfo:error.localizedDescription];
    }];
}


#pragma mark -- 按钮事件
-(void)leftBtn:(UIButton*)sender{
// orderFuWuModel *fuWuModel = self.jsonArray[sender.tag];
//    self.price = fuWuModel.t_price;
//    self.orderNo = fuWuModel.t_orderId;
//    [self getOrderContent:fuWuModel.t_orderId];
    
    yzOrderDetailController* detailVC = [[yzOrderDetailController alloc]init];
    orderFuWuModel* model = self.jsonArray[sender.tag];
    detailVC.orderId = model.t_orderId;
    detailVC.successBlock = ^(NSString * _Nonnull payState) {
        //        model.t_payStatus = payState;
        [self.tableV.mj_header beginRefreshing];
    };
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

-(void)getOrderContent:(NSString*)data{
    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/unifiedorder/alipay",postUrl] version:Token parameters:@{@"appUserId":[yzUserInfoModel getLoginUserInfo:@"userId"],@"order":data} success:^(id object) {
        NSDictionary *json = object;
        if ([[json objectForKey:@"code"] intValue] == 200) {
            [DDProgressHUD showSuccessImageWithInfo:[json objectForKey:@"message"]];
            
            NSString* payOrder = [json objectForKey:@"data"][@"body"];
            [[AlipaySDK defaultService] payOrder:payOrder fromScheme:@"yzPayDemo" callback:^(NSDictionary *resultDic) {
                NSLog(@"%@",resultDic);
            }];
            
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


#pragma mark -- 支付状态的通知
-(void)appliSuccess:(NSNotification *)notification{
    
    
    NSDictionary *dataDic = [NSDictionary dictionaryWithDictionary:notification.userInfo];
    NSString *result = [NSString stringWithFormat:@"%@",dataDic[@"resultStatus"]];
    
//        yzPaySuccessController* successVC = [[yzPaySuccessController alloc]init];
//        successVC.totalMoney = _price;
//        successVC.orderNo = self.orderNo;
//        successVC.detailType = @"0";
    //    successVC.centenType = @"detail2";
    if ([result isEqualToString:@"9000"]) {
//        [DDProgressHUD showSuccessImageWithInfo:[dataDic objectForKey:@"memo"]];
//        [self getOrderDetail];
//        self.judge = @"成功";
        //        successVC.type = @"1";
        
    }else if ([result isEqualToString:@"6001"]){
//        [DDProgressHUD showSuccessImageWithInfo:[dataDic objectForKey:@"memo"]];
        yzPaySuccessController* successVC = [[yzPaySuccessController alloc]init];
        successVC.totalMoney = [self.price floatValue]/100;
        successVC.orderNo = self.orderNo;
        successVC.detailType = @"1";
                successVC.type = @"1";
        successVC.centenType = @"detail2";
        [self.navigationController pushViewController:successVC animated:YES];
        
    }
    
}
-(void)rightBtn:(UIButton*)sender{
    orderFuWuModel *fuWuModel = self.jsonArray[sender.tag];

    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/unifiedorder/cancelOrder",postUrl] version:Token parameters:@{@"order":fuWuModel.t_orderId} success:^(id object) {
        NSDictionary* json = object;
        
        
        
        if ([[json objectForKey:@"code"] integerValue]==200) {
            
            [DDProgressHUD showSuccessImageWithInfo:@"订单已取消"];
            
            [self.tableV.mj_header beginRefreshing];
            
        }else if ([[json objectForKey:@"code"] intValue] == -6){
            [DDProgressHUD dismiss];
            [yzUserInfoModel userLoginOut];
            [yzUserInfoModel setLoginState:NO];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
            
        }else{
            [DDProgressHUD showErrorImageWithInfo:[json objectForKey:@"message"]];
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
}
@end
