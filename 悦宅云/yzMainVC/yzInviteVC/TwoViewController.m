//
//  TwoViewController.m
//  YZCSegmentController
//
//  Created by dyso on 16/8/1.
//  Copyright © 2016年 yangzhicheng. All rights reserved.
//

#import "TwoViewController.h"
#import "yzInviteListCell.h"
@interface TwoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView* tableV;
@property(nonatomic,strong)NSMutableArray* lists;
@property(nonatomic,assign)int page;
@end

@implementation TwoViewController

-(UITableView *)tableV{
    if (!_tableV) {
        _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, mDeviceWidth, mDeviceHeight - kNavBarHeight - KSAFEBAR_HEIGHT - 40) style:UITableViewStyleGrouped];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        //解决滑动视图顶部空出状态栏高度的问题
        if (@available(iOS 11.0, *)) {
            _tableV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
           self.automaticallyAdjustsScrollViewInsets = NO;
            
        }
        _tableV.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 15)];
        _tableV.sectionFooterHeight = 0;
        _tableV.separatorInset = UIEdgeInsetsZero;
        _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;//推荐该方法
        _tableV.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.tableV];
    }
    return _tableV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lists = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self tableV];
    
    [self.tableV setMj_header:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self getInviteList];
        [self.tableV.mj_header endRefreshing];
    }]];
    self.tableV.mj_header.automaticallyChangeAlpha = YES;
    [self.tableV setMj_footer:[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        [self getInviteList];
        [self.tableV.mj_footer endRefreshing];
    }]];
    self.page = 1;
    
    //创建信号量
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(2);
    // 创建全局并行
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //小区  获取小区信息
    dispatch_async(quene, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        [self getInviteList];
        dispatch_semaphore_signal(semaphore);
    });
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(@"分区==%d",self.lists.count);
    return self.lists.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    yzInviteListCell* cell = [[yzInviteListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.backgroundColor = RGB(240, 240, 240);
    [cell getMessageByDic:self.lists[indexPath.section]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat finalH = 0.0;
    yzInviteListCell* cell = (yzInviteListCell*)[self tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath];
    finalH = cell.finalH;
    
    return finalH;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==self.lists.count - 1) {
        return 30;
    }
    return 0.000001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==self.lists.count - 1) {
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mDeviceWidth - 30, 30)];
        UILabel * remaind = [[UILabel alloc]initWithFrame:view.bounds];
        remaind.text = @"访客记录只提供近30天的访客数量";
        remaind.textAlignment = NSTextAlignmentCenter;
        remaind.font = YSize(14.0);
        [view addSubview:remaind];
        return view;
    }
    return nil;
}

#pragma mark -- 请求数据
-(void)getInviteList{
    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/currentrecord/getInviteList",postUrl] version:Token parameters:@{@"page":@(self.page),@"size":@10,@"appUserId":[yzUserInfoModel getLoginUserInfo:@"userId"],@"sidx":@"inviteDate",@"sord":@"desc"} success:^(id object) {
         NSDictionary *json = object[@"data"];
   
      if ([[object objectForKey:@"code"] intValue] == 200) {
          NSArray *goods = [json objectForKey:@"content"];
          if (self.page == 1) {
              self.lists = [NSMutableArray array];
              [self.lists addObjectsFromArray:goods];
          }else{
          
        
              [self.lists addObjectsFromArray:goods];
              
         
          }
      }else if ([[object objectForKey:@"code"] intValue] == -6){
          [DDProgressHUD dismiss];
          [yzUserInfoModel userLoginOut];
          [yzUserInfoModel setLoginState:NO];
          [self.navigationController popToRootViewControllerAnimated:YES];
          
          
      }else{
          NSLog(@"");
      }
        
        [self.tableV reloadData];
    } failure:^(NSError *error) {
        [DDProgressHUD showErrorImageWithInfo:error.localizedDescription];
    }];
}
@end
