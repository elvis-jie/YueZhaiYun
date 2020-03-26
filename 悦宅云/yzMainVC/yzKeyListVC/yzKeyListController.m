//
//  yzKeyListController.m
//  悦宅云
//
//  Created by 尚广杰 on 2019/4/24.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import "yzKeyListController.h"
#import "yzKeyHeadViewCell.h"
#import "yzKeyFooterView.h"
#import "yzKeyFirstCell.h"
#import "yzKeySecondCell.h"
#import "yzPxCookInfoModel.h" //钥匙model
#import "yzMySelfKeyListController.h"
#import <JavaScriptCore/JavaScriptCore.h>
@interface yzKeyListController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIWebViewDelegate>
@property(nonatomic,strong)UICollectionView*collectionView;
/** 主钥匙数组 */
@property (nonatomic, strong) NSMutableArray *MainArray;
/** 子钥匙数组 */
@property (nonatomic, strong) NSMutableArray *ClassArray;
@property (nonatomic, assign) NSInteger integer;
@property (nonatomic, strong) NSMutableString* password;   //分享的密码

@end

@implementation yzKeyListController
-(NSMutableArray *)MainArray{
    if (!_MainArray) {
        _MainArray = [[NSMutableArray alloc] init];
    }
    return _MainArray;
}
-(NSMutableArray *)ClassArray{
    if (!_ClassArray) {
        _ClassArray = [[NSMutableArray alloc] init];
    }
    return _ClassArray;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        //自动网格布局
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
         [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        //网格布局
        CGRect rect;
        if ([self.unLockStatus isEqualToString:@"1"]) {
            rect = CGRectMake(0, kNavBarHeight + 100 + 50, mDeviceWidth, mDeviceHeight - kNavBarHeight - KSAFEBAR_HEIGHT - 100 - 50);
        }else{
            rect = CGRectMake(0, kNavBarHeight, mDeviceWidth, mDeviceHeight - kNavBarHeight - KSAFEBAR_HEIGHT);
        }
        
        _collectionView = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:flowLayout];
        //设置数据源代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = RGB(240, 240, 240);
     
        
        //注册cell
        [_collectionView registerClass:[yzKeyFirstCell class] forCellWithReuseIdentifier:@"first"];
        [_collectionView registerClass:[yzKeySecondCell class] forCellWithReuseIdentifier:@"second"];
        [_collectionView registerClass:[yzKeyHeadViewCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
         [_collectionView registerClass:[yzKeyFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"footer"];
        
    }
    return _collectionView;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:RGB(240, 240, 240)];
    
//    UILabel* line = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, mDeviceWidth, 1)];
//    [line setBackgroundColor:RGB(228, 228, 228)];
//    [self.view addSubview:line];
    
    

    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //----------格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"yyyy-MM-dd"]; //yyyyMMddHHmmss  yyyymmddhhmmss
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"zh_CN"];//东八区时间
    NSDate *datenow = [NSDate date];
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
  

    
//    self.integer = [BBUserData compareDate:currentTimeString withDate:self.atime];
    
    //<0
    
//    NSLog(@"dianti==%@",self.dianTiList);


    if ([self.unLockStatus isEqualToString:@"1"]) {
        UIImageView* headImage = [[UIImageView alloc]initWithFrame:CGRectMake(14, 64 + 13 + kSaveTopSpace, 92, 24)];
        
        headImage.image = [UIImage imageNamed:@"访客密码"];
        [self.view addSubview:headImage];
        
        UILabel* smallLabel = [[UILabel alloc]init];
        smallLabel.frame = CGRectMake(CGRectGetMaxX(headImage.frame) + 5, 64 + kSaveTopSpace, 120, 50);
        smallLabel.textAlignment = NSTextAlignmentLeft;
        smallLabel.font = YSize(13.0);
        smallLabel.textColor = [UIColor lightGrayColor];
        
        smallLabel.text = @"点亮密码按钮再输入";
        [self.view addSubview:smallLabel];
        
        
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareBtn setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
        [shareBtn setFrame:CGRectMake(mDeviceWidth - 50, 64 + kSaveTopSpace + 5, 40, 40)];
        [shareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:shareBtn];
        
        
        UIWebView* webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64 + 50 + kSaveTopSpace, mDeviceWidth, 100)];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://app.yuezhaiyun.com/question/index.html#/dianTiPassword?roomId=%@",self.fangChanId]]]];
        NSLog(@"http://app.yuezhaiyun.com/question/index.html#/dianTiPassword?roomId=%@",self.fangChanId);
        
        
        //    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://app.yuezhaiyun.com/question/index.html#/about?paperid=%@&appuserid=%@",[self.dic objectForKey:@"id"],[yzUserInfoModel getLoginUserInfo:@"userId"]]]]];
        
        webView.delegate = self;
        [self.view addSubview:webView];
    }

    
    [self.view addSubview:self.collectionView];
    
    
    [self.collectionView setMj_header:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self pxCookListData];
        [self.collectionView.mj_header endRefreshing];
    }]];
    self.collectionView.mj_header.automaticallyChangeAlpha = YES;
 
    
    [self pxCookListData];
   
    [self getPassWord];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    [self setStatusBarBackgroundColor:RGBA(255, 255, 255, 1)];
    [self.navigationController.navigationBar setBackgroundColor:RGBA(55, 255, 255, 1)];
    [self.navigationController.visibleViewController.navigationItem setLeftBarButtonItem:nil];
    
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
    
//    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [shareBtn setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
//    [shareBtn setBackgroundColor:[UIColor clearColor]];
//    [shareBtn.titleLabel setFont:[UIFont fontWithName:@"HYJinChangTiJ" size:16]];
//    [shareBtn setTitleColor:AppBackTitleColor forState:UIControlStateNormal];
//    [shareBtn setFrame:CGRectMake(0, 0, AutoWitdh(32), AutoWitdh(32))];
//    [shareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
//    [self.navigationController.visibleViewController.navigationItem setRightBarButtonItem:shareItem];
    
    //顶部信息
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setText:@"钥匙管理"];
    [titleLabel setFrame:CGRectMake(0, 0, mDeviceWidth/2, NavTopHeight)];
    [titleLabel setFont:[UIFont fontWithName:@"HYJinChangTiJ" size:18]];
    [titleLabel setTextColor:RGB(22, 22, 22)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.navigationController.visibleViewController.navigationItem setTitleView:titleLabel];
    
//    [self.navigationController.visibleViewController.navigationItem setRightBarButtonItem:nil];
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


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section==0) {
        return self.MainArray.count;
    }else
    return self.ClassArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        yzKeyFirstCell* cell = (yzKeyFirstCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"first" forIndexPath:indexPath];
        [cell setBackgroundColor:[UIColor whiteColor]];
        cell.layer.cornerRadius = 5;
        yzPxCookInfoModel * infoModel = (yzPxCookInfoModel *)self.MainArray[indexPath.row];
        [cell setPxCookModel:infoModel];
        return cell;
    }else{
    yzKeySecondCell* cell = (yzKeySecondCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"second" forIndexPath:indexPath];
        yzPxCookInfoModel * infoModel = (yzPxCookInfoModel *)self.ClassArray[indexPath.row];
        [cell setPxCookModel:infoModel];
    return cell;
    }
    return nil;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        yzPxCookInfoModel *infoModel = (yzPxCookInfoModel *)[self.MainArray objectAtIndex:indexPath.row];
        yzMySelfKeyListController *classView = [[yzMySelfKeyListController alloc] init];
        classView.infoModel = infoModel;
        classView.fangChanId = self.fangChanId;
        classView.roomId = infoModel.room_id;
        classView.dianTiList = self.dianTiList;
        classView.mainEndDate = infoModel.mainEndDate;
        classView.xinYongTianShu = infoModel.xinYongTianShu;
        [self.navigationController pushViewController:classView animated:YES];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return CGSizeMake(mDeviceWidth - 20, 50);
    }else
        return CGSizeMake((mDeviceWidth - 30)/2 , 80);
   
}

// 设置区头尺寸高度
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section==0) {
        if (self.MainArray.count==0) {
            CGSize size = CGSizeMake(mDeviceWidth, 0.00001);
            return size;
        }else{
            CGSize size = CGSizeMake(mDeviceWidth, 50);
            return size;
        }
    }else{
        if (self.ClassArray.count==0) {
            CGSize size = CGSizeMake(mDeviceWidth, 0.00001);
            return size;
        }else{
            CGSize size = CGSizeMake(mDeviceWidth, 50);
            return size;
        }
    }
   
    return CGSizeMake(0, 0);
}
// 设置区尾尺寸高度
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    CGSize size = CGSizeMake(mDeviceWidth, 1);
    return size;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *tmpView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        yzKeyHeadViewCell *reusableHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head" forIndexPath:indexPath];
        
        NSArray* arr = @[@{@"image":self.MainArray.count > 0 ? @"业主钥匙":@"",@"title":self.MainArray.count>0 ? @"您掌管下的户主钥匙":@""},@{@"image":self.ClassArray.count>0 ? @"子业主钥匙":@"",@"title":self.ClassArray.count>0 ?  @"您被授权使用的钥匙":@""}];
        
        
        [reusableHeaderView setMessageByDic:arr[indexPath.section] withIndex:indexPath];
        tmpView = reusableHeaderView;
    }
    if([kind isEqualToString:UICollectionElementKindSectionFooter]){
        yzKeyFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"footer" forIndexPath:indexPath];
        
        tmpView = footerView;
    }
    return tmpView;
}


//获取密码
-(void)getPassWord{
    [CCAFNetWork post:[NSString stringWithFormat:@"http://api.yuezhaiyun.com/pro/pro/currentrecord/generatePwd"] version:Token parameters:@{@"fangChanID":self.fangChanId} success:^(id object) {
        
        NSDictionary *json = object;
        if ([[json objectForKey:@"code"] intValue] == 200) {
            self.password = [[NSMutableString alloc]initWithString:[json objectForKey:@"data"]];
            [self.password insertString:@"   " atIndex:5];
            [self.password insertString:@"   " atIndex:4];
            [self.password insertString:@"   " atIndex:3];
            [self.password insertString:@"   " atIndex:2];
            
            NSLog(@"password==%@",self.password);
        }else{
            [DDProgressHUD showErrorImageWithInfo:[json objectForKey:@"message"]];
        }
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        [DDProgressHUD showErrorImageWithInfo:error.localizedDescription];
    }];
}




//获取主钥匙数据
-(void)pxCookListData{
    [DDProgressHUD show];
    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/userRom/listUserRoom",postUrl] version:Token parameters:@{@"userId":[yzUserInfoModel getLoginUserInfo:@"userId"]} success:^(id object) {
        
        NSDictionary *json = object;
        if ([[json objectForKey:@"code"] intValue] == 200) {
            [DDProgressHUD dismiss];
            NSDictionary* dic = [[json objectForKey:@"data"] JSONValue];
           
            NSMutableArray *detail = [dic objectForKey:@"userRoomVoList"];
            
            [self.MainArray removeAllObjects];
            [self.ClassArray removeAllObjects];
       
            for (int i = 0; i < detail.count; i ++) {
                if ([[detail[i] objectForKey:@"isMain"] isEqualToString:@"是"]) {//主
                    yzPxCookInfoModel *infoModel = [[yzPxCookInfoModel alloc] init:detail[i]];
                    [self.MainArray addObject:infoModel];
                }else/* if ([[detail[i] objectForKey:@"isMain"] intValue] == 1)*/
                {//子
                    yzPxCookInfoModel *infoModel = [[yzPxCookInfoModel alloc] init:detail[i]];
                    [self.ClassArray addObject:infoModel];
                }
                
            }
        }else if ([[json objectForKey:@"code"] intValue] == -6){
            [DDProgressHUD dismiss];
            [yzUserInfoModel userLoginOut];
            [yzUserInfoModel setLoginState:NO];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
            
        }else{
            [DDProgressHUD showErrorImageWithInfo:[json objectForKey:@"message"]];
        }
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        [DDProgressHUD showErrorImageWithInfo:error.localizedDescription];
    }];
}

#pragma mark -- 分享
-(void)shareClick:(id)sender{
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [self getUserInfoForPlatform:platformType];
    }];
}

- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    
    
    UMSocialMessageObject* messageObject = [UMSocialMessageObject messageObject];
    
    messageObject.text = [NSString stringWithFormat:@"访客密码：%@\n友情提示：点亮密码按钮再输入楼层和动态码",self.password];

    
    
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id result, NSError *error) {
        
        if (error) {
            [DDProgressHUD showErrorImageWithInfo:@"分享失败"];
            
        }else{
            [DDProgressHUD showSuccessImageWithInfo:@"分享成功"];
        }
    }];
    
    
}

#pragma mark - UIWebViewDelegate

//! UIWebView在每次加载请求完成后会调用此方法
//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//
//    //! 获取JS代码的执行环境/上下文/作用域
//    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//
//    context[@"axiosDate"] = ^(){
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//
//
//        });
//
//    };
//}
@end
