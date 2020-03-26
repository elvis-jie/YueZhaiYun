//
//  yzPayOrderController.m
//  yzProduct
//
//  Created by 尚广杰 on 2019/2/23.
//  Copyright © 2019 CC. All rights reserved.
//

#import "yzPayOrderController.h"
#import "yzPayOrderCell.h"
#import "yzJiaoFeiOrderController.h"
@interface yzPayOrderController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView* tableV;
@property(nonatomic,strong)NSMutableArray* listArr;
@property (nonatomic, assign) NSInteger pageNo;
@end

@implementation yzPayOrderController

-(UITableView *)tableView{
    if (!_tableV) {
        _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, mDeviceWidth, mDeviceHeight - kNavBarHeight - KSAFEBAR_HEIGHT) style:UITableViewStylePlain];
        _tableV.delegate = self;
        _tableV.dataSource = self;
//        [_tableV  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.view addSubview:self.tableV];
    }
    return _tableV;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.listArr = [NSMutableArray array];
    [self tableView];
    
    [self.tableV setMj_header:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageNo = 1;
        [self jiaofeiListData];
        [self.tableV.mj_header endRefreshing];
    }]];
    self.tableV.mj_header.automaticallyChangeAlpha = YES;
    [self.tableV setMj_footer:[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageNo++;
       [self jiaofeiListData];
        [self.tableV.mj_footer endRefreshing];
    }]];
    
    //显示空数据或者无网络
    [yzProductPubObject EmptyUITableViewData:self.tableV isShowNoNetWork:NO isShowEmptyData:YES refreshBtnClickBlock:^{
        [self.tableV.mj_header beginRefreshing];
    } isShowRefreshBtn:YES];
    self.pageNo = 1;

    
    [self jiaofeiListData];
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
    [titleLabel setText:@"缴费订单"];
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
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return self.listArr.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        yzPayOrderCell* cell = [[yzPayOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yz_record_cell_bg"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.listArr.count>0) {
            [cell getMessageByDic:self.listArr[indexPath.row]];
        }
        return cell;
    }else
        return nil;
   
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 15;
    }
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 15;
    }else
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mDeviceWidth, 15)];
        UIImageView* imageView=  [[UIImageView alloc]initWithFrame:view.bounds];
        imageView.image = [UIImage imageNamed:@"yz_member_fh_view_bg"];
        [view addSubview:imageView];
        
        UIImageView* leftImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
        leftImageV.image = [UIImage imageNamed:@"yz_index_shop_leftTop"];
        [imageView addSubview:leftImageV];
        
        UIImageView* rightImageV = [[UIImageView alloc]initWithFrame:CGRectMake(mDeviceWidth - 15, 0, 15, 15)];
        rightImageV.image = [UIImage imageNamed:@"yz_index_shop_rightTop"];
        [imageView addSubview:rightImageV];
        
        
        
        return view;
    }else
        return nil;
   
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==0) {
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mDeviceWidth, 15)];
        
        UIImageView* imageView=  [[UIImageView alloc]initWithFrame:view.bounds];
        imageView.image = [UIImage imageNamed:@"yz_member_fh_view_bg"];
        [view addSubview:imageView];
        
        
        UIImageView* leftImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
        leftImageV.image = [UIImage imageNamed:@"yz_index_shop_leftBottom"];
        [imageView addSubview:leftImageV];
        
        UIImageView* rightImageV = [[UIImageView alloc]initWithFrame:CGRectMake(mDeviceWidth - 15, 0, 15, 15)];
        rightImageV.image = [UIImage imageNamed:@"yz_index_shop_rightBottom"];
        [imageView addSubview:rightImageV];
        
        return view;
    }else
        return nil;
   
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        yzJiaoFeiOrderController* vc = [[yzJiaoFeiOrderController alloc]init];
        NSString* orderNo = [NSString stringWithFormat:@"%@",[self.listArr[indexPath.row] objectForKey:@"orderId"]];
        vc.orderNo = orderNo;
        vc.successJiaoFeiBlock = ^(NSString * _Nonnull payState) {
            NSDictionary *item = [self.listArr objectAtIndex:indexPath.row];
            NSMutableDictionary *mutableItem = [NSMutableDictionary dictionaryWithDictionary:item];
            [mutableItem setObject:payState forKey:@"payStatus"];
            [self.listArr setObject:mutableItem atIndexedSubscript:indexPath.row];
           
            [self.tableV.mj_header beginRefreshing];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


//获取服务订单数据
-(void)jiaofeiListData{
    [DDProgressHUD show];

    
    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/proorder/listJiaoFei",postUrl] version:Token parameters:@{@"appUserId":[yzUserInfoModel getLoginUserInfo:@"userId"],@"page":@(self.pageNo),@"size":@"10",@"yearAndMonth":@""} success:^(id object) {
  
        NSDictionary *json = object;
        
        
      
        if ([[json objectForKey:@"code"] intValue] == 200) {
            [DDProgressHUD dismiss];
    
            NSArray* arr = [[json objectForKey:@"data"] JSONValue];
            if (arr.count>0) {
                if (self.pageNo==1) {
                    self.listArr = [NSMutableArray array];
                    self.listArr = [[json objectForKey:@"data"] JSONValue];
                }else{
                    [self.listArr addObjectsFromArray:arr];
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
        [self.tableV reloadData];
    } failure:^(NSError *error) {
        [DDProgressHUD showErrorImageWithInfo:error.localizedDescription];
    }];
}


@end
