//
//  yzHelpCenterController.m
//  悦宅云
//
//  Created by 尚广杰 on 2019/4/18.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import "yzHelpCenterController.h"
#import "yzHelpCenterCell.h"
@interface yzHelpCenterController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView* tableV;
@property(nonatomic,strong)NSArray* questionArr;
@property(nonatomic,strong)NSMutableArray* typeArray;
@end

@implementation yzHelpCenterController

-(UITableView *)tableView{
    if (!_tableV) {
        _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, mDeviceWidth, mDeviceHeight - kNavBarHeight - KSAFEBAR_HEIGHT) style:UITableViewStyleGrouped];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        
        if (@available(iOS 11.0, *)) {
            _tableV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
            
        }
        _tableV.estimatedRowHeight = 0;
        _tableV.estimatedSectionHeaderHeight = 0;
        _tableV.estimatedSectionFooterHeight = 0;
//        _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.tableV];
    }
    return _tableV;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.typeArray = [NSMutableArray array];
    self.questionArr = @[
                         @{@"question":@"显示\"暂无小区\"",@"answer":@"首先，请确保您所在的社区物业已经通过了悦宅云官方授权\n\n然后，您需要在物业备案一个业主信息，即姓名+手机号，该业主即成为本房间的户主\n\n其次，经过物业认证的户主，可在”钥匙管理”给家庭成员或亲戚朋友分配权限\n\n完成以上操作，即可显示您所在的社区"},
                         @{@"question":@"什么是业主钥匙、子业主钥匙",@"answer":@"业主钥匙：您掌管下的户主钥匙\n户主，即您在物业备案的那一个业主信息，一个房间只能有一个户主\n户主具备添加/删除子钥匙、IC卡管理的权限\n\n子业主钥匙：您被授权使用的钥匙\n作为家庭成员或亲戚朋友，您被户主授权使用的钥匙\n家庭成员没有添加/删除子钥匙、IC卡管理的权限"},
                         @{@"question":@"如何使用APP乘梯",@"answer":@"在电梯内，点击APP首页面最下方的一键通行按钮，即可点亮您所在的楼层\n注：\n\n1.请确保您已被物业或家庭户主授权\n2.请确保已准确定位到您所在的社区房间\n3.物业费没有到期欠费或户主授权有效期限没有到期\n\n另：\n如果您的手机在电梯内没有信号，请在进入电梯前打开悦宅云APP，定位到您所在的房间，然后在电梯内再次触发通行按钮即可"},
                         @{@"question":@"IC卡管理",@"answer":@"只有户主才具备IC卡管理的权限\n\n1.制卡\n在电梯内，户主打开APP首页面钥匙管理-所在房间-IC卡管理-点击添加IC卡，灯绿后将IC卡贴近读卡器，即可完成制卡\n\n2.续期\n由于IC卡本身不具备联网交互功能，缴完物业费后，此时需要房间户主在电梯内给IC卡续期：户主打开APP首页面钥匙管理-所在房间-IC卡管理-IC卡续期，即可完成数据更新\n\n3.删卡\n在电梯内，户主打开APP首页面钥匙管理-所在房间-IC卡管理-点击删除IC卡，即可删除所有之前添加的IC卡\n\n另：\n如果您的手机在电梯内没有信号，请在进入电梯前打开APP，户主打开APP首页面钥匙管理-所在房间-IC卡管理-单击相关功能按钮进行数据缓存，然后在电梯内再次点击该按钮即可"},
                         @{@"question":@"IC卡无法使用",@"answer":@"首先，检查您的IC卡是不是新卡，是否已经被户主制卡授权\n\n然后，核查您是否物业费到期欠费，或到期缴费后，户主是否执行了续期操作\n\n其次，核查是否被户主执行了删除IC卡操作\n\n再次，核查IC卡读卡器是否被人破坏\n\n最后，如果监测到该IC卡是复制卡，将会被锁死，也不能使用"},
                         @{@"question":@"访客如何乘梯",@"answer":@"通过动态密码乘梯，密码共5位：1位楼层码+4位动态码\n\n首先，定位到您所在的房间\n\n然后，打开APP首页面钥匙管理，即可看到动态密码\n\n其次，先点亮密码按钮，再输入密码，密码正确则欲到达楼层被点亮\n\n注：\n1.物业费到期欠费则不显示访客密码\n2.平常不使用访客密码则不要随意点亮密码按钮"},
                         @{@"question":@"物业缴费",@"answer":@"您可以选择使用悦宅云APP的物业缴费功能进行线上缴费，也可以选择到物业办公室线下缴费\n\n注\n物业设置了各种缴费套餐，您只要选择适合您的套餐即可"}];
    for (int i = 0; i<self.questionArr.count; i++) {
        [self.typeArray addObject:@"0"];
    }
    
    [self tableView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self setStatusBarBackgroundColor:RGBA(255, 255, 255, 1)];
    [self.navigationController.navigationBar setBackgroundColor:RGBA(255, 255, 255, 1)];
    //左侧返回
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
    [backBtn setBackgroundColor:[UIColor clearColor]];

    [backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn.titleLabel setFont:[UIFont fontWithName:@"HYJinChangTiJ" size:16]];
    [backBtn setTitleColor:AppBackTitleColor forState:UIControlStateNormal];
    [backBtn setFrame:CGRectMake(0, 0, AutoWitdh(32), AutoWitdh(32))];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationController.visibleViewController.navigationItem setLeftBarButtonItem:backItem];
    
    //顶部信息
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setText:@"帮助中心"];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.questionArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    yzHelpCenterCell* cell =  [[yzHelpCenterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell getMessageByDic:self.questionArr[indexPath.row] type:self.typeArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* type = self.typeArray[indexPath.row];
    if ([type isEqualToString:@"0"]) {
        [self.typeArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
    }else{
        [self.typeArray replaceObjectAtIndex:indexPath.row withObject:@"0"];
    }
    
    
     [_tableV reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat finalH = 0.0;
    yzHelpCenterCell* cell = (yzHelpCenterCell*)[self tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath];
    finalH = cell.finalH;
    return finalH;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mDeviceWidth, 44)];
    [view setBackgroundColor:[UIColor whiteColor]];
    UILabel* titleL = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, mDeviceWidth - 20, 44)];
    titleL.text = @"常见问题如下:";
    titleL.font = YSize(15.0);
    titleL.textAlignment = NSTextAlignmentLeft;
    
    
    [view addSubview:titleL];
    return view;
}
@end
