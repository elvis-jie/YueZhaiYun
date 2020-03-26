//
//  yzOrderDetailController.m
//  yzProduct
//
//  Created by 尚广杰 on 2019/2/14.
//  Copyright © 2019 CC. All rights reserved.
//

#import "yzOrderDetailController.h"
#import "yzHeaderCell.h"
#import "yzProductDetailCell.h"
#import "yzOrderInfomationCell.h"
#import "OrderSettlePayTypeCell.h"
#import "yzOrderDetailModel.h"
#import "yzOrderSettleViewController.h"  //去付款
#import "yzGoPayOrderController.h"
#import "yzPaySuccessController.h"
@interface yzOrderDetailController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView* tableV;
@property(nonatomic,strong)UIButton* btn2;                  //取消订单
@property(nonatomic,strong)UIButton* btn1;                  //付款
@property(nonatomic,strong)NSMutableArray* allArray;
@property(nonatomic,strong)NSDictionary* addressDic;        //地址容器
@property(nonatomic,strong)NSMutableArray* finalArray;      //最终数组

@property(nonatomic,strong)UIImageView* shopImageV;         //店铺logo
@property(nonatomic,strong)UIButton* shopNameBtn;           //店铺名
@property(nonatomic,assign)float allPrice;                  //订单价格

@property(nonatomic,strong)UILabel* freightLabel;           //运费
@property(nonatomic,strong)UILabel* freightMoneyLabel;      //运费钱
@property(nonatomic,strong)UILabel* surePayLabel;           //实付款
@property(nonatomic,strong)UILabel* surePayMoneyLabel;      //实付款钱
@end

@implementation yzOrderDetailController

-(yzLinShiOrderModel *)linshiModel{
    if (!_linshiModel) {
        _linshiModel = [[yzLinShiOrderModel alloc] init];
    }
    return _linshiModel;
}

-(UITableView *)tableView{
    if (!_tableV) {
      _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, mDeviceWidth, mDeviceHeight - 40 - kNavBarHeight - KSAFEBAR_HEIGHT) style:UITableViewStyleGrouped];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        
        //解决滑动视图顶部空出状态栏高度的问题
        if (@available(iOS 11.0, *)) {
            _tableV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
//        _tableV.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
//        _tableV.sectionFooterHeight = 0;
        _tableV.separatorInset = UIEdgeInsetsZero;
        [self.view addSubview:self.tableV];
    }
    return _tableV;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.allArray = [NSMutableArray array];
    

    
    //获取订单详情
    [self getPublicData];
    
    [self tableView];
    [self setBtn];
}
//创建底部按钮
-(void)setBtn{
    self.btn1 = [[UIButton alloc]initWithFrame:CGRectMake(mDeviceWidth - 95, mDeviceHeight - 30 - KSAFEBAR_HEIGHT, 80, 20)];
    [self.btn1 setTitle:@"去付款" forState:UIControlStateNormal];
    [self.btn1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.btn1.titleLabel.font = [UIFont systemFontOfSize:14.0];
    self.btn1.layer.cornerRadius = 10;
    self.btn1.layer.masksToBounds = YES;
    self.btn1.layer.borderColor = [UIColor redColor].CGColor;
    self.btn1.layer.borderWidth = 1;
    self.btn1.hidden = YES;
    [self.btn1 addTarget:self action:@selector(goPay:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn1];
    
    self.btn2 = [[UIButton alloc]initWithFrame:CGRectMake(mDeviceWidth - 90 - 100, mDeviceHeight - 30 - KSAFEBAR_HEIGHT, 80, 20)];
    [self.btn2 setTitle:@"取消订单" forState:UIControlStateNormal];
    [self.btn2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.btn2.titleLabel.font = [UIFont systemFontOfSize:14.0];
    self.btn2.layer.cornerRadius = 10;
    self.btn2.layer.masksToBounds = YES;
    self.btn2.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.btn2.layer.borderWidth = 1;
    self.btn2.hidden = YES;
    [self.btn2 addTarget:self action:@selector(cancleOrder:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn2];
}

-(void)getPublicData{
    //创建信号量
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(2);
    // 创建全局并行
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    
    
    //任务 获取产品详细信息
    dispatch_async(quene, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        [self getOrderDetail];
        dispatch_semaphore_signal(semaphore);
    });
    
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
    [titleLabel setText:@"订单详情"];
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
//    [self.navigationController popViewControllerAnimated:YES];
    
    NSInteger index = (NSInteger)[[self.navigationController viewControllers] indexOfObject:self];
    if (index > 2) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(1)] animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark  订单详情
-(void)getOrderDetail{
    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/unifiedorder/orderInfo",postUrl] version:Token parameters:@{@"orderNo":self.orderId} success:^(id object) {
        NSDictionary* json = object;
        if ([[json objectForKey:@"code"] integerValue]==200) {
            
        self.finalArray = [NSMutableArray array];
        NSMutableArray* arr;  //所有数据的数组
        NSMutableArray* arrid = [NSMutableArray array];//所有店铺id
        arr = [[json objectForKey:@"data"] JSONValue];
            
        NSString* addressId = [arr[0] objectForKey:@"sys_app_user_address_id"];
            NSString* pay_status = [arr[0] objectForKey:@"biku_order_status"];
            if ([pay_status isEqualToString:@"0"]) {
                self.btn1.hidden = NO;
                self.btn2.hidden = NO;
            }
            
        for (NSDictionary*dic in arr) {
            yzOrderDetailModel* model = [[yzOrderDetailModel alloc]init:dic];
            [self.allArray addObject:model];
        }
            self.allPrice = 0.0;
        for (NSDictionary* dic in arr) {
            NSString* shopId = [dic objectForKey:@"biku_store_id"];
            float price = [[dic objectForKey:@"biku_order_price"] floatValue];
            _allPrice += price;
            
           
            if (![arrid containsObject:shopId]) {
                [arrid addObject:shopId];
            }
 
        }
      
        for (NSString* shopId in arrid) {
            NSMutableArray* tempArr = [NSMutableArray array];
            for (yzOrderDetailModel* model in self.allArray) {
                if ([shopId isEqualToString:model.biku_store_id]) {
                    [tempArr addObject:model];
                }
            }
            [self.finalArray addObject:tempArr];
        }
        [self getAddressById:addressId];
        [self.tableV reloadData];
      
        }else if ([[json objectForKey:@"code"] intValue] == -6){
            [DDProgressHUD dismiss];
            [yzUserInfoModel userLoginOut];
            [yzUserInfoModel setLoginState:NO];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
            
        }else{
            [DDProgressHUD showErrorImageWithInfo:[json objectForKey:@"message"]];
        }
        
//        if ([[json objectForKey:@"code"] integerValue]==200) {
//            NSArray* arr = [[json objectForKey:@"data"] JSONValue];
//            NSString* addressId = [arr[0] objectForKey:@"sys_app_user_address_id"];
//            for (NSDictionary*dic in arr) {
//                yzOrderDetailModel* model = [[yzOrderDetailModel alloc]init:dic];
//                [self.allArray addObject:model];
//            }
//            [self getAddressById:addressId];
//            [self.tableV reloadData];
            
//        }else{
//            [DDProgressHUD showErrorImageWithInfo:[json objectForKey:@"message"]];
//        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
    
}


-(void)getAddressById:(NSString* )addressId{
    [CCAFNetWork get:[NSString stringWithFormat:@"%@app/address/getAddress",postUrl] version:Token parameters:@{@"id":addressId} success:^(id object) {
        NSDictionary* json = object;
        self.addressDic = [NSDictionary dictionary];
        if ([[json objectForKey:@"code"] integerValue]==200) {
            NSString* str = [json objectForKey:@"data"];
            NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
            self.addressDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableV reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2+self.finalArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0||section==self.finalArray.count+1) {
        return 1;
    }else{
        NSArray* rowArr = self.finalArray[section - 1];
        return rowArr.count;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        yzHeaderCell* cell = [[yzHeaderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell0"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.allArray.count>0) {
            [cell getMessageByModel:self.allArray[indexPath.row] address:self.addressDic];
        }
        
        return cell;
    }else if (indexPath.section==self.finalArray.count+1){
        yzOrderInfomationCell* cell = [[yzOrderInfomationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell2"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.allArray.count>0) {
            [cell getMessageByModel:self.allArray[indexPath.row]];
        }
        
        return cell;
    }else{
        yzProductDetailCell* cell = [[yzProductDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell1"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell getProductByModel:self.finalArray[indexPath.section - 1][indexPath.row]];
        return cell;
    }
    
   
 
    
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        CGFloat finalH = 0.0;
        yzHeaderCell* cell = (yzHeaderCell*)[self tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath];
        finalH = cell.finalH;
        return finalH;
    }else if (indexPath.section==self.finalArray.count+1){
        CGFloat finalH = 0.0;
        yzOrderInfomationCell* cell = (yzOrderInfomationCell*)[self tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath];
        finalH = cell.finalH;
        return finalH;
    }else{
   
        CGFloat finalH = 0.0;
        yzProductDetailCell* cell = (yzProductDetailCell*)[self tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath];
        finalH = cell.finalH;
        return finalH;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0||section==self.finalArray.count+1) {
        return nil;
    }else{
        UIView* headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mDeviceWidth, 45)];
        [headerView setBackgroundColor:[UIColor whiteColor]];
        //店铺logo
        self.shopImageV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 15, 15)];
        self.shopImageV.image = [UIImage imageNamed:@"dian"];
        [headerView addSubview:self.shopImageV];
        //店铺名
        self.shopNameBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.shopImageV.frame)+10, 15, 200, 15)];
        yzOrderDetailModel* model = self.finalArray[section - 1][0];
        [self.shopNameBtn setTitle:[NSString stringWithFormat:@"%@ >",model.biku_store_name] forState:UIControlStateNormal];
        [self.shopNameBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.shopNameBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        self.shopNameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [headerView addSubview:self.shopNameBtn];
        return headerView;
    
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==self.finalArray.count) {
        UIView* footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mDeviceWidth, 50)];
        [footerView setBackgroundColor:[UIColor whiteColor]];
        //运费
        self.freightLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 60, 20)];
        self.freightLabel.text = @"运费";
        self.freightLabel.textAlignment = NSTextAlignmentLeft;
        self.freightLabel.font = [UIFont systemFontOfSize:14.0];
        [footerView addSubview:self.freightLabel];
        //运费钱
        self.freightMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(mDeviceWidth - 75, 10, 60, 20)];
        self.freightMoneyLabel.text = @"￥0.00";
        self.freightMoneyLabel.textAlignment = NSTextAlignmentRight;
        self.freightMoneyLabel.font = [UIFont systemFontOfSize:14.0];
        [footerView addSubview:self.freightMoneyLabel];
        //实付款
        self.surePayLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.freightLabel.frame) + 5, 160, 25)];
        self.surePayLabel.text = @"实付款（含运费）";
        self.surePayLabel.textAlignment = NSTextAlignmentLeft;
        self.surePayLabel.font = [UIFont systemFontOfSize:15.0];
        [footerView addSubview:self.surePayLabel];
        //实付款钱
        self.surePayMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(mDeviceWidth - 75, CGRectGetMaxY(self.freightMoneyLabel.frame) + 5, 60, 25)];
        self.surePayMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",self.allPrice/100];
        self.surePayMoneyLabel.textAlignment = NSTextAlignmentRight;
        self.surePayMoneyLabel.font = [UIFont systemFontOfSize:15.0];
        [footerView addSubview:self.surePayMoneyLabel];
        return footerView;
    }else
        return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0.01;
    }else if (section==self.finalArray.count+1){
        return 15;
    }else{
        
        
        return 45;
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==self.finalArray.count) {
        return 65;
    }else
        return 15;
    
}


#pragma mark -- 取消订单
-(void)cancleOrder:(UIButton*)sender{
    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/unifiedorder/cancelOrder",postUrl] version:Token parameters:@{@"order":self.orderId} success:^(id object) {
        NSDictionary* json = object;
        if ([[json objectForKey:@"code"] integerValue]==200) {
            
            [DDProgressHUD showSuccessImageWithInfo:@"订单已取消"];
            if(self.successBlock){
                self.successBlock(@"-1");
            }
            NSInteger index = (NSInteger)[[self.navigationController viewControllers] indexOfObject:self];
            if (index > 2) {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index-3)] animated:YES];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
            
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

#pragma mark --付款
-(void)goPay:(UIButton*)sender{
    
    NSInteger index = (NSInteger)[[self.navigationController viewControllers] indexOfObject:self];
    if (index > 2) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index - 2)] animated:YES];
        self.linshiModel = [[yzLinShiOrderModel alloc] init:@{@"orderNo":self.orderId}];
    }else{
        yzGoPayOrderController* settleVC = [[yzGoPayOrderController alloc]init];
        settleVC.jsonArray = self.finalArray;
        settleVC.orderNo = self.orderId;
        settleVC.finalMoney = self.allPrice;
        settleVC.detailType = @"detail";
        [self.navigationController pushViewController:settleVC animated:YES];
    }
    
   
}
@end
