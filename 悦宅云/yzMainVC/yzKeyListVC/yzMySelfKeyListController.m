//
//  yzMySelfKeyListController.m
//  悦宅云
//
//  Created by 尚广杰 on 2019/4/25.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import "yzMySelfKeyListController.h"
#import "yzMySelfKeyCell.h"
#import "pxCookAddViewController.h" //增加子钥匙
#import "ICCardController.h"        //IC卡管理
@interface yzMySelfKeyListController ()<UITableViewDelegate,UITableViewDataSource,PGDatePickerDelegate>{
    PGDatePickManager *datePickManager;
}
@property(nonatomic,strong)UITableView* tableV;
@property(nonatomic,strong)NSMutableArray* lists;
@property(nonatomic,strong)yzPxCookInfoModel *pycookModel;
@property(nonatomic,assign)NSInteger integer;
@end

@implementation yzMySelfKeyListController

-(UITableView*)tableView{
    if (!_tableV) {
        _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, mDeviceWidth, mDeviceHeight - KSAFEBAR_HEIGHT - kNavBarHeight) style:UITableViewStyleGrouped];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        //解决滑动视图顶部空出状态栏高度的问题
        if (@available(iOS 11.0, *)) {
            _tableV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableV.estimatedRowHeight = 0;
            _tableV.estimatedSectionHeaderHeight = 0;
            _tableV.estimatedSectionFooterHeight = 0;
        } else {
          self.automaticallyAdjustsScrollViewInsets = NO;
            
        }
        _tableV.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableV.separatorInset = UIEdgeInsetsZero;
        [self.view addSubview:self.tableV];
    }
    
    return _tableV;
}
-(NSMutableArray *)lists{
    if (!_lists) {
        _lists = [[NSMutableArray alloc] init];
    }
    return _lists;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
       [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh:) name:@"refresh" object:nil];
    
    
    
    [self tableView];
    
    [self.tableV setMj_header:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self pxCookListData];
        [self.tableV.mj_header endRefreshing];
    }]];
    self.tableV.mj_header.automaticallyChangeAlpha = YES;
    

    
    [self pxCookListData];
    
    
    //时间
    datePickManager = [[PGDatePickManager alloc]init];
    datePickManager.isShadeBackgroud = true;
    datePickManager.style = PGDatePickManagerStyle3;
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.datePickerType = PGPickerViewType1;
    datePicker.isHiddenMiddleText = false;
    datePicker.datePickerMode = PGDatePickerModeDate;
    

    
}


- (NSString*)addDayWithMainDay:(NSString*)mainDay xinyong:(NSString*)xinyong{
    
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc]init];//实例化一个NSDateFormatter对象
    
    [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式,这里可以设置成自己需要的格式
    
    NSDate*date =[dateFormat dateFromString:mainDay];
    

    
    NSInteger distance = [self.xinYongTianShu integerValue]; // 加的天数
    

    
    NSDate *otherDate;
    
    NSTimeInterval  oneDay = 24 * 60 * 60 * 1;  //1天的长度
    
    // 加N天
    otherDate = [date dateByAddingTimeInterval: +oneDay* distance ];

    
    NSString * currentDateString = [dateFormat stringFromDate:otherDate];
    // 方法2

    
    NSLog(@"加完信用天数后=%@", currentDateString);
    
    return currentDateString;
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
    [titleLabel setText:self.infoModel.room_msg];
    [titleLabel setFrame:CGRectMake(0, 0, mDeviceWidth/2, NavTopHeight)];
    [titleLabel setFont:YSize(18.0)];
    [titleLabel setTextColor:RGB(22, 22, 22)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.navigationController.visibleViewController.navigationItem setTitleView:titleLabel];
    
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:[UIImage imageNamed:@"blackiconfontadd"] forState:UIControlStateNormal];
    [addBtn setBackgroundColor:[UIColor clearColor]];

    [addBtn addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
 
    [addBtn setTitleColor:AppBackTitleColor forState:UIControlStateNormal];
    [addBtn setFrame:CGRectMake(0, 0, AutoWitdh(32), AutoWitdh(32))];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
    
    [self.navigationController.visibleViewController.navigationItem setRightBarButtonItem:addItem];
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
//添加子钥匙
-(void)addClick:(id)sender{
    pxCookAddViewController *addView = [[pxCookAddViewController alloc] init];
    addView.infoModel = self.infoModel;
    addView.finalTime = [self addDayWithMainDay:self.mainEndDate xinyong:self.xinYongTianShu];

//    addView.backRefreshDataBlock = ^(yzPxCookInfoModel *model) {
//        [self.tableV.mj_header beginRefreshing];
//    };
    [self.navigationController pushViewController:addView animated:YES];
}
//添加成功返回刷新
-(void)refresh:(NSNotification *)notification{
    [self.tableV.mj_header beginRefreshing];
}


#pragma mark -- table  delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.lists.count + 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        UITableViewCell* cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"IC"];
        cell.textLabel.text = @"IC卡管理";
        cell.textLabel.font = YSize(15.0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
    yzMySelfKeyCell* cell = [[yzMySelfKeyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        yzPxCookInfoModel *infoModel;
        if (self.lists.count>0) {
          infoModel = (yzPxCookInfoModel *)[self.lists objectAtIndex:(indexPath.section - 1)];
        }
    
    [cell setPxCookModel:infoModel];
    [cell setUpdateSwitchBlock:^(BOOL isOpen) {
        [self updateSwitchClick:isOpen roockId:infoModel.cook_id];
    }];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 44;
    }
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return 15+44;
    }
    return 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        if (self.lists.count==0) {
            return mDeviceHeight - 100;
        }else{
        return 15;
        }
    }
    return 0.00001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    
    if (section==1) {
        UIView* headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mDeviceWidth, 44)];
        [headView setBackgroundColor:[UIColor clearColor]];
        
        
        UIView* backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mDeviceWidth, 44)];
        [backView setBackgroundColor:[UIColor whiteColor]];
        [headView addSubview:backView];
        
        UILabel* remaind = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 150, 44)];
        remaind.textAlignment = NSTextAlignmentLeft;
        remaind.font = YSize(15.0);
        remaind.text = @"可管理的钥匙";
        
        [backView addSubview:remaind];
        
        
        UILabel* countLab =[[UILabel alloc]initWithFrame:CGRectMake(mDeviceWidth - 115, 0, 100, 44)];
        countLab.text = [NSString stringWithFormat:@"%lu把",(unsigned long)self.lists.count];
        countLab.textAlignment = NSTextAlignmentRight;
        countLab.font = YSize(15.0);
        countLab.textColor = RGB(0, 172, 61);
        [backView addSubview:countLab];
        
        return headView;
    }
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==0&&self.lists.count==0) {
        
        UIView* footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mDeviceWidth, mDeviceHeight - 100)];
        [footView setBackgroundColor:[UIColor clearColor]];
        
        UIImageView* imageV = [[UIImageView alloc]initWithFrame:CGRectMake(mDeviceWidth/2 - 60, kNavBarHeight + 70, 120, 120)];
        imageV.image = [UIImage imageNamed:@"yz_pxcook_none.png"];
        [footView addSubview:imageV];
        
        UILabel* label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(imageV.frame) + 15, mDeviceWidth - 20, 20)];
        
        label1.text = @"主人~您还木有添加子钥匙呐~";
        label1.textAlignment = NSTextAlignmentCenter;
        label1.font = YSize(18.0);
        [footView addSubview:label1];
        
        UILabel* label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(label1.frame) + 10, mDeviceWidth - 20, 40)];
        label2.text = @"添加子钥匙以后您的朋友可以更方便进入您所在的小区以及单元了呢~";
        label2.textAlignment = NSTextAlignmentCenter;
        label2.font = YSize(15.0);
        label2.numberOfLines = 0;
        [footView addSubview:label2];
        
        return footView;
    }
    
    return nil;
}

//点击跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        ICCardController* vc = [[ICCardController alloc]init];
//        vc.fangChanId = self.fangChanId;
        vc.roomId = self.roomId;
        vc.dianTiList = self.dianTiList;
        vc.state = @"1";
        [self.navigationController pushViewController:vc animated:YES];
    }else{
   
        if (self.lists.count>0) {
            self.pycookModel = (yzPxCookInfoModel *)[self.lists objectAtIndex:(indexPath.section - 1)];
        }
        [self presentViewController:datePickManager animated:false completion:nil];
    }
}


// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//
//        if (editingStyle == UITableViewCellEditingStyleDelete) {
//            yzPxCookInfoModel *infoModel = (yzPxCookInfoModel *)[self.lists objectAtIndex:indexPath.section-1];
//            [self deletePxCook:infoModel.cook_id roomId:infoModel.room_id];
//        }
//
//}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section>0) {
        UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            yzPxCookInfoModel *infoModel = (yzPxCookInfoModel *)[self.lists objectAtIndex:indexPath.section - 1];
            [self deletePxCook:infoModel.cook_id roomId:infoModel.room_id];
        }];
        return @[deleteAction];
    }
    return @[];
}
#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSLog(@"dateComponents = %@", dateComponents);
    
    NSString* month;
    NSString* day;
    
    if (dateComponents.month<10) {
        month = [NSString stringWithFormat:@"0%ld",(long)dateComponents.month];
    }else{
        month = [NSString stringWithFormat:@"%ld",(long)dateComponents.month];
    }
    
    if (dateComponents.day<10) {
        day = [NSString stringWithFormat:@"0%ld",(long)dateComponents.day];
    }else{
        day = [NSString stringWithFormat:@"%ld",(long)dateComponents.day];
    }
    
    NSString *birthday = [NSString stringWithFormat:@"%ld-%@-%@",(long)dateComponents.year,month,day];
    
   
    
    self.integer = [BBUserData compareDate:birthday withDate:[self addDayWithMainDay:self.mainEndDate xinyong:self.xinYongTianShu]];
    
    if (self.integer>=0) {
        [DDProgressHUD show];
        [CCAFNetWork post:[NSString stringWithFormat:@"%@app/userRom/updateEndDate",postUrl] version:Token parameters:@{@"id":self.pycookModel.cook_id,@"endTime":birthday} success:^(id object) {
            
            NSDictionary *json = object;
            if ([[json objectForKey:@"code"] intValue] == 200) {
                
                [self.tableV.mj_header beginRefreshing];
            }else if ([[json objectForKey:@"code"] intValue] == -6){
                [DDProgressHUD dismiss];
                [yzUserInfoModel userLoginOut];
                [yzUserInfoModel setLoginState:NO];
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }else{
                [DDProgressHUD showErrorImageWithInfo:[json objectForKey:@"message"]];
            }
            [self.tableV reloadData];
        } failure:^(NSError *error) {
            [DDProgressHUD showErrorImageWithInfo:error.localizedDescription];
        }];
    }else{
        [DDProgressHUD showErrorImageWithInfo:@"有效期限不能超过物业费到期日期"];
    }
    
    
    
}
//-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//
//
//    UITableViewRowAction *deleteRoWAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//
//        // 删除操作
//    }];
//
//    return @[deleteRoWAction];
//}



    


#pragma mark -- 网络数据

//获取子钥匙数据
-(void)pxCookListData{
    [DDProgressHUD show];
    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/userRom/listSubUserRoom",postUrl] version:Token parameters:@{@"roomId":self.infoModel.room_id} success:^(id object) {
        
        NSDictionary *json = object;
        if ([[json objectForKey:@"code"] intValue] == 200) {
            [DDProgressHUD dismiss];
            NSMutableArray *detail = [[json objectForKey:@"data"] JSONValue];
            [self.lists removeAllObjects];
            for (int i = 0; i < detail.count; i ++) {
                yzPxCookInfoModel *infoModel = [[yzPxCookInfoModel alloc] init:detail[i]];
                [self.lists addObject:infoModel];
            }
        }else if ([[json objectForKey:@"code"] intValue] == -6){
            [DDProgressHUD dismiss];
            [yzUserInfoModel userLoginOut];
            [yzUserInfoModel setLoginState:NO];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
            
        }else{
            [DDProgressHUD showErrorImageWithInfo:[json objectForKey:@"message"]];
        }
        if (self.lists.count > 0) {
            [self.tableV setHidden:NO];
        }else{
            [self.tableV setHidden:NO];
        }
        [self.tableV reloadData];
    } failure:^(NSError *error) {
        [DDProgressHUD showErrorImageWithInfo:error.localizedDescription];
    }];
}
//修改子钥匙状态
-(void)updateSwitchClick:(BOOL)isOpen roockId:(NSString *)roockId{
    [DDProgressHUD show];
    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/userRom/updateState",postUrl] version:Token parameters:@{@"id":roockId} success:^(id object) {
        
        NSDictionary *json = object;
        if ([[json objectForKey:@"code"] intValue] == 200) {
            [DDProgressHUD showSuccessImageWithInfo:json[@"message"]];
            NSMutableArray *detail = [[json objectForKey:@"data"] JSONValue];
            [self.lists removeAllObjects];
            for (int i = 0; i < detail.count; i ++) {
                yzPxCookInfoModel *infoModel = [[yzPxCookInfoModel alloc] init:detail[i]];
                [self.lists addObject:infoModel];
            }
        }else if ([[json objectForKey:@"code"] intValue] == -6){
            [DDProgressHUD dismiss];
            [yzUserInfoModel userLoginOut];
            [yzUserInfoModel setLoginState:NO];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }else{
            [DDProgressHUD showErrorImageWithInfo:[json objectForKey:@"message"]];
        }
        [self.tableV reloadData];
    } failure:^(NSError *error) {
        [DDProgressHUD showErrorImageWithInfo:error.localizedDescription];
    }];
}


/** 删除子钥匙状态 */
-(void)deletePxCook:(NSString *)cookId roomId:(NSString *)roomId{
    [DDProgressHUD show];
    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/userRom/deleteSub",postUrl] version:Token parameters:@{@"userId":[yzUserInfoModel getLoginUserInfo:@"userId"],@"id":cookId,@"roomId":roomId} success:^(id object) {
        
        NSDictionary *json = object;
        if ([[json objectForKey:@"code"] intValue] == 200) {
            [DDProgressHUD showSuccessImageWithInfo:json[@"message"]];
            NSMutableArray *detail = [[json objectForKey:@"data"] JSONValue];
            [self.lists removeAllObjects];
            for (int i = 0; i < detail.count; i ++) {
                yzPxCookInfoModel *infoModel = [[yzPxCookInfoModel alloc] init:detail[i]];
                [self.lists addObject:infoModel];
            }
        }else if ([[json objectForKey:@"code"] intValue] == -6){
            [DDProgressHUD dismiss];
            [yzUserInfoModel userLoginOut];
            [yzUserInfoModel setLoginState:NO];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
            
        }else{
            [DDProgressHUD showErrorImageWithInfo:[json objectForKey:@"message"]];
        }
        [self.tableV reloadData];
    } failure:^(NSError *error) {
        [DDProgressHUD showErrorImageWithInfo:error.localizedDescription];
    }];
}
@end
