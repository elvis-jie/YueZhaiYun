//
//  addressAddViewController.m
//  yzProduct
//
//  Created by LiuHQ on 2018/9/25.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "addressAddViewController.h"
#import "STPickerArea.h"
#import "yzAddressModel.h"


@interface addressAddViewController ()<STPickerAreaDelegate>
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) NSString *province;//省
@property (nonatomic, strong) NSString *city;//市
@property (nonatomic, strong) NSString *area;//区
@property (nonatomic, strong) yzAddressModel *addressModel;
@end

@implementation addressAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.scrollContentHeight.constant = mDeviceHeight;
    self.contactDetail.delegate = self;
    self.contactName.delegate = self;
    self.contactMobile.delegate = self;
    [self.contactMobile addTarget:self action:@selector(phoneNumberTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    //textview的提示框
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 200, 20)];
    label.enabled = NO;
    label.text = @"请输入详细地址......";
    label.font =  [UIFont fontWithName:@"HYJinChangTiJ" size:15];
    label.textColor = [UIColor whiteColor];
    self.promptLabel = label;
    [self.contactDetail addSubview:label];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.listScrollivew addGestureRecognizer:tapGestureRecognizer];
    
    //如果address_id存在则为修改
    if ([self.address_id intValue] > 0) {
        [self getAddressInfo];
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
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  UITextView的代理方法
 */
-(void) textViewDidChange:(UITextView *)textView
{
    
    if (self.contactDetail.text.length == 0) {
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
#pragma mark- 手机号输入框的事件
- (void)phoneNumberTextFieldDidChange:(UITextField *)textField{
    
    
    if (textField.text.length > 11) {
        textField.text = [textField.text substringToIndex:11];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// 撤销第一相应
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.contactMobile resignFirstResponder];
    [self.contactName resignFirstResponder];
    [self.contactDetail resignFirstResponder];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)locationClick:(id)sender {
    STPickerArea *pickerArea = [[STPickerArea alloc]init];
    [pickerArea setDelegate:self];
    [pickerArea setContentMode:STPickerContentModeBottom];
    [pickerArea show];
}
- (void)pickerArea:(STPickerArea *)pickerArea province:(NSString *)province city:(NSString *)city area:(NSString *)area
{
    NSString *text = [NSString stringWithFormat:@"%@ %@ %@", province, city, area];
    self.province = province;
    self.city = city;
    self.area = area;
    [self.contactCountry setTitle:text forState:UIControlStateNormal];
}

- (IBAction)defaultBtn:(id)sender {
    self.isSelected = !self.isSelected;
    self.defaultBtn.selected = self.isSelected;
}

/**
 验证码手机号
 
 @param mobileNum 手机号
 @return YES 通过 NO 不通过
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

- (IBAction)saveClick:(id)sender {
    if (self.contactName.text.length == 0) {
        [DDProgressHUD showErrorImageWithInfo:@"请输入收货人"];
        return;
    }
    if (self.contactMobile.text.length == 0) {
        [DDProgressHUD showErrorImageWithInfo:@"请输入手机号"];
        return;
    }else{
        BOOL isTel = [self validateContactNumber:self.contactMobile.text];
        if (!isTel) {
            [DDProgressHUD showErrorImageWithInfo:@"请输入正确手机号"];
            return;
        }
        
    }
    if (self.contactCountry.titleLabel.text.length == 0) {
        [DDProgressHUD showErrorImageWithInfo:@"请输入省市区"];
        return;
    }
    if (self.contactDetail.text.length == 0) {
        [DDProgressHUD showErrorImageWithInfo:@"请输入详细地址"];
        return;
    }
    if ([self.address_id intValue] > 0) {
        //进行修改信息
        [DDProgressHUD show];
        [CCAFNetWork post:[NSString stringWithFormat:@"%@app/address/update",postUrl] version:Token parameters:@{@"id":self.address_id,@"userId":[yzUserInfoModel getLoginUserInfo:@"userId"],@"name":self.contactName.text,@"phone":self.contactMobile.text,@"country":self.province,@"city":self.city,@"qu":self.area,@"info":self.contactDetail.text,@"isDefault":[NSNumber numberWithBool:self.isSelected]} success:^(id object) {
            
            NSDictionary *json = object;
            if ([[json objectForKey:@"code"] intValue] == 200) {
                [DDProgressHUD showSuccessImageWithInfo:[json objectForKey:@"message"]];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (self.backRefreshDataBlock) {
                        self.backRefreshDataBlock();
                    }
                    [self.navigationController popViewControllerAnimated:YES];
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
        [DDProgressHUD show];
        [CCAFNetWork post:[NSString stringWithFormat:@"%@app/address/save",postUrl] version:Token parameters:@{@"userId":[yzUserInfoModel getLoginUserInfo:@"userId"],@"name":self.contactName.text,@"phone":self.contactMobile.text,@"country":self.province,@"city":self.city,@"qu":self.area,@"info":self.contactDetail.text,@"isDefault":[NSNumber numberWithBool:self.isSelected]} success:^(id object) {
            
            NSDictionary *json = object;
            if ([[json objectForKey:@"code"] intValue] == 200) {
                [DDProgressHUD showSuccessImageWithInfo:[json objectForKey:@"message"]];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (self.backRefreshDataBlock) {
                        self.backRefreshDataBlock();
                    }
                    [self.navigationController popViewControllerAnimated:YES];
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
/** 获取地址信息 */
-(void)getAddressInfo{
    [DDProgressHUD show];
    [CCAFNetWork get:[NSString stringWithFormat:@"%@app/address/getAddress",postUrl] version:Token parameters:@{@"id":self.address_id} success:^(id object) {
        
        NSDictionary *json = object;
        if ([[json objectForKey:@"code"] intValue] == 200) {
            [DDProgressHUD dismiss];
            NSDictionary *detail = [[json objectForKey:@"data"] JSONValue];
            self.addressModel = [[yzAddressModel alloc] init:detail];
            //设置数据
            self.contactName.text = self.addressModel.address_name;
            self.contactMobile.text = self.addressModel.address_mobile;
            self.contactDetail.text = self.addressModel.address_info;
            if (self.contactDetail.text.length == 0) {
                self.promptLabel.hidden = NO;
            }else
            {
                self.promptLabel.hidden = YES;
            }
            [self.contactCountry setTitle:[NSString stringWithFormat:@"%@ %@ %@",self.addressModel.provine,self.addressModel.city,self.addressModel.area] forState:UIControlStateNormal];
            self.defaultBtn.selected = self.addressModel.isDefault;
            self.isSelected = self.addressModel.isDefault;
            self.province = self.addressModel.provine;
            self.city = self.addressModel.city;
            self.area = self.addressModel.area;
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
