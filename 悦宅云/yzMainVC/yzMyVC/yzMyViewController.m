//
//  yzMyViewController.m
//  悦宅云
//
//  Created by 尚广杰 on 2019/4/15.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import "yzMyViewController.h"
#import <UShareUI/UShareUI.h>
#import "yzFeedbackController.h"
#import "yzAboutController.h"
#import "yzHelpCenterController.h"
#import "yzMyCarController.h"        //我的车辆
#import "tenementListViewController.h"  //我的报修
#import "yzPayOrderController.h"
#import "addressListViewController.h"  //我的地址
#import "yzEvaluateListController.h"
#import "yzVoteController.h"
#import "yzSetViewController.h"        //设置
#import "yzAdamiViewController.h"      //超管登录页面
@interface yzMyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray* images;
@property(nonatomic,strong)UITableView* tableV;
@property(nonatomic,strong)UILabel* name;
@property(nonatomic,strong)UILabel* tel;
@end

@implementation yzMyViewController
-(UITableView *)tableV{
    if (!_tableV) {
        _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, mDeviceWidth, mDeviceHeight) style:UITableViewStyleGrouped];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        //解决滑动视图顶部空出状态栏高度的问题
        if (@available(iOS 11.0, *)) {
            _tableV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//            _tableV.estimatedRowHeight = 0;
            _tableV.estimatedSectionHeaderHeight = 0;
            _tableV.estimatedSectionFooterHeight = 0;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
            
        }
//        _tableV.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
//        _tableV.sectionFooterHeight = 0;
        _tableV.separatorInset = UIEdgeInsetsZero;
        [self.view addSubview:self.tableV];
    }
    return _tableV;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.images = @[@{@"image":@"车辆",@"title":@"我的车辆"},@{@"image":@"缴费订单",@"title":@"缴费订单"},@{@"image":@"报修",@"title":@"我的报修"},/*@{@"image":@"收藏",@"title":@"收货地址"},*/@{@"image":@"帮助拷贝",@"title":@"帮助中心"},@{@"image":@"意见",@"title":@"意见反馈"},@{@"image":@"关于我们",@"title":@"关于我们"},@{@"image":@"物业评价",@"title":@"物业评价"},@{@"image":@"分享",@"title":@"分享好友"},@{@"image":@"管理员",@"title":@"超管登录"}];
    
    [self tableV];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self setStatusBarBackgroundColor:RGBA(255, 255, 255, 0)];
    [self.navigationController.navigationBar setBackgroundColor:RGBA(255, 255, 255, 0)];

    
    //左侧返回
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"whiteBack"] forState:UIControlStateNormal];
    [backBtn setBackgroundColor:[UIColor clearColor]];
    //    [backBtn setTitle:@" 返回" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [backBtn.titleLabel setFont:[UIFont fontWithName:@"HYJinChangTiJ" size:16]];
    [backBtn setTitleColor:AppBackTitleColor forState:UIControlStateNormal];
    [backBtn setFrame:CGRectMake(0, 0, AutoWitdh(32), AutoWitdh(32))];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationController.visibleViewController.navigationItem setLeftBarButtonItem:backItem];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }
    return self.images.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        static NSString* identifire = @"cell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifire];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifire];
        }
//        [cell setBackgroundColor:[UIColor redColor]];
        
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headBack"]];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView* headImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, kNavBarHeight + 10, 60, 60)];
        headImage.image = [UIImage imageNamed:@"默认头像"];
        headImage.layer.cornerRadius = 30;
        headImage.layer.masksToBounds = YES;
        [cell addSubview:headImage];
        
        
        self.name = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImage.frame) + 10, headImage.frame.origin.y, mDeviceWidth - 100, 30)];
//        name.text = @"张扬";
        if ([yzUserInfoModel getisLogin]) {
        [self.name setText:[BBUserData stringChangeNull:[yzUserInfoModel getLoginUserInfo:@"userName"] replaceWith:@""]];
        }
        self.name.font = YSize(14.0);
        self.name.textColor = [UIColor whiteColor];
        self.name.textAlignment = NSTextAlignmentLeft;
        
        [cell addSubview:self.name];
        
        self.tel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImage.frame) + 10, CGRectGetMaxY(self.name.frame), mDeviceWidth - 100, 30)];
        if ([yzUserInfoModel getisLogin]) {
        NSString *mobiel = [yzUserInfoModel getLoginUserInfo:@"mobile"];
        if (mobiel.length > 0) {
            mobiel = [mobiel stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        }
        [self.tel setText:mobiel];
        }
//        tel.text = @"13848245698";
        self.tel.font = YSize(14.0);
        self.tel.textColor = [UIColor whiteColor];
        self.tel.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:self.tel];
        
        
        UIImageView* rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(mDeviceWidth - 25, kNavBarHeight + 10 + 21, 7, 18)];
        rightImage.image = [UIImage imageNamed:@"grayright"];
        [cell addSubview:rightImage];
        return cell;
    }else{
    static NSString* identifire = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifire];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifire];
    }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.images[indexPath.row][@"image"]]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.images[indexPath.row][@"title"]];
        cell.textLabel.font = YSize(15.0);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 200;
    }else
        return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000001;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            if (![yzUserInfoModel getisLogin]) {
                yzLoginViewController *loginView = [[yzLoginViewController alloc] init];
                [loginView setLoginSuccessBlock:^{
                     [self.name setText:[yzUserInfoModel getLoginUserInfo:@"userName"]];
                    NSString *mobiel = [yzUserInfoModel getLoginUserInfo:@"mobile"];
                    if (mobiel.length > 0) {
                        mobiel = [mobiel stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
                    }
                    [self.tel setText:mobiel];
                
                }];
                [self.navigationController presentViewController:[yzProductPubObject navc:loginView] animated:YES completion:nil];
            }else{
                yzSetViewController* setVC = [[yzSetViewController alloc]init];
                [setVC setLoginOutBlock:^{
                    self.name.text = @"";
                    self.tel.text = @"";
                }];
                [self.navigationController pushViewController:setVC animated:YES];
            }
        }
            break;
        case 1:
        {
            //我的车辆
            if (indexPath.row==0) {
                NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"XiaoQuModel"];
                yzXiaoQuModel* quModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                
                NSString* xiaoquId  = [BBUserData stringChangeNull:quModel.room replaceWith:@""];
                if ([xiaoquId isEqualToString:@""]) {
                    [DDProgressHUD showErrorImageWithInfo:@"暂无小区"];
                    return;
                }else{
                yzMyCarController* carVC = [[yzMyCarController alloc]init];
                [self.navigationController pushViewController:carVC animated:YES];
                }
            }
            //缴费订单
            if (indexPath.row==1) {
                
                yzPayOrderController* payVC = [[yzPayOrderController alloc]init];
                [self.navigationController pushViewController:payVC animated:YES];
            }
            //我的报修
            if (indexPath.row==2) {
                tenementListViewController *tenementVC = [[tenementListViewController alloc] init];
                [self.navigationController pushViewController:tenementVC animated:YES];
            }
            //收货地址
//            if (indexPath.row==3) {
//                addressListViewController *addressVC = [[addressListViewController alloc] init];
//                [self.navigationController pushViewController:addressVC animated:YES];
//            }
            //帮助中心
            if (indexPath.row==3) {
                yzHelpCenterController* helpVC = [[yzHelpCenterController alloc]init];
                [self.navigationController pushViewController:helpVC animated:YES];
            }
            //意见反馈
            if (indexPath.row==4) {
                yzFeedbackController* backVC = [[yzFeedbackController alloc]init];
                [self.navigationController pushViewController:backVC animated:YES];
            }
            //关于我们
            if (indexPath.row==5) {
                yzAboutController* aboutVC = [[yzAboutController alloc]init];
                [self.navigationController pushViewController:aboutVC animated:YES];
            }
            //物业评价
            if (indexPath.row==6) {

                
                NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"XiaoQuModel"];
                yzXiaoQuModel* quModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                
                NSString* xiaoquId  = [BBUserData stringChangeNull:quModel.xiaoqu_id replaceWith:@""];
                if ([xiaoquId isEqualToString:@""]) {
                    [DDProgressHUD showErrorImageWithInfo:@"暂无小区"];
                    return;
                }else{
                    
                    yzVoteController* voteVC = [[yzVoteController alloc]init];
                    [self.navigationController pushViewController:voteVC animated:YES];
                }
            }
            //分享
            
            if (indexPath.row==7) {
                [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
                [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                    // 根据获取的platformType确定所选平台进行下一步操作
                    [self getUserInfoForPlatform:platformType];
                }];
            }
            //超管登录
            if (indexPath.row==8) {
                yzAdamiViewController* adamiVC = [[yzAdamiViewController alloc]init];
                [self.navigationController pushViewController:adamiVC animated:YES];
            }
        }
            break;
        default:
            break;
    }
}
#pragma mark -- 分享

- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    
    
    UMSocialMessageObject* messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"悦宅云" descr:@"悦宅云APP提供物业管理、物业服务、周边商品和服务等，业主足不出户即可享受互联网科技带来的生活新体验。" thumImage:[UIImage imageNamed:@"icon"]];
    //设置网页地址
    shareObject.webpageUrl = @"http://www.yuezhaiyun.com/webapp/index.html?from=groupmessage&isappinstalled=0";
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id result, NSError *error) {
        NSLog(@"%@==%@",result,error.description);
        if (error) {
            [DDProgressHUD showErrorImageWithInfo:@"分享失败"];
            
        }else{
            [DDProgressHUD showSuccessImageWithInfo:@"分享成功"];
        }
    }];
    
    
}
@end
