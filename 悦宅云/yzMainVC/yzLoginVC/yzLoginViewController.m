//
//  yzLoginViewController.m
//  yzProduct
//
//  Created by LiuHQ on 2018/9/20.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "yzLoginViewController.h"
#import "yzUserInfoModel.h"
#import "yzFuWuWebController.h"
#import "yzIndexViewController.h"
#import "yzNavViewController.h"
@interface yzLoginViewController ()<UITextFieldDelegate>
@property (nonatomic, strong)yzUserInfoModel *userInfoModel;
@property (nonatomic, assign)BOOL isSel;
@end

@implementation yzLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.backImage.userInteractionEnabled = YES;
    
    self.logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(mDeviceWidth/3, 80, mDeviceWidth/3, mDeviceWidth/3)];
    self.logoImage.image = [UIImage imageNamed:@"whiteLogo"];
    
    [self.backImage addSubview:self.logoImage];
    
    self.loginMobile.delegate = self;
     [self.loginMobile addTarget:self action:@selector(phoneNumberTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.loginCode.delegate = self;
    
    [self.loginBtn setBackgroundColor:RGB(255, 0, 10)];
    self.loginBtn.layer.cornerRadius = 17;
    self.loginBtn.layer.masksToBounds = YES;
    
    
    //协议

    NSString* str = @"我已阅读并同意服务条款";
    NSString *str1 = @"我已阅读并同意";
    
    NSString *str2 = @"服务条款";
     NSRange range2 = [str rangeOfString:str2];
    CGRect rect = Rect(str, mDeviceWidth, YSize(15.0));
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(mDeviceWidth/2 - rect.size.width/2 + 15, mDeviceHeight - KSAFEBAR_HEIGHT - rect.size.height - 20, rect.size.width + 20, rect.size.height + 10)];
    _textView.font = YSize(15.0);
    _textView.delegate = self;
    _textView.editable = NO;        //必须禁止输入，否则点击将弹出输入键盘_textView.scrollEnabled = NO;
    [_textView setBackgroundColor:[UIColor clearColor]];
    _textView.textColor = [UIColor blackColor];
    
    
      NSMutableAttributedString *mastring = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]}];
    
    [mastring addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:range2];
    
     NSString *valueString2 = [[NSString stringWithFormat:@"fuwutiaokuan://%@",str2] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    [mastring addAttribute:NSLinkAttributeName value:valueString2 range:range2];
 
    _textView.attributedText = mastring;
   
   

    [self.backImage addSubview:_textView];
    
    
    
    //选中
    self.seleBtn = [[UIButton alloc]initWithFrame:CGRectMake(mDeviceWidth/2 - rect.size.width/2 - 15, self.textView.frame.origin.y + 8, rect.size.height - 2, rect.size.height - 2)];
    [self.seleBtn setBackgroundImage:[UIImage imageNamed:@"right_nor"] forState:UIControlStateNormal];
    [self.seleBtn setBackgroundImage:[UIImage imageNamed:@"right"] forState:UIControlStateSelected];
    [self.seleBtn addTarget:self action:@selector(seleBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.backImage addSubview:self.seleBtn];
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    
        if ([[URL scheme] isEqualToString:@"fuwutiaokuan"]) {
        
        yzFuWuWebController* VC = [[yzFuWuWebController alloc]init];
        VC.webStr = @"http://app.yuezhaiyun.com/agreement/userAgreement.html";
        [self.navigationController pushViewController:VC animated:YES];
        
                return NO;
        
            }
    
        return YES;
    
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
-(void)seleBtn:(UIButton*)sender{
    sender.selected = !sender.selected;
    self.isSel = sender.selected;
}

-(void)backClick:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)getCodeClick:(id)sender {
    //获取验证码
    if (self.loginMobile.text.length == 0) {
        [DDProgressHUD showErrorImageWithInfo:@"请输入手机号"];
        return;
    }
    [DDProgressHUD showWithStatus:@"获取验证码"];
    [CCAFNetWork post:[NSString stringWithFormat:@"%@appuser/sendCode",postUrl] version:Token parameters:@{@"phone":self.loginMobile.text} success:^(id object) {
        
        NSDictionary *json = object;
        if ([[json objectForKey:@"code"] intValue] == 200) {
            [DDProgressHUD showSuccessImageWithInfo:[json objectForKey:@"message"]];
            [self getCodeTimer];
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

- (IBAction)loginClick:(id)sender {
    
    
    //登录
    if (self.loginMobile.text.length == 0) {
        [DDProgressHUD showErrorImageWithInfo:@"请输入手机号"];
        return;
    }
    if (self.loginCode.text.length == 0) {
        [DDProgressHUD showErrorImageWithInfo:@"请输入短信验证码"];
        return;
    }
    if (!self.isSel) {
        [DDProgressHUD showErrorImageWithInfo:@"请阅读并同意协议"];
        return;
    }
    
    [DDProgressHUD showWithStatus:@"登录中"];
    [CCAFNetWork post:[NSString stringWithFormat:@"%@appuser/signIn",postUrl] version:Token parameters:@{@"phone":self.loginMobile.text,@"code":self.loginCode.text} success:^(id object) {
        
        NSDictionary *json = object;
        if ([[json objectForKey:@"code"] intValue] == 200) {
            
//            [self getQuList];
            
            [DDProgressHUD showSuccessImageWithInfo:[json objectForKey:@"message"]];
            NSDictionary *userDict = [json[@"data"] JSONValue];
            self.userInfoModel = [[yzUserInfoModel alloc] init:userDict];
            //存储小区数据
//            NSMutableArray *xiaoQuListArray = [userDict objectForKey:@"xiaoQuVoList"];
//            NSMutableArray *quListArray = [[NSMutableArray alloc] init];
//            for (int i = 0; i < xiaoQuListArray.count ; i ++) {
//                NSDictionary *quDict = [xiaoQuListArray objectAtIndex:i];
//                yzXiaoQuModel *quModel = [[yzXiaoQuModel alloc] init];
//                quModel.xiaoqu_id = [yzProductPubObject withStringReturn:quDict[@"id"]];
//                quModel.xiaoqu_name = [yzProductPubObject withStringReturn:quDict[@"name"]];
//                if (i == 0) {
//                    quModel.isSelected = YES;
//                }else{
//                    quModel.isSelected = NO;
//                }
//                [quListArray addObject:quModel];
//            }
//            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:quListArray] forKey:@"XiaoQuArray"];
            
    
            yzIndexViewController *indexVC = [[yzIndexViewController alloc]init];
            yzNavViewController *nav = [[yzNavViewController alloc] initWithRootViewController:indexVC];
            [UIApplication sharedApplication].keyWindow.rootViewController = nav;
            
            
            [yzUserInfoModel setLoginUserInfo:self.userInfoModel];
            
            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self dismissViewControllerAnimated:YES completion:^{
//                    if (self.loginSuccessBlock) {
//                        self.loginSuccessBlock();
//                    }
//                }];
//            });
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

- (IBAction)wechatClick:(id)sender {
}
-(void)getCodeTimer{
    __block NSInteger time = 59; //设置倒计时时间
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
    WEAKSELF
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [weakSelf.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                weakSelf.getCodeBtn.userInteractionEnabled = YES;
            });
            
        }else{
            
            NSInteger seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [weakSelf.getCodeBtn setTitle:[NSString stringWithFormat:@"重新发送(%.2ld)", (long)seconds] forState:UIControlStateNormal];
                weakSelf.getCodeBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

@end
