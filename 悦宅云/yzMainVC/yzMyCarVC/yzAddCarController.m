//
//  yzAddCarController.m
//  yzProduct
//
//  Created by 尚广杰 on 2019/2/6.
//  Copyright © 2019 CC. All rights reserved.
//

#import "yzAddCarController.h"
#import "RZCarPlateNoTextField.h"
#import "RZCarPlateNoInputAlertView.h"
#import "JMDropMenu.h"
#import "GFCalendar.h"

@interface yzAddCarController ()<UITextFieldDelegate,UIScrollViewDelegate,JMDropMenuDelegate>
@property(nonatomic,strong)UIButton* addCarBtn;        //添加车辆按钮


@property(nonatomic,strong)NSArray* array;
@property(nonatomic,strong)NSArray* carType;           //车辆种类
@property(nonatomic,strong)NSArray* carKind;           //车辆类型
@property(nonatomic,strong)NSArray* carColor;          //车辆颜色

@property(nonatomic,strong)NSString* typeStr;          //id
@property(nonatomic,strong)NSString* kindStr;
@property(nonatomic,strong)NSString* colorStr;

@property(nonatomic,strong)UIView* backView;           //日期遮罩层

@property(nonatomic,strong)UISwitch* switchBtn;        //启用状态开关

@end

@implementation yzAddCarController
-(UIButton* )carbtn{
    if (!_addCarBtn) {
        _addCarBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, mDeviceHeight - 50 - KSAFEBAR_HEIGHT, mDeviceWidth, 50)];
        if ([self.type isEqualToString:@"1"]) {
        [_addCarBtn setTitle:@"添        加" forState:UIControlStateNormal];
        }else{
        [_addCarBtn setTitle:@"编        辑" forState:UIControlStateNormal];
        }
        
        [_addCarBtn setBackgroundColor:[UIColor colorWithRed:230/255.0 green:0.0 blue:0.0 alpha:1]];
        [_addCarBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        
        [_addCarBtn addTarget:self action:@selector(addCar:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.addCarBtn];
    }
    return self.addCarBtn;
}

-(UIScrollView*)scrollV{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, mDeviceWidth, mDeviceHeight - 50 - KSAFEBAR_HEIGHT - 64)];
        _scrollView.contentSize = CGSizeMake(mDeviceWidth, mDeviceHeight);
        _scrollView.delegate = self;
        [self.view addSubview:self.scrollView];
        [self createUI];
    }
    return self.scrollView;
}



//启用状态开关
-(void)switchBtn:(UISwitch*)sender{
    if (sender.isOn==YES) {
        self.typeTextField.enabled = YES;
        self.typeSortTextField.enabled = YES;
        self.cardTextField.enabled = YES;
        self.colorTextField.enabled = YES;
        self.timeTextField.enabled = YES;
        self.countTextField.enabled = YES;
        self.remarkTextField.enabled = YES;
    }else{
        self.typeTextField.enabled = NO;
        self.typeSortTextField.enabled = NO;
        self.cardTextField.enabled = NO;
        self.colorTextField.enabled = NO;
        self.timeTextField.enabled = NO;
        self.countTextField.enabled = NO;
        self.remarkTextField.enabled = NO;
    }
    
}
//添加车辆
-(void)addCar:(UIButton*)sender{
    [self addCar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    NSLog(@"%@",self.dic);
    
    self.carKind = @[@{@"id":@"11115",@"name":@"长期",@"value":@"1"},@{@"id":@"11116",@"name":@"临时",@"value":@"2"}];
    self.carType = @[@{@"id":@"11111",@"name":@"轿车",@"value":@"1"},@{@"id":@"11112",@"name":@"SUV",@"value":@"2"},@{@"id":@"11113",@"name":@"客车",@"value":@"3"},@{@"id":@"11114",@"name":@"货车",@"value":@"4"}];
    
    self.carColor = @[@{@"id":@"11117",@"name":@"黑色",@"value":@"1"},@{@"id":@"11118",@"name":@"白色",@"value":@"2"},@{@"id":@"11119",@"name":@"其它",@"value":@"3"}];
    [self scrollV];
    
    [self carbtn];
    
  
    
   
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
    [titleLabel setText:@"添加车辆"];
    }else{
        [titleLabel setText:@"编辑车辆"];
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
    [self.navigationController popViewControllerAnimated:YES];
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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.typeTextField resignFirstResponder];
     [self.typeSortTextField resignFirstResponder];
     [self.cardTextField resignFirstResponder];
     [self.colorTextField resignFirstResponder];
     [self.timeTextField resignFirstResponder];
     [self.countTextField resignFirstResponder];
     [self.remarkTextField resignFirstResponder];
    
}

-(NSString*)getCurrentTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *timeString = [formatter stringFromDate:[NSDate date]];
    
    return timeString;
}
//按钮添加车辆或编辑车辆
-(void)addCar{
    
    if ([self.type isEqualToString:@"1"]) {
        [self addCarNetWork];
    }else{
        [self editCarNewWork];
    }
    
}

//添加车辆
-(void)addCarNetWork{
    if (self.kindStr.length==0) {
        [DDProgressHUD showErrorImageWithInfo:@"请选择车辆类型"];
        return;
    }
    if (self.typeStr.length==0) {
        [DDProgressHUD showErrorImageWithInfo:@"请选择车辆种类"];
        return;
    }
  
    if (self.cardTextField.text.length==0) {
        [DDProgressHUD showErrorImageWithInfo:@"请输入车牌号"];
        return;
    }
    
    BOOL isCarNum = [CCAFNetWork isValidCarID:self.cardTextField.text];
    if (!isCarNum) {
        [DDProgressHUD showErrorImageWithInfo:@"请输入正确车牌号"];
        return;
    }
    if (self.colorStr.length==0) {
        [DDProgressHUD showErrorImageWithInfo:@"请选择颜色"];
        return;
    }
    
    
    
    [DDProgressHUD show];
    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/car/save",postUrl] version:Token parameters:@{@"carType":self.typeStr,@"storType":self.kindStr,@"color":self.colorStr,@"code":self.cardTextField.text,@"remarks":self.remarkTextField.text,@"times":self.countTextField.text,@"date":self.timeTextField.text,@"appUserId":[yzUserInfoModel getLoginUserInfo:@"userId"]} success:^(id object) {
        [DDProgressHUD dismiss];
        NSDictionary *json = object;
        
        if ([[json objectForKey:@"code"] intValue] == 200) {
            [DDProgressHUD showSuccessImageWithInfo:[json objectForKey:@"message"]];
            if (self.blockAddSuccess) {
                self.blockAddSuccess();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else if ([[json objectForKey:@"code"] intValue] == -6){
            [DDProgressHUD dismiss];
            [yzUserInfoModel userLoginOut];
            [yzUserInfoModel setLoginState:NO];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
            
        }else{
            [DDProgressHUD showErrorImageWithInfo:[json objectForKey:@"message"]];
        }
        
        
    } failure:^(NSError *error) {
        
    }];
}
//编辑车辆
-(void)editCarNewWork{
    BOOL isCarNum = [CCAFNetWork isValidCarID:self.cardTextField.text];
    if (!isCarNum) {
        [DDProgressHUD showErrorImageWithInfo:@"请输入正确车牌号"];
        return;
    }
    [DDProgressHUD show];

    
    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/car/update",postUrl] version:Token parameters:@{@"carType":self.typeStr,@"storType":self.kindStr,@"color":self.colorStr,@"code":self.cardTextField.text,@"remarks":self.remarkTextField.text,@"times":self.countTextField.text,@"date":self.timeTextField.text,@"appUserId":[yzUserInfoModel getLoginUserInfo:@"userId"],@"id":self.dic[@"id"]} success:^(id object) {
        [DDProgressHUD dismiss];
        NSDictionary *json = object;
        
        if ([[json objectForKey:@"code"] intValue] == 200) {
            [DDProgressHUD showSuccessImageWithInfo:[json objectForKey:@"message"]];
            if (self.blockEditSuccess) {
                self.blockEditSuccess();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else if ([[json objectForKey:@"code"] intValue] == -6){
            [DDProgressHUD dismiss];
            [yzUserInfoModel userLoginOut];
            [yzUserInfoModel setLoginState:NO];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
        }else{
            [DDProgressHUD showErrorImageWithInfo:[json objectForKey:@"message"]];
        }
        
        
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark 页面布局
-(void)createUI{
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 44)];
    lab.text = @"启用状态";
    lab.font = [UIFont systemFontOfSize:15.0];
    lab.textAlignment = NSTextAlignmentLeft;
    lab.hidden = [self.type isEqualToString:@"1"] ? YES : NO;
    [self.scrollView addSubview:lab];
    
    self.switchBtn = [[UISwitch alloc]initWithFrame:CGRectMake(mDeviceWidth - 64, 7.5, 49, 31)];
    self.switchBtn.on = YES;
    self.switchBtn.hidden = [self.type isEqualToString:@"1"] ? YES : NO;
    [self.switchBtn addTarget:self action:@selector(switchBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.switchBtn];
    

    UILabel* line0 = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(lab.frame), mDeviceWidth - 30, 1)];
    [line0 setBackgroundColor:[UIColor lightGrayColor]];
    line0.hidden = [self.type isEqualToString:@"1"] ? YES : NO;
    
    [self.scrollView addSubview:line0];
    
    //车辆类型
    self.typeSortLab = [[UILabel alloc]initWithFrame:CGRectMake(15, [self.type isEqualToString:@"1"] ? 0:45, 100, 44)];
    self.typeSortLab.text = @"车辆类型";
    self.typeSortLab.font = [UIFont systemFontOfSize:15.0];
    self.typeSortLab.textAlignment = NSTextAlignmentLeft;
    [self.scrollView addSubview:self.typeSortLab];
    
    self.typeSortTextField = [[UITextField alloc]initWithFrame:CGRectMake(mDeviceWidth - 135, self.typeSortLab.frame.origin.y, 120, 44)];
    self.typeSortTextField.delegate = self;
    self.typeSortTextField.tag = 100;
    self.typeSortTextField.font = [UIFont systemFontOfSize:15.0];
    self.typeSortTextField.textAlignment = NSTextAlignmentRight;
    self.typeSortTextField.returnKeyType = UIReturnKeyDefault;
    [self.typeSortTextField resignFirstResponder];
    
    if (self.dic) {
        NSDictionary* dic = [self.dic objectForKey:@"storType"];
        for (NSDictionary* kindDic in self.carKind) {
            if ([dic[@"value"] isEqualToString:kindDic[@"value"]]) {
                self.typeSortTextField.text = kindDic[@"name"];
                self.kindStr = kindDic[@"id"];
            }
        }
        
        
    }
    
    self.typeSortTextField.attributedPlaceholder = [self setPlaceholderByString:@"请输入车辆类型"];
    self.typeSortTextField.rightViewMode = UITextFieldViewModeAlways;
    [self.scrollView addSubview:self.typeSortTextField];
    
    UIView* typeView = [[UIView alloc]initWithFrame:self.typeSortTextField.bounds];
    [self.typeSortTextField addSubview:typeView];
    
    UITapGestureRecognizer* tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(typeTap)];
    [typeView addGestureRecognizer:tap1];
    
    UILabel* line1 = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.typeSortLab.frame), mDeviceWidth - 30, 1)];
    [line1 setBackgroundColor:[UIColor lightGrayColor]];
    [self.scrollView addSubview:line1];
    //车辆种类
    self.typeLab = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(line1.frame), 100, 44)];
    self.typeLab.text = @"车辆种类";
    self.typeLab.font = [UIFont systemFontOfSize:15.0];
    self.typeLab.textAlignment = NSTextAlignmentLeft;
    [self.scrollView addSubview:self.typeLab];
    
    self.typeTextField = [[UITextField alloc]initWithFrame:CGRectMake(mDeviceWidth - 135, CGRectGetMaxY(line1.frame), 120, 44)];
    self.typeTextField.delegate = self;
    self.typeTextField.tag = 101;
    self.typeTextField.font = [UIFont systemFontOfSize:15.0];
    self.typeTextField.textAlignment = NSTextAlignmentRight;
    self.typeTextField.returnKeyType = UIReturnKeyDone;
    
    if (self.dic) {
        NSDictionary* dic = [self.dic objectForKey:@"carType"];
        for (NSDictionary* typeDic in self.carType) {
            if ([dic[@"value"] isEqualToString:typeDic[@"value"]]) {
                self.typeTextField.text = typeDic[@"name"];
                self.typeStr = typeDic[@"id"];
            }
        }
        
    }
    
    self.typeTextField.attributedPlaceholder = [self setPlaceholderByString:@"请输入车辆种类"];
    self.typeTextField.rightViewMode = UITextFieldViewModeAlways;
    [self.scrollView addSubview:self.typeTextField];
    
    UIView* typeSortView = [[UIView alloc]initWithFrame:self.typeTextField.bounds];
    [self.typeTextField addSubview:typeSortView];
    
    UITapGestureRecognizer* tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(typeSortTap)];
    [typeSortView addGestureRecognizer:tap2];
    
    UILabel* line2 = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.typeLab.frame), mDeviceWidth - 30, 1)];
    [line2 setBackgroundColor:[UIColor lightGrayColor]];
    [self.scrollView addSubview:line2];
    //车牌号
    self.cardLab = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(line2.frame), 100, 44)];
    self.cardLab.text = @"车牌号";
    self.cardLab.font = [UIFont systemFontOfSize:15.0];
    self.cardLab.textAlignment = NSTextAlignmentLeft;
    [self.scrollView addSubview:self.cardLab];
    
    self.cardTextField = [[UITextField alloc]initWithFrame:CGRectMake(mDeviceWidth - 135, CGRectGetMaxY(line2.frame), 120, 44)];
    self.cardTextField.delegate = self;
    self.cardTextField.tag = 102;
    self.cardTextField.font = [UIFont systemFontOfSize:15.0];
    self.cardTextField.textAlignment = NSTextAlignmentRight;
    self.cardTextField.returnKeyType = UIReturnKeyDone;
    
    self.cardTextField.text = [self.dic objectForKey:@"code"];
    self.cardTextField.attributedPlaceholder = [self setPlaceholderByString:@"请输入车牌号"];
    self.cardTextField.rightViewMode = UITextFieldViewModeAlways;
    [self.scrollView addSubview:self.cardTextField];
    
    UIView* cardView = [[UIView alloc]initWithFrame:self.cardTextField.bounds];
    [self.cardTextField addSubview:cardView];
    
    UITapGestureRecognizer* tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cardTap)];
    [cardView addGestureRecognizer:tap3];
    
    UILabel* line3 = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.cardLab.frame), mDeviceWidth - 30, 1)];
    [line3 setBackgroundColor:[UIColor lightGrayColor]];
    [self.scrollView addSubview:line3];
    //颜色
    self.colorLab = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(line3.frame), 100, 44)];
    self.colorLab.text = @"颜色";
    self.colorLab.font = [UIFont systemFontOfSize:15.0];
    self.colorLab.textAlignment = NSTextAlignmentLeft;
    [self.scrollView addSubview:self.colorLab];
    
    self.colorTextField = [[UITextField alloc]initWithFrame:CGRectMake(mDeviceWidth - 135, CGRectGetMaxY(line3.frame), 120, 44)];
    self.colorTextField.delegate = self;
    self.colorTextField.tag = 103;
    self.colorTextField.font = [UIFont systemFontOfSize:15.0];
    self.colorTextField.textAlignment = NSTextAlignmentRight;
    self.colorTextField.returnKeyType = UIReturnKeyDone;
    
    if (self.dic) {
        NSDictionary* dic = [self.dic objectForKey:@"color"];
        for (NSDictionary* colorDic in self.carColor) {
            if ([dic[@"value"] isEqualToString:colorDic[@"value"]]) {
                self.colorTextField.text = colorDic[@"name"];
                self.colorStr = colorDic[@"id"];
            }
        }
        
    }
    
    self.colorTextField.attributedPlaceholder = [self setPlaceholderByString:@"请输入颜色"];
    self.colorTextField.rightViewMode = UITextFieldViewModeAlways;
    [self.scrollView addSubview:self.colorTextField];
    
    UIView* colorView = [[UIView alloc]initWithFrame:self.colorTextField.bounds];
    [self.colorTextField addSubview:colorView];
    
    UITapGestureRecognizer* tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(colorTap)];
    [colorView addGestureRecognizer:tap4];
    
    UILabel* line4 = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.colorLab.frame), mDeviceWidth - 30, 1)];
    [line4 setBackgroundColor:[UIColor lightGrayColor]];
    [self.scrollView addSubview:line4];
    //可用时段
    self.timeLab = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(line4.frame), 100, 44)];
    self.timeLab.text = @"可用时段";
    
    self.timeLab.font = [UIFont systemFontOfSize:15.0];
    self.timeLab.textAlignment = NSTextAlignmentLeft;
    [self.scrollView addSubview:self.timeLab];
    
    self.timeTextField = [[UITextField alloc]initWithFrame:CGRectMake(mDeviceWidth - 135, CGRectGetMaxY(line4.frame), 120, 44)];
    self.timeTextField.delegate = self;
    self.timeTextField.tag = 104;
    self.timeTextField.font = [UIFont systemFontOfSize:15.0];
    self.timeTextField.textAlignment = NSTextAlignmentRight;
    self.timeTextField.returnKeyType = UIReturnKeyDone;
    self.timeTextField.text = [BBUserData stringChangeNull:[self.dic objectForKey:@"date"] replaceWith:@""];
    
    self.timeTextField.attributedPlaceholder = [self setPlaceholderByString:@"请选择时段"];
    self.timeTextField.rightViewMode = UITextFieldViewModeAlways;
    [self.scrollView addSubview:self.timeTextField];
    
    if ([self.typeSortTextField.text isEqualToString:@"长期"]) {
        self.timeLab.textColor = [UIColor redColor];
        self.timeTextField.enabled = YES;
    }else if ([self.typeSortTextField.text isEqualToString:@"临时"]){
        self.timeLab.textColor = [UIColor lightGrayColor];
        self.timeTextField.enabled = NO;
   
    }else{
        self.timeLab.textColor = [UIColor redColor];
        self.timeTextField.enabled = YES;
     
    }
    
    UIView* timeView = [[UIView alloc]initWithFrame:self.timeTextField.bounds];
    [self.timeTextField addSubview:timeView];
    
    UITapGestureRecognizer* tap5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(timeTap)];
    [timeView addGestureRecognizer:tap5];
    
    UILabel* line5 = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.timeLab.frame), mDeviceWidth - 30, 1)];
    [line5 setBackgroundColor:[UIColor lightGrayColor]];
    [self.scrollView addSubview:line5];
    //可用次数
    self.countLab = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(line5.frame), 100, 44)];
    self.countLab.text = @"可用次数";
    self.countLab.font = [UIFont systemFontOfSize:15.0];
    self.countLab.textAlignment = NSTextAlignmentLeft;
    [self.scrollView addSubview:self.countLab];
    
    self.countTextField = [[UITextField alloc]initWithFrame:CGRectMake(mDeviceWidth - 135, CGRectGetMaxY(line5.frame), 120, 44)];
    self.countTextField.delegate = self;
    self.countTextField.tag = 105;
    self.countTextField.font = [UIFont systemFontOfSize:15.0];
    self.countTextField.textAlignment = NSTextAlignmentRight;
    self.countTextField.returnKeyType = UIReturnKeyDone;
    
    if ([self.typeSortTextField.text isEqualToString:@"长期"]) {
      
        self.countLab.textColor = [UIColor lightGrayColor];
        self.countTextField.enabled = NO;

    }else if ([self.typeSortTextField.text isEqualToString:@"临时"]){
  
        self.countLab.textColor = [UIColor redColor];
        self.countTextField.text = [self.dic objectForKey:@"times"];
        self.countTextField.enabled = YES;
    }else{
        self.countLab.textColor = [UIColor lightGrayColor];
        self.countTextField.enabled = NO;
      
    }
    
    self.countTextField.attributedPlaceholder = [self setPlaceholderByString:@"请输入次数"];
    self.countTextField.rightViewMode = UITextFieldViewModeAlways;
    [self.scrollView addSubview:self.countTextField];
    
    UILabel* line6 = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.countLab.frame), mDeviceWidth - 30, 1)];
    [line6 setBackgroundColor:[UIColor lightGrayColor]];
    [self.scrollView addSubview:line6];
    //备注
    self.remarkLab = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(line6.frame), 100, 44)];
    self.remarkLab.text = @"备注";
    self.remarkLab.font = [UIFont systemFontOfSize:15.0];
    self.remarkLab.textAlignment = NSTextAlignmentLeft;
    [self.scrollView addSubview:self.remarkLab];
    
    self.remarkTextField = [[UITextField alloc]initWithFrame:CGRectMake(mDeviceWidth - 135, CGRectGetMaxY(line6.frame), 120, 44)];
    self.remarkTextField.delegate = self;
    self.remarkTextField.tag = 106;
    self.remarkTextField.font = [UIFont systemFontOfSize:15.0];
    self.remarkTextField.textAlignment = NSTextAlignmentRight;
    self.remarkTextField.returnKeyType = UIReturnKeyDone;
    
    self.remarkTextField.text = [BBUserData stringChangeNull:[self.dic objectForKey:@"remarks"] replaceWith:@""];
    self.remarkTextField.attributedPlaceholder = [self setPlaceholderByString:@"请输入备注"];
    self.remarkTextField.rightViewMode = UITextFieldViewModeAlways;
    [self.scrollView addSubview:self.remarkTextField];
    
    UILabel* line7 = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.remarkLab.frame), mDeviceWidth - 30, 1)];
    [line7 setBackgroundColor:[UIColor lightGrayColor]];
    [self.scrollView addSubview:line7];
}
//设置placeholder
-(NSMutableAttributedString*)setPlaceholderByString:(NSString*)holderText{
    
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
    [placeholder addAttribute:NSForegroundColorAttributeName
                        value:[UIColor lightGrayColor]
                        range:NSMakeRange(0, holderText.length)];
    [placeholder addAttribute:NSFontAttributeName
                        value:[UIFont boldSystemFontOfSize:15]
                        range:NSMakeRange(0, holderText.length)];
    return placeholder;
}
#pragma mark 车辆类型
-(void)typeTap{
    JMDropMenu* dropMenu = [JMDropMenu showDropMenuFrame:CGRectMake(self.view.frame.size.width - 128, 64 + 44 + ([self.type isEqualToString:@"1"] ? 0 : 44), 120, 44*self.carKind.count+8) ArrowOffset:102.f TitleArr:self.carKind RowHeight:44.f Delegate:self];
//    self.typeTextField.text = [NSString stringWithFormat:@"%@",self.carType[menuRow]];
    
    dropMenu.blockSelectedMenu = ^(JMDropMenuModel* model) {
        self.typeSortTextField.text = model.name;
        if ([self.typeSortTextField.text isEqualToString:@"长期"]) {
            self.timeLab.textColor = [UIColor redColor];
            self.timeTextField.enabled = YES;
            self.countLab.textColor = [UIColor lightGrayColor];
            self.countTextField.enabled = NO;
            self.countTextField.text = @"";
        }else if ([self.typeSortTextField.text isEqualToString:@"临时"]){
            self.timeLab.textColor = [UIColor lightGrayColor];
            self.timeTextField.enabled = NO;
            self.countLab.textColor = [UIColor redColor];
            self.countTextField.enabled = YES;
            self.timeTextField.text = @"";
        }else{
            self.timeLab.textColor = [UIColor blackColor];
            self.countLab.textColor = [UIColor blackColor];
            self.timeTextField.enabled = YES;
            self.countTextField.enabled = YES;
            
        }
        
        self.kindStr = model.idStr;
    };
    [self.countTextField resignFirstResponder];
    [self.remarkTextField resignFirstResponder];
}


#pragma mark 车辆种类
-(void)typeSortTap{
    [self.countTextField resignFirstResponder];
    [self.remarkTextField resignFirstResponder];

    JMDropMenu* dropMenu = [JMDropMenu showDropMenuFrame:CGRectMake(self.view.frame.size.width - 128, 64 + 88 + ([self.type isEqualToString:@"1"] ? 0 : 44), 120, 44*self.carType.count+8) ArrowOffset:102.f TitleArr:self.carType RowHeight:44.f Delegate:self];
    dropMenu.blockSelectedMenu = ^(JMDropMenuModel* model) {
        self.typeTextField.text = model.name;
        self.typeStr = model.idStr;
    };
}
#pragma mark 车牌号
-(void)cardTap{
    [self.countTextField resignFirstResponder];
    [self.remarkTextField resignFirstResponder];
    [RZCarPlateNoInputAlertView showToVC:self plateNo:@"" title:@"请输入车牌号" plateLength:8 complete:^(BOOL isCancel, NSString * _Nonnull plateNo) {
        self.cardTextField.text = plateNo;
        
    }];
}
#pragma mark 颜色
-(void)colorTap{
    [self.countTextField resignFirstResponder];
    [self.remarkTextField resignFirstResponder];
    
  JMDropMenu* dropMenu = [JMDropMenu showDropMenuFrame:CGRectMake(self.view.frame.size.width - 128, 64 + 176 + ([self.type isEqualToString:@"1"] ? 0 : 44), 120, 44*self.carColor.count+8) ArrowOffset:102.f TitleArr:self.carColor RowHeight:44.f Delegate:self];
    dropMenu.blockSelectedMenu = ^(JMDropMenuModel* model) {
        self.colorTextField.text = model.name;
        self.colorStr = model.idStr;
    };
}
//可用时段
-(void)timeTap{
    [self.countTextField resignFirstResponder];
    [self.remarkTextField resignFirstResponder];
    CGFloat width = self.view.bounds.size.width - 20.0;
    CGPoint origin = CGPointMake(10.0, 64.0 + 90.0);
    GFCalendarView *calendar = [[GFCalendarView alloc] initWithFrameOrigin:origin width:width];
    [calendar setBackgroundColor:[UIColor orangeColor]];
    // 点击某一天的回调
    calendar.didSelectDayHandler = ^(NSInteger year, NSInteger month, NSInteger day) {
        
        [_backView removeFromSuperview];
        
        NSString* monthS = nil;
        NSString* dayS = nil;
        if (month<10) {
            monthS = [NSString stringWithFormat:@"%@%ld",@"0",(long)month];
        }else{
            monthS = [NSString stringWithFormat:@"%ld",(long)month];
        }
        if (day<10) {
            dayS = [NSString stringWithFormat:@"%@%ld",@"0",(long)day];
        }else{
            dayS = [NSString stringWithFormat:@"%ld",(long)day];
        }
        
        NSString* apend = [NSString stringWithFormat:@"%ld%@%@",(long)year,monthS,dayS];
        NSString* current = [self getCurrentTime];
        
        NSInteger append = [apend integerValue];
        NSInteger currented = [current integerValue];
        
        if (append>=currented) {
            self.timeTextField.text = [NSString stringWithFormat:@"%ld-%@-%@",(long)year,monthS,dayS];
        }else{
            NSLog(@"啥都没有");
            [DDProgressHUD showErrorImageWithInfo:@"不能小于当天"];
        }
    };
    
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mDeviceWidth, mDeviceHeight)];
    [_backView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6]];
    [[UIApplication sharedApplication].keyWindow addSubview:_backView];
    [_backView addSubview:calendar];
}
@end
