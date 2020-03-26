//
//  yzJiaoFeiOrderController.m
//  yzProduct
//
//  Created by 尚广杰 on 2019/2/24.
//  Copyright © 2019 CC. All rights reserved.
//

#import "yzJiaoFeiOrderController.h"
#import "yzJiaoFeiHeaderCell.h"
#import "yzJiaoFeiCenterCell.h"
#import "yzJiaoFeiBottomCell.h"
#import "yzPaySuccessController.h"
#import "OrderSettlePayTypeCell.h"
#import "yzSettlePayModel.h" //支付方式
#import "CommonCrypto/CommonDigest.h"
@interface yzJiaoFeiOrderController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView* tableV;
@property(nonatomic,strong)NSDictionary* dic;

@property(nonatomic,strong)UIButton* cancleBtn;
@property(nonatomic,strong)UIButton* payBtn;
@property(nonatomic,assign)float price;

@property(nonatomic,strong)NSString* judge;      //判断是否支付成功
@property (nonatomic, strong) NSMutableArray *payArray;
@property (nonatomic, strong) yzSettlePayModel *payModel;
@property (nonatomic, strong) NSString* payType;          //支付宝微信
@end

@implementation yzJiaoFeiOrderController
-(NSMutableArray *)payArray{
    if (!_payArray) {
        _payArray = [[NSMutableArray alloc] init];
    }
    return _payArray;
}
-(UIButton*)cancleBtn{
    if (!_cancleBtn) {
        _cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake(mDeviceWidth - 190, mDeviceHeight - 30 - KSAFEBAR_HEIGHT, 80, 20)];
        [_cancleBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [_cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _cancleBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        _cancleBtn.layer.cornerRadius = 10;
        _cancleBtn.layer.masksToBounds = YES;
        _cancleBtn.layer.borderWidth = 1;
        _cancleBtn.layer.borderColor = [UIColor blackColor].CGColor;
        [_cancleBtn addTarget:self action:@selector(cancleBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_cancleBtn];
    }
    return _cancleBtn;
}
-(UIButton*)payBtn{
    if (!_payBtn) {
        _payBtn = [[UIButton alloc]initWithFrame:CGRectMake(mDeviceWidth - 95, mDeviceHeight - 30 - KSAFEBAR_HEIGHT, 80, 20)];
        [_payBtn setTitle:@"付款" forState:UIControlStateNormal];
        [_payBtn setBackgroundColor:[UIColor redColor]];
        _payBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        _payBtn.layer.cornerRadius = 10;
        _payBtn.layer.masksToBounds = YES;
        [_payBtn addTarget:self action:@selector(payBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_payBtn];
    }
    return _payBtn;
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
        _tableV.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _tableV.sectionFooterHeight = 0;
        _tableV.separatorInset = UIEdgeInsetsZero;
        [self.view addSubview:self.tableV];
    }
    return _tableV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appliSuccess:) name:@"AlipaySDKYDD" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(WXChatSuccess:) name:@"ORDER_PAY_SUCCESSNOTIFICATION" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(WXChatCancel:) name:@"ORDER_PAY_CANCEL" object:nil];
    [self cancleBtn];
    [self payBtn];
    [self tableView];
    
  
    [self getOrderDetail];
    //支付方式
    [self getPayData];
    self.judge = @"未成功";
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
    [titleLabel setText:@"缴费详情"];
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
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index-2)] animated:YES];
        }else{
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    
    if ([self.judge isEqualToString:@"成功"]) {
        if(self.successJiaoFeiBlock){
            self.successJiaoFeiBlock(@"1");
        }
    }
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
    if (indexPath.section==0) {
        yzJiaoFeiHeaderCell* cell = [[yzJiaoFeiHeaderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [cell getMessageByDic:self.dic];
        return cell;
    }else if (indexPath.section==1){
        yzJiaoFeiCenterCell* cell = [[yzJiaoFeiCenterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        NSString* priceStr = [NSString stringWithFormat:@"%.2f",[[self.dic objectForKey:@"shiJiao"] floatValue]/100];
         self.price = [priceStr floatValue];
        
        NSLog(@"---%f",self.price);
        
        
        [cell getMessageByDic:self.dic];
        return cell;
    }else if(indexPath.section==2){
        yzJiaoFeiBottomCell* cell = [[yzJiaoFeiBottomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [cell getMessageByDic:self.dic];
        return cell;
    }else{
        OrderSettlePayTypeCell *payCell = [tableView dequeueReusableCellWithIdentifier:@"OrderSettlePayTypeCell"];
        if (!payCell) {
            payCell = (OrderSettlePayTypeCell *)[[[NSBundle mainBundle] loadNibNamed:@"OrderSettlePayTypeCell" owner:self options:nil] lastObject];
        }
        [payCell setSettlePayModel:(yzSettlePayModel *)self.payArray[indexPath.row]];
        [payCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return payCell;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        CGFloat finalH = 0.0;
        yzJiaoFeiHeaderCell* cell = (yzJiaoFeiHeaderCell*)[self tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath];
        finalH = cell.finalH;
        return finalH;
    }else if (indexPath.section==1){
        CGFloat finalH = 0.0;
        yzJiaoFeiCenterCell* cell = (yzJiaoFeiCenterCell*)[self tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath];
        finalH = cell.finalH;
        return finalH;
    }else if(indexPath.section==2){
        
        CGFloat finalH = 0.0;
        yzJiaoFeiBottomCell* cell = (yzJiaoFeiBottomCell*)[self tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath];
        finalH = cell.finalH;
        return finalH;
    }else{
        return 44;
    }
    return 0;
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




//获取订单详情
-(void)getOrderDetail{
    [DDProgressHUD show];
    
    
    [CCAFNetWork get:[NSString stringWithFormat:@"%@app/paymanage/getPayOrderDetail",postUrl] version:Token parameters:@{@"orderNo":self.orderNo} success:^(id object) {
        
        NSDictionary *json = object;
        
        
        
        if ([[json objectForKey:@"code"] intValue] == 200) {
            [DDProgressHUD dismiss];
            NSString* dicStr = [json objectForKey:@"data"];
            NSData *jsonData = [dicStr dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            self.dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&err];
            NSString* payState = [NSString stringWithFormat:@"%@",[self.dic objectForKey:@"payState"]];
            NSLog(@"%@",payState);
            
            if ([payState isEqualToString:@"0"]) {
                self.cancleBtn.hidden = NO;
                self.payBtn.hidden = NO;
            }else{
                self.cancleBtn.hidden = YES;
                self.payBtn.hidden = YES;
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

#pragma mark -- 取消订单   付款
-(void)cancleBtn:(UIButton*)sender{
    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/unifiedorder/cancelOrder",postUrl] version:Token parameters:@{@"order":[self.dic objectForKey:@"id"]} success:^(id object) {
        NSDictionary* json = object;
        if ([[json objectForKey:@"code"] integerValue]==200) {
            
            [DDProgressHUD showSuccessImageWithInfo:@"订单已取消"];
            if(self.successJiaoFeiBlock){
                self.successJiaoFeiBlock(@"-1");
            }
            NSInteger index = (NSInteger)[[self.navigationController viewControllers] indexOfObject:self];
            if (index > 2) {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index-2)] animated:YES];
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
-(void)payBtn:(UIButton*)sender{


            
    [self getOrderContent:[NSString stringWithFormat:@"%@",[self.dic objectForKey:@"id"]]];
            
            
    
}

-(void)getOrderContent:(NSString*)data{
//    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/unifiedorder/alipay",postUrl] version:nil parameters:@{@"appUserId":[yzUserInfoModel getLoginUserInfo:@"userId"],@"order":data} success:^(id object) {
//        NSDictionary *json = object;
//        if ([[json objectForKey:@"code"] intValue] == 200) {
//            [DDProgressHUD showSuccessImageWithInfo:[json objectForKey:@"message"]];
//
//            NSString* payOrder = [json objectForKey:@"data"][@"body"];
//            [[AlipaySDK defaultService] payOrder:payOrder fromScheme:@"yzPayDemo" callback:^(NSDictionary *resultDic) {
//                NSLog(@"%@",resultDic);
//            }];
//
//        }else{
//            [DDProgressHUD showErrorImageWithInfo:[json objectForKey:@"message"]];
//        }
//    } failure:^(NSError *error) {
//        [DDProgressHUD showErrorImageWithInfo:error.localizedDescription];
//    }];
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
    
//    yzPaySuccessController* successVC = [[yzPaySuccessController alloc]init];
//    successVC.totalMoney = _price;
//    successVC.orderNo = self.orderNo;
//    successVC.detailType = @"0";
//    successVC.centenType = @"detail2";
    if ([result isEqualToString:@"9000"]) {
//        [DDProgressHUD showSuccessImageWithInfo:[dataDic objectForKey:@"memo"]];
        [self getOrderDetail];
        self.judge = @"成功";
//        successVC.type = @"1";
        
    }else if ([result isEqualToString:@"6001"]){
//        [DDProgressHUD showSuccessImageWithInfo:[dataDic objectForKey:@"memo"]];
//        successVC.type = @"0";
        
    }
//    [self.navigationController pushViewController:successVC animated:YES];
}

//微信支付成功
-(void)WXChatSuccess:(NSNotification *)notification{
//    [DDProgressHUD showSuccessImageWithInfo:@"付款成功"];
    [self getOrderDetail];
    self.judge = @"成功";
}
-(void)WXChatCancel:(NSNotification *)notification{
    [DDProgressHUD showErrorImageWithInfo:notification.object];
}
@end
