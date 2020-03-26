//
//  pxCookAddViewController.m
//  yzProduct
//
//  Created by LiuHQ on 2018/9/26.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "pxCookAddViewController.h"
#import "yzAddSuccessController.h"
@interface pxCookAddViewController ()<UITextFieldDelegate,UITextViewDelegate,PGDatePickerDelegate>{
    PGDatePickManager *datePickManager;
}
@property (nonatomic, strong) UILabel *promptLabel;
    @property(nonatomic,assign) NSInteger integer;
@end

@implementation pxCookAddViewController
-(yzPxCookInfoModel *)infoModel{
    if (!_infoModel) {
        _infoModel = [[yzPxCookInfoModel alloc] init];
    }
    return _infoModel;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.pxcookName setDelegate:self];
    [self.pxcookMobile setDelegate:self];

    [self.pxcookRemark setDelegate:self];
    
    [self.pxcookMobile addTarget:self action:@selector(phoneNumberTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    //textview的提示框
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 200, 20)];
    label.enabled = NO;
    label.text = @"请输入备注信息......";
    label.font =  YSize(15.0);
    label.textColor = [UIColor whiteColor];
    self.promptLabel = label;
    [self.pxcookRemark addSubview:label];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
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
    [titleLabel setText:self.infoModel.room_msg];
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
/**
 *  UITextView的代理方法
 */
-(void) textViewDidChange:(UITextView *)textView
{
    
    if (self.pxcookRemark.text.length == 0) {
        self.promptLabel.hidden = NO;
    }else
    {
        self.promptLabel.hidden = YES;
    }
}
// 详细地址的占位label
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];//按回车取消第一相应者
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// 撤销第一相应
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.pxcookName resignFirstResponder];
    [self.pxcookMobile resignFirstResponder];
    [self.pxcookRemark resignFirstResponder];
    
}
#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSLog(@"dateComponents = %@", dateComponents);
    
    NSString* month;
    NSString* day;
    
    if (dateComponents.month<10) {
        month = [NSString stringWithFormat:@"0%ld",(long)dateComponents.month];
    }else{
        month = [NSString stringWithFormat:@"%ld",(long)dateComponents.month];
    }
    
    if (dateComponents.day<10) {
        day = [NSString stringWithFormat:@"0%ld",(long)dateComponents.day];
    }else{
        day = [NSString stringWithFormat:@"%ld",(long)dateComponents.day];
    }
    
    NSString *birthday = [NSString stringWithFormat:@"%ld-%@-%@",(long)dateComponents.year,month,day];
    

    [self.pxcookTime setTitle:birthday forState:UIControlStateNormal];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (BOOL)validateContactNumber:(NSString *)mobileNum
{
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 16[6], 17[5, 6, 7, 8], 18[0-9], 170[0-9], 19[89]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705,198
     * 联通号段: 130,131,132,155,156,185,186,145,175,176,1709,166
     * 电信号段: 133,153,180,181,189,177,1700,199
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|6[6]|7[05-8]|8[0-9]|9[89])\\d{8}$";
    
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478]|9[8])\\d{8}$)|(^1705\\d{7}$)";
    
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|66|7[56]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    
    NSString *CT = @"(^1(33|53|77|8[019]|99)\\d{8}$)|(^1700\\d{7}$)";
    
    /**
     * 大陆地区固话及小灵通
     * 区号：010,020,021,022,023,024,025,027,028,029
     * 号码：七位或八位
     */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    // NSPredicate *regextestPHS = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    if(([regextestmobile evaluateWithObject:mobileNum] == YES)
       || ([regextestcm evaluateWithObject:mobileNum] == YES)
       || ([regextestct evaluateWithObject:mobileNum] == YES)
       || ([regextestcu evaluateWithObject:mobileNum] == YES)) {
        return YES;
    } else {
        return NO;
    }
}


- (IBAction)submitClick:(id)sender {
    
  
    
  
    if (self.pxcookName.text.length == 0) {
        [DDProgressHUD showErrorImageWithInfo:@"请输入姓名"];
        return;
    }
    if (self.pxcookMobile.text.length == 0) {
        [DDProgressHUD showErrorImageWithInfo:@"请输入手机号"];
        return;
    }else if ([self.pxcookMobile.text isEqualToString:[yzUserInfoModel getLoginUserInfo:@"mobile"]]){
        [DDProgressHUD showErrorImageWithInfo:@"不能添加自己为子钥匙"];
        return;
    }
    else{
        BOOL isTel = [self validateContactNumber:self.pxcookMobile.text];
        if (!isTel) {
            [DDProgressHUD showErrorImageWithInfo:@"请输入正确手机号"];
            return;
        }
    }
    if ([self.pxcookTime.titleLabel.text isEqualToString:@"请输入截止日期"]) {
        [DDProgressHUD showErrorImageWithInfo:@"请输入失效时间"];
        return;
    }
    self.integer = [BBUserData compareDate:self.pxcookTime.titleLabel.text withDate:self.finalTime];
    
    if (self.integer>=0) {
    [DDProgressHUD show];

    
    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/userRom/saveSub",postUrl] version:Token parameters:@{@"roomId":self.infoModel.room_id,@"xiaoQuId":self.infoModel.xiaoqu_id,@"name":self.pxcookName.text,@"phone":self.pxcookMobile.text,@"endTime":self.pxcookTime.titleLabel.text,@"remarks":self.pxcookRemark.text} success:^(id object) {
        
        NSDictionary *json = object;
        if ([[json objectForKey:@"code"] intValue] == 200) {
            [DDProgressHUD showSuccessImageWithInfo:[json objectForKey:@"message"]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                yzAddSuccessController* successVC = [[yzAddSuccessController alloc]init];
                successVC.timeStr = self.pxcookTime.titleLabel.text;
                successVC.telStr = self.pxcookMobile.text;
                successVC.quStr = self.infoModel.room_msg;
                [self.navigationController pushViewController:successVC animated:YES];
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
        [DDProgressHUD showErrorImageWithInfo:@"有效期限不能超过物业费到期日期"];
    }
    
}

- (IBAction)selectedTimeClick:(id)sender {
    [self keyboardHide:nil];
    [self presentViewController:datePickManager animated:false completion:nil];
}

#pragma mark- 手机号输入框的事件
- (void)phoneNumberTextFieldDidChange:(UITextField *)textField{
    
    
    if (textField.text.length > 11) {
        textField.text = [textField.text substringToIndex:11];
    }
    
}


@end
