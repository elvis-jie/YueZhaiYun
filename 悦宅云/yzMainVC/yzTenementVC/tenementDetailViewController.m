//
//  tenementDetailViewController.m
//  yzProduct
//
//  Created by LiuHQ on 2018/9/27.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "tenementDetailViewController.h"
#import "tenementInfoModel.h"
#import "JZLPhotoBrowser.h"
@interface tenementDetailViewController ()
@property (nonatomic, strong) tenementInfoModel *infoModel;
@property (nonatomic, strong) NSMutableArray* imageArr;
@end

@implementation tenementDetailViewController
-(tenementInfoModel *)infoModel{
    if (!_infoModel) {
        _infoModel = [[tenementInfoModel alloc] init];
    }
    return _infoModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.cancleBtn.layer.cornerRadius = 35/2;
    self.cancleBtn.layer.borderColor = RGB(251, 53, 0).CGColor;
    self.cancleBtn.layer.borderWidth = 1;
    
    
    self.doneBtn.layer.cornerRadius = 35/2;
    [self.doneBtn setBackgroundColor:RGB(251, 53, 0)];
    
    self.imageArr = [NSMutableArray array];
    [self getTenDetail];
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
    [titleLabel setText:@"报修详情"];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
/** 获取报修单信息 */
-(void)getTenDetail{
    [DDProgressHUD show];
    [CCAFNetWork get:[NSString stringWithFormat:@"%@app/probaoxiu/findById",postUrl] version:Token parameters:@{@"id":self.ten_id} success:^(id object) {
        NSDictionary *json = object;
        if ([[json objectForKey:@"code"] intValue] == 200) {
            [DDProgressHUD dismiss];
            self.infoModel = [[tenementInfoModel alloc] init:[json[@"data"] JSONValue]];
            //设置数据
            [self setupUIData];
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
-(void)setupUIData{
    if (self.infoModel.list_baoxiuState.t_value == 1) {
        [self.tenState setText:@"已提交"];
        self.tenStateSlider.value = 0;
        self.doneBtn.hidden = YES;
    }else if (self.infoModel.list_baoxiuState.t_value == 2) {
        [self.tenState setText:@"处理中"];
        self.tenStateSlider.value = 0.5;
        self.cancleBtn.hidden = YES;
    }else if (self.infoModel.list_baoxiuState.t_value == 3){
        [self.tenState setText:@"已完成"];
        self.tenStateSlider.value = 1;
    
        self.cancleBtn.hidden = YES;
        self.doneBtn.hidden = YES;
    }else{
        [self.tenState setText:@"已取消"];
        self.tenStateSlider.value = 1;
        
        self.cancleBtn.hidden = YES;
        self.doneBtn.hidden = YES;
    }
    [self.tenQuName setText:[self.infoModel.xiaoQuDic objectForKey:@"name"]];
    [self.tenBName setText:self.infoModel.list_baoxiuName];
    [self.tenMobile setText:self.infoModel.list_baoxiuPhone];
    [self.tenRemarks setText:self.infoModel.list_baoxiuInfo];
    float height = [yzProductPubObject heightForString:self.tenRemarks.text fontSize:self.tenRemarks.font.pointSize andWidth:AutoWitdh(216)];
    self.tenRemarkHeightLayou.constant = height;
    int picCount = 0;
    if (self.infoModel.list_baoxiuPic1.length > 0) {
        picCount ++;
        [self.tenPicOne sd_setImageWithURL:[NSURL URLWithString:self.infoModel.list_baoxiuPic1] forState:UIControlStateNormal placeholderImage:FaultClassImg options:SDWebImageRefreshCached];
        [self.imageArr addObject:self.infoModel.list_baoxiuPic1];
    }
    if (self.infoModel.list_baoxiuPic2.length > 0) {
        picCount ++;
        [self.tenPicTwo sd_setImageWithURL:[NSURL URLWithString:self.infoModel.list_baoxiuPic2] forState:UIControlStateNormal placeholderImage:FaultClassImg options:SDWebImageRefreshCached];
        [self.imageArr addObject:self.infoModel.list_baoxiuPic2];
    }
    if (self.infoModel.list_baoxiuPic3.length > 0) {
        picCount ++;
        [self.tenPicThree sd_setImageWithURL:[NSURL URLWithString:self.infoModel.list_baoxiuPic3] forState:UIControlStateNormal placeholderImage:FaultClassImg options:SDWebImageRefreshCached];
        [self.imageArr addObject:self.infoModel.list_baoxiuPic3];
    }
    [self.tenPicNum setText:[NSString stringWithFormat:@"%d/3",picCount]];
    
    
}

- (IBAction)btn1:(id)sender {
    if (self.imageArr.count>0) {
            [JZLPhotoBrowser showPhotoBrowserWithUrlArr:self.imageArr currentIndex:0 originalImageViewArr:self.imageArr];
    }
}
- (IBAction)btn2:(id)sender {
    if (self.imageArr.count>1) {
        [JZLPhotoBrowser showPhotoBrowserWithUrlArr:self.imageArr currentIndex:1 originalImageViewArr:self.imageArr];
    }
}
- (IBAction)btn3:(id)sender {
    if (self.imageArr.count>2) {
        [JZLPhotoBrowser showPhotoBrowserWithUrlArr:self.imageArr currentIndex:2 originalImageViewArr:self.imageArr];
    }
}


- (IBAction)cancelClick:(id)sender {
    [DDProgressHUD showErrorImageWithInfo:@"取消报修中..."];
    [CCAFNetWork get:[NSString stringWithFormat:@"%@app/probaoxiu/cancel",postUrl] version:Token parameters:@{@"id":self.infoModel.list_id} success:^(id object) {
        NSDictionary *json = object;
        if ([[json objectForKey:@"code"] intValue] == 200) {
            [DDProgressHUD showSuccessImageWithInfo:json[@"message"]];
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

- (IBAction)okClick:(id)sender {
    [DDProgressHUD showErrorImageWithInfo:@"完成报修中..."];
    [CCAFNetWork get:[NSString stringWithFormat:@"%@app/probaoxiu/baoxiuEndTimeAndState",postUrl] version:Token parameters:@{@"id":self.infoModel.list_id} success:^(id object) {
        NSDictionary *json = object;
        if ([[json objectForKey:@"code"] intValue] == 200) {
            [DDProgressHUD showSuccessImageWithInfo:json[@"message"]];
        }else if ([[json objectForKey:@"code"] intValue] == -6){
            [DDProgressHUD dismiss];
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
