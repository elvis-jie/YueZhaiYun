//
//  yzMyCarController.m
//  yzProduct
//
//  Created by 尚广杰 on 2019/2/1.
//  Copyright © 2019 CC. All rights reserved.
//

#import "yzMyCarController.h"
#import "yzAddCarController.h"
#import "yzXiaoQuModel.h"
@interface yzMyCarController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView* tableV;        //车辆列表
@property(nonatomic,strong)UIButton* addCarBtn;        //添加车辆按钮
@property(nonatomic,strong)UILabel* carLabel;     //
@property(nonatomic,strong)NSArray* cheWeiList;               //车位列表
@property(nonatomic,strong)NSMutableArray* carArray;          //车辆数组
@property(nonatomic,strong)NSMutableArray* longArray;         //长期车辆数组
@property(nonatomic,strong)NSMutableArray* TemporaryArray;    //临时车辆数组
@property(nonatomic,assign)NSInteger pageNo;


@end

@implementation yzMyCarController

-(UITableView *)tableView{
    if (!_tableV) {
        _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, mDeviceWidth, mDeviceHeight - 50 - KSAFEBAR_HEIGHT - kNavBarHeight) style:UITableViewStyleGrouped];
        _tableV.delegate = self;
        _tableV.dataSource = self;
//        _tableV.sectionHeaderHeight = 44;
//        _tableV.sectionFooterHeight = 0.00000001;
        
        //解决滑动视图顶部空出状态栏高度的问题
        if (@available(iOS 11.0, *)) {
            _tableV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
          
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.tableV];
    }
    return _tableV;
}

-(UIButton* )carbtn{
    if (!_addCarBtn) {
        _addCarBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableV.frame), mDeviceWidth, 50)];
        [_addCarBtn setTitle:@"添加车辆" forState:UIControlStateNormal];
        [_addCarBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [_addCarBtn setBackgroundColor:[UIColor lightGrayColor]];
        [_addCarBtn addTarget:self action:@selector(addCar:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.addCarBtn];
    }
    return self.addCarBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self tableView];
    [self carbtn];
    
    [self.tableV setMj_header:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageNo = 0;
        [self getPublicData];
        [self.tableV.mj_header endRefreshing];
    }]];
    self.tableV.mj_header.automaticallyChangeAlpha = YES;
    [self.tableV setMj_footer:[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageNo++;
        [self getPublicData];
        [self.tableV.mj_footer endRefreshing];
    }]];
    
    //显示空数据或者无网络
    [yzProductPubObject EmptyUITableViewData:self.tableV isShowNoNetWork:NO isShowEmptyData:YES refreshBtnClickBlock:^{
        [self.tableV.mj_header beginRefreshing];
    } isShowRefreshBtn:YES];
    self.pageNo = 0;
    
 //获取车辆信息
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
        [self getCheWeiList];
        [self getCarList];
        dispatch_semaphore_signal(semaphore);
    });
    
}



//添加车辆
-(void)addCar:(UIButton*)sender{
    yzAddCarController* addVC = [[yzAddCarController alloc]init];
    addVC.type = @"1";
    addVC.blockAddSuccess = ^{
        [self getCarList];
    };
    [self.navigationController pushViewController:addVC animated:YES];
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
    [titleLabel setText:@"我的车辆"];
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
    if (self.longArray.count>0&&self.TemporaryArray.count>0) {
        return 3;
    }else if (self.longArray.count==0&&self.TemporaryArray.count==0){
        return 1 ;
    }else
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.longArray.count>0&&self.TemporaryArray.count>0) {
        
        if (section==0) {
            return self.cheWeiList.count + 1;
            
        }else if(section==1){
            return self.longArray.count;
            
        }else{
            return self.TemporaryArray.count;
        }
    }else if (self.longArray.count==0&&self.TemporaryArray.count==0){
        return self.cheWeiList.count + 1;
    }else if(self.longArray.count>0&&self.TemporaryArray.count==0){
        if (section==0) {
            return self.cheWeiList.count + 1;
        }else{
        return self.longArray.count;
        }
    }else if(self.longArray.count==0&&self.TemporaryArray.count>0){
        if (section==0) {
            return self.cheWeiList.count +1;
        }else{
        return self.TemporaryArray.count;
        }
    }
    
    
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        UITableViewCell* cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yz_member_fh_view_bg"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row==0) {
            cell.textLabel.text = @"车位地址";
            cell.textLabel.textColor = [UIColor redColor];
        }else{
            if (self.cheWeiList.count>0) {
                NSDictionary* dic = self.cheWeiList[indexPath.row - 1];
                cell.textLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
                NSString* str = [NSString stringWithFormat:@"%@",dic[@"time"]];
              
                if ([str isEqual:[NSNull null]]||[str isEqualToString:@"null"]||[str isEqualToString:@"<null>"]) {
                    
                    cell.detailTextLabel.text =@"";
                    
                }else{
                  
                    cell.detailTextLabel.text = str;

                }
//                cell.textLabel.font = [UIFont fontWithName:@"HYJinChangTiJ" size:15.0];
//                cell.detailTextLabel.font = [UIFont fontWithName:@"HYJinChangTiJ" size:15.0];
                //            if ([self StringIsNullOrEmpty:str]) {
                //              cell.detailTextLabel.text = @"";
                //            }else{
                //                NSArray* timeArr = [str componentsSeparatedByString:@","];
                //                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@-%@-%@",timeArr[0],timeArr[1],timeArr[2]];
                //
                //            }
            }
        }
        return cell;
    }else{
    static NSString* identifire = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifire];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifire];
    }
    if (indexPath.section==1) {
        if (self.longArray.count>0) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@",[self.longArray[indexPath.row] objectForKey:@"code"]];
        }else{
              cell.textLabel.text = [NSString stringWithFormat:@"%@",[self.TemporaryArray[indexPath.row] objectForKey:@"code"]];
        }
        
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[self.TemporaryArray[indexPath.row] objectForKey:@"code"]];
    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    return cell;
    }
    return nil;
}
-(NSString*)replaceTime:(NSString*)str{
    NSString* timeStr;
    int time = [str intValue];
    if (time<10) {
        timeStr = [NSString stringWithFormat:@"0%d",time];
         return timeStr;
    }else{
        return str;
    }
    return nil;
}


//- (BOOL)StringIsNullOrEmpty:(NSString *)str
//{
//    return (str == nil || [str isKindOfClass:[NSNull class]] || str.length == 0);
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 30;
    }
    return 44;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section!=0) {
        yzAddCarController* addVC = [[yzAddCarController alloc]init];
        addVC.type = @"2";
        addVC.blockEditSuccess = ^{
            [self getCarList];
        };
        
        if (indexPath.section==1) {
            if (self.longArray.count>0) {
                addVC.dic = self.longArray[indexPath.row];
            }else if (self.TemporaryArray.count>0){
                addVC.dic = self.TemporaryArray[indexPath.row];
            }
            
        }else if(indexPath.section==2){
            addVC.dic = self.TemporaryArray[indexPath.row];
        }
        [self.navigationController pushViewController:addVC animated:YES];
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 15;
    }else{
        return 44;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 15;
    }else{
        return 0.00001;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mDeviceWidth, 15)];
        UIImageView* imageView=  [[UIImageView alloc]initWithFrame:view.bounds];
        imageView.image = [UIImage imageNamed:@"yz_member_fh_view_bg"];
        [view addSubview:imageView];
        
        UIImageView* leftImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
        leftImageV.image = [UIImage imageNamed:@"yz_index_shop_leftTop"];
        [imageView addSubview:leftImageV];
        
        UIImageView* rightImageV = [[UIImageView alloc]initWithFrame:CGRectMake(mDeviceWidth - 15, 0, 15, 15)];
        rightImageV.image = [UIImage imageNamed:@"yz_index_shop_rightTop"];
        [imageView addSubview:rightImageV];
        
        
        
        return view;
    }else{
    
    
    UIView* headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mDeviceWidth, 44)];
    self.carLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, mDeviceWidth - 30, 44)];
    if (self.longArray.count>0&&self.TemporaryArray.count>0) {
        if (section==1) {
            self.carLabel.text = @"常驻车辆";
        }else if(section==2){
            self.carLabel.text = @"临时车辆";
        }
    }else if (self.longArray.count==0&&self.TemporaryArray.count==0){
        self.carLabel.text = @"";
    }else if(self.longArray.count>0&&self.TemporaryArray.count==0){
        if (section==1) {
            self.carLabel.text = @"常驻车辆";
        }
        
    }else if(self.longArray.count==0&&self.TemporaryArray.count>0){
        if (section==1) {
            self.carLabel.text = @"临时车辆";
        }
        
    }
        self.carLabel.textColor = [UIColor redColor];
    self.carLabel.textAlignment = NSTextAlignmentLeft;
    self.carLabel.font = [UIFont systemFontOfSize:15.0];
    [headView addSubview:self.carLabel];
    return headView;
    }
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==0) {
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mDeviceWidth, 15)];
        
        UIImageView* imageView=  [[UIImageView alloc]initWithFrame:view.bounds];
        imageView.image = [UIImage imageNamed:@"yz_member_fh_view_bg"];
        [view addSubview:imageView];
        
        
        UIImageView* leftImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
        leftImageV.image = [UIImage imageNamed:@"yz_index_shop_leftBottom"];
        [imageView addSubview:leftImageV];
        
        UIImageView* rightImageV = [[UIImageView alloc]initWithFrame:CGRectMake(mDeviceWidth - 15, 0, 15, 15)];
        rightImageV.image = [UIImage imageNamed:@"yz_index_shop_rightBottom"];
        [imageView addSubview:rightImageV];
        
        return view;
    }else
        return nil;
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        return NO;
    }
    return YES;
}
//ios 11之前的方法
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section!=0) {

  
    UITableViewRowAction *a1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            // 按钮被按了，会调用block里面的代码:
    NSString* carId = nil;
    NSString* type = nil;
    
    if (self.longArray.count>0&&self.TemporaryArray.count>0) {
        if (indexPath.section==1) {
            carId = [self.longArray[indexPath.row] objectForKey:@"id"];
            type = @"long";
        }else if(indexPath.section==2){
            carId = [self.TemporaryArray[indexPath.row] objectForKey:@"id"];
            type = @"tem";
        }
    }else if(self.longArray.count>0&&self.TemporaryArray.count==0){
        if (indexPath.section==1) {
            carId = [self.longArray[indexPath.row] objectForKey:@"id"];
            type = @"long";
        }
        
    }else if(self.longArray.count==0&&self.TemporaryArray.count>0){
        if (indexPath.section==1) {
        carId = [self.TemporaryArray[indexPath.row] objectForKey:@"id"];
        type = @"tem";
        }
    }
    
    [DDProgressHUD show];
    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/car/delete",postUrl] version:Token parameters:@{@"id":carId} success:^(id object) {
        [DDProgressHUD dismiss];
        NSDictionary *json = object;
        
        if ([[json objectForKey:@"code"] intValue] == 200) {
            
            [DDProgressHUD showSuccessImageWithInfo:[json objectForKey:@"message"]];
            if ([type isEqualToString:@"long"]) {
                [self.longArray removeObjectAtIndex:indexPath.row];
            }else{
                [self.TemporaryArray removeObjectAtIndex:indexPath.row];
            }
            [self.tableV reloadData];
            
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
   
    
        }];
   

    return @[a1];
    }
        return nil;
    
}
#pragma mark -- 车辆信息接口
//车位信息
-(void)getCheWeiList{
    //获取小区数据
    //获取小区数据
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"XiaoQuModel"];
    yzXiaoQuModel* quModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    
    
    
    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/car/getCheWeilist",postUrl] version:Token parameters:@{@"page":@0,@"size":@10,@"roomId":quModel.roomId} success:^(id object) {
        [DDProgressHUD dismiss];
        NSDictionary *json = object;
        self.cheWeiList = [NSArray array];
        if ([[json objectForKey:@"code"] intValue] == 200) {
            self.cheWeiList = [[json objectForKey:@"data"] JSONValue];
            
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
        [DDProgressHUD showErrorImageWithInfo:@"暂无网络"];
    }];
}
//获取车辆信息
-(void)getCarList{
    [DDProgressHUD show];
    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/car/getlist",postUrl] version:Token parameters:@{@"page":[NSNumber numberWithInteger:self.pageNo],@"size":@10,@"appUserId":[yzUserInfoModel getLoginUserInfo:@"userId"]} success:^(id object) {
        [DDProgressHUD dismiss];
        NSDictionary *json = object;
        
        if ([[json objectForKey:@"code"] intValue] == 200) {
            NSDictionary *dic = [json objectForKey:@"data"];
            NSArray* arr = [dic objectForKey:@"content"];
    
            if (arr.count>0) {
                self.carArray = [NSMutableArray array];
                self.longArray = [NSMutableArray array];
                self.TemporaryArray = [NSMutableArray array];
                for (int i = 0; i<arr.count; i++) {
                    
                    
                    NSDictionary*dictionary = arr[i];
                    
                    NSString* idStr = [[dictionary objectForKey:@"storType"] objectForKey:@"value"];
                    if ([idStr isEqualToString:@"1"]) {
                        [self.longArray addObject:dictionary];
                        
                        
                    }else{
                        [self.TemporaryArray addObject:dictionary];
                        
                    }
                }
                
                [self.tableV reloadData];
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
        
    }];
}


@end
