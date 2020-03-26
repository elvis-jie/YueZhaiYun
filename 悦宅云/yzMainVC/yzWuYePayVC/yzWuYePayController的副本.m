//
//  yzWuYePayController.m
//  悦宅云
//
//  Created by 尚广杰 on 2019/4/26.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import "yzWuYePayController.h"
#import "yzPayMoneyCell.h"
#import "yzJiaoFeiCell.h"
#import "yzPaySuccessController.h"
#import "CommonCrypto/CommonDigest.h"
#import "yzJiaoFeiOrderController.h"
@interface yzWuYePayController ()<UITableViewDelegate,UITableViewDataSource,PGDatePickerDelegate>{
    PGDatePickManager *datePickManager;
}
@property(nonatomic,strong)UIView* orangeView;     //橙色背景
@property(nonatomic,strong)UIView* roundView1;     //物业圆背景
@property(nonatomic,strong)UIView* roundView2;     //车位圆背景
@property(nonatomic,strong)UILabel* wuLabel;       //物业费
@property(nonatomic,strong)UILabel* cheLabel;      //车位费
@property(nonatomic,strong)UILabel* dayLab1;       //物业天数
@property(nonatomic,strong)UILabel* dayLab2;       //车位天数

@property(nonatomic,strong)UILabel* time1;         //剩余时间
@property(nonatomic,strong)UILabel* time2;

@property(nonatomic,strong)UIImageView* locationImg; //定位图标
@property(nonatomic,strong)UILabel* quLabel;       //小区

@property(nonatomic,strong)UIView* centerView;      //
@property(nonatomic,strong)UIButton* payBtn;        //代缴费用
@property(nonatomic,strong)UIButton* recordBtn;     //缴费记录


@property(nonatomic,strong)NSString* type;          //0  代缴费用   1  缴费记录

@property(nonatomic,strong)UIView* bottomView;      //底部视图
@property(nonatomic,strong)UILabel* priceLabel;     //总价
@property(nonatomic,strong)UIButton* submitBtn;     //立即缴费

@property(nonatomic,strong)UIView* zhiView;         //支付方式

@property(nonatomic,strong)UITableView* tableView1;
@property(nonatomic,strong)UITableView* tableView2;
@property(nonatomic,strong)NSMutableArray* wuYeArr;
@property(nonatomic,strong)NSMutableArray* recoderArr;
@property(nonatomic,assign)NSIndexPath* lastSeleteIndex;  //单选标记

@property (nonatomic, strong) NSString* price;                       //实缴费用
@property (nonatomic, strong) NSString* orderNum;                    //订单号

@property(nonatomic,strong)NSDate* beginDate;
@property(nonatomic,strong)NSDate* endDate;

@property(nonatomic,strong)UIButton* seleTimeBtn;     //选择时间

@property(nonatomic,strong)UIButton* zhiBtn;          //支付方式按钮
@property(nonatomic,strong)UIButton* WXBtn;
@property(nonatomic,strong)NSMutableArray* finalArray;
@end

@implementation yzWuYePayController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:RGB(240, 240, 240)];
    
    self.finalArray = [NSMutableArray array];
    
         [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appliSuccess:) name:@"AlipaySDKYDD" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(WXChatSuccess:) name:@"ORDER_PAY_SUCCESSNOTIFICATION" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(WXChatCancel:) name:@"ORDER_PAY_CANCEL" object:nil];
    self.beginDate = [NSDate date];
    
    self.lastSeleteIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    [self CreateHeadView];
    
    [self CreateBottomView];
    [self getPublicData];
    
    NSLog(@"roomId==%@",self.roomId);
    
    
    //时间
    datePickManager = [[PGDatePickManager alloc]init];
    datePickManager.isShadeBackgroud = true;
    datePickManager.style = PGDatePickManagerStyle3;
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.datePickerType = PGPickerViewType1;
    datePicker.isHiddenMiddleText = false;
    datePicker.datePickerMode = PGDatePickerModeDate;
}
-(void)getPublicData{
    //创建信号量
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(2);
    // 创建全局并行
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //任务 获取产品详细信息
    dispatch_async(quene, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        [self getWuYePayData];
        [self getAllCheList];
        dispatch_semaphore_signal(semaphore);
    });
    
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
    [backBtn setTitleColor:AppBackTitleColor forState:UIControlStateNormal];
    [backBtn setFrame:CGRectMake(0, 0, AutoWitdh(32), AutoWitdh(32))];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationController.visibleViewController.navigationItem setLeftBarButtonItem:backItem];
    //顶部信息
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setText:@"物业缴费"];
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
//头部视图
-(void)CreateHeadView{
    self.orangeView = [[UIView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, mDeviceWidth, mDeviceWidth/2)];
    [self.orangeView setBackgroundColor:RGB(255, 72, 23)];
    [self.view addSubview:self.orangeView];
    
    //圆圈1
    self.roundView1 = [[UIView alloc]initWithFrame:CGRectMake(mDeviceWidth/2 - mDeviceWidth/4 - 2, mDeviceWidth/4/2, mDeviceWidth/4, mDeviceWidth/4)];
    self.roundView1.layer.cornerRadius = mDeviceWidth/4/2;
    self.roundView1.layer.borderWidth = 1;
    self.roundView1.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.orangeView addSubview:self.roundView1];
    
    self.wuLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, self.roundView1.frame.size.width - 20, 15)];
    self.wuLabel.text = @"物业费";
    self.wuLabel.font = YSize(13.0);
    self.wuLabel.textAlignment = NSTextAlignmentCenter;
    self.wuLabel.textColor = [UIColor whiteColor];
    [self.roundView1 addSubview:self.wuLabel];
    
    self.dayLab1 = [[UILabel alloc]init];
    self.dayLab1.font = YSize(18.0);
    self.dayLab1.textAlignment = NSTextAlignmentCenter;
    CGRect rect = Rect(@"天", self.roundView1.frame.size.width, YSize(18.0));
    self.dayLab1.frame = CGRectMake(0, mDeviceWidth/4/2 - rect.size.height/2, mDeviceWidth/4, rect.size.height);
    self.dayLab1.text = @"0天";
    self.dayLab1.textColor = [UIColor whiteColor];
    [self.roundView1 addSubview:self.dayLab1];
    
    
    self.time1 = [[UILabel alloc]initWithFrame:CGRectMake(10, self.roundView1.frame.size.height - 28, self.roundView1.frame.size.width - 20, 15)];
    self.time1.text = @"剩余时间";
    self.time1.font = YSize(12.0);
    self.time1.textAlignment = NSTextAlignmentCenter;
    self.time1.textColor = [UIColor whiteColor];
    [self.roundView1 addSubview:self.time1];
    
    
    //圆圈2
    self.roundView2 = [[UIView alloc]initWithFrame:CGRectMake(mDeviceWidth/2 + 2, mDeviceWidth/4/2, mDeviceWidth/4, mDeviceWidth/4)];
    self.roundView2.layer.cornerRadius = mDeviceWidth/4/2;
    self.roundView2.layer.borderWidth = 1;
    self.roundView2.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.orangeView addSubview:self.roundView2];
    
    self.cheLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, self.roundView1.frame.size.width - 20, 15)];
    self.cheLabel.text = @"车位费";
    self.cheLabel.font = YSize(13.0);
    self.cheLabel.textAlignment = NSTextAlignmentCenter;
    self.cheLabel.textColor = [UIColor whiteColor];
    [self.roundView2 addSubview:self.cheLabel];
    
    self.dayLab2 = [[UILabel alloc]init];
    self.dayLab2.font = YSize(18.0);
    self.dayLab2.textAlignment = NSTextAlignmentCenter;
    self.dayLab2.frame = CGRectMake(0, mDeviceWidth/4/2 - rect.size.height/2, mDeviceWidth/4, rect.size.height);
    self.dayLab2.text = @"0天";
    self.dayLab2.textColor = [UIColor whiteColor];
    [self.roundView2 addSubview:self.dayLab2];
    
    
    self.time2 = [[UILabel alloc]initWithFrame:CGRectMake(10, self.roundView2.frame.size.height - 28, self.roundView2.frame.size.width - 20, 15)];
    self.time2.text = @"剩余时间";
    self.time2.font = YSize(12.0);
    self.time2.textAlignment = NSTextAlignmentCenter;
    self.time2.textColor = [UIColor whiteColor];
    [self.roundView2 addSubview:self.time2];
    
    
    //定位小区
 
    self.quLabel = [[UILabel alloc]init];
    self.quLabel.text = self.quStr;
    self.quLabel.font = YSize(12);
    self.quLabel.textColor = [UIColor whiteColor];
    CGRect rect1 = Rect(self.quLabel.text, mDeviceWidth - 20, YSize(12.0));
    self.quLabel.frame = CGRectMake(mDeviceWidth/2 - rect1.size.width/2 + rect1.size.height/2, CGRectGetMaxY(self.roundView1.frame) + 5, rect1.size.width, rect1.size.height);
    [self.orangeView addSubview:self.quLabel];
    
    self.locationImg = [[UIImageView alloc]initWithFrame:CGRectMake(mDeviceWidth/2 - rect1.size.width/2 - rect1.size.height/2, CGRectGetMaxY(self.roundView1.frame) + 5, rect1.size.height, rect1.size.height)];
    self.locationImg.image = [UIImage imageNamed:@"whitelocation"];
    
    [self.orangeView addSubview:self.locationImg];
    
    self.type = @"0";
    
    self.centerView = [[UIView alloc]initWithFrame:CGRectMake(20, mDeviceWidth/2 - 20, mDeviceWidth - 40, 40)];
    self.centerView.layer.cornerRadius = 20;
    [self.centerView setBackgroundColor:[UIColor whiteColor]];
    [self.orangeView addSubview:self.centerView];
    
    
    self.payBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, self.centerView.frame.size.width/2 - 20  - 0.5, 40)];
    [self.payBtn setTitle:@" 代缴费用" forState:UIControlStateNormal];
    self.payBtn.titleLabel.font = YSize(14.0);
    [self.payBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.payBtn setImage:[UIImage imageNamed:@"缴费2"] forState:UIControlStateNormal];
    [self.payBtn addTarget:self action:@selector(payBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.centerView addSubview:self.payBtn];
    
    
    UILabel* line = [[UILabel alloc]initWithFrame:CGRectMake(self.centerView.frame.size.width/2 - 0.5, 13, 1, 14)];
    [line setBackgroundColor:[UIColor lightGrayColor]];
    [self.centerView addSubview:line];
    
    self.recordBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.centerView.frame.size.width/2 + 0.5, 0, self.centerView.frame.size.width/2 - 20 - 0.5, 40)];
    [self.recordBtn setTitle:@" 缴费记录" forState:UIControlStateNormal];
    self.recordBtn.titleLabel.font = YSize(14.0);
    [self.recordBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.recordBtn setImage:[UIImage imageNamed:@"历史记录"] forState:UIControlStateNormal];
    [self.recordBtn addTarget:self action:@selector(recordBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.centerView addSubview:self.recordBtn];
}
//底部视图
-(void)CreateBottomView{
    
    self.tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.orangeView.frame) + 35, mDeviceWidth - 30, mDeviceHeight - kNavBarHeight - KSAFEBAR_HEIGHT - self.orangeView.frame.size.height - 100 - 60 - 40) style:UITableViewStyleGrouped];
    self.tableView1.backgroundColor = [UIColor whiteColor];
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
 
    self.tableView1.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView1.separatorInset = UIEdgeInsetsZero;
    self.tableView1.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:self.tableView1];
    

    self.seleTimeBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.orangeView.frame) + 35, mDeviceWidth - 30, 30) ];
    [self.seleTimeBtn setBackgroundColor:[UIColor whiteColor]];
    [self.seleTimeBtn setTitle:@"  选择时间" forState:UIControlStateNormal];
    self.seleTimeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.seleTimeBtn.titleLabel.font = YSize(13.0);
    [self.seleTimeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.seleTimeBtn addTarget:self action:@selector(seleTimeBtn:)
               forControlEvents:UIControlEventTouchUpInside];
    self.seleTimeBtn.hidden = YES;
    [self.view addSubview:self.seleTimeBtn];
    
    self.tableView2 = [[UITableView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.seleTimeBtn.frame), mDeviceWidth - 30, mDeviceHeight - kNavBarHeight - 30 - KSAFEBAR_HEIGHT - self.orangeView.frame.size.height - 50) style:UITableViewStyleGrouped];
    self.tableView2.backgroundColor = [UIColor whiteColor];
    self.tableView2.delegate = self;
    self.tableView2.dataSource = self;
    self.tableView2.hidden = YES;
//    self.tableView2.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView2.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:self.tableView2];

    
    //解决滑动视图顶部空出状态栏高度的问题
    if (@available(iOS 11.0, *)) {
        self.tableView1.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        //            _tableV.estimatedRowHeight = 0;
        self.tableView1.estimatedSectionHeaderHeight = 0;
        self.tableView1.estimatedSectionFooterHeight = 0;
        self.tableView2.estimatedSectionHeaderHeight = 0;
        self.tableView2.estimatedSectionFooterHeight = 0;
        
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
    
    self.zhiView = [[UIView alloc]initWithFrame:CGRectMake(15, mDeviceHeight - KSAFEBAR_HEIGHT - 50 - 75 - 40, mDeviceWidth - 30, 60 + 40)];
    self.zhiView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.zhiView];
    
    UILabel* type = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 200, 18)];
    type.text = @"选择支付方式";
    type.textColor = [UIColor blackColor];
    type.font = YSize(15.0);
    type.textAlignment = NSTextAlignmentLeft;
    
    [self.zhiView addSubview:type];
    
    UIImageView* zhifubao = [[UIImageView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(type.frame) + 3, 30, 30)];
    zhifubao.image = [UIImage imageNamed:@"yz_pay_alipay"];
    [self.zhiView addSubview:zhifubao];
    
    UILabel* lable1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(zhifubao.frame) + 10, zhifubao.frame.origin.y, 200, 15)];
    lable1.text = @"支付宝支付";
    lable1.textAlignment = NSTextAlignmentLeft;
    lable1.font = YSize(12.0);
    [self.zhiView addSubview:lable1];
    
    UILabel* lable2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(zhifubao.frame) + 10, CGRectGetMaxY(lable1.frame), 200, 15)];
    lable2.text = @"推荐支付宝用户使用";
    lable2.textAlignment = NSTextAlignmentLeft;
    lable2.textColor = [UIColor lightGrayColor];
    lable2.font = YSize(12.0);
    [self.zhiView addSubview:lable2];
    
    self.zhiBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.zhiView.frame.size.width - 30, CGRectGetMaxY(type.frame) + 10.5, 20, 20)];
 
    [self.zhiBtn setBackgroundImage:[UIImage imageNamed:@"right"] forState:UIControlStateSelected];
    [self.zhiBtn setBackgroundImage:[UIImage imageNamed:@"right_nor"] forState:UIControlStateNormal];
    self.zhiBtn.selected = YES;
    [self.zhiBtn addTarget:self action:@selector(seleZhi:) forControlEvents:UIControlEventTouchUpInside];
    [self.zhiView addSubview:self.zhiBtn];
    
    
    
    UIImageView* weixin = [[UIImageView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(zhifubao.frame) + 5, 30, 30)];
    weixin.image = [UIImage imageNamed:@"yz_pay_wechat"];
    [self.zhiView addSubview:weixin];
    
    UILabel* lable3 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(weixin.frame) + 10, weixin.frame.origin.y, 200, 15)];
    lable3.text = @"微信支付";
    lable3.textAlignment = NSTextAlignmentLeft;
    lable3.font = YSize(12.0);
    [self.zhiView addSubview:lable3];
    
    UILabel* lable4 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(weixin.frame) + 10, CGRectGetMaxY(lable3.frame), 200, 15)];
    lable4.text = @"微信用户可支付";
    lable4.textAlignment = NSTextAlignmentLeft;
    lable4.textColor = [UIColor lightGrayColor];
    lable4.font = YSize(12.0);
    [self.zhiView addSubview:lable4];
    
    self.WXBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.zhiView.frame.size.width - 30, weixin.frame.origin.y + 6, 20, 20)];
    [self.WXBtn setBackgroundImage:[UIImage imageNamed:@"right"] forState:UIControlStateSelected];
    [self.WXBtn setBackgroundImage:[UIImage imageNamed:@"right_nor"] forState:UIControlStateNormal];
    [self.WXBtn addTarget:self action:@selector(seleWX:) forControlEvents:UIControlEventTouchUpInside];
    [self.zhiView addSubview:self.WXBtn];
    
    
    
    
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, mDeviceHeight - 50 - KSAFEBAR_HEIGHT, mDeviceWidth, 50)];
    [self.bottomView setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.bottomView];
    
    self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 120, 50)];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"共计:￥"];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3,str.length - 3)];
    _priceLabel.attributedText = str;
    self.priceLabel.font = YSize(14.0);
    self.priceLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.bottomView addSubview:self.priceLabel];
    
    
    self.submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(mDeviceWidth - 85, 10, 70, 30)];
    [self.submitBtn setTitle:@"立即缴费" forState:UIControlStateNormal];
    [self.submitBtn setBackgroundColor:RGB(255, 72, 23)];
    [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.submitBtn.titleLabel.font = YSize(13.0);
    [self.submitBtn addTarget:self action:@selector(submitBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.submitBtn];
}
#pragma mark -- 选择s支付方式
-(void)seleZhi:(UIButton*)sender{
    if (!self.zhiBtn.isSelected) {
        self.zhiBtn.selected = YES;
        self.WXBtn.selected = NO;
    }
}
-(void)seleWX:(UIButton*)sender{
    if (!self.WXBtn.isSelected) {
        self.zhiBtn.selected = NO;
        self.WXBtn.selected = YES;
    }
}

#pragma mark -- 按钮事件
-(void)payBtn:(UIButton*)sender{
    [self.payBtn setImage:[UIImage imageNamed:@"缴费2"] forState:UIControlStateNormal];
    [self.recordBtn setImage:[UIImage imageNamed:@"历史记录"] forState:UIControlStateNormal];
    if (![self.type isEqualToString:@"0"]) {
        self.type = @"0";
        self.tableView2.hidden = YES;
        self.seleTimeBtn.hidden = YES;
        self.bottomView.hidden = NO;
        self.tableView1.hidden = NO;
        self.zhiView.hidden = NO;
    }
    
}

-(void)recordBtn:(UIButton*)sender{
    [self.payBtn setImage:[UIImage imageNamed:@"缴费2灰色"] forState:UIControlStateNormal];
    [self.recordBtn setImage:[UIImage imageNamed:@"历史记录橙"] forState:UIControlStateNormal];
    
    if (![self.type isEqualToString:@"1"]) {
        self.type = @"1";
        self.tableView2.hidden = NO;
        self.seleTimeBtn.hidden = NO;
        self.bottomView.hidden = YES;;
        self.tableView1.hidden = YES;
        self.zhiView.hidden = YES;
    }
}
-(void)submitBtn:(UIButton*)sender{
    [DDProgressHUD show];
    NSDictionary* dic;
    if (self.finalArray.count>0) {
        dic = self.finalArray[self.lastSeleteIndex.section];
       
    }else{
        return;
    }
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"XiaoQuModel"];
    yzXiaoQuModel* quModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/paymanage/generateWuYeOrder",postUrl] version:Token parameters:@{@"xiaoQuId":quModel.xiaoqu_id,@"appUserId":[yzUserInfoModel getLoginUserInfo:@"userId"],@"contentId":[dic objectForKey:@"roomId"],@"payItemId":[dic objectForKey:@"itemId"],@"shiJiao":_price,@"danYuanId":[dic objectForKey:@"danYuanId"]} success:^(id object) {
        [DDProgressHUD dismiss];
        NSDictionary *json = object;
        
        if ([[json objectForKey:@"code"] intValue] == 200) {
            self.orderNum = json[@"data"];
            [self getOrderContent:json[@"data"]];
            
            
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
-(void)getOrderContent:(NSString*)data{
    
    if (self.zhiBtn.selected==YES) {
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

//选择时间
-(void)seleTimeBtn:(UIButton*)sender{
    [self presentViewController:datePickManager animated:false completion:nil];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView==self.tableView1) {
        return self.finalArray.count;
    }else
        return self.recoderArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

        return 1;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.tableView1) {
        static NSString* identifire = @"cell";
        yzPayMoneyCell* cell = [tableView dequeueReusableCellWithIdentifier:identifire];
        if (!cell) {
            cell = [[yzPayMoneyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifire];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.finalArray.count>0) {
            
           cell.layer.shadowColor = [UIColor blackColor].CGColor;
            // 阴影偏移，默认(0, -3)
            cell.layer.shadowOffset = CGSizeMake(0,0);
            // 阴影透明度，默认0
            cell.layer.shadowOpacity = 0.3;
            // 阴影半径，默认3
            cell.layer.shadowRadius = 3;
            
            
            if ([_lastSeleteIndex isEqual:indexPath]) {
                cell.seleImage.image = [UIImage imageNamed:@"right"];
            }else{
                cell.seleImage.image = [UIImage imageNamed:@"right_nor"];
            }
            
            NSDictionary* dic = self.finalArray[self.lastSeleteIndex.section];
            [cell getWuYeMessageByDic:self.finalArray[indexPath.section]];
            
            _price = [NSString stringWithFormat:@"%0.2f",[[dic objectForKey:@"price"] floatValue]/100];
            
            NSString* price = [NSString stringWithFormat:@"总计:￥%@",_price];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:price];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3,str.length - 3)];
            _priceLabel.attributedText = str;
        }
        
        return cell;
    }else{
        static NSString* identifire = @"Cell";
        yzJiaoFeiCell* cell = [tableView dequeueReusableCellWithIdentifier:identifire];
        if (!cell) {
            cell = [[yzJiaoFeiCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifire];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.recoderArr.count>0) {
            [cell getMessageByDic:self.recoderArr[indexPath.row]];
        }
        return cell;
    }
    
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.tableView1) {
        yzPayMoneyCell * lastSelectCell = [tableView cellForRowAtIndexPath: _lastSeleteIndex];
        if (lastSelectCell != nil) {
            lastSelectCell.seleImage.image = [UIImage imageNamed:@"right_nor"];
            
        }
        yzPayMoneyCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.seleImage.image = [UIImage imageNamed:@"right"];
        _lastSeleteIndex = indexPath;
        
        NSDictionary* dic = [[NSDictionary alloc]init];
        
        
        dic = self.finalArray[indexPath.section];
    
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        NSDate *datestr = [dateFormatter dateFromString:[dic objectForKey:@"activeTime"]];
        
//        self.dayLab1.text = [NSString stringWithFormat:@"%ld天",(long)[self calcDaysFromBegin:self.beginDate end:datestr]];
        
        
        
        _lastSeleteIndex = indexPath;
        _price = [NSString stringWithFormat:@"%0.2f",[[dic objectForKey:@"price"] floatValue]/100];
        NSString* price = [NSString stringWithFormat:@"总计:￥%@",_price];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:price];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3,str.length - 3)];
        _priceLabel.attributedText = str;
        
        [self.tableView1 reloadData];
        
    }else{
        yzJiaoFeiOrderController* vc = [[yzJiaoFeiOrderController alloc]init];
        NSString* orderNo = [NSString stringWithFormat:@"%@",[self.recoderArr[indexPath.row] objectForKey:@"orderId"]];
        vc.orderNo = orderNo;
        vc.successJiaoFeiBlock = ^(NSString * _Nonnull payState) {
            NSDictionary *item = [self.recoderArr objectAtIndex:indexPath.row];
            NSMutableDictionary *mutableItem = [NSMutableDictionary dictionaryWithDictionary:item];
            [mutableItem setObject:payState forKey:@"payStatus"];
            [self.recoderArr setObject:mutableItem atIndexedSubscript:indexPath.row];
            
            [self.tableView2.mj_header beginRefreshing];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.tableView1) {
        return 75;
    }
    return 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView==self.tableView1) {
       
        return 10;
    }else
        return 0.000001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
  
    return 0.0001;
}

/** 获取业主房屋信息 */
-(void)getWuYePayData{
    [DDProgressHUD show];
    //获取小区数据
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"XiaoQuModel"];
    yzXiaoQuModel* quModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [CCAFNetWork get:[NSString stringWithFormat:@"%@app/paymanage/getMainRoom",postUrl] version:Token parameters:@{@"xiaoQuId":quModel.xiaoqu_id,@"userId":[yzUserInfoModel getLoginUserInfo:@"userId"]} success:^(id object) {
        [DDProgressHUD dismiss];
        NSDictionary *json = object;
        
        if ([[json objectForKey:@"code"] intValue] == 200) {
            NSArray* arr = [[json objectForKey:@"data"] JSONValue];
            NSLog(@"%lu",(unsigned long)arr.count);
            if (arr.count>0) {
                NSDictionary* dic = arr[0];
                NSString* roomid = [dic objectForKey:@"roomId"];
                for (NSDictionary* dic in arr) {
                    if ([[dic objectForKey:@"roomId"] isEqualToString:self.roomId]) {
                       [self getRoomPayMealById:roomid];
                    }
                }
            }else{
                [DDProgressHUD showErrorImageWithInfo:@"无数据"];
            }

        }else if ([[json objectForKey:@"code"] intValue] == -6){
            [DDProgressHUD dismiss];
            [yzUserInfoModel userLoginOut];
            [yzUserInfoModel setLoginState:NO];
            [self.navigationController popToRootViewControllerAnimated:YES];
     
        }else{
            [DDProgressHUD showErrorImageWithInfo:[json objectForKey:@"message"]];
        }
        [self.tableView1 reloadData];
    } failure:^(NSError *error) {
        [DDProgressHUD showErrorImageWithInfo:error.localizedDescription];
    }];
    
    
}

/** 获取房屋缴费套餐 */
-(void)getRoomPayMealById:(NSString *)roomId{
    
    self.wuYeArr = [NSMutableArray array];

    [CCAFNetWork get:[NSString stringWithFormat:@"%@app/paymanage/getPayItem",postUrl] version:Token parameters:@{@"roomId":roomId} success:^(id object) {
        [DDProgressHUD dismiss];
        NSDictionary *json = object;
        
        if ([[json objectForKey:@"code"] intValue] == 200) {
            self.wuYeArr = [[json objectForKey:@"data"] JSONValue];
            NSDictionary* dic = self.wuYeArr[0];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"YYYY-MM-dd"];
            NSDate *datestr = [dateFormatter dateFromString:[dic objectForKey:@"activeTime"]];
            self.dayLab1.text = [NSString stringWithFormat:@"%ld天",(long)[self calcDaysFromBegin:self.beginDate end:datestr]];
            
            [self.finalArray addObjectsFromArray:self.wuYeArr];
            
        }else if ([[json objectForKey:@"code"] intValue] == -6){
            [DDProgressHUD dismiss];
            [yzUserInfoModel userLoginOut];
            [yzUserInfoModel setLoginState:NO];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
            
        }else{
            [DDProgressHUD showErrorImageWithInfo:[json objectForKey:@"message"]];
        }
        [self.tableView1 reloadData];
    } failure:^(NSError *error) {
        [DDProgressHUD showErrorImageWithInfo:error.localizedDescription];
    }];
}

//获取车位信息
-(void)getAllCheList
{
    //获取小区数据
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"XiaoQuModel"];
    yzXiaoQuModel* quModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [CCAFNetWork get:[NSString stringWithFormat:@"%@app/paymanage/getAllChewei",postUrl] version:Token parameters:@{@"userId":[yzUserInfoModel getLoginUserInfo:@"userId"],@"xiaoQuId":quModel.xiaoqu_id} success:^(id object) {
        [DDProgressHUD dismiss];
        NSDictionary *json = object;
      
        if ([[json objectForKey:@"code"] intValue] == 200) {
            NSString* roomId;
            NSArray* arr = [[json objectForKey:@"data"] JSONValue];
            
         
            
            if (arr.count>0) {
                roomId = [arr[0] objectForKey:@"roomId"];
                [self getCarMealByRoomId:roomId];
            }
            
        }else if ([[json objectForKey:@"code"] intValue] == -6){
            [DDProgressHUD dismiss];
            [yzUserInfoModel userLoginOut];
            [yzUserInfoModel setLoginState:NO];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
            
        }else{
            [DDProgressHUD showErrorImageWithInfo:[json objectForKey:@"message"]];
        }
        [self.tableView1 reloadData];
    } failure:^(NSError *error) {
        [DDProgressHUD showErrorImageWithInfo:error.localizedDescription];
    }];
    
}
/***  车辆缴费信息  **/
-(void)getCarMealByRoomId:(NSString* )roomId{
    
    [CCAFNetWork get:[NSString stringWithFormat:@"%@app/paymanage/getCheWeiPayItem",postUrl] version:Token parameters:@{@"cheWeiId":roomId} success:^(id object) {
        [DDProgressHUD dismiss];
        NSDictionary *json = object;
        NSLog(@"---%@",object);
        if ([[json objectForKey:@"code"] intValue] == 200) {
            NSMutableArray* cheMealArr = [[json objectForKey:@"data"] JSONValue];
            NSDictionary* dic = cheMealArr[0];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"YYYY-MM-dd"];
            NSDate *datestr = [dateFormatter dateFromString:[dic objectForKey:@"activeTime"]];
            self.dayLab2.text = [NSString stringWithFormat:@"%ld天",(long)[self calcDaysFromBegin:self.beginDate end:datestr]];
            [self.finalArray addObjectsFromArray:cheMealArr];
        }else if ([[json objectForKey:@"code"] intValue] == -6){
            [DDProgressHUD dismiss];
            [yzUserInfoModel userLoginOut];
            [yzUserInfoModel setLoginState:NO];
            [self.navigationController popToRootViewControllerAnimated:YES];

        }else{
            [DDProgressHUD showErrorImageWithInfo:[json objectForKey:@"message"]];
        }
        [self.tableView1 reloadData];
    } failure:^(NSError *error) {
        [DDProgressHUD showErrorImageWithInfo:error.localizedDescription];
    }];
}

//获取服务订单数据
-(void)jiaofeiListDataByDate:(NSString*)date{
    [DDProgressHUD show];
    
    self.recoderArr = [NSMutableArray array];
    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/proorder/listJiaoFei",postUrl] version:Token parameters:@{@"appUserId":[yzUserInfoModel getLoginUserInfo:@"userId"],@"page":@"1",@"size":@"10",@"yearAndMonth":date} success:^(id object) {
        
        NSDictionary *json = object;
        
        
        
        if ([[json objectForKey:@"code"] intValue] == 200) {
            [DDProgressHUD dismiss];
            
            self.recoderArr = [[json objectForKey:@"data"] JSONValue];
            
            [self.tableView2 reloadData];
        }else if ([[json objectForKey:@"code"] intValue] == -6){
            [DDProgressHUD dismiss];
            [yzUserInfoModel userLoginOut];
            [yzUserInfoModel setLoginState:NO];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
        }else{
            [DDProgressHUD showErrorImageWithInfo:[json objectForKey:@"message"]];
        }
        [self.tableView2 reloadData];
    } failure:^(NSError *error) {
        [DDProgressHUD showErrorImageWithInfo:error.localizedDescription];
    }];
}
#pragma mark -- 计算天数
- (NSInteger) calcDaysFromBegin:(NSDate *)beginDate end:(NSDate *)endDate

{
    
    //创建日期格式化对象
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //取两个日期对象的时间间隔：
    //这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:typedef double NSTimeInterval;
    
    NSTimeInterval time=[endDate timeIntervalSinceDate:beginDate];

    int days=((int)time)/(3600*24);
    
    //int hours=((int)time)%(3600*24)/3600;
    
    //NSString *dateContent=[[NSString alloc] initWithFormat:@"%i天%i小时",days,hours];
    
    if (days<0) {
        days = 0;
    }
    
        return days;
    
}
#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSString* month;
    if (dateComponents.month<10) {
        month = [NSString stringWithFormat:@"0%ld",(long)dateComponents.month];
    }else{
        month = [NSString stringWithFormat:@"%ld",(long)dateComponents.month];
    }

    
    NSString *birthday = [NSString stringWithFormat:@"%ld-%@",(long)dateComponents.year,month];
    [self.seleTimeBtn setTitle:[NSString stringWithFormat:@"  %@",birthday] forState:UIControlStateNormal];
    
    [self jiaofeiListDataByDate:birthday];

}


#pragma mark -- 支付状态的通知
-(void)appliSuccess:(NSNotification *)notification{
    
    
    NSDictionary *dataDic = [NSDictionary dictionaryWithDictionary:notification.userInfo];
    NSString *result = [NSString stringWithFormat:@"%@",dataDic[@"resultStatus"]];
    
    yzPaySuccessController* successVC = [[yzPaySuccessController alloc]init];
    successVC.totalMoney = [_price floatValue];
    
    successVC.orderNo = self.orderNum;
    successVC.detailType = @"0";
    
    if ([result isEqualToString:@"9000"]) {
        [DDProgressHUD showSuccessImageWithInfo:[dataDic objectForKey:@"memo"]];
        //        if (self.cartViewRefreshBlock) {
        //            self.cartViewRefreshBlock();
        //        }
        
        successVC.type = @"1";
        
    }else if ([result isEqualToString:@"6001"]){
        
        successVC.type = @"0";
        
    }
    [self.navigationController pushViewController:successVC animated:YES];
}

//微信支付成功
-(void)WXChatSuccess:(NSNotification *)notification{

    
    yzPaySuccessController* successVC = [[yzPaySuccessController alloc]init];
    successVC.totalMoney = [_price floatValue];
    
    successVC.orderNo = self.orderNum;
    successVC.detailType = @"0";

        
        successVC.type = @"1";
        

    [self.navigationController pushViewController:successVC animated:YES];
}
-(void)WXChatCancel:(NSNotification *)notification{

    
    yzPaySuccessController* successVC = [[yzPaySuccessController alloc]init];
    successVC.totalMoney = [_price floatValue];
    
    successVC.orderNo = self.orderNum;
    successVC.detailType = @"0";
    successVC.type = @"0";
        
    
    [self.navigationController pushViewController:successVC animated:YES];
}
@end
