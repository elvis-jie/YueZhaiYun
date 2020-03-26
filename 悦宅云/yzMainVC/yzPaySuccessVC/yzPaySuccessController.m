//
//  yzPaySuccessController.m
//  yzProduct
//
//  Created by 尚广杰 on 2019/2/22.
//  Copyright © 2019 CC. All rights reserved.
//

#import "yzPaySuccessController.h"
#import "yzOrderDetailController.h"     //商品详情
#import "yzJiaoFeiOrderController.h"    //缴费详情
@interface yzPaySuccessController ()
@property(nonatomic,strong)UIImageView* successImage;       //
@property(nonatomic,strong)UILabel* payType;                //支付方式
@property(nonatomic,strong)UILabel* payMoney;               //支付金额
@property(nonatomic,strong)UIButton* myOrderBtn;            //我的订单
@property(nonatomic,strong)UIButton* homoeBtn;              //返回首页

@property(nonatomic,strong)yzOrderDetailController* detailVC;
@property(nonatomic,strong)yzJiaoFeiOrderController* jiaoDetailVC;
@end

@implementation yzPaySuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setUI];
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
    if ([self.type isEqualToString:@"1"]) {
        [titleLabel setText:@"订单支付成功"];
    }else{
        [titleLabel setText:@"订单支付失败"];
    }
    
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
    if ([self.detailType isEqualToString:@"0"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
     UIViewController *detailController =self.navigationController.viewControllers[1];
    
     [self.navigationController popToViewController:detailController animated:YES];
    }
}
-(void)setUI{
    self.successImage = [[UIImageView alloc]initWithFrame:CGRectMake(70, 50 + 65, 60, 60/1.3)];
    if ([self.type isEqualToString:@"1"]) {
       self.successImage.image = [UIImage imageNamed:@"success"];
    }else{
        self.successImage.image = [UIImage imageNamed:@"fail"];
    }
    
    self.successImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.successImage];
    
    self.payType = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.successImage.frame) + 10, self.successImage.frame.origin.y, 200, 30/1.3)];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"支付方式：支付宝"];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,str.length - 5)];
    self.payType.attributedText = str;

    self.payType.textAlignment = NSTextAlignmentLeft;
    self.payType.font = [UIFont systemFontOfSize:15.0];
    [self.view addSubview:self.payType];
    
    
    
    self.payMoney = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.successImage.frame) + 10, CGRectGetMaxY(self.payType.frame), 200, 30/1.3)];
    
    NSMutableAttributedString *strMoney = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"支付金额：￥%.2f",self.totalMoney]];
    [strMoney addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,strMoney.length - 5)];
    self.payMoney.attributedText = strMoney;
    
    self.payMoney.textAlignment = NSTextAlignmentLeft;
    self.payMoney.font = [UIFont systemFontOfSize:15.0];
    [self.view addSubview:self.payMoney];
    
    
    self.myOrderBtn = [[UIButton alloc]initWithFrame:CGRectMake((mDeviceWidth - 200)/3, CGRectGetMaxY(self.successImage.frame) + 70, 100, 40)];
    [self.myOrderBtn setTitle:@"查看订单" forState:UIControlStateNormal];
    [self.myOrderBtn setBackgroundColor:[UIColor redColor]];
    self.myOrderBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    self.myOrderBtn.layer.cornerRadius = 5;
    self.myOrderBtn.layer.masksToBounds = YES;
    [self.myOrderBtn addTarget:self action:@selector(goList:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.myOrderBtn];
    
    self.homoeBtn = [[UIButton alloc]initWithFrame:CGRectMake((mDeviceWidth - 200)/3*2 + 100, CGRectGetMaxY(self.successImage.frame) + 70, 100, 40)];
    [self.homoeBtn setTitle:@"返回首页" forState:UIControlStateNormal];
    [self.homoeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.homoeBtn addTarget:self action:@selector(goHome:) forControlEvents:UIControlEventTouchUpInside];
    self.homoeBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    self.homoeBtn.layer.cornerRadius = 5;
    self.homoeBtn.layer.masksToBounds = YES;
    self.homoeBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.homoeBtn.layer.borderWidth = 0.5;
    [self.view addSubview:self.homoeBtn];
}
//我的订单
-(void)goList:(UIButton*)sender{
   
    if (self.centenType.length>0) {
        if ([self.centenType isEqualToString:@"detail"]) {
            NSInteger index = (NSInteger)[[self.navigationController viewControllers] indexOfObject:self];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index - 2)] animated:YES];
        }else{
            NSInteger index = (NSInteger)[[self.navigationController viewControllers] indexOfObject:self];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index - 1)] animated:YES];
        }
        
        
    }else{
    
    if ([self.detailType isEqualToString:@"1"]) {
        if (!_detailVC) {
            _detailVC = [[yzOrderDetailController alloc]init];
        }
        _detailVC.orderId = self.orderNo;
        
        [self.navigationController pushViewController:_detailVC animated:YES];
    }else{
    
        if (!_jiaoDetailVC) {
            _jiaoDetailVC = [[yzJiaoFeiOrderController alloc]init];
        }

        _jiaoDetailVC.orderNo = self.orderNo;

        [self.navigationController pushViewController:_jiaoDetailVC animated:YES];
    }

    }
}

//返回首页
-(void)goHome:(UIButton*)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
