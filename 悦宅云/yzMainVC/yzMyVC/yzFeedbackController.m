//
//  yzFeedbackController.m
//  yzProduct
//
//  Created by 尚广杰 on 2019/2/21.
//  Copyright © 2019 CC. All rights reserved.
//

#import "yzFeedbackController.h"
#import "TZImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "JZLPhotoBrowser.h"      //图片展示

#import "TZLocationManager.h"
#import "TZAssetCell.h"
#import <MobileCoreServices/MobileCoreServices.h>



@interface yzFeedbackController ()<TZImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate>
{
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;

}

@property(nonatomic,strong)UIScrollView* scrollV;

@property(nonatomic,strong)UIImageView* headerImageV;       //头部图片
@property(nonatomic,strong)UIImagePickerController* imagePickerVC;



@property (strong, nonatomic) CLLocation *location;

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@property(nonatomic,strong)UILabel* nameLabel;          //姓名
@property(nonatomic,strong)UILabel* telLabel;           //电话
@property(nonatomic,strong)UILabel* questionLabel;      //问题描述
@property(nonatomic,strong)UILabel* imageLabel;         //图片上传
@property(nonatomic,strong)UILabel* promptLabel;

@property(nonatomic,strong)UITextField* nameTextFiled;
@property(nonatomic,strong)UITextField* telTextFiled;
@property(nonatomic,strong)UITextView* remarksView;

@property(nonatomic,strong)UIView* showImageView;       //图片列表view

@property(nonatomic,strong)UIButton* showBtn;
@property(nonatomic,strong)UIButton* addBtn;
@property(nonatomic,strong)UIButton* submitBtn;

@property(nonatomic,strong)NSArray* titleArr;

@property(nonatomic,strong)UILabel* imageCount;     //图片计数器

@property(nonatomic,strong)NSDictionary* dic;
@end

@implementation yzFeedbackController
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (UIImagePickerController *)imagePickerVC {
    if (_imagePickerVC == nil) {
        _imagePickerVC = [[UIImagePickerController alloc] init];
        _imagePickerVC.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVC.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVC.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (@available(iOS 9, *)) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
        
    }
    return _imagePickerVC;
}
-(UIScrollView *)scrollView{
    if (!_scrollV) {
        _scrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, mDeviceWidth, mDeviceHeight)];
        _scrollV.delegate = self;
         _scrollV.contentSize = CGSizeMake(mDeviceWidth, mDeviceHeight + 100);
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self.view addSubview:self.scrollV];
        [self setUI];
    }
    return self.scrollV;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    _titleArr = @[@"功能异常",@"体验问题",@"新增功能",@"其它"];
    [self scrollView];
    

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
    [titleLabel setText:@"意见反馈"];
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

//设置页面
-(void)setUI{
    self.headerImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mDeviceWidth, mDeviceWidth/2.5)];
    self.headerImageV.image = [UIImage imageNamed:@"反馈"];
    [self.scrollV addSubview:self.headerImageV];
    
    UIView* backView1 = [[UIView alloc]initWithFrame:CGRectMake(10, mDeviceWidth/2.5 - 30, mDeviceWidth - 20, mDeviceWidth - 20)];
    [backView1 setBackgroundColor:[UIColor whiteColor]];
    backView1.layer.cornerRadius = 5;
    backView1.layer.masksToBounds = NO;
    backView1.layer.shadowColor = [UIColor blackColor].CGColor;
    // 阴影偏移，默认(0, -3)
    backView1.layer.shadowOffset = CGSizeMake(0,0);
    // 阴影透明度，默认0
    backView1.layer.shadowOpacity = 0.5;
    // 阴影半径，默认3
    backView1.layer.shadowRadius = 5;
    [self.scrollV addSubview:backView1];
    
    UILabel* title = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, mDeviceWidth - 50, 20)];
    title.text = @"反馈问题类型";
    title.font = YSize(15.0);
    title.textAlignment = NSTextAlignmentLeft;
    
    [backView1 addSubview:title];
    
    
    for (int i = 0; i < _titleArr.count; i++) {
        UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(15 + (5 + (mDeviceWidth - 50)/5)*i, CGRectGetMaxY(title.frame) + 7, (mDeviceWidth - 50)/5, 25)];
        [btn setTitle:_titleArr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = YSize(13.0);
        
        btn.layer.cornerRadius = 5;
        btn.layer.borderWidth = 1;
        btn.tag = 1000 + i;
        if (i==0) {
            
            btn.layer.borderColor = [UIColor redColor].CGColor;
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }else{
            btn.layer.borderColor = [UIColor blackColor].CGColor;
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        [btn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
        [backView1 addSubview:btn];
    }
    
    UIView* backView2 = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(title.frame) + 17 + 25, mDeviceWidth - 50, backView1.frame.size.height - 92)];
    backView2.layer.cornerRadius = 5;
    backView2.layer.borderWidth = 1;
    backView2.layer.borderColor =RGB(240, 240, 240).CGColor;
    
    [backView1 addSubview:backView2];
    
    
    self.remarksView = [[UITextView alloc]initWithFrame:CGRectMake(5, 5, backView2.frame.size.width - 10, backView2.frame.size.height - 85)];
    self.remarksView.delegate = self;
    self.remarksView.font = [UIFont systemFontOfSize:15.0];
    [backView2 addSubview:self.remarksView];
    
    
    //textview的提示框
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5,5, 200, 20)];
    label.enabled = NO;
    label.text = @"请简单描述您的问题......";
    label.font =  YSize(13.0);
    label.textColor = [UIColor whiteColor];
    self.promptLabel = label;
    [self.remarksView addSubview:self.promptLabel];
    
    self.showImageView = [[UIView alloc]initWithFrame:CGRectMake(0, backView2.frame.size.height - 70, backView2.frame.size.width, 60)];
    [self.showImageView setBackgroundColor:[UIColor clearColor]];
    
    [backView2 addSubview:self.showImageView];
    
    

    
    [self setImageView];
    
  /*
    UILabel* line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerImageV.frame), mDeviceWidth, 1)];
    [line1 setBackgroundColor:[UIColor lightGrayColor]];
    [self.scrollV addSubview:line1];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(line1.frame), 100, 44)];
    self.nameLabel.text = @"姓        名:";
    self.nameLabel.font = [UIFont systemFontOfSize:15.0];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.scrollV addSubview:self.nameLabel];
    
    
    self.nameTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(100, self.nameLabel.frame.origin.y, mDeviceWidth - 130, 44)];
    self.nameTextFiled.placeholder = @"请输入用户名";
    self.nameTextFiled.font = [UIFont systemFontOfSize:15.0];
    [self.scrollV addSubview:self.nameTextFiled];
    
    
    UILabel* line2 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.nameTextFiled.frame), mDeviceWidth, 1)];
    [line2 setBackgroundColor:[UIColor lightGrayColor]];
    [self.scrollV addSubview:line2];
    
    
    self.telLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(line2.frame), 100, 44)];
    self.telLabel.text = @"电        话:";
    self.telLabel.font = [UIFont systemFontOfSize:15.0];
    self.telLabel.textAlignment = NSTextAlignmentLeft;
    [self.scrollV addSubview:self.telLabel];
    
    self.telTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(100, self.telLabel.frame.origin.y, mDeviceWidth - 130, 44)];
    self.telTextFiled.placeholder = @"请输入联系方式";
    self.telTextFiled.keyboardType = UIKeyboardTypeNumberPad;
    self.telTextFiled.font = [UIFont systemFontOfSize:15.0];
    [self.scrollV addSubview:self.telTextFiled];
    
    
    UILabel* line3 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.telTextFiled.frame), mDeviceWidth, 1)];
    [line3 setBackgroundColor:[UIColor lightGrayColor]];
    [self.scrollV addSubview:line3];
    
    self.questionLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(line3.frame), 100, 44)];
    self.questionLabel.text = @"问题描述:";
    self.questionLabel.font = [UIFont systemFontOfSize:15.0];
    self.questionLabel.textAlignment = NSTextAlignmentLeft;
    [self.scrollV addSubview:self.questionLabel];
    
    
    self.remarksView = [[UITextView alloc]initWithFrame:CGRectMake(100, CGRectGetMaxY(line3.frame)+ 5, mDeviceWidth - 130, 140)];
    self.remarksView.delegate = self;
    self.remarksView.font = [UIFont systemFontOfSize:15.0];
    [self.scrollV addSubview:self.remarksView];
    
    
    //textview的提示框
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5,5, 200, 20)];
    label.enabled = NO;
    label.text = @"请简单描述您的问题......";
    label.font =  [UIFont fontWithName:@"HYJinChangTiJ" size:15];
    label.textColor = [UIColor whiteColor];
    self.promptLabel = label;
    [self.remarksView addSubview:self.promptLabel];
    
    UILabel* line4 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.remarksView.frame)+5, mDeviceWidth, 1)];
    [line4 setBackgroundColor:[UIColor lightGrayColor]];
    [self.scrollV addSubview:line4];
    
    self.imageLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(line4.frame), 100, 44)];
    self.imageLabel.text = @"图片上传:";
    self.imageLabel.font = [UIFont systemFontOfSize:15.0];
    self.imageLabel.textAlignment = NSTextAlignmentLeft;
    [self.scrollV addSubview:self.imageLabel];
    
    
    self.showImageView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imageLabel.frame) + 10, mDeviceWidth, 60)];
    [self.showImageView setBackgroundColor:[UIColor redColor]];
    
    [self.scrollV addSubview:self.showImageView];
    
    
    [self setImageView];
    
   */
    UILabel* line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(backView1.frame) + 20, mDeviceWidth, 1)];
    [line1 setBackgroundColor:RGB(240, 240, 240)];
    [self.scrollV addSubview:line1];
    
    
    self.telLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(line1.frame), 100, 44)];
    self.telLabel.text = @"手  机  号:";
    self.telLabel.font = [UIFont systemFontOfSize:15.0];
    self.telLabel.textAlignment = NSTextAlignmentLeft;
    [self.scrollV addSubview:self.telLabel];
    
    self.telTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(100, self.telLabel.frame.origin.y, mDeviceWidth - 130, 44)];
    self.telTextFiled.placeholder = @"请输入手机号码";
    self.telTextFiled.keyboardType = UIKeyboardTypeNumberPad;
    self.telTextFiled.font = [UIFont systemFontOfSize:15.0];
    [self.scrollV addSubview:self.telTextFiled];
    
    
    UILabel* line2 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.telTextFiled.frame), mDeviceWidth, 1)];
    [line2 setBackgroundColor:RGB(240, 240, 240)];
    [self.scrollV addSubview:line2];
    
    
    self.submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(line2.frame) + 60, mDeviceWidth - 20, 40)];
    [self.submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    self.submitBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self.submitBtn setBackgroundColor:[UIColor redColor]];
    self.submitBtn.layer.cornerRadius = 5;
    self.submitBtn.layer.masksToBounds = YES;
    [self.submitBtn addTarget:self action:@selector(submitBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollV addSubview:self.submitBtn];
}
//四个按钮
-(void)selectBtn:(UIButton*)sender{
    
    for (int i = 0; i<self.titleArr.count; i++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:1000+i];
        [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        button.layer.borderColor = [UIColor blackColor].CGColor;
    }
    [sender setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    sender.layer.borderColor = [UIColor redColor].CGColor;
}



//图片展示view
-(void)setImageView{
    
    
    
    NSLog(@"---%@",_selectedPhotos);
    [self.showImageView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGRect rect = Rect(@"0/3", 100, YSize(13.0));
    
    self.imageCount = [[UILabel alloc]initWithFrame:CGRectMake(self.showImageView.frame.size.width - rect.size.width - 10, 60 - rect.size.height, rect.size.width, rect.size.height)];
    
    self.imageCount.text = @"0/3";
    self.imageCount.font = YSize(13.0);
    self.imageCount.textColor = RGB(200, 200, 200);
    self.imageCount.textAlignment = NSTextAlignmentRight;
    
    [self.showImageView addSubview:self.imageCount];
    if (_selectedPhotos.count>0) {
        self.imageCount.text = [NSString stringWithFormat:@"%lu/3",(unsigned long)_selectedPhotos.count];
        for (int i = 0; i < _selectedPhotos.count; i++) {
            self.showBtn = [[UIButton alloc]initWithFrame:CGRectMake(15 + (50 + 10)*i, 5, 50, 50)];
            self.showBtn.tag = i;
            [self.showBtn addTarget:self action:@selector(showBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self.showBtn setBackgroundImage:_selectedPhotos[i] forState:UIControlStateNormal];
            [self.showImageView addSubview:self.showBtn];
        }
    }else{
        [self.showBtn removeFromSuperview];
        self.imageCount.text = @"0/3";
    }
    
    
    self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addBtn setBackgroundImage:[UIImage imageNamed:@"yz_repairs_add.png"] forState:UIControlStateNormal];
    if (_selectedPhotos.count>0) {
        self.addBtn.frame = CGRectMake(CGRectGetMaxX(self.showBtn.frame) + 15, 5, 50, 50);
    }else{
        self.addBtn.frame = CGRectMake(15, 5, 50, 50);
    }
    
    [self.addBtn addTarget:self action:@selector(addBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.showImageView addSubview:self.addBtn];

    
   
  
}


#pragma mark -- 提交建议
-(void)submitBtn:(UIButton*)sender{
    
    [self keyboardHide:nil];
    if (self.remarksView.text.length == 0) {
        [DDProgressHUD showErrorImageWithInfo:@"请输入您的建议"];
        return;
    }
    if (self.telTextFiled.text.length == 0) {
        [DDProgressHUD showErrorImageWithInfo:@"请输入电话"];
        return;
    }else{
        BOOL isTel = [self validateContactNumber:self.telTextFiled.text];
        if (!isTel) {
            [DDProgressHUD showErrorImageWithInfo:@"请输入正确手机号"];
            return;
        }
    }
 
    
    //先上传图片
    if (_selectedPhotos.count > 0) {
        NSMutableArray *images = [[NSMutableArray alloc] init];
        for (int i = 0; i < _selectedPhotos.count; i ++) {
            UIImage *image = (UIImage *)_selectedPhotos[i];
            [images addObject:image];
        }
        if (images.count >0) {
            [DDProgressHUD show];
            [[AliyunOSImageAssistant sharedAliyunOSImageAssistant] uploadImageArr:images];
            [[AliyunOSImageAssistant sharedAliyunOSImageAssistant] setImageUrlBlock:^(NSArray *imgUrl) {
                NSLog(@"imgUrl--%@",imgUrl);
                [self sendComplain:imgUrl];
            }];
        }
        
    }else{
        [self sendComplain:nil];
    }
}

-(void)showBtn:(UIButton*)sender{
    
    NSMutableArray *photos = [NSMutableArray new];
    
    for (int i = 0; i < _selectedPhotos.count; i ++) {
        GKPhoto *photo = [GKPhoto new];
        photo.image = _selectedPhotos[i];
        [photos addObject:photo];
    }
    GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photos currentIndex:sender.tag];
    browser.showStyle = GKPhotoBrowserShowStyleNone;
    browser.loadStyle = GKPhotoBrowserLoadStyleDeterminate;
    [browser showFromVC:self];
   
}

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

-(void)sendComplain:(NSArray *)imageArray{
    [DDProgressHUD showWithStatus:@"提交中..."];
   
     [[NSOperationQueue mainQueue] addOperationWithBlock:^{//只留下主线程返回的进度数据

        self.dic = @{@"feedbackPhone":self.telTextFiled.text,@"feedbackName":@"呵呵",@"feedbackInfo":self.remarksView.text,@"appUserId":[yzUserInfoModel getLoginUserInfo:@"userId"],@"baoxiuPic1":imageArray.count>0?imageArray[0]:@"",@"baoxiuPic2":imageArray.count>1?imageArray[1]:@"",@"baoxiuPic3":imageArray.count>2?imageArray[2]:@""};
        
        [CCAFNetWork post:[NSString stringWithFormat:@"%@app/feedback/save",postUrl] version:Token parameters:self.dic success:^(id object) {
            
            NSDictionary *json = object;
            if ([[json objectForKey:@"code"] intValue] == 200) {
                //            [DDProgressHUD dismiss];
                [DDProgressHUD showSuccessImageWithInfo:[json objectForKey:@"message"]];
                [self.navigationController popViewControllerAnimated:YES];
            }else if ([[json objectForKey:@"code"] intValue] == -6){
                [DDProgressHUD dismiss];
                [yzUserInfoModel userLoginOut];
                [yzUserInfoModel setLoginState:NO];
                [self.navigationController popToRootViewControllerAnimated:YES];
                
                
                
            }else{
                //            [DDProgressHUD dismiss];
                [DDProgressHUD showErrorImageWithInfo:[json objectForKey:@"message"]];
                
            }
        } failure:^(NSError *error) {
            [DDProgressHUD showErrorImageWithInfo:error.localizedDescription];
        }];
  
    }];


    
}

// 撤销第一相应
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.nameTextFiled resignFirstResponder];
    [self.telTextFiled resignFirstResponder];
    [self.remarksView resignFirstResponder];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.nameTextFiled resignFirstResponder];
    [self.telTextFiled resignFirstResponder];
    [self.remarksView resignFirstResponder];
}
/**
 *  UITextView的代理方法
 */
-(void) textViewDidChange:(UITextView *)textView
{
    
    if (self.remarksView.text.length == 0) {
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

-(void)addBtn:(UIButton*)sender{
    
 
    [self pushTZImagePickerController];

}

#pragma mark - TZImagePickerController

- (void)pushTZImagePickerController {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:3 columnNumber:3 delegate:self pushPhotoPickerVc:YES];
    
    
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    
    
    imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    
    imagePickerVc.allowTakePicture = YES;
    [imagePickerVc setUiImagePickerControllerSettingBlock:^(UIImagePickerController *imagePickerController) {
        imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    }];
    
    // 2. 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    // imagePickerVc.navigationBar.translucent = NO;
    imagePickerVc.iconThemeColor = [UIColor colorWithRed:31 / 255.0 green:185 / 255.0 blue:34 / 255.0 alpha:1.0];
    imagePickerVc.showPhotoCannotSelectLayer = YES;
    imagePickerVc.cannotSelectLayerColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    [imagePickerVc setPhotoPickerPageUIConfigBlock:^(UICollectionView *collectionView, UIView *bottomToolBar, UIButton *previewButton, UIButton *originalPhotoButton, UILabel *originalPhotoLabel, UIButton *doneButton, UIImageView *numberImageView, UILabel *numberLabel, UIView *divideLine) {
        [doneButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }];

    
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.sortAscendingByModificationDate = YES;
    imagePickerVc.showSelectBtn = NO;
    
    // 设置竖屏下的裁剪尺寸
    NSInteger left = 30;
    NSInteger widthHeight = mDeviceWidth - 2 * left;
    NSInteger top = (mDeviceHeight - widthHeight) / 2;
    imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
    
    imagePickerVc.statusBarStyle = UIStatusBarStyleLightContent;
    
    // 设置是否显示图片序号
    imagePickerVc.showSelectedIndex = YES;
    
    
    
    
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {

    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}



// 调用相机
- (void)pushImagePickerController {
    // 提前定位
    __weak typeof(self) weakSelf = self;
    [[TZLocationManager manager] startLocationWithSuccessBlock:^(NSArray<CLLocation *> *locations) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.location = [locations firstObject];
    } failureBlock:^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.location = nil;
    }];
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVC.sourceType = sourceType;
        NSMutableArray *mediaTypes = [NSMutableArray array];

        [mediaTypes addObject:(NSString *)kUTTypeImage];

        if (mediaTypes.count) {
            _imagePickerVC.mediaTypes = mediaTypes;
        }
        [self presentViewController:_imagePickerVC animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    tzImagePickerVc.sortAscendingByModificationDate = YES;
    [tzImagePickerVc showProgressHUD];
    if ([type isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image location:self.location completion:^(PHAsset *asset, NSError *error){
            [tzImagePickerVc hideProgressHUD];
            if (error) {
                NSLog(@"图片保存失败 %@",error);
            } else {
                TZAssetModel *assetModel = [[TZImageManager manager] createModelWithAsset:asset];

                [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];

            }
        }];
    }
}

- (void)refreshCollectionViewWithAddedAsset:(PHAsset *)asset image:(UIImage *)image {
    
    [_selectedAssets addObject:asset];
    [_selectedPhotos addObject:image];
//    [self.tableV reloadData];
    [self setImageView];

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

#pragma mark - TZImagePickerControllerDelegate


- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
//    [_tableV reloadData];

    [self setImageView];
}
@end
