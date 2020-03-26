//
//  yzCartViewController.m
//  yzProduct
//
//  Created by LiuHQ on 2018/9/20.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "yzCartViewController.h"
#import "MyCartListViewCell.h" //列表cell
#import "MyCartListHeaderView.h" //header
#import "yzCartGoodsModel.h"        //购物车数据
#import "MyCartListBottomView.h" //购物车底部视图
#import "yzOrderSettleViewController.h" //结算页面
//#import "yzWuYeServeController.h"       //物业服务

@interface yzCartViewController ()<MyCartListHeaderViewDelegate>
@property (nonatomic, strong) NSMutableArray *jsonArray;
@property (nonatomic, strong) yzCartCountModel *cartCountModel;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, strong) MyCartListBottomView *bottomView;
@end

@implementation yzCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.listTableView setMj_header:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageNo = 0;
        [self getCartList];
        [self.listTableView.mj_header endRefreshing];
    }]];
    self.listTableView.mj_header.automaticallyChangeAlpha = YES;
//    [self.listTableView setMj_footer:[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        self.pageNo++;
//        [self getCartList];
//        [self.listTableView.mj_footer endRefreshing];
//    }]];
    
    //显示空数据或者无网络
    [yzProductPubObject EmptyUITableViewData:self.listTableView isShowNoNetWork:NO isShowEmptyData:YES refreshBtnClickBlock:^{
        [self.listTableView.mj_header beginRefreshing];
    } isShowRefreshBtn:YES];
    
    //添加底部视图
    WEAKSELF
    self.bottomView = [[MyCartListBottomView alloc] initWithFrame:CGRectMake(0, 0, mDeviceWidth, 50)];
    [self.cartBottomView addSubview:self.bottomView];
    [self.bottomView setCartGoodsSelectedBlock:^(yzCartCountModel *model) {
       //全选
        [weakSelf updateCartGoodsCheck:model];
    }];
    [self.bottomView setCartGotoPayBlock:^{
//        if ([yzUserInfoModel getisLogin]) {
            yzOrderSettleViewController *settleView = [[yzOrderSettleViewController alloc] init];
            [settleView setCartViewRefreshBlock:^{
                [weakSelf.listTableView.mj_header beginRefreshing];
            }];
            [weakSelf.navigationController pushViewController:settleView animated:YES];
//        }else{
//            yzLoginViewController *loginView = [[yzLoginViewController alloc] init];
//            [loginView setLoginSuccessBlock:^{
//                [weakSelf.listTableView.mj_header beginRefreshing];
//            }];
//            [weakSelf.navigationController presentViewController:[yzProductPubObject navc:loginView] animated:YES completion:nil];
//        }
        
    }];
    
    self.pageNo = 0;
    [self getCartList];
    
    
    
    
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
    [backBtn.titleLabel setFont:[UIFont fontWithName:@"HYJinChangTiJ" size:16]];
    [backBtn setTitleColor:AppBackTitleColor forState:UIControlStateNormal];
    [backBtn setFrame:CGRectMake(0, 0, AutoWitdh(32), AutoWitdh(32))];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationController.visibleViewController.navigationItem setLeftBarButtonItem:backItem];
    //顶部信息
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setText:@"购物车"];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.jsonArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ((yzCartGoodsModel *)self.jsonArray[section]).goodsArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return AutoHeight(44);
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MyCartListHeaderView *headerView = [[MyCartListHeaderView alloc] initWithFrame:CGRectMake(0, 0, mDeviceWidth, AutoHeight(44))];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    headerView.delegate = self;
    //设置数据
    [headerView setCartShopInfo:(yzCartGoodsModel *)self.jsonArray[section]];
    return headerView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCartListViewCell *listCell = [tableView dequeueReusableCellWithIdentifier:@"MyCartListViewCell"];
    if (!listCell) {
        listCell = (MyCartListViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"MyCartListViewCell" owner:self options:nil] lastObject];
    }
    [listCell setGoodsInfoData:(yzCartShopGoodsModel *)[((yzCartGoodsModel *)self.jsonArray[indexPath.section]).goodsArray objectAtIndex:indexPath.row]];
    [listCell setGoodsAddBlock:^(yzCartShopGoodsModel *model) {
       //增加产品数量
        [self updateGoodsAddCount:model];
    }];
    [listCell setGoodsJianBlock:^(yzCartShopGoodsModel *model) {
        if (model.biku_goods_count==1) {
            NSLog(@"确定删除产品吗");
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除该产品吗" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* cancleAlert = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            UIAlertAction* sureAlert = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self updateGoodsCount:model];
                
            }];
            [alertController addAction:cancleAlert];
            [alertController addAction:sureAlert];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }else{
            //减少产品数量
            [self updateGoodsCount:model];
        }
    }];
    [listCell setGoodsCheckBlock:^(yzCartShopGoodsModel *model) {
        //产品选中状态
        [self updateGoodsCheck:model];
    }];
    [listCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return listCell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSMutableArray *)jsonArray{
    if (!_jsonArray) {
        _jsonArray = [[NSMutableArray alloc] init];
    }
    return _jsonArray;
}
#pragma mark --MyCartListHeaderViewDelegate
-(void)headerSelectedBlock:(yzCartGoodsModel *)model{
    //商店全选与未选中
    [self updateShopCart:model];
}
-(void)headerToShopInfo:(int)shopId{
    //进入店铺信息
//    yzWuYeServeController* serveVC = [[yzWuYeServeController alloc]init];
//    [self.navigationController pushViewController:serveVC animated:YES];
    
    
}
/** 获取购物车信息 */
-(void)getCartList{
    [DDProgressHUD show];
    [CCAFNetWork get:[NSString stringWithFormat:@"%@app/biku/listShoppingCar",postUrl] version:Token parameters:@{@"userId":[yzUserInfoModel getLoginUserInfo:@"userId"]/*,@"size":@"30",@"page":[NSNumber numberWithInteger:self.pageNo]*/} success:^(id object) {
        
        NSDictionary *json = object;
        if ([[json objectForKey:@"code"] intValue] == 200) {
            [DDProgressHUD dismiss];
            NSDictionary *detail = [[json objectForKey:@"data"] JSONValue];
      
            
            self.cartCountModel = [[yzCartCountModel alloc] init:detail];
            [self.bottomView setCartTotalInfo:self.cartCountModel];
            if (self.pageNo == 0) {
                [self.jsonArray removeAllObjects];
            }
            NSMutableArray *shopArray = [detail objectForKey:@"bikuStoreShopCarVoList"];
            for (int i = 0;  i < shopArray.count; i ++) {
                yzCartGoodsModel *shopModel = [[yzCartGoodsModel alloc] init:shopArray[i]];
                //产品
                NSMutableArray *goodsArray = [[shopArray objectAtIndex:i] objectForKey:@"bikuGoodsShopCarVoList"];
                for (int j = 0; j < goodsArray.count; j ++) {
                    yzCartShopGoodsModel *goodsModel = [[yzCartShopGoodsModel alloc] init:goodsArray[j]];
                    [shopModel.goodsArray addObject:goodsModel];
                }
                [self.jsonArray addObject:shopModel];
            }
        }else if ([[json objectForKey:@"code"] intValue] == -6){
            [DDProgressHUD dismiss];
            [yzUserInfoModel userLoginOut];
            [yzUserInfoModel setLoginState:NO];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
        }else{
            [DDProgressHUD showErrorImageWithInfo:[yzProductPubObject netWorkingStatus:[json objectForKey:@"code"] message:[json objectForKey:@"message"]]];
//            if ([[NSString stringWithFormat:@"%@",[json objectForKey:@"code"]] isEqualToString:@"-1000001"]) {
//                yzLoginViewController *loginView = [[yzLoginViewController alloc] init];
//                [loginView setLoginSuccessBlock:^{
//                    [self.listTableView.mj_header beginRefreshing];
//                }];
//                [self.navigationController presentViewController:[yzProductPubObject navc:loginView] animated:YES completion:nil];
//            }
        }
        [self.listTableView reloadData];
    } failure:^(NSError *error) {
        [DDProgressHUD showErrorImageWithInfo:error.localizedDescription];
    }];
}
/** 购物车店铺全选 */
-(void)updateShopCart:(yzCartGoodsModel *)model{
    [DDProgressHUD show];
    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/biku/updateStoreCheck",postUrl] version:Token parameters:@{@"userId":[yzUserInfoModel getLoginUserInfo:@"userId"],@"storeId":[NSNumber numberWithInt:model.biku_store_id],@"check":[NSNumber numberWithBool:model.checked]} success:^(id object) {
        
        NSDictionary *json = object;
        if ([[json objectForKey:@"code"] intValue] == 200) {
            [DDProgressHUD showSuccessImageWithInfo:[json objectForKey:@"message"]];
            [self.jsonArray removeAllObjects];
            [self getCartList];
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
/** 修改购物车数量-增加 */
-(void)updateGoodsAddCount:(yzCartShopGoodsModel *)model{
//    [DDProgressHUD show];
 
    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/biku/saveShoppingCar",postUrl] version:Token parameters:@{@"userId":[yzUserInfoModel getLoginUserInfo:@"userId"],@"goodId":model.biku_goods_id,@"attrId":model.biku_goods_attr_id,@"count":[NSNumber numberWithInt:1]} success:^(id object) {
        
        NSDictionary *json = object;
        if ([[json objectForKey:@"code"] intValue] == 200) {
//            [DDProgressHUD showSuccessImageWithInfo:[json objectForKey:@"message"]];
//            [DDProgressHUD dismiss];
            [self.jsonArray removeAllObjects];
            [self getCartList];
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
/** 修改购物车数量-减少 */
-(void)updateGoodsCount:(yzCartShopGoodsModel *)model{
    
    
    
    
//    [DDProgressHUD show];
    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/biku/subShoppingCar",postUrl] version:Token parameters:@{@"userId":[yzUserInfoModel getLoginUserInfo:@"userId"],@"shopCarId":model.biku_car_id} success:^(id object) {
        
        NSDictionary *json = object;
        if ([[json objectForKey:@"code"] intValue] == 200) {
            NSString* data = [json objectForKey:@"data"];
            NSData *jsonData = [data dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&err];
            if ([[dic objectForKey:@"shopCarCount"] intValue] == 0) {
                //进行删除当前产品
                [self deleteCartGoods:model.biku_car_id];
            }else{
//                [DDProgressHUD showSuccessImageWithInfo:[json objectForKey:@"message"]];
//                [DDProgressHUD dismiss];
                [self.jsonArray removeAllObjects];
                [self getCartList];
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
        [DDProgressHUD showErrorImageWithInfo:error.localizedDescription];
    }];

}
/** 删除产品 */
-(void)deleteCartGoods:(NSString *)cart_id{
    [DDProgressHUD show];
    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/biku/deleteShoppingCar",postUrl] version:Token parameters:@{@"userId":[yzUserInfoModel getLoginUserInfo:@"userId"],@"shopCarId":cart_id} success:^(id object) {
        
        NSDictionary *json = object;
        if ([[json objectForKey:@"code"] intValue] == 200) {
            [DDProgressHUD showSuccessImageWithInfo:[json objectForKey:@"message"]];
            [self.jsonArray removeAllObjects];
            [self getCartList];
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
/** 单个产品选中 */
-(void)updateGoodsCheck:(yzCartShopGoodsModel *)model{
    [DDProgressHUD show];
    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/biku/updateGoodsCheck",postUrl] version:Token parameters:@{@"userId":[yzUserInfoModel getLoginUserInfo:@"userId"],@"shopCarId":model.biku_car_id,@"check":[NSNumber numberWithBool:model.checked]} success:^(id object) {
        
        NSDictionary *json = object;
        if ([[json objectForKey:@"code"] intValue] == 200) {
            [DDProgressHUD showSuccessImageWithInfo:[json objectForKey:@"message"]];
            [self.jsonArray removeAllObjects];
            [self getCartList];
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
/** 底部全选 */
-(void)updateCartGoodsCheck:(yzCartCountModel *)model{
    [DDProgressHUD show];
    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/biku/updateAllCheck",postUrl] version:Token parameters:@{@"userId":[yzUserInfoModel getLoginUserInfo:@"userId"],@"check":[NSNumber numberWithBool:model.allCheck]} success:^(id object) {
        
        NSDictionary *json = object;
        if ([[json objectForKey:@"code"] intValue] == 200) {
            [DDProgressHUD showSuccessImageWithInfo:[json objectForKey:@"message"]];
            [self.jsonArray removeAllObjects];
            [self getCartList];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected obshangject to the new view controller.
}
*/

@end
