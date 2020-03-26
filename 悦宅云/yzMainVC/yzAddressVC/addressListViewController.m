//
//  addressListViewController.m
//  yzProduct
//
//  Created by LiuHQ on 2018/9/25.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "addressListViewController.h"
#import "addressListViewCell.h" //列表cell
#import "addressAddViewController.h" //增加收货地址
#import "yzAddressModel.h" //地址信息model

@interface addressListViewController ()
@property (nonatomic, strong) NSMutableArray *jsonArray;
@property (nonatomic, assign) NSInteger pageNo;
@end

@implementation addressListViewController
-(NSMutableArray *)jsonArray{
    if (!_jsonArray) {
        _jsonArray = [[NSMutableArray alloc] init];
    }
    return _jsonArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    self.listTableView.tableFooterView = [UIView new];
    
    [self.listTableView setMj_header:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageNo = 0;
        [self getAddressList];
        [self.listTableView.mj_header endRefreshing];
    }]];
    self.listTableView.mj_header.automaticallyChangeAlpha = YES;
    [self.listTableView setMj_footer:[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageNo++;
        [self getAddressList];
        [self.listTableView.mj_footer endRefreshing];
    }]];
    
    self.pageNo = 0;
    [self getAddressList];
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
    [backBtn.titleLabel setFont:[UIFont fontWithName:@"HYJinChangTiJ" size:16]];
    [backBtn setTitleColor:AppBackTitleColor forState:UIControlStateNormal];
    [backBtn setFrame:CGRectMake(0, 0, AutoWitdh(32), AutoWitdh(32))];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationController.visibleViewController.navigationItem setLeftBarButtonItem:backItem];
    
    //顶部信息
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setText:@"我的收货地址"];
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
    if (self.settleOrderRefreshBlock) {
        self.settleOrderRefreshBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.jsonArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125;
}

//头视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}
// 隐藏UITableViewStyleGrouped下边多余的间隔
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    addressListViewCell *listCell = [tableView dequeueReusableCellWithIdentifier:@"addressListViewCell"];
    if (!listCell) {
        listCell = (addressListViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"addressListViewCell" owner:self options:nil] lastObject];
    }
    [listCell setAddressInfoModel:(yzAddressModel *)self.jsonArray[indexPath.row]];
    [listCell setAddressSelectedBlock:^(NSString *address_id) {
        //设置默认
        [self setAddressDefault:address_id];
    }];
    [listCell setAddressEditBlock:^(NSString *address_id) {
        //修改地址
        addressAddViewController *editView = [[addressAddViewController alloc] init];
        editView.address_id = address_id;
        [editView setBackRefreshDataBlock:^{
            self.pageNo = 0;
            [self getAddressList];
        }];
        [self.navigationController pushViewController:editView animated:YES];
    }];
    [listCell setAddressDeleteBlock:^(NSString *address_id) {
        //删除地址
        [self setAddressDelete:address_id];
    }];
    [listCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return listCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    yzAddressModel* model = (yzAddressModel*)self.jsonArray[indexPath.row];
    
    //设置默认
    [self setAddressDefault:model.address_id];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/** 获取收货地址 */
-(void)getAddressList{
    [DDProgressHUD show];
    [CCAFNetWork get:[NSString stringWithFormat:@"%@app/address/listAddress",postUrl] version:Token parameters:@{@"userId":[yzUserInfoModel getLoginUserInfo:@"userId"],@"size":@"10",@"page":[NSNumber numberWithInteger:self.pageNo]} success:^(id object) {
        
        NSDictionary *json = object;
//        if (self.pageNo == 0) {
            [self.jsonArray removeAllObjects];
//        }
        if ([[json objectForKey:@"code"] intValue] == 200) {
            [DDProgressHUD dismiss];
            NSMutableArray *detail = [[json objectForKey:@"data"] JSONValue];
            for (int i = 0; i < detail.count; i ++) {
                yzAddressModel *addressModel = [[yzAddressModel alloc] init:detail[i]];
                [self.jsonArray addObject:addressModel];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addClick:(id)sender {
    addressAddViewController *addView = [[addressAddViewController alloc] init];
    [addView setBackRefreshDataBlock:^{
        self.pageNo = 0;
        [self getAddressList];
    }];
    [self.navigationController pushViewController:addView animated:YES];
}
/** 设置默认地址 */
-(void)setAddressDefault:(NSString *)address_id{
    [DDProgressHUD show];
    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/address/updateDefault",postUrl] version:Token parameters:@{@"userId":[yzUserInfoModel getLoginUserInfo:@"userId"],@"id":address_id} success:^(id object) {
        
        NSDictionary *json = object;
        if ([[json objectForKey:@"code"] intValue] == 200) {
            [DDProgressHUD showSuccessImageWithInfo:[json objectForKey:@"message"]];
            [self.jsonArray removeAllObjects];
            [self getAddressList];
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
/** 删除地址 */
-(void)setAddressDelete:(NSString *)address_id{
    [DDProgressHUD show];
    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/address/delete",postUrl] version:Token parameters:@{@"userId":[yzUserInfoModel getLoginUserInfo:@"userId"],@"ids":address_id} success:^(id object) {
        
        NSDictionary *json = object;
        if ([[json objectForKey:@"code"] intValue] == 200) {
            [DDProgressHUD showSuccessImageWithInfo:[json objectForKey:@"message"]];
            [self.jsonArray removeAllObjects];
            [self getAddressList];
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
@end
