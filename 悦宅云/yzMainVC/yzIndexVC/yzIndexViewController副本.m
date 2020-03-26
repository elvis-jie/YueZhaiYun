//
//  yzIndexViewController.m
//  yzProduct
//
//  Created by LiuHQ on 2018/9/20.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "yzIndexViewController.h"

#import "indexGNViewCell.h"     //功能cell
//#import "indexMsgViewCell.h"     //资讯cell

//#import "indexShopViewCell.h"   //店铺cell
//#import "indexGoodsViewCell.h"  //产品cell

//view
//#import "indexTopLocationView.h" //顶部选择view
//#import "indexBottomGoodsHeaderView.h" //产品headerview
//#import "indexBottomFooterView.h"       //产品底部view
#import "indexGoodsProductAttrView.h"            //产品规格view

//model
//#import "yzIndexGoodsModel.h" //产品model
#import "yzIndexShopGoodsModel.h" //首页产品列表
#import "yzXiaoQuModel.h" //小区model


//controller
#import "yzGoodsDetailViewController.h" //产品详情
//#import "pxCookListViewController.h" //钥匙管理页面
//#import "houseKeepListViewController.h" //呼叫管家页面
//#import "tenementAddViewController.h" //添加报修页面
//#import "tenementListViewController.h"
//#import "yzWuYeServeController.h"   //物业服务
//#import "yzFaceBackViewController.h" //投诉建议
//#import "yzWuYePayController.h"      //物业缴费
#import "yzOnePassController.h"      //一键通行

//#import "yzNoticeListController.h"         //最新资讯
#import "yzMessageController.h"

//#import "productViewCell.h"
#import "indexAdPicViewCell.h"
#import "productViewCell.h"
#import "indexMsgViewCell.h"

#import "SGDropMenu.h"               //下拉菜单
#import "yzInviteController.h"
#import "yzMyViewController.h"        //我的
#import "yzKeyListController.h"         //钥匙管理
#import "yzNewInformationController.h"  //最新资讯
#import "yzHouseKeepController.h"     //管家
#import "yzOrderListController.h"    //订单
#import "yzVoteController.h"          //参与投票
#import "yzComplainController.h"      //物业投诉
#import "yzRepairsController.h"       //物业报修
#import "yzWuYePayController.h"       //物业缴费
#import "yzIndexBottomView.h"        //自定义tabbar

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapKit/MAMapKit.h>

#import <CoreBluetooth/CoreBluetooth.h>

#define SERVICE_UUID @"CDD1"
#define CHARACTERISTIC_UUID @"CDD2"

@interface yzIndexViewController ()<indexGNViewCellDelegate,DCCycleScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,SGDropMenuDelegate,AMapLocationManagerDelegate,CBPeripheralManagerDelegate>

@property (nonatomic, strong) UIButton *titleButton;//顶部信息

@property (nonatomic, strong) indexGoodsProductAttrView *productView;

@property (nonatomic, strong) NSMutableArray *goodsArray;//产品数组
@property (nonatomic, strong) NSMutableArray *shopGoodsArray;//小区产品数组
@property (nonatomic, strong) NSMutableArray *xiaoquArray;//小区数组

@property (nonatomic,strong)NSString* sendAllNum;     //最终发送的楼宇信息

@property (nonatomic,strong)NSMutableArray* equalIDs;   //匹配的id
@property(nonatomic,strong)UITableView* listTableView;
@property (nonatomic,strong)UICollectionView* collectionView;
@property (nonatomic,strong)NSArray* typeArr;
@property (nonatomic,strong)UIButton* addBtn;

/** titleArr */
@property (nonatomic, strong) NSArray *titleArr;
/** imgArr */
@property (nonatomic, strong) NSArray *imageArr;
//顶部地址
@property (nonatomic, strong) UILabel* locationLabel;
//第一次
@property (nonatomic, strong) NSString* first;
//高德
@property(nonatomic,strong)AMapLocationManager* locationManager;

//自定义tabbar
@property(nonatomic,strong)yzIndexBottomView* bottomView;

@property(nonatomic,assign)MAMapPoint point;                //定位的点
@property(nonatomic,strong)NSMutableArray* pointArray;      //经纬度数组
@property(nonatomic,strong)NSMutableArray* distanceArray;   //计算得到的距离数组


@property (nonatomic, strong) CBPeripheralManager *peripheralManager;
@property (nonatomic, strong) CBMutableCharacteristic *characteristic;

@end

@implementation yzIndexViewController
-(UITableView *)tableV{
    if (!_listTableView) {
        _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, mDeviceWidth, mDeviceHeight - KSAFEBAR_HEIGHT - kTabBarHeight) style:UITableViewStylePlain];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        //解决滑动视图顶部空出状态栏高度的问题
        if (@available(iOS 11.0, *)) {
            _listTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.listTableView];
    }
    return _listTableView;
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        //自动网格布局
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];

//        flowLayout.itemSize = CGSizeMake((mDeviceWidth - 30)/2, (mDeviceWidth - 30)/2);
        //网格布局
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, mDeviceWidth, (mDeviceWidth - 10)/2*7 + mDeviceWidth/2.7*3 + 50) collectionViewLayout:flowLayout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.scrollEnabled = NO;
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        //注册cell
        [_collectionView registerClass:[productViewCell class] forCellWithReuseIdentifier:@"Cell"];
        //设置数据源代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = RGB(240, 240, 240);
    }
    return _collectionView;
    
}

-(NSMutableArray *)goodsArray{
    if (!_goodsArray) {
        _goodsArray = [[NSMutableArray alloc] init];
    }
    return _goodsArray;
}
-(NSMutableArray *)xiaoquArray{
    if (!_xiaoquArray) {
        _xiaoquArray = [[NSMutableArray alloc] init];
    }
    return _xiaoquArray;
}
-(NSMutableArray *)shopGoodsArray{
    if (!_shopGoodsArray) {
        _shopGoodsArray = [[NSMutableArray alloc] init];
    }
    return _shopGoodsArray;
}
-(indexGoodsProductAttrView *)productView{
    if (!_productView) {
        _productView = [[indexGoodsProductAttrView alloc] initWithFrame:CGRectMake(0, mDeviceHeight, mDeviceWidth, mDeviceHeight)];
        [_productView setBackgroundColor:RGBA(0, 0, 0, 0)];
        WEAKSELF
        [_productView setCloseClickBlock:^{
            
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.productView.backgroundColor = RGBA(0, 0, 0, 0);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.3f animations:^{
                    weakSelf.productView.frame = CGRectMake(0, mDeviceHeight, mDeviceWidth, mDeviceHeight);
                }];
            }];
            
            
        }];
    }
    return _productView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self tableV];
    
    self.bottomView = [[yzIndexBottomView alloc]initWithFrame:CGRectMake(0, mDeviceHeight - kTabBarHeight, mDeviceWidth, kTabBarHeight)];
    [self.bottomView setBackgroundColor:[UIColor whiteColor]];
    self.bottomView.layer.shadowOffset = CGSizeMake(0, 0);
    self.bottomView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.bottomView.layer.shadowOpacity = 0.5;
    self.bottomView.layer.shadowRadius = 5;
    [self.bottomView.btn1 addTarget:self action:@selector(guanjia:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView.btn2 addTarget:self action:@selector(unlock:) forControlEvents:UIControlEventTouchUpInside];
     [self.bottomView.btn3 addTarget:self action:@selector(order:) forControlEvents:UIControlEventTouchUpInside];
    // 单边阴影 顶边
    float shadowPathWidth = self.bottomView.layer.shadowRadius;
    CGRect shadowRect = CGRectMake(0, 0-shadowPathWidth/2.0, self.bottomView.bounds.size.width, shadowPathWidth);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:shadowRect];
    self.bottomView.layer.shadowPath = path.CGPath;

    
    [self.view addSubview:self.bottomView];

    
    self.equalIDs = @[@"11111111111111111111111111111111",@"22222222222222222222222222222222",@"33333333333333333333333333333333",@"44444444444444444444444444444444",@"55555555555555555555555555555555"].mutableCopy;
   
//    self.typeArr = @[@"1",@"1",@"1",@"1",@"2",@"1",@"1",@"1",@"1",@"1",@"1",@"2",@"1",@"1",@"1",@"1",@"2"];
    self.typeArr = [NSArray array];
    self.titleArr = @[@"消息",@"扫一扫"];
    self.imageArr = @[@"消息",@"扫码"];
    
    self.listTableView.estimatedRowHeight = 0;
    self.listTableView.estimatedSectionFooterHeight = 0;
    self.listTableView.estimatedSectionHeaderHeight = 0;
    
    [self.listTableView setMj_header:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
    
        [self getPublicData];
        [self.listTableView.mj_header endRefreshing];
    }]];
    self.listTableView.mj_header.automaticallyChangeAlpha = YES;
    
//    [self.listTableView setMj_footer:[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{

//        [self getIndexData];
//        [self.listTableView.mj_footer endRefreshing];
//    }]];
    [self.listTableView registerNib:[UINib nibWithNibName:@"indexShopViewCell" bundle:nil] forCellReuseIdentifier:@"indexShopViewCell"];
    

    [self getPublicData];
    
    
    // 创建外设管理器，会回调peripheralManagerDidUpdateState方法
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    
}
#pragma mark  -- 获取数据
-(void)getPublicData{
    //创建信号量
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(2);
    // 创建全局并行
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
   
    
    
    //任务 获取产品详细信息
    dispatch_async(quene, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        [self getShopData];
        dispatch_semaphore_signal(semaphore);
    });

}


#pragma mark  --  开始定位
-(void)startLocation{
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    //   定位超时时间，最低2s，此处设置为10s
    self.locationManager.locationTimeout = 2;
    //   逆地理请求超时时间，最低2s，此处设置为10s
    self.locationManager.reGeocodeTimeout = 2;
    
    // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error) {
            NSLog(@"locError:{%ld - %@}",(long)error.code,error.localizedDescription);
            if (error.code == AMapLocationErrorLocateFailed) {
                return ;
            }
        }
        NSLog(@"===%.10f===%.10f",location.coordinate.latitude,location.coordinate.longitude);
     
        self.point = MAMapPointForCoordinate(CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude));
        //创建信号量
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(2);
        // 创建全局并行
        dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //小区  获取小区信息
        dispatch_async(quene, ^{
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            [self getQuList];
            dispatch_semaphore_signal(semaphore);
        });
        if (regeocode) {
            NSLog(@"reGeocode:%@",regeocode);
        }
        
    
    }];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:YES];
    //解决滑动视图顶部空出状态栏高度的问题
    if (@available(iOS 11.0, *)) {
        self.listTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        if([UIViewController instancesRespondToSelector:@selector(edgesForExtendedLayout)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        
    }
    [self setStatusBarBackgroundColor:RGBA(255, 255, 255, 0)];
    [self.navigationController.navigationBar setBackgroundColor:RGBA(255, 255, 255, 0)];
    //左侧扫描按钮
    UIButton *scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [scanBtn setImage:[UIImage imageNamed:@"我的"] forState:UIControlStateNormal];
    [scanBtn setBackgroundColor:[UIColor clearColor]];
    [scanBtn setFrame:CGRectMake(0, 0, AutoWitdh(32), AutoWitdh(32))];
    [scanBtn addTarget:self action:@selector(myClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *scanItem = [[UIBarButtonItem alloc] initWithCustomView:scanBtn];
    [self.navigationController.visibleViewController.navigationItem setLeftBarButtonItem:scanItem];

    UIView* headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mDeviceWidth - 100, 32)];
    [headView setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.visibleViewController.navigationItem setTitleView:headView];
    
    
    self.locationLabel = [[UILabel alloc]init];
    self.locationLabel.textAlignment = NSTextAlignmentLeft;
    self.locationLabel.font = YSize(14.0);
    
    [self.locationLabel setTextColor:[UIColor whiteColor]];
    [self.locationLabel setFrame:CGRectMake(0, 0, headView.frame.size.width/3*2, 32)];
    [headView addSubview:self.locationLabel];
    
    
    
    self.first = [[NSUserDefaults standardUserDefaults] objectForKey:@"first"];
    NSLog(@"第一次==%@",self.first);
    if (![self.first isEqualToString:@"1"]) {
        //创建信号量
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(2);
        // 创建全局并行
        dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        //定位
        dispatch_async(quene, ^{
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            //开始定位
            [self startLocation];
            dispatch_semaphore_signal(semaphore);
        });
    }else{
        //获取小区数据
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"XiaoQuModel"];
        
        
        yzXiaoQuModel* quModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        
        
        //        yzXiaoQuModel* quModel = [[NSUserDefaults standardUserDefaults] objectForKey:@"XiaoQuModel"];
        self.locationLabel.text = [NSString stringWithFormat:@"%@%@-%@-%@",quModel.xiaoqu_name,quModel.louYu,quModel.danYuan,quModel.floor];
        NSLog(@"%@%@-%@-%@",quModel.xiaoqu_name,quModel.louYu,quModel.danYuan,quModel.floor);
        if (quModel.louYu.length==1) {
            quModel.louYu = [@"0" stringByAppendingString:quModel.louYu];
        }
        if (quModel.danYuan.length==1) {
            quModel.danYuan = [@"0" stringByAppendingString:quModel.danYuan];
        }
        if (quModel.floor.length==1) {
            quModel.floor = [@"0" stringByAppendingString:quModel.floor];
        }
        self.sendAllNum = [NSString stringWithFormat:@"AAFF%@%@%@55",quModel.louYu,quModel.danYuan,quModel.floor];
    }
    
    
    
    //消息
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuBtn setImage:[UIImage imageNamed:@"iconfontadd"] forState:UIControlStateNormal];
    [menuBtn setBackgroundColor:[UIColor clearColor]];
    [menuBtn setFrame:CGRectMake(0, 0, AutoWitdh(32), AutoWitdh(32))];
    [menuBtn addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    [self.navigationController.visibleViewController.navigationItem setRightBarButtonItem:menuItem];

    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    if(offsetY > 0){
        [self.navigationController.navigationBar setBackgroundColor:RGBA(255, 255, 255, ((offsetY - 50 ) / 150))];
        [self setStatusBarBackgroundColor:RGBA(255, 255, 255, ((offsetY - 50 ) / 150))];
    }
    
    //footerView
    if (scrollView == self.listTableView) {
        //去掉UItableview的section的footerview黏性
        CGFloat sectionFooterHeight = 15;
        if (scrollView.contentOffset.y<=sectionFooterHeight && scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionFooterHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }
    }
}
//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
        case 1:
        case 2:
        case 3:
            return 1;
            break;

        default:
            return self.goodsArray.count > 0?1:0;
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return mDeviceWidth/1.53 + 30;
            break;
        case 1:
            return 181;
            break;
        case 2:
            return 75 + (mDeviceWidth - 40)/3 ;
            break;
        case 3:
            return (mDeviceWidth - 10)/2*7 + mDeviceWidth/2.7*3 + 50;
            break;

        default:
            return 0;
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
            case 2:
            return 15;
            break;
        case 3:
            return 15;
            break;
            
        default:
            return 0;
            break;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 2:{
            UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mDeviceWidth, 15)];
            view.backgroundColor = RGB(240, 240, 240);
            return view;
        }
            break;
        case 3:{
            UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mDeviceWidth, 15)];
            view.backgroundColor = RGB(240, 240, 240);
            return view;
        }
            break;
            
        default:
            return nil;
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            indexAdPicViewCell *cell = [[indexAdPicViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
            UIImageView* headB = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mDeviceWidth, mDeviceWidth/1.53)];
            headB.image = [UIImage imageNamed:@"headB"];
            headB.userInteractionEnabled = YES;
            [cell addSubview:headB];
            
            
            
            NSArray *imageArray = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1537459349378&di=91ef08121afbaf39f0ac21f6fcb4028b&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fwallpaper%2Fb%2F55597435bb036.jpg",@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1554952423&di=1a4f1d4e309efb1289d5939f5b2c93be&src=http://img15.3lian.com/2015/f2/57/d/93.jpg",@"http://h.hiphotos.baidu.com/image/pic/item/18d8bc3eb13533fa65021ddba5d3fd1f40345b8b.jpg"];
            cell.dcCycleS = [DCCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 80, self.view.frame.size.width, mDeviceWidth/2.2) shouldInfiniteLoop:YES imageGroups:imageArray];
            cell.dcCycleS.itemSpace = -4;
            cell.dcCycleS.autoScrollTimeInterval = 5;
            cell.dcCycleS.autoScroll = YES;
            cell.dcCycleS.isZoom = YES;
            //    banner.itemSpace = 0;
            cell.dcCycleS.imgCornerRadius = 10;
            cell.dcCycleS.itemWidth = self.view.frame.size.width - 100;
            cell.dcCycleS.delegate = self;
            
            [headB addSubview:cell.dcCycleS];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 1:{
            indexGNViewCell *gnCell = [tableView dequeueReusableCellWithIdentifier:@"indexGNViewCell"];
            if (!gnCell) {
                gnCell = (indexGNViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"indexGNViewCell" owner:self options:nil] lastObject];
            }
            gnCell.delegate = self;
            [gnCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return gnCell;
        }
            break;
        case 2:{
            indexMsgViewCell *msgCell = [[indexMsgViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
           
            [msgCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            NSArray* imageArr = @[@"洗衣",@"开锁",@"保洁"];
            for (int i = 0; i<imageArr.count; i++) {
                UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(10 + (10 + (mDeviceWidth - 40)/3)*i, 60, (mDeviceWidth - 40)/3, (mDeviceWidth - 40)/3)];
                [btn setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
                btn.tag = 100  + i;
                [btn addTarget:self action:@selector(fuwu:) forControlEvents:UIControlEventTouchUpInside];
                [msgCell addSubview:btn];
            }
            
            return msgCell;
        }
            break;
    
        
        default:{
            UITableViewCell* cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            [cell addSubview:self.collectionView];
            
       
            
            return cell;
        }
            break;
    }
    
}


#pragma mark  --  collectionView

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.shopGoodsArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    productViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
//    [cell setBackgroundColor:[UIColor orangeColor]];
//    self.addBtn = cell.addBtn;
//    self.addBtn.tag = indexPath.row;
//    [self.addBtn addTarget:self action:@selector(addBtn:) forControlEvents:UIControlEventTouchUpInside];
    yzIndexShopGoodsModel *model = self.shopGoodsArray[indexPath.row];
    [cell getMessageByModel:model];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    yzIndexShopGoodsModel *model = self.shopGoodsArray[indexPath.row];
    if (![model.goodsId isEqualToString:@"<null>"]) {
        return CGSizeMake((mDeviceWidth - 10)/2, (mDeviceWidth - 10)/2);
    }else{
       return CGSizeMake(mDeviceWidth, mDeviceWidth/2.7);
    }
//    if (indexPath.row==4) {
//        return CGSizeMake(mDeviceWidth, mDeviceWidth/2.7);
//    }else if (indexPath.row==11){
//    return CGSizeMake(mDeviceWidth, mDeviceWidth/2.7);
//    }else if (indexPath.row==16){
//        return CGSizeMake(mDeviceWidth, mDeviceWidth/2.7);
//    }else{
//        return CGSizeMake((mDeviceWidth - 10)/2, (mDeviceWidth - 10)/2);
//    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    yzGoodsDetailViewController* detailVC = [[yzGoodsDetailViewController alloc]init];
    yzIndexShopGoodsModel* model = self.shopGoodsArray[indexPath.row];
    if (model.have_attr) {
        detailVC.type = @"2";
    }else{
        detailVC.type = @"1";
    }
    detailVC.model = model;
    [self.navigationController pushViewController:detailVC animated:YES];
}



/** 功能管理 */
-(void)toGnViewClick:(NSInteger)currentIndex{
    if (![yzUserInfoModel getisLogin]) {
        yzLoginViewController *loginView = [[yzLoginViewController alloc] init];
        [loginView setLoginSuccessBlock:^{
            [self.listTableView.mj_header beginRefreshing];
        }];
        [self.navigationController presentViewController:[yzProductPubObject navc:loginView] animated:YES completion:nil];
    }else{
        switch (currentIndex) {
            case 0:
                {
//钥匙管理
                    yzKeyListController* keyVC = [[yzKeyListController alloc]init];
                    [self.navigationController pushViewController:keyVC animated:YES];
                }
                break;
            case 1:{
//访客邀请
                yzInviteController* invitVC = [[yzInviteController alloc]init];
                [self.navigationController pushViewController:invitVC animated:YES];
                
            }
                break;
            case 2:{
//物业缴费
                yzWuYePayController* wyPayVC = [[yzWuYePayController alloc]init];
                wyPayVC.quStr = self.locationLabel.text;
                [self.navigationController pushViewController:wyPayVC animated:YES];
                
            }
                break;
            case 3:{
                //物业报修
                yzRepairsController *repairVC = [[yzRepairsController alloc] init];
                [self.navigationController pushViewController:repairVC animated:YES];
            }
                break;
            case 4:{
//                if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isSelectedQu"]) {
//                    [DDProgressHUD showErrorImageWithInfo:@"请选择小区"];
//                    return;
//                }
                //物业投诉
                yzComplainController *complainVC = [[yzComplainController alloc] init];
                [self.navigationController pushViewController:complainVC animated:YES];
            }
                break;
            case 5:{
                yzNewInformationController *infomationView = [[yzNewInformationController alloc] init];
                [self.navigationController pushViewController:infomationView animated:YES];
            }
                break;
            case 6:{
                
                yzVoteController* voteVC = [[yzVoteController alloc]init];
                [self.navigationController pushViewController:voteVC animated:YES];
                
//                NSString *appUserId = [yzUserInfoModel getLoginUserInfo:@"userId"];
//                NSLog(@"====%@",appUserId);

                
            }
                break;
            case 7:
            {
//                tenementListViewController *tene = [[tenementListViewController alloc] init];
//                [self.navigationController pushViewController:tene animated:YES];
                
//                yzWuYeServeController* serve = [[yzWuYeServeController alloc]init];
//                [self.navigationController pushViewController:serve animated:YES];
                
            }
                break;
       
            
            default:
                break;
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/** 点击图片回调 */
- (void)cycleScrollView:(DCCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"%ld",(long)index);
}


/** 我的 */
-(void)myClick:(id)sender{
//    DCGMScanViewController *scan = [[DCGMScanViewController alloc] init];
//    [self.navigationController pushViewController:scan animated:YES];
//    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    yzMyViewController* myVC = [[yzMyViewController alloc]init];
    [self.navigationController pushViewController:myVC animated:YES];
}

/** 消息事件 */
-(void)menuClick:(id)sender{

    [SGDropMenu showDropMenuFrame:CGRectMake(self.view.frame.size.width - 134, 60, 120, 88) ArrowOffset:102.f TitleArr:self.titleArr ImageArr:self.imageArr Type:SGDropMenuTypeQQ LayoutType:SGDropMenuLayoutTypeNormal RowHeight:40.f Delegate:self];
    
}

- (void)didSelectRowAtIndex:(NSInteger)index Title:(NSString *)title Image:(NSString *)image {
    if (index==0) {
        yzMessageController* messageVC = [[yzMessageController alloc]init];
        [self.navigationController pushViewController:messageVC animated:YES];
        
    }else{
        DCGMScanViewController *scan = [[DCGMScanViewController alloc] init];
        [self.navigationController pushViewController:scan animated:YES];
        [self.view setBackgroundColor:[UIColor whiteColor]];
    }
}
/** 洗衣  开锁  保洁 */
-(void)fuwu:(UIButton*)sender{
    if (sender.tag==100) {
        NSLog(@"洗衣");
    }else if (sender.tag==101){
         NSLog(@"开锁");
    }else{
         NSLog(@"保洁");
    }
}


/** 进入店铺 */
-(void)enterShop{
//    yzWuYeServeController* serveVC = [[yzWuYeServeController alloc]init];
//    [self.navigationController pushViewController:serveVC animated:YES];
    
}


/** 加入购物车按钮 */
-(void)addBtn:(UIButton*)sender{
    
    if (![yzUserInfoModel getisLogin]) {
        yzLoginViewController *loginView = [[yzLoginViewController alloc] init];
        [loginView setLoginSuccessBlock:^{
            [self.listTableView.mj_header beginRefreshing];
        }];
        [self.navigationController presentViewController:[yzProductPubObject navc:loginView] animated:YES completion:nil];
    }else{
    
    yzIndexShopGoodsModel *model = self.shopGoodsArray[sender.tag];
    WEAKSELF
    if (model.have_attr) {
        //打开规格选择
        [UIView animateWithDuration:0.5f animations:^{
            
            self.productView.frame = CGRectMake(0, 0, mDeviceWidth, mDeviceHeight);
            [self.productView.goodsNumber setText:@"1"];
//            [self.productView setAddGoodsCartBlock:^(NSString* goods_id, NSString *attr_id, NSString *count) {
//                [weakSelf addGoodsCart:goods_id attrId:attr_id count:count];
//            }];
        } completion:^(BOOL finished) {
//            [self.productView setGoodsInfoModel:model];
            [self.productView getGoodsAttr:model.goodsId];
            self.productView.backgroundColor = RGBA(0, 0, 0, 0.4);
        }];
    }else{
        [self addGoodsCart:model.goodsId attrId:@"" count:@"1"];
        
    }
    }
}
/**加入购物车 */
-(void)addGoodsCart:(NSString*)goods_id attrId:(NSString *)attr_id count:(NSString *)count{
    [DDProgressHUD show];
    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/biku/saveShoppingCar",postUrl] version:@"" parameters:@{@"goodId":goods_id,@"attrId":attr_id,@"count":count,@"userId":[yzUserInfoModel getLoginUserInfo:@"userId"]} success:^(id object) {
//        [yzUserInfoModel getLoginUserInfo:@"userId"]
        [DDProgressHUD dismiss];
        NSDictionary *json = object;
        if ([[json objectForKey:@"code"] intValue] == 200) {
            [DDProgressHUD showSuccessImageWithInfo:[json objectForKey:@"message"]];
            //关闭视图
            [self.productView closeClick:nil];
        }else{
            [DDProgressHUD showErrorImageWithInfo:[json objectForKey:@"message"]];
        }
        
    } failure:^(NSError *error) {
        [DDProgressHUD showErrorImageWithInfo:error.localizedDescription];
    }];
}


#pragma mark --  调用接口
/** 获取物业店铺信息 */
-(void)getShopData{
    [DDProgressHUD show];
    
    [CCAFNetWork get:[NSString stringWithFormat:@"%@app/biku/homeGoodsWithAdv",postUrl] version:@"" parameters:nil success:^(id object) {
        [DDProgressHUD dismiss];
        NSDictionary *json = object;
        self.shopGoodsArray = [NSMutableArray array];
        if ([[json objectForKey:@"code"] intValue] == 200) {
            NSMutableArray* goods = [json objectForKey:@"data"];
            
            for (int i = 0; i < goods.count; i ++) {
                yzIndexShopGoodsModel *model = [[yzIndexShopGoodsModel alloc] init:goods[i]];
                [self.shopGoodsArray addObject:model];
            }
        }else{
            [DDProgressHUD showErrorImageWithInfo:[json objectForKey:@"message"]];
        }
//        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        [DDProgressHUD showErrorImageWithInfo:error.localizedDescription];
    }];
    
    
}


//获取小区信息
-(void)getQuList{
    
    self.sendAllNum = @"";
    
    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/index/getindexdata",postUrl] version:@"" parameters:@{@"appUserId":@"15480657277192808527845679645019"} success:^(id object) {
        
        NSDictionary *json = object;
        
        
        if ([[json objectForKey:@"code"] intValue] == 200) {
            
            
//            [DDProgressHUD showSuccessImageWithInfo:[json objectForKey:@"message"]];
            NSDictionary *userDict = json[@"data"];
            
            //存储小区数据
            NSMutableArray *xiaoQuListArray = [userDict objectForKey:@"xiaoQu"];
            NSMutableArray *quListArray = [[NSMutableArray alloc] init];
            self.pointArray = [[NSMutableArray alloc]init];
            for (int i = 0; i < xiaoQuListArray.count ; i ++) {
                NSDictionary *quDict = [xiaoQuListArray objectAtIndex:i];

                yzXiaoQuModel *quModel = [[yzXiaoQuModel alloc] init];
                quModel.xiaoqu_id = [yzProductPubObject withStringReturn:quDict[@"id"]];
                quModel.xiaoqu_name = [yzProductPubObject withStringReturn:quDict[@"name"]];
                quModel.wuye_id = [yzProductPubObject withStringReturn:quDict[@"wuYeId"]];
                 quModel.location = [yzProductPubObject withStringReturn:quDict[@"location"]];
                quModel.louYu = [yzProductPubObject withStringReturn:quDict[@"louYu"]];
                quModel.danYuan = [yzProductPubObject withStringReturn:quDict[@"danYuan"]];
                quModel.floor = [yzProductPubObject withStringReturn:quDict[@"floor"]];
                
                [quListArray addObject:quModel];
                NSString* str = quModel.location;
                str = [str stringByReplacingOccurrencesOfString:@"{" withString:@""];
                str = [str stringByReplacingOccurrencesOfString:@"}" withString:@""];
                
                [self.pointArray addObject:str];
                
            }
            if (![self.first isEqualToString:@"1"]) {
                self.distanceArray = [[NSMutableArray alloc]init];
                for (int i = 0; i<self.pointArray.count; i++) {
                    NSArray* arr = [self.pointArray[i] componentsSeparatedByString:@","];
                    CLLocationDegrees latitude = [[arr objectAtIndex:0] doubleValue];
                     
                    CLLocationDegrees longitude = [[arr objectAtIndex:1] doubleValue];
                    MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(latitude,longitude));
                    //2.计算距离
                    CLLocationDistance distance = MAMetersBetweenMapPoints(self.point,point2);
                    
                    
                    [self.distanceArray addObject:[NSNumber numberWithDouble:distance]];
                    
                    
                }
                
                
                double min_number = 100000000;
                int min_index = 0;
                
                
                for (int i = 0; i<self.distanceArray.count; i++) {
                    //取最大值和最大值的对应下标
                    double b = [self.distanceArray[i] doubleValue];
                    if (b<min_number) {
                        min_index = i;
                    }
                    min_number = b<min_number?b:min_number;
                    
                    yzXiaoQuModel *quModel = quListArray[min_index];
         
                    self.locationLabel.text = [NSString stringWithFormat:@"%@%@-%@-%@",quModel.xiaoqu_name,quModel.louYu,quModel.danYuan,quModel.floor];
                    
                    if (quModel.louYu.length==1) {
                        quModel.louYu = [@"0" stringByAppendingString:quModel.louYu];
                    }
                    if (quModel.danYuan.length==1) {
                        quModel.danYuan = [@"0" stringByAppendingString:quModel.danYuan];
                    }
                    if (quModel.floor.length==1) {
                        quModel.floor = [@"0" stringByAppendingString:quModel.floor];
                    }
                    self.sendAllNum = [NSString stringWithFormat:@"AAFF%@%@%@55",quModel.louYu,quModel.danYuan,quModel.floor];
                    
                     [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject: quModel] forKey:@"XiaoQuModel"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
               
                
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"first"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }
            
            
            
            
            
            [self.xiaoquArray removeAllObjects];
         
            
        }else{
            [DDProgressHUD showErrorImageWithInfo:[json objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [DDProgressHUD showErrorImageWithInfo:error.localizedDescription];
    }];
}

#pragma mark -- 底部三个按钮
-(void)guanjia:(UIButton*)sender{
    yzHouseKeepController* keepVC = [[yzHouseKeepController alloc]init];
    [self.navigationController pushViewController:keepVC animated:YES];
}
-(void)unlock:(UIButton*)sender{
    NSString *appUserId = [yzUserInfoModel getLoginUserInfo:@"userId"];
    NSLog(@"====%@",appUserId);
    //                for (NSString* userid in self.equalIDs) {
    if ([self.equalIDs containsObject:appUserId]) {
        yzOnePassController *passView = [[yzOnePassController alloc] init];
        [self.navigationController pushViewController:passView animated:YES];
    }else{
        if (self.sendAllNum.length>0) {
            [self openTheDoorByNum:self.sendAllNum];
        }else{
            [DDProgressHUD showErrorImageWithInfo:@"没有楼层信息"];
        }
        
    }
}
-(void)order:(UIButton*)sender{
    yzOrderListController* orderVC = [[yzOrderListController alloc]init];
    [self.navigationController pushViewController:orderVC animated:YES];
}



#pragma mark --- 蓝牙部分

-(void)openTheDoorByNum:(NSString*)str{
    if (self.characteristic) {
        if (self.peripheralManager.isAdvertising) {
            [self.peripheralManager stopAdvertising];
            
            // 根据服务的UUID开始广播
            [self.peripheralManager startAdvertising:@{CBAdvertisementDataServiceUUIDsKey:@[[CBUUID UUIDWithString:SERVICE_UUID]],CBAdvertisementDataLocalNameKey:str}];
            
        }else{
            // 根据服务的UUID开始广播
            [self.peripheralManager startAdvertising:@{CBAdvertisementDataServiceUUIDsKey:@[[CBUUID UUIDWithString:SERVICE_UUID]],CBAdvertisementDataLocalNameKey:str}];
        }
        
        
        BOOL sendSuccess = [self.peripheralManager updateValue:[str dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:self.characteristic onSubscribedCentrals:nil];
        
        
        if (sendSuccess) {
            [DDProgressHUD showSuccessImageWithInfo:@"数据发送成功"];
            NSLog(@"数据发送成功: %@",str);
            //同时创建计时器 开始倒计时
            [self createTimer];
        }else {
            [DDProgressHUD showErrorImageWithInfo:@"数据发送失败"];
            NSLog(@"数据发送失败");
        }
    }else{
        NSLog(@"蓝牙未开启");
        
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"蓝牙未开启，请先打开蓝牙再使用" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertController addAction:sureAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
}


/** 设备的蓝牙状态
 CBManagerStateUnknown = 0,  未知
 CBManagerStateResetting,    重置中
 CBManagerStateUnsupported,  不支持
 CBManagerStateUnauthorized, 未验证
 CBManagerStatePoweredOff,   未启动
 CBManagerStatePoweredOn,    可用
 */
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    CBPeripheralManagerState state = (CBPeripheralManagerState)peripheral.state;
    switch (state) {
        case CBPeripheralManagerStateUnknown:
        {
            NSLog(@"未知蓝牙状态");
        }
            break;
        case CBPeripheralManagerStateResetting:
        {
            NSLog(@"蓝牙重置中");
        }
            break;
        case CBPeripheralManagerStateUnsupported:
        {
            NSLog(@"不支持蓝牙");
        }
            break;
        case CBPeripheralManagerStateUnauthorized:
        {
            NSLog(@"蓝牙未授权");
        }
            break;
        case CBPeripheralManagerStatePoweredOn:
        {
            NSLog(@"蓝牙开启");
            
            // 创建Service（服务）和Characteristics（特征）
            [self setupServiceAndCharacteristics];
        }
            break;
        case CBPeripheralManagerStatePoweredOff:
        {
            NSLog(@"蓝牙关闭");
            self.characteristic = nil;
            [self.peripheralManager stopAdvertising];
            
        }
            break;
            
            
        default:
            break;
    }
    
    
}

/** 创建服务和特征 */
- (void)setupServiceAndCharacteristics {
    // 创建服务
    CBUUID *serviceID = [CBUUID UUIDWithString:SERVICE_UUID];
    CBMutableService *service = [[CBMutableService alloc] initWithType:serviceID primary:YES];
    // 创建服务中的特征
    CBUUID *characteristicID = [CBUUID UUIDWithString:CHARACTERISTIC_UUID];
    CBMutableCharacteristic *characteristic = [
                                               [CBMutableCharacteristic alloc]
                                               initWithType:characteristicID
                                               properties:
                                               CBCharacteristicPropertyRead |
                                               CBCharacteristicPropertyWrite |
                                               CBCharacteristicPropertyNotify
                                               value:nil
                                               permissions:CBAttributePermissionsReadable |
                                               CBAttributePermissionsWriteable | CBAttributePermissionsWriteable
                                               ];
    // 特征添加进服务
    service.characteristics = @[characteristic];
    
    // 为了手动给中心设备发送数据
    self.characteristic = characteristic;
    
    // 服务加入管理
    [self.peripheralManager addService:service];
    
    
}

#pragma mark - 定时器 (GCD)
- (void)createTimer {
    
    //设置倒计时时间
    //通过检验发现，方法调用后，timeout会先自动-1，所以如果从15秒开始倒计时timeout应该写16
    //__block 如果修饰指针时，指针相当于弱引用，指针对指向的对象不产生引用计数的影响
    __block int timeout = 2;
    
    //获取全局队列
    dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //创建一个定时器，并将定时器的任务交给全局队列执行(并行，不会造成主线程阻塞)
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, global);
    
    // 设置触发的间隔时间
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    //1.0 * NSEC_PER_SEC  代表设置定时器触发的时间间隔为1s
    //0 * NSEC_PER_SEC    代表时间允许的误差是 0s
    
    //block内部 如果对当前对象的强引用属性修改 应该使用__weak typeof(self)weakSelf 修饰  避免循环调用
    __weak typeof(self)weakSelf = self;
    //设置定时器的触发事件
    dispatch_source_set_event_handler(timer, ^{
        
        //倒计时  刷新button上的title ，当倒计时时间为0时，结束倒计时
        
        //1. 每调用一次 时间-1s
        timeout --;
        
        //2.对timeout进行判断时间是停止倒计时，还是修改button的title
        if (timeout <= 0) {
            
            //停止倒计时，button打开交互，背景颜色还原，title还原
            
            //关闭定时器
            dispatch_source_cancel(timer);
            
            //MRC下需要释放，这里不需要
            //            dispatch_realse(timer);
            
            //button上的相关设置
            //注意: button是属于UI，在iOS中多线程处理时，UI控件的操作必须是交给主线程(主队列)
            //在主线程中对button进行修改操作
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (weakSelf.peripheralManager.isAdvertising) {
                    [weakSelf.peripheralManager stopAdvertising];
                }
            });
        }
    });
    
    dispatch_resume(timer);
}

@end
