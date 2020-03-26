//
//  tenementAddViewController.m
//  yzProduct
//
//  Created by LiuHQ on 2018/9/27.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "tenementAddViewController.h"
#import "indexTopLocationView.h" //顶部选择view
#import "WPhotoViewController.h"
#import "FeedImagesView.h"
#import "GKPhotoBrowser.h"
#import "tenementClassModel.h"
#import "tenementAddResultViewController.h" //添加结果


#import "TZImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"


#import "TZLocationManager.h"
#import "TZAssetCell.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface tenementAddViewController ()<UITextFieldDelegate,UITextViewDelegate,TZImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    
}
@property(nonatomic,strong)UIImagePickerController* imagePickerVC;
@property (strong, nonatomic) CLLocation *location;

@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) indexTopLocationView *topLocationView;//社区选择view
@property (nonatomic, assign) BOOL isShowTop;//是否显示顶部view
@property (nonatomic, strong) NSString *xiaoQuId;
//@property (strong, nonatomic) NSMutableArray *imageArray;
@property(nonatomic, strong)FeedImagesView *feedImagesView;//图片视图
@property (nonatomic, strong) NSMutableArray *classTypeArray;//报修类型
@end

@implementation tenementAddViewController
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


//-(NSMutableArray *)imageArray{
//    if (!_imageArray) {
//        _imageArray = [[NSMutableArray alloc] init];
//    }
//    return _imageArray;
//}
-(NSMutableArray *)classTypeArray{
    if (!_classTypeArray) {
        _classTypeArray = [[NSMutableArray alloc] init];
    }
    return _classTypeArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tenName.delegate = self;
    self.tenMobile.delegate = self;
    self.renRemark.delegate = self;
    
    
    
    
    self.xiaoQuId = [[NSUserDefaults standardUserDefaults] objectForKey:@"xiaoqu_id"];
    [self.roomName setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"xiaoqu_name"] forState:UIControlStateNormal];
    
    //textview的提示框
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 200, 20)];
    label.enabled = NO;
    label.text = @"请简单描述您的问题......";
    label.font =  [UIFont fontWithName:@"HYJinChangTiJ" size:15];
    label.textColor = [UIColor whiteColor];
    self.promptLabel = label;
    [self.renRemark addSubview:label];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    //选择图片
    [self.tenPicView addSubview:self.feedImagesView];
    //图片 或者 视频
    [self.feedImagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tenPicView.mas_top);
        make.left.equalTo(self.tenPicView.mas_left);
        make.right.equalTo(self.tenPicView.mas_right);
        make.height.mas_equalTo(0).priorityLow();
        make.bottom.equalTo(self.tenPicView.mas_bottom);
    }];
    
    [self getOrderState];
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
    [titleLabel setText:@"物业报修"];
    [titleLabel setFrame:CGRectMake(0, 0, mDeviceWidth/2, NavTopHeight)];
    [titleLabel setFont:[UIFont fontWithName:@"HYJinChangTiJ" size:18]];
    [titleLabel setTextColor:RGB(22, 22, 22)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.navigationController.visibleViewController.navigationItem setTitleView:titleLabel];
    [self.navigationController.visibleViewController.navigationItem setRightBarButtonItem:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.topLocationView _tapGesturePressed];
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
    
    if (self.renRemark.text.length == 0) {
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
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (self.isShowTop) {
        //隐藏
        [self.topLocationView _tapGesturePressed];
    }
    self.isShowTop = !self.isShowTop;
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
    [self.tenMobile resignFirstResponder];
    [self.tenName resignFirstResponder];
    [self.renRemark resignFirstResponder];
    
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
     [self keyboardHide:nil];
    if ([self.roomName.titleLabel.text isEqualToString:@"请选择小区"]) {
        [DDProgressHUD showErrorImageWithInfo:@"请选择小区"];
        return;
    }
    if (self.tenName.text.length == 0) {
        [DDProgressHUD showErrorImageWithInfo:@"请输入姓名"];
        return;
    }
    if (self.tenMobile.text.length == 0) {
        [DDProgressHUD showErrorImageWithInfo:@"请输入电话"];
        return;
    }else{
        BOOL isTel = [self validateContactNumber:self.tenMobile.text];
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
-(void)sendComplain:(NSArray *)imageArray{
    [DDProgressHUD showWithStatus:@"提交中..."];
    NSString *repTypeId = @"";
    for (int i = 0; i < self.classTypeArray.count; i ++) {
        tenementClassModel *classModel = (tenementClassModel *)[self.classTypeArray objectAtIndex:i];
        if (classModel.isSelected) {
            repTypeId = classModel.t_id;
        }
    }
    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/probaoxiu/save",postUrl] version:Token parameters:@{@"proXiaoquId":self.xiaoQuId,@"baoxiuType":repTypeId,@"baoxiuName":self.tenName.text,@"baoxiuPhone":self.tenMobile.text,@"appUserId":[yzUserInfoModel getLoginUserInfo:@"userId"],@"baoxiuInfo":self.renRemark.text,@"baoxiuPic1":imageArray.count>0?imageArray[0]:@"",@"baoxiuPic2":imageArray.count>1?imageArray[1]:@"",@"baoxiuPic3":imageArray.count>2?imageArray[2]:@""} success:^(id object) {
        
        NSDictionary *json = object;
        if ([[json objectForKey:@"code"] intValue] == 200) {
            [DDProgressHUD dismiss];//showSuccessImageWithInfo:[json objectForKey:@"message"]];
            tenementAddResultViewController *resultView = [[tenementAddResultViewController alloc] init];
            resultView.result = 1;
            resultView.ten_id = [json objectForKey:@"data"];
            [self presentViewController:[yzProductPubObject navc:resultView] animated:YES completion:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else if ([[json objectForKey:@"code"] intValue] == -6){
            [DDProgressHUD dismiss];
            [yzUserInfoModel userLoginOut];
            [yzUserInfoModel setLoginState:NO];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
            
        }else{
            [DDProgressHUD dismiss];//showErrorImageWithInfo:[json objectForKey:@"message"]];
            tenementAddResultViewController *resultView = [[tenementAddResultViewController alloc] init];
            resultView.result = 0;
            [self presentViewController:[yzProductPubObject navc:resultView] animated:YES completion:^{

            }];
        }
    } failure:^(NSError *error) {
        [DDProgressHUD showErrorImageWithInfo:error.localizedDescription];
    }];
}
-(FeedImagesView *)feedImagesView{
    WEAKSELF
    if (!_feedImagesView) {
        _feedImagesView = [[FeedImagesView alloc] init];
        [_feedImagesView setBackgroundColor:[UIColor clearColor]];
        [_feedImagesView setFeedImageclickBlock:^(NSInteger index) {
            NSMutableArray *photos = [NSMutableArray new];
            
            for (int i = 0; i < _selectedPhotos.count; i ++) {
                GKPhoto *photo = [GKPhoto new];
//                photo.image = [weakSelf.imageArray[i] objectForKey:@"image"];
                photo.image = _selectedPhotos[i];
                [photos addObject:photo];
            }
            GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photos currentIndex:index];
            browser.showStyle = GKPhotoBrowserShowStyleNone;
            browser.loadStyle = GKPhotoBrowserLoadStyleDeterminate;
            [browser showFromVC:weakSelf];
        }];
    }
    return _feedImagesView;
}
- (IBAction)addPicClick:(id)sender {
     [self keyboardHide:nil];
    WEAKSELF
//    self.imageArray = nil;
//    WPhotoViewController *WphotoVC = [[WPhotoViewController alloc] init];
//    //选择图片的最大数
//    WphotoVC.selectPhotoOfMax = 3;
//    [WphotoVC setSelectPhotosBack:^(NSMutableArray *phostsArr) {
//        weakSelf.imageArray = phostsArr;
//        //更新scrollview
//        if ([phostsArr count] == 0 ) {
//            [self.feedImagesView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.height.mas_equalTo(0).priorityMedium();
//            }];
//        }
//        [self.feedImagesView setImagesArrays:phostsArr];
//    }];
//    [self presentViewController:WphotoVC animated:YES completion:nil];
    
    [self pushTZImagePickerController];
    
}

- (IBAction)typeClick:(id)sender {
     [self keyboardHide:nil];
    UIButton *button = (UIButton *)sender;
    if (button.tag == 0) {
        self.typeOne.selected = YES;
        self.typeTwo.selected = NO;
        self.typeThree.selected = NO;
    }else if (button.tag == 1) {
        self.typeOne.selected = NO;
        self.typeTwo.selected = YES;
        self.typeThree.selected = NO;
    }else{
        self.typeOne.selected = NO;
        self.typeTwo.selected = NO;
        self.typeThree.selected = YES;
    }
    for (int i = 0; i < self.classTypeArray.count; i ++) {
        tenementClassModel *classModel = (tenementClassModel *)[self.classTypeArray objectAtIndex:i];
        if ([classModel.t_display isEqualToString:button.titleLabel.text]) {
            classModel.isSelected = YES;
        }else{
            classModel.isSelected = NO;
        }
    }
}

- (IBAction)selectedQuClick:(id)sender {
     [self keyboardHide:nil];
    WEAKSELF
    if (self.isShowTop) {
        //隐藏
        [self.topLocationView _tapGesturePressed];
    }else{
        //获取小区数据
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"XiaoQuArray"];
        NSArray *oldSavedArray = nil;
        if (oldSavedArray == nil) {
           oldSavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
        
        NSMutableArray *xiaoquArray = [[NSMutableArray alloc] init];
        NSString *xiaoqu_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"xiaoqu_id"];
//        for (int i = 0; i < oldSavedArray.count; i ++) {
//            yzXiaoQuModel *xiaoquModel = (yzXiaoQuModel *)[oldSavedArray objectAtIndex:i];
//            if ([xiaoquModel.xiaoqu_id isEqualToString:xiaoqu_id]) {
//                xiaoquModel.isSelected = YES;
//            }else{
//                xiaoquModel.isSelected = NO;
//            }
//            [xiaoquArray addObject:xiaoquModel];
//        }
        
        self.topLocationView = [[indexTopLocationView alloc] initWithFrame:CGRectMake(50, self.roomName.frame.size.height+self.roomName.frame.origin.y+44, mDeviceWidth-100, 200)];
        [self.topLocationView option_show];
        [self.topLocationView setPxCookModel:xiaoquArray];
        [self.topLocationView setSelectedRoomBlock:^(NSString *room_id, NSString *room_name,NSString* wuye_id) {
            weakSelf.xiaoQuId = room_id;
            [weakSelf.roomName setTitle:room_name forState:UIControlStateNormal];
        }];
    }
    self.isShowTop = !self.isShowTop;
}
//获取报修订单状态
-(void)getOrderState{
    ///
    [CCAFNetWork get:[NSString stringWithFormat:@"%@app/probaoxiu/getBaoxiuType",postUrl] version:Token parameters:nil success:^(id object) {
        NSDictionary *json = object;
        if ([[json objectForKey:@"code"] intValue] == 200) {
            [DDProgressHUD dismiss];
            NSMutableArray *itemClass = [json objectForKey:@"data"];
            for (int i = 0; i < itemClass.count; i ++) {
                tenementClassModel *classModel = [[tenementClassModel alloc] init:itemClass[i]];
                if ([classModel.t_display isEqualToString:@"设备"]) {
                    classModel.isSelected = YES;
                }
                [self.classTypeArray addObject:classModel];
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
    
    if ([_selectedPhotos count] == 0 ) {
        [self.feedImagesView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0).priorityMedium();
        }];
    }
    [self.feedImagesView setImagesArray:_selectedPhotos];
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
    if ([_selectedPhotos count] == 0 ) {
        [self.feedImagesView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0).priorityMedium();
        }];
    }
    [self.feedImagesView setImagesArray:_selectedPhotos];
    
}
@end
