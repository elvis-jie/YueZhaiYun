//
//  yzOrderViewController.m
//  yzProduct
//
//  Created by 尚广杰 on 2019/2/19.
//  Copyright © 2019 CC. All rights reserved.
//

#import "yzOrderViewController.h"
#import "orderSettleAddressViewCell.h" //收货地址cell
#import "orderSettleGoodsViewCell.h" //产品信息cell
#import "orderSettleAmountViewCell.h" //总计cell
#import "OrderSettlePayTypeCell.h" //支付方式cell
#import "yzCartGoodsModel.h" //购物车结算产品信息
#import "addressListViewController.h" //收货地址页面
#import "yzAddressModel.h" //收货地址
#import "yzSettlePayModel.h" //支付方式
#import "orderSettleHeaderView.h" //产品店铺header
#import "yzPaySuccessController.h"
#import "CommonCrypto/CommonDigest.h"
@interface yzOrderViewController ()
@property (nonatomic, strong) NSMutableArray *jsonArray;
@property (nonatomic, strong) yzCartCountModel *cartCountModel;
@property (nonatomic, strong) yzAddressModel *addressModel;
@property (nonatomic, strong) NSMutableArray *payArray;
@property (nonatomic, strong) NSString* orderNum;
@property (nonatomic, strong) UIButton* payBtn;
@property (nonatomic, strong) yzSettlePayModel *payModel;
@property (nonatomic, strong) NSString* payType;          //支付宝微信
@end

@implementation yzOrderViewController
-(NSMutableArray *)payArray{
    if (!_payArray) {
        _payArray = [[NSMutableArray alloc] init];
    }
    return _payArray;
}
-(yzAddressModel *)addressModel{
    if (!_addressModel) {
        _addressModel = [[yzAddressModel alloc] init];
    }
    return _addressModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
       [self.tableV setTableFooterView:[UIView new]];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appliSuccess:) name:@"AlipaySDKYDD" object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(WXChatSuccess:) name:@"ORDER_PAY_SUCCESSNOTIFICATION" object:nil];
       [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(WXChatCancel:) name:@"ORDER_PAY_CANCEL" object:nil];
    
    //支付方式
    [self getPayData];

    
    //获取地址
    [self getDefaultAddress];
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
    
//    NSInteger index = (NSInteger)[[self.navigationController viewControllers] indexOfObject:self];
//    if (index > 2) {
//        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index-2)] animated:YES];
//    }else{
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==3) {
        return 2;
    }
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0)
    {
        orderSettleAddressViewCell *addressCell = [tableView dequeueReusableCellWithIdentifier:@"orderSettleAddressViewCell"];
        if (!addressCell) {
            addressCell = (orderSettleAddressViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"orderSettleAddressViewCell" owner:self options:nil] lastObject];
        }
        [addressCell setToAddressBlock:^{
            addressListViewController *addressView = [[addressListViewController alloc] init];
            [addressView setSettleOrderRefreshBlock:^{
                [self getDefaultAddress];
            }];
            [self.navigationController pushViewController:addressView animated:YES];
        }];
        [addressCell setAddressInfoData:self.addressModel];
        [addressCell.layer setCornerRadius:5.0f];
        [addressCell.layer setMasksToBounds:YES];
        [addressCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return addressCell;
    }else if (indexPath.section==2){
        //共计金额
        orderSettleAmountViewCell *amountCell = [tableView dequeueReusableCellWithIdentifier:@"orderSettleAmountViewCell"];
        if (!amountCell) {
            amountCell = (orderSettleAmountViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"orderSettleAmountViewCell" owner:self options:nil] lastObject];
        }
        [amountCell.layer setCornerRadius:5.0f];
        [amountCell.layer setMasksToBounds:YES];
//       if ([self.type isEqualToString:@"1"]) {
//          [amountCell setShopGoodsAmouData:self.goodsModel];
//       }else{
           [amountCell setGoodsAmouData:self.goodsModel];
//       }
        
        [amountCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return amountCell;
    }else if (indexPath.section==3){
        OrderSettlePayTypeCell *payCell = [tableView dequeueReusableCellWithIdentifier:@"OrderSettlePayTypeCell"];
        if (!payCell) {
            payCell = (OrderSettlePayTypeCell *)[[[NSBundle mainBundle] loadNibNamed:@"OrderSettlePayTypeCell" owner:self options:nil] lastObject];
        }
        [payCell setSettlePayModel:(yzSettlePayModel *)self.payArray[indexPath.row]];
        [payCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return payCell;
    }else{
        orderSettleGoodsViewCell *goodsCell = [tableView dequeueReusableCellWithIdentifier:@"orderSettleGoodsViewCell"];
        if (!goodsCell) {
            goodsCell = (orderSettleGoodsViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"orderSettleGoodsViewCell" owner:self options:nil] lastObject];
        }
        [goodsCell.layer setCornerRadius:5.0f];
        [goodsCell.layer setMasksToBounds:YES];
//        if ([self.type isEqualToString:@"1"]) {
//             [goodsCell setShopGoodsInfoData:self.shopGoodModel];
//        }else{
             [goodsCell setGoodInfoData:self.goodsModel];
//        }
       
        [goodsCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return goodsCell;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 70.5;
    }else if (indexPath.section == 2){
        return 40;
    }else if (indexPath.section == 3){
        return 44;
    }else{
        return 90;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

    
    if (indexPath.section == 3) {
        for (int i = 0; i < self.payArray.count; i ++) {
            self.payModel = (yzSettlePayModel *)[self.payArray objectAtIndex:i];
            if (i == indexPath.row) {
                self.payModel.isSelected = YES;
                if (i==0) {
                    self.payType = @"支付宝";
                }else{
                    self.payType = @"微信";
                }
            }else{
                self.payModel.isSelected = NO;
            }
        }
        [self.tableV reloadData];
      
    }
}
//头视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 45;
    }else{
        return 15;
    }
}
// 隐藏UITableViewStyleGrouped下边多余的间隔
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        orderSettleHeaderView *headerView = (orderSettleHeaderView *)[[[NSBundle mainBundle] loadNibNamed:@"orderSettleHeaderView" owner:self options:nil] lastObject];
        headerView.frame = CGRectMake(0, 0, self.tableV.frame.size.width, 45);
//        if ([self.type isEqualToString:@"1"]) {
//            [headerView setWuYeIndexData:self.shopGoodModel];
//        }else{
        [headerView setShopIndexData:self.goodsModel];
//        }
        return headerView;
    }else{
        return nil;
    }
}

/** 获取订单信息 */
-(void)getOrderSettle{
    [DDProgressHUD show];
    [CCAFNetWork get:[NSString stringWithFormat:@"%@app/biku/listOrderCar",postUrl] version:Token parameters:@{@"userId":[yzUserInfoModel getLoginUserInfo:@"userId"]} success:^(id object) {
        
        NSDictionary *json = object;
        if ([[json objectForKey:@"code"] intValue] == 200) {
            [DDProgressHUD dismiss];
            NSDictionary *detail = [[json objectForKey:@"data"] JSONValue];
            self.cartCountModel = [[yzCartCountModel alloc] init:detail];
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
            [DDProgressHUD showErrorImageWithInfo:[json objectForKey:@"message"]];
        }
        
    } failure:^(NSError *error) {
        [DDProgressHUD showErrorImageWithInfo:error.localizedDescription];
    }];
}
/** 获取默认地址 */
-(void)getDefaultAddress{
    [DDProgressHUD show];
    [CCAFNetWork get:[NSString stringWithFormat:@"%@app/address/getDefault",postUrl] version:Token parameters:@{@"userId":[yzUserInfoModel getLoginUserInfo:@"userId"]} success:^(id object) {
        
        NSDictionary *json = object;
        if ([[json objectForKey:@"code"] intValue] == 200) {
            [DDProgressHUD dismiss];
            NSDictionary *detail = [[json objectForKey:@"data"] JSONValue];
            self.addressModel = [[yzAddressModel alloc] init:detail];
            if (![detail isKindOfClass:[NSDictionary class]]) {
                self.addressModel.isHaveData = NO;
            }else{
                self.addressModel.isHaveData = YES;
            }
        }else if ([[json objectForKey:@"code"] intValue] == -6){
            [DDProgressHUD dismiss];
            [yzUserInfoModel userLoginOut];
            [yzUserInfoModel setLoginState:NO];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
            
        }else{
            self.addressModel.isHaveData = NO;
            [DDProgressHUD showErrorImageWithInfo:[json objectForKey:@"message"]];
        }
        [self.tableV reloadData];
    } failure:^(NSError *error) {
        self.addressModel.isHaveData = NO;
        [DDProgressHUD showErrorImageWithInfo:error.localizedDescription];
    }];
}
/** 设置支付方式 */
-(void)getPayData{
    NSArray *payType = @[@{@"icon":@"yz_pay_alipay",@"payName":@"支付宝支付",@"pay_id":@"1"},@{@"icon":@"yz_pay_wechat",@"payName":@"微信支付",@"pay_id":@"2"}];
    for (int i = 0; i < payType.count; i ++) {
        self.payModel = [[yzSettlePayModel alloc] init:payType[i]];
        if (i == 0) {
            self.payModel.isSelected = YES;
            self.payType = @"支付宝";
        }
        [self.payArray addObject:self.payModel];
    }
    
}

- (IBAction)payMoney:(id)sender {
    [self createOrder];
}
/** 生成订单 */
-(void)createOrder{
    
    if (self.addressModel.address_id.length == 0) {
        [DDProgressHUD showErrorImageWithInfo:@"请选择收货地址"];
        return;
    }
    [DDProgressHUD show];
    if ([self.type isEqualToString:@"1"]) {
        [CCAFNetWork post:[NSString stringWithFormat:@"%@app/unifiedorder/generateOrderDirect",postUrl] version:Token parameters:@{@"appUserId":[yzUserInfoModel getLoginUserInfo:@"userId"],@"addressId":self.addressModel.address_id,@"goodsId":[NSString stringWithFormat:@"%d",self.goodsModel.biku_goods_id],@"attrId":@""} success:^(id object) {
            
            NSDictionary *json = object;
            if ([[json objectForKey:@"code"] intValue] == 200) {
                //            [DDProgressHUD showSuccessImageWithInfo:[json objectForKey:@"message"]];
                
                NSLog(@"===%@",json);
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.orderNum = json[@"data"];
                    
                    [self getOrderContent:json[@"data"]];
                    
                });
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
    }else{
        [CCAFNetWork post:[NSString stringWithFormat:@"%@app/unifiedorder/generateOrderDirect",postUrl] version:Token parameters:@{@"appUserId":[yzUserInfoModel getLoginUserInfo:@"userId"],@"addressId":self.addressModel.address_id,@"goodsId":[NSString stringWithFormat:@"%d",self.goodsModel.biku_goods_id],@"attrId":self.attrModel.biku_goods_attr_id} success:^(id object) {
            
            NSDictionary *json = object;
            if ([[json objectForKey:@"code"] intValue] == 200) {
                //            [DDProgressHUD showSuccessImageWithInfo:[json objectForKey:@"message"]];
                
                NSLog(@"===%@",json);
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.orderNum = json[@"data"];
                    
                    [self getOrderContent:json[@"data"]];
                    
                });
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
    
    
}


-(void)getOrderContent:(NSString*)data{
     NSLog(@"orderid == %@",data);
    if ([self.payType isEqualToString:@"支付宝"]) {
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
    }else{
        if(![WXApi isWXAppInstalled]){
            [DDProgressHUD showErrorImageWithInfo:@"您还没有安装微信"];
            return;
        }
        if (![WXApi isWXAppSupportApi]) {
            [DDProgressHUD showErrorImageWithInfo:@"您当前微信版本不支持支付，请您更新"];
            return;
        }
        
        
        [CCAFNetWork post:[NSString stringWithFormat:@"%@app/unifiedorder/wxpay",postUrl] version:Token parameters:@{@"appUserId":[yzUserInfoModel getLoginUserInfo:@"userId"],@"order":data} success:^(id object) {
            NSDictionary *json = object;
            if ([[json objectForKey:@"code"] intValue] == 200) {
                [DDProgressHUD showSuccessImageWithInfo:[json objectForKey:@"message"]];
                NSDictionary* dic = [json objectForKey:@"data"];
                
                PayReq* req             = [[PayReq alloc] init];
                req.partnerId           = [dic objectForKey:@"mch_id"];
                req.prepayId            = [dic objectForKey:@"prepay_id"];
                req.nonceStr            = [dic objectForKey:@"nonce_str"];
                req.openID              = [dic objectForKey:@"appid"];
                //            NSString* str = [dic objectForKey:@"timestamp"];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
                
                [formatter setDateStyle:NSDateFormatterMediumStyle];
                
                [formatter setTimeStyle:NSDateFormatterShortStyle];
                
                [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
                
                //设置时区,这个对于时间的处理有时很重要
                
                NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
                
                [formatter setTimeZone:timeZone];
                
                NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
                
                NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
                NSLog(@"时间戳===%@",timeSp);
                req.timeStamp           =  (UInt32)[timeSp intValue];
                req.package             = @"Sign=WXPay";
                //            req.sign  = [dic objectForKey:@"sign"];
                req.sign = [self createMD5SingForPayWithAppID:req.openID partnerid:req.partnerId prepayid:req.prepayId package:req.package noncestr:req.nonceStr timestamp:req.timeStamp];
                
                NSLog(@"sign==%@",req.sign);
                //调起微信支付
                if ([WXApi sendReq:req]) {
                    NSLog(@"吊起成功");
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
    

}
-(NSString *)createMD5SingForPayWithAppID:(NSString *)appid_key partnerid:(NSString *)partnerid_key prepayid:(NSString *)prepayid_key package:(NSString *)package_key noncestr:(NSString *)noncestr_key timestamp:(UInt32)timestamp_key{
    NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
    [signParams setObject:appid_key forKey:@"appid"];//微信appid 例如wxfb132134e5342
    [signParams setObject:noncestr_key forKey:@"noncestr"];//随机字符串
    [signParams setObject:package_key forKey:@"package"];//扩展字段  参数为 Sign=WXPay
    [signParams setObject:partnerid_key forKey:@"partnerid"];//商户账号
    [signParams setObject:prepayid_key forKey:@"prepayid"];//此处为统一下单接口返回的预支付订单号
    [signParams setObject:[NSString stringWithFormat:@"%u",timestamp_key] forKey:@"timestamp"];//时间戳
    
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [signParams allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[signParams objectForKey:categoryId] isEqualToString:@""]
            && ![[signParams objectForKey:categoryId] isEqualToString:@"sign"]
            && ![[signParams objectForKey:categoryId] isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [signParams objectForKey:categoryId]];
        }
    }
    //添加商户密钥key字段  API 密钥
    [contentString appendFormat:@"key=%@", @"3020ec5d6d0447ec8c0500ef32c3eyue"];
    NSString *result = [self MD5ForUpper32Bate:contentString];//md5加密
    return result;
}

#pragma mark - MD5加密 32位 大写
- (NSString *)MD5ForUpper32Bate:(NSString *)str{
    
    //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02X", result[i]];
    }
    
    return digest;
}
#pragma mark -- 支付状态的通知
-(void)appliSuccess:(NSNotification *)notification{
    
    
    NSDictionary *dataDic = [NSDictionary dictionaryWithDictionary:notification.userInfo];
    NSString *result = [NSString stringWithFormat:@"%@",dataDic[@"resultStatus"]];
    
    if ([result isEqualToString:@"9000"]) {
//        [DDProgressHUD showSuccessImageWithInfo:[dataDic objectForKey:@"memo"]];
 
        yzPaySuccessController* successVC = [[yzPaySuccessController alloc]init];
//        if ([self.type isEqualToString:@"1"]) {
//
//            successVC.totalMoney = self.shopGoodModel.goodsPrice/100;
//        }else{

            successVC.totalMoney = self.goodsModel.biku_goods_shop_price/100;
//        }
        
        successVC.type = @"1";
        successVC.orderNo = self.orderNum;
        successVC.detailType = @"1";
        [self.navigationController pushViewController:successVC animated:YES];
    }else if ([result isEqualToString:@"6001"]){
        
        yzPaySuccessController* successVC = [[yzPaySuccessController alloc]init];
//        if ([self.type isEqualToString:@"1"]) {
//
//            successVC.totalMoney = self.shopGoodModel.goodsPrice/100;
//        }else{
        
            successVC.totalMoney = self.goodsModel.biku_goods_shop_price/100;
//        }
        successVC.type = @"0";
        successVC.orderNo = self.orderNum;
        successVC.detailType = @"1";
        [self.navigationController pushViewController:successVC animated:YES];
        //        [DDProgressHUD showErrorImageWithInfo:[dataDic objectForKey:@"memo"]];
    }
}

//微信支付成功
-(void)WXChatSuccess:(NSNotification *)notification{
    yzPaySuccessController* successVC = [[yzPaySuccessController alloc]init];
    if ([self.type isEqualToString:@"1"]) {
        
        successVC.totalMoney = self.shopGoodModel.goodsPrice/100;
    }else{
        
        successVC.totalMoney = self.goodsModel.biku_goods_shop_price/100;
    }
    successVC.type = @"0";
    successVC.orderNo = self.orderNum;
    successVC.detailType = @"1";
    [self.navigationController pushViewController:successVC animated:YES];
}
-(void)WXChatCancel:(NSNotification *)notification{
    [DDProgressHUD showErrorImageWithInfo:notification.object];
}

@end
