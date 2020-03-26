//
//  yzVoteController.m
//  悦宅云
//
//  Created by 尚广杰 on 2019/4/19.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import "yzVoteController.h"
#import "yzEvaluateController.h"
@interface yzVoteController ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView* scrollView;
@property(nonatomic,strong)UIImageView* headImage;
@property(nonatomic,strong)NSArray* listArr;
@end

@implementation yzVoteController
-(UIScrollView *)scrollV{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, mDeviceWidth, mDeviceHeight - kNavBarHeight - KSAFEBAR_HEIGHT)];
        _scrollView.delegate = self;
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
  
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
            
        }
        _scrollView.contentSize = CGSizeMake(mDeviceWidth, mDeviceHeight + 100);
        [self.view addSubview:self.scrollView];
        
    }
    return _scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
     self.listArr = [NSArray array];
    [self scrollV];
    
    [self getPublicData];
}

-(void)getPublicData{
    //创建信号量
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(2);
    // 创建全局并行
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //任务 获取产品详细信息
    dispatch_async(quene, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        [self getList];
        dispatch_semaphore_signal(semaphore);
    });
    
}
-(void)getList{
    [DDProgressHUD show];
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"XiaoQuModel"];
    yzXiaoQuModel* quModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/paper/listProPaper",postUrl] version:Token parameters:@{@"page":@1,@"size":@10,@"xiaoQuId":quModel.xiaoqu_id} success:^(id object) {
        [DDProgressHUD dismiss];
        NSDictionary *json = object;
        
        if ([[json objectForKey:@"code"] intValue] == 200) {
            NSDictionary* contentDic = [[json objectForKey:@"data"] JSONValue];
            self.listArr = [contentDic objectForKey:@"content"];
          [self setUI];
            
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
    [titleLabel setText:@"参与投票"];
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


#pragma mark -- UI
-(void)setUI{
    self.headImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mDeviceWidth, mDeviceWidth/75*32)];
    self.headImage.image = [UIImage imageNamed:@"参与投票"];
    [self.scrollView addSubview:self.headImage];
    
    for (int i = 0; i<self.listArr.count; i++) {
        NSDictionary* dic = self.listArr[i];
        
        UIView* rectView = [[UIView alloc]initWithFrame:CGRectMake(10 + ((mDeviceWidth - 30)/2 + 10)*(i%2), mDeviceWidth/75*32 - 45 + ((mDeviceWidth - 30)/2 + 10)*(i/2), (mDeviceWidth - 30)/2, (mDeviceWidth - 30)/2)];
        
        [rectView setBackgroundColor:[UIColor whiteColor]];
        rectView.layer.cornerRadius = 5;
        rectView.layer.masksToBounds = NO;
        rectView.layer.shadowColor = [UIColor blackColor].CGColor;
        // 阴影偏移，默认(0, -3)
        rectView.layer.shadowOffset = CGSizeMake(0,0);
        // 阴影透明度，默认0
        rectView.layer.shadowOpacity = 0.3;
        // 阴影半径，默认3
        rectView.layer.shadowRadius = 2;
        
        rectView.tag = i;

        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        
        [rectView addGestureRecognizer:tap];
        
        UIImageView* imageV = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, rectView.frame.size.width - 10, (rectView.frame.size.width - 10)/1.28)];
        imageV.image = [UIImage imageNamed:@"评出"];
        [rectView addSubview:imageV];
        
        UILabel* titleL = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(imageV.frame) + 3, rectView.frame.size.width - 10, 15)];
        
        titleL.numberOfLines = 1;
        titleL.textAlignment = NSTextAlignmentLeft;
        titleL.text = [BBUserData stringChangeNull:[dic objectForKey:@"paperName"] replaceWith:@"评出您最满意的物业业务"];
        titleL.font = YSize(13.0);
        
        [rectView addSubview:titleL];
        
        UILabel* tapLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(titleL.frame) + 3, rectView.frame.size.width - 10, 15)];
        
        tapLabel.numberOfLines = 1;
        tapLabel.textAlignment = NSTextAlignmentLeft;
        tapLabel.text = @"点击立即参加>>";
        tapLabel.font = YSize(11.0);
        tapLabel.textColor = [UIColor redColor];
        [rectView addSubview:tapLabel];
        
        [self.scrollView addSubview:rectView];
    }
    
    
}

-(void)tap:(UITapGestureRecognizer*)tap{
    NSLog(@"%ld",tap.view.tag);
    yzEvaluateController* vc = [[yzEvaluateController alloc]init];
    NSDictionary* dic = self.listArr[tap.view.tag];
    vc.dic = dic;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
