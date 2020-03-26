
//
//  yzRepairsController.m
//  悦宅云
//
//  Created by 尚广杰 on 2019/4/22.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import "yzRepairsController.h"
#import "TZImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "JZLPhotoBrowser.h"      //图片展示
#import "tenementClassModel.h"
#import "tenementAddResultViewController.h" //添加结果
@interface yzRepairsController ()<TZImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    
}
@property(nonatomic,strong)UIImagePickerController* imagePickerVC;


@property (nonatomic, strong) NSMutableArray *classTypeArray;//报修类型
@property (strong, nonatomic) CLLocation *location;
@property(nonatomic,strong)UIButton* showBtn;
@property(nonatomic,strong)UIButton* addBtn;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property(nonatomic,strong)UILabel* promptLabel;
@property(nonatomic,strong)UIView* showImageView;
@end

@implementation yzRepairsController
-(NSMutableArray *)classTypeArray{
    if (!_classTypeArray) {
        _classTypeArray = [[NSMutableArray alloc] init];
    }
    return _classTypeArray;
}
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
    [self scrollView];
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
    
    [backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn.titleLabel setFont:[UIFont fontWithName:@"HYJinChangTiJ" size:16]];
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

#pragma mark -- 布局
-(void)setUI{
    //小区
    self.quLabel = [[UILabel alloc]init];
    self.quLabel.font = YSize(14.0);
    self.quLabel.text = @"小      区：";
    self.quLabel.textColor = [UIColor blackColor];
    CGRect rect = Rect(@"报修类型：", 150, YSize(14.0));
    
    self.quLabel.frame = CGRectMake(15, 15, rect.size.width, rect.size.height);
    [self.scrollV addSubview:self.quLabel];
    
    
    self.quNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.quLabel.frame) + 10, self.quLabel.frame.origin.x, mDeviceWidth - rect.size.width - 50, rect.size.height)];
    self.quNameLabel.font = YSize(14.0);
    self.quNameLabel.text = self.name;
    self.quNameLabel.textColor = [UIColor blackColor];
    [self.scrollV addSubview:self.quNameLabel];
    
    //报修类型
    self.typeLabel = [[UILabel alloc]init];
    self.typeLabel.font = YSize(14.0);
    self.typeLabel.text = @"报修类型：";
    self.typeLabel.textColor = [UIColor blackColor];
    
    self.typeLabel.frame = CGRectMake(15, CGRectGetMaxY(self.quLabel.frame) + 20, rect.size.width, rect.size.height);
    [self.scrollV addSubview:self.typeLabel];
    
    //循环三个按钮
    for (int i = 0; i < 3; i++) {
        NSArray* arr = @[@" 设备",@" 房屋",@" 其它"];
        UIButton* typeBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.typeLabel.frame) + 5 + 60*i, self.typeLabel.frame.origin.y, 60, rect.size.height)];
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
    
    
    
    
    
    
    //姓名
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = YSize(14.0);
    self.nameLabel.text = @"姓      名：";
    self.nameLabel.textColor = [UIColor blackColor];
    
    self.nameLabel.frame = CGRectMake(15, CGRectGetMaxY(self.typeLabel.frame) + 20, rect.size.width, rect.size.height);
    [self.scrollV addSubview:self.nameLabel];
    
    
    self.nameFiled = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.nameLabel.frame) + 10, self.nameLabel.frame.origin.y - (10 - rect.size.height/2), self.quNameLabel.frame.size.width, 20)];
    self.nameFiled.font = YSize(14.0);
    self.nameFiled.placeholder = @"请输入用户名";
    [self.scrollV addSubview:self.nameFiled];
    
    //电话
    self.telLabel = [[UILabel alloc]init];
    self.telLabel.font = YSize(14.0);
    self.telLabel.text = @"电      话：";
    self.telLabel.textColor = [UIColor blackColor];
    
    self.telLabel.frame = CGRectMake(15, CGRectGetMaxY(self.nameLabel.frame) + 20, rect.size.width, rect.size.height);
    [self.scrollV addSubview:self.telLabel];
    
    self.telFiled = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.telLabel.frame) + 10, self.telLabel.frame.origin.y - (10 - rect.size.height/2), self.quNameLabel.frame.size.width, 20)];
    self.telFiled.font = YSize(14.0);
    self.telFiled.placeholder = @"请输入联系方式";
        [self.telFiled addTarget:self action:@selector(phoneNumberTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.scrollV addSubview:self.telFiled];
    
    //问题描述
    self.questionLabel = [[UILabel alloc]init];
    self.questionLabel.font = YSize(14.0);
    self.questionLabel.text = @"问题描述：";
    self.questionLabel.textColor = [UIColor blackColor];
    
    self.questionLabel.frame = CGRectMake(15, CGRectGetMaxY(self.telLabel.frame) + 20, rect.size.width, rect.size.height);
    [self.scrollV addSubview:self.questionLabel];
    
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.questionLabel.frame) + 10,self.questionLabel.frame.origin.y, self.quNameLabel.frame.size.width, 110)];
    self.textView.delegate = self;
    self.textView.font = [UIFont systemFontOfSize:15.0];
    self.textView.layer.borderColor = RGB(240, 240, 240).CGColor;
    self.textView.layer.borderWidth = 1;
    self.textView.layer.cornerRadius = 5;
    
    [self.scrollV addSubview:self.textView];
    
    
    //textview的提示框
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5,5, self.quNameLabel.frame.size.width - 10, 20)];
    label.enabled = NO;
    label.text = @"请简单的描述问题（0-200字）";
    label.font =  YSize(13.0);
    label.textColor = RGB(240, 240, 240);
    self.promptLabel = label;
    [self.textView addSubview:self.promptLabel];
    
    
    
    
    //图片上传
    self.imageLabel = [[UILabel alloc]init];
    self.imageLabel.font = YSize(14.0);
    self.imageLabel.text = @"图片上传：";
    self.imageLabel.textColor = [UIColor blackColor];
    
    self.imageLabel.frame = CGRectMake(15, CGRectGetMaxY(self.questionLabel.frame) + 120, rect.size.width, rect.size.height);
    [self.scrollV addSubview:self.imageLabel];
    
    
    self.countLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.imageLabel.frame) + 10, self.imageLabel.frame.origin.y, mDeviceWidth - rect.size.width - 50, rect.size.height)];
    self.countLabel.font = YSize(14.0);
    self.countLabel.text = @"请上传图片（1-3张）";
    self.countLabel.textColor = [UIColor lightGrayColor];
    [self.scrollV addSubview:self.countLabel];
    
    self.showImageView = [[UIView alloc]initWithFrame:CGRectMake(self.quNameLabel.frame.origin.x, CGRectGetMaxY(self.countLabel.frame) + 20, mDeviceWidth - rect.size.width - 40, 50)];
    [self.showImageView setBackgroundColor:[UIColor clearColor]];
    
    [self.scrollV addSubview:self.showImageView];
    
    
    
    
    [self setImageView];
    
    
    
    
    
    
    self.submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.countLabel.frame) + 150, mDeviceWidth - 20, 40)];
    [self.submitBtn setBackgroundColor:[UIColor redColor]];
    [self.submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    self.submitBtn.layer.cornerRadius = 4;
    [self.submitBtn addTarget:self action:@selector(submitBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollV addSubview:self.submitBtn];
}

- (void)textViewDidChange:(UITextView *)textView

{
    
    if (self.telFiled.text.length == 0) {
        self.promptLabel.hidden = NO;
    }else
    {
        self.promptLabel.hidden = YES;
    }
    
}

#pragma mark -- 类型选择
-(void)seleTypeBtn:(UIButton*)sender{
    for (int i = 0; i<3; i++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:10+i];
        [button setImage:[UIImage imageNamed:@"right_nor"] forState:UIControlStateNormal];
    }
    
    [sender setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
    
    
    for (int i = 0; i < self.classTypeArray.count; i ++) {
        tenementClassModel *classModel = (tenementClassModel *)[self.classTypeArray objectAtIndex:i];
        

        NSString *newStr= [sender.titleLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([classModel.t_display isEqualToString:newStr]) {
            classModel.isSelected = YES;
        }else{
            classModel.isSelected = NO;
        }
    }
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


#pragma mark -- 提交
-(void)submitBtn:(UIButton*)sender{
    if (self.nameFiled.text.length == 0) {
        [DDProgressHUD showErrorImageWithInfo:@"请输入姓名"];
        return;
    }
    
    if (self.telFiled.text.length == 0) {
        [DDProgressHUD showErrorImageWithInfo:@"请输入电话"];
        return;
    }else{
        BOOL isTel = [CCAFNetWork validateContactNumber:self.telFiled.text];
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
    //获取小区数据
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"XiaoQuModel"];
    yzXiaoQuModel* quModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    
    for (int i = 0; i < self.classTypeArray.count; i ++) {
        tenementClassModel *classModel = (tenementClassModel *)[self.classTypeArray objectAtIndex:i];
        if (classModel.isSelected) {
            repTypeId = classModel.t_id;
        }
    }
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        [CCAFNetWork post:[NSString stringWithFormat:@"%@app/probaoxiu/save",postUrl] version:Token parameters:@{@"proXiaoquId":quModel.xiaoqu_id,@"baoxiuType":repTypeId,@"baoxiuName":self.nameFiled.text,@"baoxiuPhone":self.telFiled.text,@"appUserId":[yzUserInfoModel getLoginUserInfo:@"userId"],@"proRoomId":quModel.roomId,@"baoxiuInfo":self.textView.text,@"baoxiuPic1":imageArray.count>0?imageArray[0]:@"",@"baoxiuPic2":imageArray.count>1?imageArray[1]:@"",@"baoxiuPic3":imageArray.count>2?imageArray[2]:@""} success:^(id object) {
            
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
        
    }];
    
   
}


//图片展示view
-(void)setImageView{
    
    
    
    NSLog(@"---%@",_selectedPhotos);
    [self.showImageView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    

    if (_selectedPhotos.count>0) {

        for (int i = 0; i < _selectedPhotos.count; i++) {
            self.showBtn = [[UIButton alloc]initWithFrame:CGRectMake((50 + 10)*i, 0, 50, 50)];
            self.showBtn.tag = i;
            [self.showBtn addTarget:self action:@selector(showBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self.showBtn setBackgroundImage:_selectedPhotos[i] forState:UIControlStateNormal];
            [self.showImageView addSubview:self.showBtn];
        }
    }else{
        [self.showBtn removeFromSuperview];
     
    }
    
    
    self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addBtn setBackgroundImage:[UIImage imageNamed:@"上传照片"] forState:UIControlStateNormal];
    if (_selectedPhotos.count>0) {
        self.addBtn.frame = CGRectMake(CGRectGetMaxX(self.showBtn.frame) + 10, 0, 50, 50);
    }else{
        self.addBtn.frame = CGRectMake(0, 0, 50, 50);
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

#pragma mark- 手机号输入框的事件
- (void)phoneNumberTextFieldDidChange:(UITextField *)textField{
    
    
    if (textField.text.length > 11) {
        textField.text = [textField.text substringToIndex:11];
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.nameFiled resignFirstResponder];
    [self.telFiled resignFirstResponder];
     [self.textView resignFirstResponder];
}
@end
