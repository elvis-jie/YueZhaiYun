//
//  yzNewInformationController.m
//  悦宅云
//
//  Created by 尚广杰 on 2019/4/19.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import "yzNewInformationController.h"
#import "UIView+Ext.h"
#import "RPTaggedNavView.h"
#import "yzInformationCell.h"
#import "yzNoticeViewController.h"
@interface yzNewInformationController ()
<RPTaggedNavViewDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) RPTaggedNavView * taggedNavView;
//@property (nonatomic, strong) UIScrollView * bgScroll;
@property (nonatomic, strong) UITableView* tableView1;
//@property (nonatomic, strong) UITableView* tableView2;
//@property (nonatomic, strong) UITableView* tableView3;

@property (nonatomic, strong) NSMutableArray* list1;
@property (nonatomic, strong) NSArray* list2;
@property (nonatomic, strong) NSArray* list3;

@property (nonatomic, assign) int pageNo;
@end

@implementation yzNewInformationController
-(UITableView*)tableV1{
    if (!_tableView1) {
        _tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, mDeviceWidth, mDeviceHeight - KSAFEBAR_HEIGHT - kNavBarHeight) style:UITableViewStyleGrouped];
        _tableView1.delegate = self;
        _tableView1.dataSource = self;
        //解决滑动视图顶部空出状态栏高度的问题
        if (@available(iOS 11.0, *)) {
            _tableView1.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView1.estimatedSectionHeaderHeight = 0;
            _tableView1.estimatedSectionFooterHeight = 0;
        } else {
           self.automaticallyAdjustsScrollViewInsets = NO;
            
        }
        _tableView1.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView1.separatorInset = UIEdgeInsetsZero;
        [self.view addSubview:self.tableView1];
    }
    return _tableView1;
}

//-(UITableView*)tableV2{
//    if (!_tableView2) {
//        _tableView2 = [[UITableView alloc]initWithFrame:CGRectMake(mDeviceWidth, 0, mDeviceWidth, mDeviceHeight-self.taggedNavView.bottomY - KSAFEBAR_HEIGHT) style:UITableViewStyleGrouped];
//        _tableView2.delegate = self;
//        _tableView2.dataSource = self;
//        //解决滑动视图顶部空出状态栏高度的问题
//        if (@available(iOS 11.0, *)) {
//            _tableView2.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//            //            _tableV.estimatedRowHeight = 0;
//            _tableView2.estimatedSectionHeaderHeight = 0;
//            _tableView2.estimatedSectionFooterHeight = 0;
//        } else {
//           self.automaticallyAdjustsScrollViewInsets = NO;
//
//        }
//        _tableView2.separatorStyle = UITableViewCellSelectionStyleNone;
//        _tableView2.separatorInset = UIEdgeInsetsZero;
//        [self.bgScroll addSubview:self.tableView2];
//    }
//    return _tableView2;
//}

//-(UITableView*)tableV3{
//    if (!_tableView3) {
//        _tableView3 = [[UITableView alloc]initWithFrame:CGRectMake(mDeviceWidth*2, 0, mDeviceWidth, mDeviceHeight-self.taggedNavView.bottomY - KSAFEBAR_HEIGHT) style:UITableViewStyleGrouped];
//        _tableView3.delegate = self;
//        _tableView3.dataSource = self;
//        //解决滑动视图顶部空出状态栏高度的问题
//        if (@available(iOS 11.0, *)) {
//            _tableView3.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//            //            _tableV.estimatedRowHeight = 0;
//            _tableView3.estimatedSectionHeaderHeight = 0;
//            _tableView3.estimatedSectionFooterHeight = 0;
//        } else {
//            self.automaticallyAdjustsScrollViewInsets = NO;
//
//        }
//        _tableView3.separatorStyle = UITableViewCellSelectionStyleNone;
//        _tableView3.separatorInset = UIEdgeInsetsZero;
//        [self.bgScroll addSubview:self.tableView3];
//    }
//    return _tableView3;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.list1 = [NSMutableArray array];
    [self tableV1];
    self.pageNo = 1;
    
    
    [self.tableView1 setMj_header:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageNo = 1;
        [self getList];
        [self.tableView1.mj_header endRefreshing];
    }]];
    self.tableView1.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView1 setMj_footer:[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageNo++;
        [self getList];
        [self.tableView1.mj_footer endRefreshing];
    }]];
    
    //显示空数据或者无网络
    [yzProductPubObject EmptyUITableViewData:self.tableView1 isShowNoNetWork:NO isShowEmptyData:YES refreshBtnClickBlock:^{
        [self.tableView1.mj_header beginRefreshing];
    } isShowRefreshBtn:YES];
   
   [self getList];
    
}


-(void)getList{
   
    
    [DDProgressHUD show];
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"XiaoQuModel"];
    yzXiaoQuModel* quModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSString * wuye_id = [BBUserData stringChangeNull:quModel.wuye_id replaceWith:@""];
  
    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/notice/listProNotice",postUrl] version:Token parameters:@{@"page":@(self.pageNo),@"size":@10,@"wuYeId":wuye_id,@"sord":@"desc",@"sidx":@"modifyTime"} success:^(id object) {
        [DDProgressHUD dismiss];
        NSDictionary *json = object;
        
        if ([[json objectForKey:@"code"] intValue] == 200) {
            NSDictionary* contentDic = [[json objectForKey:@"data"] JSONValue];
            NSArray* arr = [contentDic objectForKey:@"content"];
            if (arr.count>0) {
                if (self.pageNo==1) {
                    self.list1 = [NSMutableArray array];
                    self.list1 = [contentDic objectForKey:@"content"];
                }else{
                    [self.list1 addObjectsFromArray:arr];
                }
            }else{
                [self.tableView1.mj_footer endRefreshingWithNoMoreData];
            }
            
         
            [self.tableView1 reloadData];

        }else if ([[json objectForKey:@"code"] intValue] == -6){
            [DDProgressHUD dismiss];
            [yzUserInfoModel userLoginOut];
            [yzUserInfoModel setLoginState:NO];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
        }else{
            [DDProgressHUD showErrorImageWithInfo:[json objectForKey:@"message"]];
        }
        
        
    } failure:^(NSError *error) {
        [DDProgressHUD showErrorImageWithInfo:@"暂无网络"];
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
    [titleLabel setText:@"最新资讯"];
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


- (void)createUI
{
//    self.taggedNavView = [[RPTaggedNavView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, mDeviceWidth, 44)];
//    self.taggedNavView.delegate = self;
//    self.taggedNavView.dataArr = [NSArray arrayWithObjects:@"近期推荐",@"街道资讯",@"社区资讯", nil];
//    self.taggedNavView.tagTextColor_normal = [UIColor blackColor];
//    self.taggedNavView.tagTextColor_selected = [UIColor redColor];
//    self.taggedNavView.tagTextFont_normal = 15;
//
//    self.taggedNavView.sliderColor = [UIColor redColor];
//    self.taggedNavView.sliderW = 60;
//    self.taggedNavView.sliderH = 1;
//    [self.view addSubview:self.taggedNavView];
    
//    self.bgScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.taggedNavView.bottomY, mDeviceWidth, mDeviceHeight-self.taggedNavView.bottomY)];
//    self.bgScroll.contentSize = CGSizeMake(mDeviceWidth*3, 0);
//    self.bgScroll.delegate = self;
//    self.bgScroll.pagingEnabled = YES;
//    [self.view addSubview:self.bgScroll];
    
//    [self tableV1];
//    [self tableV2];
//    [self tableV3];
}
#pragma mark -- taggedNavViewDelegate
//- (void)haveSelectedIndex:(NSInteger)index
//{
//    self.bgScroll.contentOffset = CGPointMake(mDeviceWidth*index, 0);
//}

#pragma mark -- scrollviewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger selectedIndx = scrollView.contentOffset.x/mDeviceWidth;
    [self.taggedNavView selectingOneTagWithIndex:selectedIndx];
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.list1.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (tableView == self.tableView1) {
  
    
    static NSString* identifire = @"Cell";
    yzInformationCell* cell = [tableView dequeueReusableCellWithIdentifier:identifire];
    if (!cell) {
        cell = [[yzInformationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifire];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    if (self.list1.count>0) {
        [cell getMessageByDic:self.list1[indexPath.section]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
//    }else if (tableView==self.tableView2){
//        yzInformationCell* cell2 = [[yzInformationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//        cell2.textLabel.text = @"2";
//        cell2.selectionStyle = UITableViewCellSelectionStyleNone;
//        return cell2;
//    }else{
//        yzInformationCell* cell3 = [[yzInformationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//        cell3.textLabel.text = @"3";
//        cell3.selectionStyle = UITableViewCellSelectionStyleNone;
//        return cell3;
//    }
//    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat finalH = 0.0;
    yzInformationCell* cell = (yzInformationCell*)[self tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath];
    finalH = cell.finalH;
    return finalH;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000001;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    yzNoticeViewController* vc = [[yzNoticeViewController alloc]init];
    NSDictionary* dic = self.list1[indexPath.section];
    vc.dic = dic;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[SDWebImageManager sharedManager].imageCache clearMemory];
}
@end
