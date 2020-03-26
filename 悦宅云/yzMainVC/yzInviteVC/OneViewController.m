//
//  OneViewController.m
//  YZCSegmentController
//
//  Created by dyso on 16/8/1.
//  Copyright © 2016年 yangzhicheng. All rights reserved.
//

#import "OneViewController.h"
#import "SPDateTimePickerView.h"
#import "yzXiaoQuModel.h" //小区model
@interface OneViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,SPDateTimePickerViewDelegate>
@property(nonatomic,strong)UITableView* tableV;
@property(nonatomic,strong)NSMutableArray* lists;

@property(nonatomic,strong)UIButton* deleteBtn;

@property(nonatomic,strong)UILabel* nameLabel;
@property(nonatomic,strong)UILabel* countLabel;
@property(nonatomic,strong)UILabel* telLabel;
@property(nonatomic,strong)UILabel* timeLabel;
@property(nonatomic,strong)UILabel* byCarLabel;
@property(nonatomic,strong)UILabel* carNumLabel;
@property(nonatomic,strong)UILabel* remarkLabel;


@property(nonatomic,strong)UITextField* nameTextField;
@property(nonatomic,strong)UITextField* countTextField;
@property(nonatomic,strong)UITextField* telTextField;
@property(nonatomic,strong)UITextField* timeTextField;
@property(nonatomic,strong)UISwitch* byCarSwitch;
@property(nonatomic,strong)UITextField* carNumTextField;
@property(nonatomic,strong)UITextView* remarkTextView;

@property(nonatomic,strong)UIButton* submitBtn;     //提交


@property(nonatomic,assign)int editSection;

@property(nonatomic,strong)NSDictionary* dict;
@property(nonatomic,strong)yzXiaoQuModel* quModel;
@end

@implementation OneViewController

-(UITableView *)tableV{
    if (!_tableV) {
        _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, mDeviceWidth, mDeviceHeight - kNavBarHeight - KSAFEBAR_HEIGHT - 40 - 60) style:UITableViewStyleGrouped];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        //解决滑动视图顶部空出状态栏高度的问题
        if (@available(iOS 11.0, *)) {
            _tableV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
          self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableV.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
//        _tableV.sectionFooterHeight = 0;
        _tableV.separatorInset = UIEdgeInsetsZero;
        [self.view addSubview:self.tableV];
    }
    return _tableV;
}

-(UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(_tableV.frame) + 10, mDeviceWidth - 20, 40)];
        [_submitBtn setBackgroundColor:[UIColor orangeColor]];
        [_submitBtn setTitle:@"提             交" forState:UIControlStateNormal];
        _submitBtn.titleLabel.font = YSize(15.0);
        _submitBtn.layer.cornerRadius = 4;
        _submitBtn.layer.masksToBounds = YES;
        [_submitBtn addTarget:self action:@selector(submitBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_submitBtn];
    }
    return _submitBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
//        NSMutableArray* array = @[@{@"appUserId":@"11111111111111111111111111111111",@"inviteName":@"测试2",@"inviteNum":@"1",@"invitePhone":@"13122223333",@"inviteDate":@"2019-05-29",@"inviteWithCar":@"1",@"inviteCarCode":@"京A12345",@"inviteRemark":@"测试一下",@"inviteTime":@{@"id":@"15553945802567497340247589466362"}}.mutableCopy];
    //获取小区数据
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"XiaoQuModel"];
    
    
    self.quModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSLog(@"==%@",self.quModel.xiaoqu_id);
    
    self.dict = [[NSDictionary alloc]init];
    self.lists = @[@{@"appUserId":[yzUserInfoModel getLoginUserInfo:@"userId"],@"xiaoQuId":self.quModel.xiaoqu_id,@"inviteName":@"",@"inviteNum":@"",@"invitePhone":@"",@"inviteDate":@"",@"inviteWithCar":@"0",@"inviteCarCode":@"",@"inviteRemark":@"",@"inviteTime":@{@"id":@"15553945961768726175448059294084"}}.mutableCopy].mutableCopy;
    
    
    
    [self tableV];
    [self submitBtn];
    

    
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.lists.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    UITableViewCell* cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSMutableDictionary* dic = self.lists[indexPath.section];
    
    
   
    
    
    self.deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(mDeviceWidth - 30, 15, 20, 20)];
    [self.deleteBtn setTitle:@"X" forState:UIControlStateNormal];
    [self.deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.deleteBtn addTarget:self action:@selector(deleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.deleteBtn.tag = indexPath.section;
    [cell addSubview:self.deleteBtn];
    
    //访客姓名
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.text = @"访客姓名:";
    self.nameLabel.font = YSize(15.0);
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    CGRect rect = Rect(self.nameLabel.text, 100, YSize(15.0));
    self.nameLabel.frame = CGRectMake(15, 50, rect.size.width, rect.size.height);
    [cell addSubview:self.nameLabel];
    
    self.nameTextField = [[UITextField alloc]init];
    self.nameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.nameTextField.delegate = self;
    self.nameTextField.tag = 1000 + indexPath.section;
    self.nameTextField.text = [dic objectForKey:@"inviteName"];
    [cell addSubview:self.nameTextField];
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.left.equalTo(self.nameLabel).offset(rect.size.width + 15);
        make.width.mas_equalTo(AutoWitdh(mDeviceWidth - 45 - rect.size.width));
        make.height.mas_equalTo(30);
    }];
    
    //来访人数
    self.countLabel = [[UILabel alloc]init];
    self.countLabel.text = @"来访人数:";
    self.countLabel.font = YSize(15.0);
    self.countLabel.textAlignment = NSTextAlignmentLeft;
 
    self.countLabel.frame = CGRectMake(self.nameLabel.frame.origin.x, CGRectGetMaxY(self.nameLabel.frame) + 20, rect.size.width, rect.size.height);
    [cell addSubview:self.countLabel];
    
    self.countTextField = [[UITextField alloc]init];
    self.countTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.countTextField.delegate = self;
    self.countTextField.keyboardType = UIKeyboardTypePhonePad;
    self.countTextField.tag = 2000 + indexPath.section;
     self.countTextField.text = [dic objectForKey:@"inviteNum"];
    [cell addSubview:self.countTextField];
    [self.countTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.countLabel);
        make.centerX.equalTo(self.nameTextField);;
        make.width.mas_equalTo(AutoWitdh(mDeviceWidth - 45 - rect.size.width));
        make.height.mas_equalTo(30);
    }];
    
    
    //手机号码
    self.telLabel = [[UILabel alloc]init];
    self.telLabel.text = @"手机号码:";
    self.telLabel.font = YSize(15.0);
    self.telLabel.textAlignment = NSTextAlignmentLeft;
 
    self.telLabel.frame = CGRectMake(self.countLabel.frame.origin.x, CGRectGetMaxY(self.countLabel.frame) + 20, rect.size.width, rect.size.height);
    [cell addSubview:self.telLabel];
    
    self.telTextField = [[UITextField alloc]init];
    self.telTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.telTextField.delegate = self;
    self.telTextField.tag = 3000 + indexPath.section;
    self.telTextField.keyboardType = UIKeyboardTypePhonePad;
     self.telTextField.text = [dic objectForKey:@"invitePhone"];
    [self.telTextField addTarget:self action:@selector(phoneNumberTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    [cell addSubview:self.telTextField];
    [self.telTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.telLabel);
        make.centerX.equalTo(self.nameTextField);;
        make.width.mas_equalTo(AutoWitdh(mDeviceWidth - 45 - rect.size.width));
        make.height.mas_equalTo(30);
    }];
    
    
    //到访时间
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.text = @"到访时间:";
    self.timeLabel.font = YSize(15.0);
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
   
    self.timeLabel.frame = CGRectMake(self.telLabel.frame.origin.x, CGRectGetMaxY(self.telLabel.frame) + 20, rect.size.width, rect.size.height);
    [cell addSubview:self.timeLabel];
    
    self.timeTextField = [[UITextField alloc]init];
    self.timeTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.timeTextField.delegate = self;
    self.timeTextField.tag = 4000 + indexPath.section;
     self.timeTextField.text = [dic objectForKey:@"inviteDate"];
    [cell addSubview:self.timeTextField];
    [self.timeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeLabel);
        make.centerX.equalTo(self.nameTextField);;
        make.width.mas_equalTo(AutoWitdh(mDeviceWidth - 45 - rect.size.width));
        make.height.mas_equalTo(30);
    }];
    
    
    UIButton* btn = [[UIButton alloc]init];
    [btn setBackgroundColor:[UIColor clearColor]];
    btn.tag = 4000 + indexPath.section;
    [btn addTarget:self action:@selector(seleTime:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeLabel);
        make.centerX.equalTo(self.nameTextField);;
        make.width.mas_equalTo(AutoWitdh(mDeviceWidth - 45 - rect.size.width));
        make.height.mas_equalTo(30);
    }];
    
    
    
    //开车来访
    self.byCarLabel = [[UILabel alloc]init];
    self.byCarLabel.text = @"开车来访:";
    self.byCarLabel.font = YSize(15.0);
    self.byCarLabel.textAlignment = NSTextAlignmentLeft;
    
    self.byCarLabel.frame = CGRectMake(self.timeLabel.frame.origin.x, CGRectGetMaxY(self.timeLabel.frame) + 20, rect.size.width, rect.size.height);
    [cell addSubview:self.byCarLabel];
    
    self.byCarSwitch = [[UISwitch alloc]init];
    NSString* on = [NSString stringWithFormat:@"%@",[dic objectForKey:@"inviteWithCar"]];

    if ([on isEqualToString:@"1"]) {
        [self.byCarSwitch setOn:YES];
    }else{
        [self.byCarSwitch setOn:NO];
    }
    [self.byCarSwitch addTarget:self action:@selector(byCarSwitch:) forControlEvents:UIControlEventValueChanged];
    self.byCarSwitch.tag = 7000 + indexPath.section;
    [cell addSubview:self.byCarSwitch];
    [self.byCarSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.byCarLabel);
        make.left.equalTo(self.byCarLabel).offset(rect.size.width + 15);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
    
    
    
    //车牌号码
    self.carNumLabel = [[UILabel alloc]init];
    self.carNumLabel.text = @"车牌号码:";
    self.carNumLabel.font = YSize(15.0);
    
    self.carNumLabel.textAlignment = NSTextAlignmentLeft;
    self.carNumLabel.frame = CGRectMake(self.timeLabel.frame.origin.x, CGRectGetMaxY(self.byCarLabel.frame) + 20, rect.size.width, rect.size.height);
    [cell addSubview:self.carNumLabel];
    
    
    self.carNumTextField = [[UITextField alloc]init];
    self.carNumTextField.borderStyle = UITextBorderStyleRoundedRect;
    // 强制输入的字母为大写字母
    self.carNumTextField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    // 去掉智能拼写修正的功能(个人觉得不使用英文写作输入的话,最好关掉妨碍美观占位置)
    self.carNumTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.carNumTextField.keyboardType = UIKeyboardTypeDefault;
    self.carNumTextField.enablesReturnKeyAutomatically = YES;
    self.carNumTextField.delegate = self;
    self.carNumTextField.tag = 5000 + indexPath.section;
     self.carNumTextField.text = [dic objectForKey:@"inviteCarCode"];
//   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.carNumTextField];
    
    if ([on isEqualToString:@"1"]) {
        self.carNumTextField.enabled = YES;
    }else{
        self.carNumTextField.enabled = NO;
    }
    
    [cell addSubview:self.carNumTextField];
    [self.carNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.carNumLabel);
        make.centerX.equalTo(self.nameTextField);;
        make.width.mas_equalTo(AutoWitdh(mDeviceWidth - 45 - rect.size.width));
        make.height.mas_equalTo(30);
    }];
    
    
    
    //备注信息
    
    self.remarkLabel = [[UILabel alloc]init];
    self.remarkLabel.text = @"备注信息:";
    self.remarkLabel.font = YSize(15.0);
    self.remarkLabel.textAlignment = NSTextAlignmentLeft;
    
self.remarkLabel.frame = CGRectMake(self.timeLabel.frame.origin.x, CGRectGetMaxY(self.carNumLabel.frame) + 20, rect.size.width, rect.size.height);
    [cell addSubview:self.remarkLabel];
    
    self.remarkTextView = [[UITextView alloc]init];
    self.remarkTextView.layer.borderWidth = 0.5;
    self.remarkTextView.layer.borderColor = RGB(240, 240, 240).CGColor;
    self.remarkTextView.layer.cornerRadius = 5;
    self.remarkTextView.layer.masksToBounds = YES;
    self.remarkTextView.delegate = self;
    self.remarkTextView.tag = 6000 + indexPath.section;
     self.remarkTextView.text = [dic objectForKey:@"inviteRemark"];
    [cell addSubview:self.remarkTextView];
    [self.remarkTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.remarkLabel);
        make.centerX.equalTo(self.nameTextField);;
        make.width.mas_equalTo(AutoWitdh(mDeviceWidth - 45 - rect.size.width));
        make.height.mas_equalTo(130);
    }];
    
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 430;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == self.lists.count - 1) {
        return 200;
    }
    return 15;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==self.lists.count - 1) {
        UIView* backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mDeviceWidth, 200)];
        
        UIButton* addBtn = [[UIButton alloc]initWithFrame:CGRectMake(mDeviceWidth/2 - 25, 100 - 25, 50, 50)];
        [addBtn setImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(addCell:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:addBtn];
        
        return backView;
    }
    return nil;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [self.nameTextField resignFirstResponder];
//    [self.countTextField resignFirstResponder];
//    [self.telTextField resignFirstResponder];
//    [self.carNumTextField resignFirstResponder];
//    [self.remarkTextView resignFirstResponder];
    
    [self.view endEditing:YES];
}



///添加cell
-(void)addCell:(UIButton*)sender{
    NSMutableDictionary* dic = @{@"appUserId":[yzUserInfoModel getLoginUserInfo:@"userId"],@"xiaoQuId":self.quModel.xiaoqu_id,@"inviteName":@"",@"inviteNum":@"",@"invitePhone":@"",@"inviteDate":@"",@"inviteWithCar":@"0",@"inviteCarCode":@"",@"inviteRemark":@"",@"inviteTime":@{@"id":@""}}.mutableCopy;
 
    
    [self.lists addObject:dic];
    [self.tableV reloadData];
}
///删除Cell
-(void)deleteBtn:(UIButton*)sender{
    [self.lists removeObjectAtIndex:sender.tag];

    [self.tableV reloadData];
}
#pragma mark --选择时间
-(void)seleTime:(UIButton*)sender{
    self.editSection = sender.tag%1000;
    NSLog(@"===%d",self.editSection);
    SPDateTimePickerView *pickerView = [[SPDateTimePickerView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,  [UIScreen mainScreen].bounds.size.height)];
    pickerView.delegate = self;
    pickerView.title = @"时间选择器";
    [self.view addSubview:pickerView];
    [pickerView showDateTimePickerView];
    
    
    [self.nameTextField resignFirstResponder];
    [self.countTextField resignFirstResponder];
    [self.telTextField resignFirstResponder];
    [self.carNumTextField resignFirstResponder];
    [self.remarkTextView resignFirstResponder];
    [self.view endEditing:YES];
}


#pragma mark - SPDateTimePickerViewDelegate
- (void)didClickFinishDateTimePickerView:(NSString *)date dic:(NSDictionary *)dic{
    
    
    NSMutableDictionary* mutDic = self.lists[self.editSection];
    [mutDic setObject:date forKey:@"inviteDate"];
    [mutDic setObject:dic forKey:@"inviteTime"];
    [self.lists replaceObjectAtIndex:self.editSection withObject:mutDic];
//    self.timeTextField.text = date;
    [self.tableV reloadData];
    NSLog(@"++++%@",self.lists);
}

//- (void)textFieldDidChange:(NSNotification *)notification {
//    UITextField *textField = notification.object;
//    if (!textField) {
//        return;
//    }
//    textField.text = textField.text.lowercaseString;
//}
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
-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    int section = textView.tag%1000;
    NSMutableDictionary* dic = self.lists[section];
    [dic setObject:textView.text forKey:@"inviteRemark"];
    [self.lists replaceObjectAtIndex:section withObject:dic];
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField.tag/1000==4){
        [textField resignFirstResponder];
        
    }

    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    textField.text = [textField.text uppercaseString];
    if (textField.tag/1000==1) {
        int section = textField.tag%1000;
        NSMutableDictionary* dic = self.lists[section];
        [dic setObject:textField.text forKey:@"inviteName"];
       [self.lists replaceObjectAtIndex:section withObject:dic];
        
    }else if (textField.tag/1000==2){
        int section = textField.tag%1000;
        NSMutableDictionary* dic = self.lists[section];
        [dic setObject:textField.text forKey:@"inviteNum"];
        [self.lists replaceObjectAtIndex:section withObject:dic];
      
    }else if (textField.tag/1000==3){
        int section = textField.tag%1000;
        NSMutableDictionary* dic = self.lists[section];
        [dic setObject:textField.text forKey:@"invitePhone"];
        [self.lists replaceObjectAtIndex:section withObject:dic];
        
    }else if (textField.tag/1000==4){
        self.editSection = textField.tag%1000;
        
        NSMutableDictionary* dic = self.lists[self.editSection];
        [dic setObject:textField.text forKey:@"inviteDate"];
        [self.lists replaceObjectAtIndex:self.editSection withObject:dic];
        
        
    }else if (textField.tag/1000==5){
        int section = textField.tag%1000;
        NSMutableDictionary* dic = self.lists[section];
        [dic setObject:textField.text forKey:@"inviteCarCode"];
        [self.lists replaceObjectAtIndex:section withObject:dic];
        
    }else if (textField.tag/1000==6){
        int section = textField.tag%1000;
        NSMutableDictionary* dic = self.lists[section];
        [dic setObject:textField.text forKey:@"inviteRemark"];
        [self.lists replaceObjectAtIndex:section withObject:dic];
        
    }
    
    
}

///是否开车
-(void)byCarSwitch:(UISwitch*)sender{
   BOOL isButtonOn = [sender isOn];
    
    int section = sender.tag%1000;
    int tag = self.carNumTextField.tag%1000;
    NSMutableDictionary* dic = self.lists[section];
    [dic setObject:@(isButtonOn) forKey:@"inviteWithCar"];
    [self.lists replaceObjectAtIndex:section withObject:dic];
    if (isButtonOn) {
        
        if (section==tag) {
            self.carNumTextField.enabled = YES;
        }
        
    }else{
       
        if (section==tag) {
            self.carNumTextField.enabled = NO;
        }
    }
    
    [self.tableV reloadData];

}

#pragma mark -- 提交邀请
-(void)submitBtn:(UIButton*)sender{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate* datenow = [NSDate date];
    NSString* currentTime = [formatter stringFromDate:datenow];
    
    for (NSDictionary* dic in self.lists) {
        NSString* name = [dic objectForKey:@"inviteName"];
        NSString* tel = [dic objectForKey:@"invitePhone"];
        NSString* date = [dic objectForKey:@"inviteDate"];
        NSString* carNum = [dic objectForKey:@"inviteCarCode"];
        
        if (name.length==0) {
            [DDProgressHUD showErrorImageWithInfo:@"请填写名字"];
            return;
        }
        if (tel.length==0) {
            [DDProgressHUD showErrorImageWithInfo:@"请填写手机号"];
            return;
        }else{
            BOOL isTel = [CCAFNetWork validateContactNumber:tel];
            if (!isTel) {
                [DDProgressHUD showErrorImageWithInfo:@"请输入正确手机号"];
                return;
            }
        }
        if (date.length==0) {
            [DDProgressHUD showErrorImageWithInfo:@"请选择时间"];
            return;
        }else{
            NSDate *dateA = [formatter dateFromString:currentTime];
            NSDate *dateB = [formatter dateFromString:date];
            NSComparisonResult result = [dateA compare:dateB];
            if (result == NSOrderedDescending) {
                [DDProgressHUD showErrorImageWithInfo:@"不能选择今天之前的时间"];
                return;
            }
         
        }
        
        if (carNum.length>0) {
            BOOL isCarNum = [CCAFNetWork isValidCarID:carNum];
            if (!isCarNum) {
                [DDProgressHUD showErrorImageWithInfo:@"请输入正确车牌号"];
                return;
            }
        }
    }
    
    
    
    [DDProgressHUD show];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@app/currentrecord/saveInvite",postUrl] parameters:self.lists error:nil];
    
    NSLog(@"+++%@",self.lists);
    
    request.timeoutInterval = 10.f;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:Token forHTTPHeaderField:@"Authorization"];
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
    
        if (!error) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                // 请求成功数据处理
                [DDProgressHUD showSuccessImageWithInfo:[responseObject objectForKey:@"message"]];
                self.lists = @[@{@"appUserId":[yzUserInfoModel getLoginUserInfo:@"userId"],@"xiaoQuId":self.quModel.xiaoqu_id,@"inviteName":@"",@"inviteNum":@"",@"invitePhone":@"",@"inviteDate":@"",@"inviteWithCar":@"0",@"inviteCarCode":@"",@"inviteRemark":@"",@"inviteTime":@{@"id":@"15553945961768726175448059294084"}}.mutableCopy].mutableCopy;
                [self.tableV reloadData];
            } else {
                [DDProgressHUD showSuccessImageWithInfo:[responseObject objectForKey:@"message"]];
            }
        } else {
            NSLog(@"请求失败error=%@", error);
        }
    }];
    
    [task resume];
    

}



@end
