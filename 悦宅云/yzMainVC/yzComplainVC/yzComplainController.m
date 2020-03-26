//
//  yzComplainController.m
//  悦宅云
//
//  Created by 尚广杰 on 2019/4/20.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import "yzComplainController.h"
#import "TZImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "JZLPhotoBrowser.h"      //图片展示

#import "TZLocationManager.h"
#import "TZAssetCell.h"
@interface yzComplainController ()<TZImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate,UIScrollViewDelegate>
{
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    
}
@property(nonatomic,strong)UIImagePickerController* imagePickerVC;

@property(nonatomic,strong)UITextField* phoneT;

@property (strong, nonatomic) CLLocation *location;

@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property(nonatomic,strong)UIButton* showBtn;
@property(nonatomic,strong)UIButton* addBtn;


@property(nonatomic,strong)UITextView* remarksView;
@property(nonatomic,strong)UILabel* promptLabel;
@property(nonatomic,strong)UILabel* countL;            //底部计数
@property(nonatomic,strong)UIView* showImageView;       //图片列表view


@property(nonatomic,strong)UILabel* imageCount;     //图片计数器

@property(nonatomic,strong)UIButton* submitBtn;
@property(nonatomic,strong)UIScrollView* scrollV;
@property (nonatomic, assign) int type_id;//类型id
@end

@implementation yzComplainController
-(UIScrollView *)scrollView{
    if (!_scrollV) {
        _scrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, mDeviceWidth, mDeviceHeight)];
        _scrollV.delegate = self;
        _scrollV.contentSize = CGSizeMake(mDeviceWidth, mDeviceHeight + 100);
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
    _type_id = 0;
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
    [backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn.titleLabel setFont:[UIFont fontWithName:@"HYJinChangTiJ" size:16]];
    [backBtn setTitleColor:AppBackTitleColor forState:UIControlStateNormal];
    [backBtn setFrame:CGRectMake(0, 0, AutoWitdh(32), AutoWitdh(32))];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationController.visibleViewController.navigationItem setLeftBarButtonItem:backItem];
    
    //顶部信息
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setText:@"物业投诉"];
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


#pragma mark -- 设置页面
-(void)setUI{
    //投诉类型
    UILabel* comType = [[UILabel alloc]init];
    comType.font = YSize(14.0);
    comType.textAlignment = NSTextAlignmentLeft;
    
    NSString* str = @"*  投诉类型:";
    // 创建Attributed
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:str];
    // 需要改变的区间(第一个参数，从第几位起，长度)
    NSRange range = NSMakeRange(0, 1);
    // 改变字体大小及类型
    [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:range];
    // 改变文字颜色
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    // 为label添加Attributed
    [comType setAttributedText:noteStr];
    CGRect rect = Rect(str, 200, YSize(14.0));
    comType.frame = CGRectMake(15, 20, rect.size.width, rect.size.height);
    [self.scrollV addSubview:comType];
    
    
    //循环三个按钮
    for (int i = 0; i < 3; i++) {
        NSArray* arr = @[@" 物业",@" 管家",@" 其它"];
        UIButton* typeBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(comType.frame) + 10 + 60*i, 20 - (10 - rect.size.height/2), 60, 20)];
        typeBtn.titleLabel.font = YSize(15.0);
        typeBtn.tag = 10 + i;
        [typeBtn setTitle:arr[i] forState:UIControlStateNormal];
        if (i==0) {
            
            [typeBtn setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
        }else{
         [typeBtn setImage:[UIImage imageNamed:@"right_nor"] forState:UIControlStateNormal];
        }
        
        
        
        [typeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [typeBtn addTarget:self action:@selector(seleTypeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollV addSubview:typeBtn];
    }
    
    //投诉内容
    UILabel* contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(comType.frame) + 20, rect.size.width, rect.size.height)];
    contentLabel.font = YSize(14.0);
    contentLabel.textAlignment = NSTextAlignmentLeft;
    
    NSString* str1 = @"*  投诉内容:";
    // 创建Attributed
    NSMutableAttributedString *noteStr1 = [[NSMutableAttributedString alloc] initWithString:str1];
    // 需要改变的区间(第一个参数，从第几位起，长度)

    // 改变字体大小及类型
    [noteStr1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:range];
    // 改变文字颜色
    [noteStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    // 为label添加Attributed
    [contentLabel setAttributedText:noteStr1];

    [self.scrollV addSubview:contentLabel];
    
    
    self.remarksView = [[UITextView alloc]initWithFrame:CGRectMake(15,CGRectGetMaxY(contentLabel.frame) + 5, mDeviceWidth - 30, 200)];
    self.remarksView.delegate = self;
    self.remarksView.font = [UIFont systemFontOfSize:15.0];
    self.remarksView.layer.borderColor = RGB(240, 240, 240).CGColor;
    self.remarksView.layer.borderWidth = 1;
    self.remarksView.layer.cornerRadius = 5;
    
    [self.scrollV addSubview:self.remarksView];
    
    
    //textview的提示框
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5,5, 200, 20)];
    label.enabled = NO;
    label.text = @"输入您将投诉的内容，不少于10字";
    label.font =  YSize(13.0);
    label.textColor = RGB(240, 240, 240);
    self.promptLabel = label;
    [self.remarksView addSubview:self.promptLabel];
    
    
    self.countL = [[UILabel alloc]initWithFrame:CGRectMake(self.remarksView.frame.size.width - 110, self.remarksView.frame.size.height - 30, 100, 20)];
    self.countL.textAlignment = NSTextAlignmentRight;
    self.countL.font = YSize(13.0);
    self.countL.text = @"0/50字";
    self.countL.textColor = [UIColor lightGrayColor];
    [self.remarksView addSubview:self.countL];
    
    
    self.showImageView = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.remarksView.frame) + 20, mDeviceWidth - 30, 60 + rect.size.height + 10)];
    [self.showImageView setBackgroundColor:[UIColor clearColor]];
    
    [self.scrollV addSubview:self.showImageView];
    
    
    
    
    [self setImageView];
    
    
    
    
    
    //联系方式
    UILabel* telLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.showImageView.frame) + 20, rect.size.width, rect.size.height)];
    telLabel.font = YSize(14.0);
    telLabel.textAlignment = NSTextAlignmentLeft;
    
    NSString* str2 = @"*  联系方式:";
    // 创建Attributed
    NSMutableAttributedString *noteStr2 = [[NSMutableAttributedString alloc] initWithString:str2];
    // 需要改变的区间(第一个参数，从第几位起，长度)
    
    // 改变字体大小及类型
    [noteStr2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:range];
    // 改变文字颜色
    [noteStr2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    // 为label添加Attributed
    [telLabel setAttributedText:noteStr2];
    
    [self.scrollV addSubview:telLabel];
    
    self.phoneT = [[UITextField alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(telLabel.frame) + 10, mDeviceWidth - 30, 40)];
    self.phoneT.placeholder = @"输入您的联系方式，我们将在第一时间内与您联系";
    self.phoneT.font = YSize(13.0);
    self.phoneT.borderStyle = UITextBorderStyleRoundedRect;
    [self.scrollV addSubview:self.phoneT];
    
    
    self.submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.phoneT.frame) + 60, mDeviceWidth - 30, 40)];
    [self.submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    self.submitBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self.submitBtn setBackgroundColor:[UIColor redColor]];
    self.submitBtn.layer.cornerRadius = 5;
    self.submitBtn.layer.masksToBounds = YES;
    [self.submitBtn addTarget:self action:@selector(submitBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollV addSubview:self.submitBtn];
}


- (void)textViewDidChange:(UITextView *)textView

{

    
        //实时显示字数
    
        self.countL.text = [NSString stringWithFormat:@"%lu/50字", (unsigned long)textView.text.length];
    
        
    
        //字数限制操作
    
        if (textView.text.length >= 50) {
        
                
        
                textView.text = [textView.text substringToIndex:50];
        
                self.countL.text = @"50/50字";
        
                
        
            }
    
        //取消按钮点击权限，并显示提示文字
    
    if (self.remarksView.text.length == 0) {
        self.promptLabel.hidden = NO;
    }else
    {
        self.promptLabel.hidden = YES;
    }
    
    
    
}
//图片展示view
-(void)setImageView{
    
    
    
    NSLog(@"---%@",_selectedPhotos);
    [self.showImageView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGRect rect = Rect(@"上传照片0/3", 150, YSize(14.0));
    
    self.imageCount = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    
    self.imageCount.text = @"上传照片0/3";
    self.imageCount.font = YSize(14.0);
    self.imageCount.textColor = RGB(200, 200, 200);
    self.imageCount.textAlignment = NSTextAlignmentRight;
    
    [self.showImageView addSubview:self.imageCount];
    if (_selectedPhotos.count>0) {
        self.imageCount.text = [NSString stringWithFormat:@"上传照片%lu/3",(unsigned long)_selectedPhotos.count];
        for (int i = 0; i < _selectedPhotos.count; i++) {
            self.showBtn = [[UIButton alloc]initWithFrame:CGRectMake((60 + 10)*i, CGRectGetMaxY(self.imageCount.frame) + 10, 60, 60)];
            self.showBtn.tag = i;
            [self.showBtn addTarget:self action:@selector(showBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self.showBtn setBackgroundImage:_selectedPhotos[i] forState:UIControlStateNormal];
            [self.showImageView addSubview:self.showBtn];
        }
    }else{
        [self.showBtn removeFromSuperview];
        self.imageCount.text = @"上传照片0/3";
    }
    
    
    self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addBtn setBackgroundImage:[UIImage imageNamed:@"上传照片"] forState:UIControlStateNormal];
    if (_selectedPhotos.count>0) {
        self.addBtn.frame = CGRectMake(CGRectGetMaxX(self.showBtn.frame) + 10, CGRectGetMaxY(self.imageCount.frame) + 10, 60, 60);
    }else{
        self.addBtn.frame = CGRectMake(0, CGRectGetMaxY(self.imageCount.frame) + 10, 60, 60);
    }
    
    [self.addBtn addTarget:self action:@selector(addBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.showImageView addSubview:self.addBtn];
    
    
    
    
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
#pragma mark -- 类型选择
-(void)seleTypeBtn:(UIButton*)sender{
    for (int i = 0; i<3; i++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:10+i];
       [button setImage:[UIImage imageNamed:@"right_nor"] forState:UIControlStateNormal];
    }

    [sender setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
    self.type_id = sender.tag - 10;
}
#pragma mark -- 提交
-(void)submitBtn:(UIButton*)sender{
//    [self keyboardHide:nil];
 
    if (self.phoneT.text.length == 0) {
        [DDProgressHUD showErrorImageWithInfo:@"请输入电话"];
        return;
    }else{
        BOOL isTel = [yzProductPubObject validateContactNumber:self.phoneT.text];
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
-(void)sendComplain:(NSArray*)imageArray{
     [DDProgressHUD showWithStatus:@"提交中..."];
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"XiaoQuModel"];
    yzXiaoQuModel* quModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    //管家  物业   建议
    NSArray *typeArray = @[@"3eb198188b0411e8a77400163e03ee3b",@"48f42a128b0411e8a77400163e03ee3b",@"56fd96d88b0411e8a77400163e03ee3b"];
    [DDProgressHUD showWithStatus:@"提交中..."];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [CCAFNetWork post:[NSString stringWithFormat:@"%@app/tousujianyi/save",postUrl] version:Token parameters:@{@"proXiaoquId":quModel.xiaoqu_id,@"tousuTypeId":[typeArray objectAtIndex:self.type_id],@"phone":self.phoneT.text,@"appUserId":[yzUserInfoModel getLoginUserInfo:@"userId"],@"tousuInfo":self.remarksView.text,@"pic1":imageArray.count>0?imageArray[0]:@"",@"pic2":imageArray.count>1?imageArray[1]:@"",@"pic3":imageArray.count>2?imageArray[2]:@""} success:^(id object) {
            NSDictionary *json = object;
            if ([[json objectForKey:@"code"] intValue] == 200) {
                [DDProgressHUD showSuccessImageWithInfo:[json objectForKey:@"message"]];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
    }];
   
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.remarksView resignFirstResponder];
    [self.phoneT resignFirstResponder];
 
}
@end
