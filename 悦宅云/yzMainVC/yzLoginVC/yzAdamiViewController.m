//
//  yzAdamiViewController.m
//  悦宅云
//
//  Created by 尚广杰 on 2019/10/30.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import "yzAdamiViewController.h"
#import "yzOnePassController.h"
#import "yzQuListViewController.h"
@interface yzAdamiViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)UIImageView* backImage;
@property(nonatomic,strong)UIImageView* logoImage;
//账号
@property(nonatomic,strong)UILabel* accountLabel;
@property(nonatomic,strong)UITextField* accountTextField;
@property(nonatomic,strong)UILabel* line1;

//密码
@property(nonatomic,strong)UILabel* passwordLabel;
@property(nonatomic,strong)UITextField* passwordTextField;
@property(nonatomic,strong)UILabel* line2;

//登录按钮
@property(nonatomic,strong)UIButton* loginBtn;

@property(nonatomic,strong)NSArray* quLists;
@end

@implementation yzAdamiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    loginBack
    
   
    
    [self setUI];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    [self setStatusBarBackgroundColor:RGBA(255, 255, 255, 0)];
    [self.navigationController.navigationBar setBackgroundColor:RGBA(255, 255, 255, 0)];
    
    //左侧返回
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
    [backBtn setBackgroundColor:[UIColor clearColor]];
    [backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setFrame:CGRectMake(0, 0, 27, 27)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationController.visibleViewController.navigationItem setLeftBarButtonItem:nil];
    
    [self.navigationController.visibleViewController.navigationItem setTitleView:nil];
    
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --- 设置UI
-(void)setUI{
    self.backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mDeviceWidth, mDeviceHeight)];
    self.backImage.image = [UIImage imageNamed:@"loginBack"];
    self.backImage.userInteractionEnabled = YES;
    [self.view addSubview:self.backImage];
    
    self.logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(mDeviceWidth/3, 80, mDeviceWidth/3, mDeviceWidth/3)];
    self.logoImage.image = [UIImage imageNamed:@"whiteLogo"];
    
    [self.backImage addSubview:self.logoImage];
    
    
    //账号
    self.accountLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, mDeviceHeight/2 - 80, 60, 30)];
    self.accountLabel.text = @"账  号:";
    self.accountLabel.font = YSize(15.0);
    self.accountLabel.textAlignment = NSTextAlignmentLeft;
    [self.backImage addSubview:self.accountLabel];
    
    self.accountTextField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.accountLabel.frame) + 10, self.accountLabel.frame.origin.y, mDeviceWidth - 120, 30)];
    self.accountTextField.delegate = self;
    self.accountTextField.placeholder = @"请输入账号";
    self.accountTextField.text = @"fuyuguangchangyiqi";
    [self.accountTextField setValue:YSize(14.0) forKeyPath:@"_placeholderLabel.font"];
    [self.backImage addSubview:self.accountTextField];
    
    self.line1 = [[UILabel alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(self.accountLabel.frame) + 10, mDeviceWidth - 50, 1)];
    [self.line1 setBackgroundColor:[UIColor colorWithRed:234/255.0 green:84/255.0 blue:19/255.0 alpha:1]];
    [self.backImage addSubview:self.line1];
    
    //密码
    self.passwordLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, mDeviceHeight/2 - 30, 60, 30)];
    self.passwordLabel.text = @"密  码:";
    self.passwordLabel.font = YSize(15.0);
    self.passwordLabel.textAlignment = NSTextAlignmentLeft;
    [self.backImage addSubview:self.passwordLabel];
    
    self.passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.passwordLabel.frame) + 10, self.passwordLabel.frame.origin.y, mDeviceWidth - 120, 30)];
    self.passwordTextField.delegate = self;
    self.passwordTextField.placeholder = @"请输入密码";
    self.passwordTextField.text = @"123456";
    [self.passwordTextField setValue:YSize(14.0) forKeyPath:@"_placeholderLabel.font"];
    [self.backImage addSubview:self.passwordTextField];
    
    
    self.line2 = [[UILabel alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(self.passwordLabel.frame) + 10, mDeviceWidth - 50, 1)];
    [self.line2 setBackgroundColor:[UIColor colorWithRed:234/255.0 green:84/255.0 blue:19/255.0 alpha:1]];
    [self.backImage addSubview:self.line2];
    
    self.loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(60, CGRectGetMaxY(self.line2.frame) + 30, mDeviceWidth - 120, 30)];
    [self.loginBtn setBackgroundColor:RGB(255, 0, 10)];
    [self.loginBtn setTitle:@"登    录" forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginBtn.titleLabel.font = YSize(15.0);
    self.loginBtn.layer.cornerRadius = 15.0;
    self.loginBtn.layer.masksToBounds = YES;
    [self.loginBtn addTarget:self action:@selector(loginBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.backImage addSubview:self.loginBtn];
    
}
#pragma mark- 手机号输入框的事件
- (void)phoneNumberTextFieldDidChange:(UITextField *)textField{
    
    
    if (textField.text.length > 11) {
        textField.text = [textField.text substringToIndex:11];
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
//登录
-(void)loginBtn:(UIButton*)sender{
    //登录
    if (self.accountTextField.text.length == 0) {
        [DDProgressHUD showErrorImageWithInfo:@"请输入账号"];
        return;
    }
//    else{
//        BOOL isTel = [CCAFNetWork validateContactNumber:self.accountTextField.text];
//        if (!isTel) {
//            [DDProgressHUD showErrorImageWithInfo:@"请输入正确手机号"];
//            return;
//        }
//    }
    if (self.passwordTextField.text.length == 0) {
        [DDProgressHUD showErrorImageWithInfo:@"请输入密码"];
        return;
    }

    NSString* str = [self getNowTimeTimestamp];
    NSLog(@"时间戳====%@",str);
    
    
    
    [DDProgressHUD showWithStatus:@"登录中"];
    [CCAFNetWork post:[NSString stringWithFormat:@"%@prouser/signInBack",postUrl] version:nil parameters:@{@"userName":self.accountTextField.text,@"passWord":self.passwordTextField.text} success:^(id object) {

        NSDictionary *json = object;
        if ([[json objectForKey:@"code"] intValue] == 200) {
            [DDProgressHUD dismiss];
            yzQuListViewController *listView = [[yzQuListViewController alloc] init];
            listView.dianTi = [[json objectForKey:@"data"] objectForKey:@"sysDiantiList"];
            listView.quLists = [[json objectForKey:@"data"] objectForKey:@"xiaoQuList"];
            NSString* curtime = [[json objectForKey:@"data"] objectForKey:@"currentTimeMillis"];
            
            NSDate *datenow = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
            //设置时区,这个对于时间的处理有时很重要
          
            [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"zh_CN"]];
            NSString *dateString = [formatter stringFromDate: datenow];
       
            NSDate *now = [formatter dateFromString:dateString];;//现在时间,你可以输出来看下是什么格式
            NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)([now timeIntervalSince1970]*1000)];
            
    
            
            
            NSInteger finalTime = [curtime integerValue] - [timeSp integerValue];
                    NSLog(@"==%ld",finalTime);
            listView.midTime = finalTime;
            listView.localityTime = str;
            listView.roleId = [[json objectForKey:@"data"] objectForKey:@"roleId"];
            [self.navigationController pushViewController:listView animated:YES];
            
        }else if ([[json objectForKey:@"code"] intValue] == -200){
            [DDProgressHUD dismiss];
            
            [DDProgressHUD showErrorImageWithInfo:[json objectForKey:@"message"]];
            
        }else{
            [DDProgressHUD showErrorImageWithInfo:[json objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [DDProgressHUD showErrorImageWithInfo:error.localizedDescription];
    }];
}

-(NSString *)getNowTimeTimestamp{
    
    NSDate  *dateValue = [NSDate date];
    NSTimeInterval second = [dateValue timeIntervalSince1970];
    long  long dTime = [[NSNumber numberWithDouble:second*1000] longLongValue];
    NSString   *msecond =  [NSString stringWithFormat:@"%llu",dTime];
 
    
  
    
    return msecond;
    
}
@end
