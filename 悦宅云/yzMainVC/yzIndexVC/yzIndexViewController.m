//
//  yzIndexViewController.m
//  yzProduct
//
//  Created by LiuHQ on 2018/9/20.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "yzIndexViewController.h"
//FMDB
#import "yzThroughRecordModel_Helper.h"
#import "yzThroughRecordModel.h"

#import "indexGNViewCell.h"     //功能cell
#import "indexMsgViewCell.h"     //资讯cell

//#import "indexShopViewCell.h"   //店铺cell
//#import "indexGoodsViewCell.h"  //产品cell

//view
#import "indexTopLocationView.h" //顶部选择view
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


#import "yzMessageController.h"

//#import "productViewCell.h"
#import "indexAdPicViewCell.h"
#import "productViewCell.h"
#import "yzFuWuWebController.h"

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
#import "yzPayListController.h"       //缴费列表
#import "yzIndexBottomView.h"        //自定义tabbar

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapKit/MAMapKit.h>

#import <CoreBluetooth/CoreBluetooth.h>
#import "yzMenuCell.h"

#import "WBGuideCover.h"            //引导图

#import "SELUpdateAlert.h"          //提示更新
#import "yzHeaderDetailController.h" //顶部轮播详情
#import "ICCardController.h"

#define SERVICE_UUID @"CDD1"
#define CHARACTERISTIC_UUID @"CDD2"
// 颜色RGB
#define XYQColorRGB(r, g, b)　　 [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define XYQColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
@interface yzIndexViewController ()<indexGNViewCellDelegate,DCCycleScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,SGDropMenuDelegate,AMapLocationManagerDelegate,CBPeripheralManagerDelegate,CBCentralManagerDelegate>

@property (nonatomic, strong) UIButton *titleButton;//顶部信息
@property (nonatomic, strong) indexTopLocationView *topLocationView;//社区选择view
@property (nonatomic, strong) indexGoodsProductAttrView *productView;
@property (nonatomic, assign) BOOL isShowTop;//是否显示顶部view
@property (nonatomic, strong) NSMutableArray *goodsArray;//产品数组
@property (nonatomic, strong) NSMutableArray *shopGoodsArray;//小区产品数组
@property (nonatomic, strong) NSMutableArray *xiaoquArray;//小区数组

@property (nonatomic,strong)NSString* sendAllNum;     //最终发送的楼宇信息

@property (nonatomic,strong)NSMutableArray* equalIDs;   //匹配的id

@property (nonatomic,strong)UICollectionView* collectionView;
@property (nonatomic,strong)NSArray* typeArr;
@property (nonatomic,strong)UIButton* addBtn;

/** titleArr */
@property (nonatomic, strong) NSArray *titleArr;
/** imgArr */
@property (nonatomic, strong) NSArray *imageArr;
//顶部地址
@property (nonatomic, strong) UIButton* locationBtn;
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

@property(nonatomic,strong)CBCentralManager* centeralManager;
@property(nonatomic,strong)NSMutableArray <CBPeripheral*>* scanedDevices;

// 用来存放Cell的唯一标示符
@property (nonatomic, strong) NSMutableDictionary *cellDic;
@property (nonatomic, strong) NSArray* images;
@property (nonatomic, strong) NSArray* titles;

@property (nonatomic, strong) NSMutableArray* headerImages;
    @property (nonatomic, strong) NSMutableArray* bottomAdvertArr;  //底部功能

@property (nonatomic, strong) yzXiaoQuModel *quModel;
@property (nonatomic, strong) NSString* holidayStr;            //板子广播信息是否是节假日
@property (nonatomic, strong) NSString* scanType;    //0  打开扫一次   1  点击扫描   2  不提示
@property (nonatomic, assign) BOOL scan;
@property (nonatomic, strong) NSString* dianTiId;
@property (nonatomic, strong) NSString* sysDeviceDiantiCode;
@property (nonatomic, strong) NSString* target;      //目标指令   电梯名称后两位

@property (nonatomic, strong) UIView* alpView;       //新手引导
@property (nonatomic, strong) UIImageView* pointImage;
@property (nonatomic, assign) int tag;


@property (nonatomic, strong) NSMutableArray* bleNameArray;    //搜索到的蓝牙数组
@property (nonatomic, strong) NSMutableArray* midArray;
@property (nonatomic, strong) NSMutableArray* finalArray;
@property (nonatomic, strong) NSMutableArray* ThroughRecord;   //通行记录


@property (nonatomic, strong) NSDictionary* wuYeNotice;        //通知公告
@property (nonatomic, strong) NSString* notice;

@property (nonatomic, strong) NSString* show;

@property (nonatomic, strong) NSString* locationVersion;       //本地版本号
@property (nonatomic, strong) NSString* onlineVersion;         //线上版本号

@property (nonatomic, strong) NSString* wangluo;               //0 无网络  1 有网络
@property (nonatomic, strong) NSString* openTime;              //开门时间
@property (nonatomic, strong) NSString* tiDoor;                //F 门禁    电梯

@property (nonatomic, strong) NSString* startNum;              //1 打开程序发送广播  2来回切换蓝牙不发送广播

@property (nonatomic, strong) UIButton* unlockBtn;             //底部覆盖通行按钮
@property (nonatomic, assign) BOOL open;                       //蓝牙是否开启


@property (nonatomic,strong) NSString* year;         //年
@property (nonatomic,strong) NSString* mouth;        //月
@property (nonatomic,strong) NSString* day;          //日
@property (nonatomic,strong) NSString* hour;         //时
@property (nonatomic,strong) NSString* minute;       //分
@property (nonatomic,strong) NSString* second;       //秒
@property (nonatomic,strong) NSString* week;         //周几
@property (nonatomic,strong) NSString* sendAll;
@property (nonatomic, strong) NSString* verify1;      //校验码时间校验
@property (nonatomic,strong)UIButton* wuganBtn;
@end

@implementation yzIndexViewController

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        
//        if (@available(iOS 11.0, *)) {
//            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//
//        } else {
//            self.automaticallyAdjustsScrollViewInsets = NO;
//
//        }
        
        //自动网格布局
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];

        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
//        flowLayout.itemSize = CGSizeMake((mDeviceWidth - 30)/2, (mDeviceWidth - 30)/2);
        //网格布局
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, mDeviceWidth, mDeviceHeight - 50 - KSAFEBAR_HEIGHT) collectionViewLayout:flowLayout];
        _collectionView.showsVerticalScrollIndicator = NO;
     
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        //注册cell
        [_collectionView registerClass:[indexAdPicViewCell class] forCellWithReuseIdentifier:@"Cell1"];
        [_collectionView registerClass:[yzMenuCell class] forCellWithReuseIdentifier:@"Cell2"];
//        [_collectionView registerClass:[indexMsgViewCell class] forCellWithReuseIdentifier:@"Cell3"];
//        [_collectionView registerClass:[productViewCell class] forCellWithReuseIdentifier:@"Cell"];
        //设置数据源代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    
        _collectionView.backgroundColor = RGB(240, 240, 240);
        [self.view addSubview:self.collectionView];
    }
    return _collectionView;
    
}

-(NSMutableArray *)goodsArray{
    if (!_goodsArray) {
        _goodsArray = [[NSMutableArray alloc] init];
    }
    return _goodsArray;
}
-(NSMutableArray *)headerImages{
    if (!_headerImages) {
        _headerImages = [[NSMutableArray alloc] init];
    }
    return _headerImages;
}
    -(NSMutableArray *)bottomAdvertArr{
        if (!_bottomAdvertArr) {
            _bottomAdvertArr = [[NSMutableArray alloc] init];
        }
        return _bottomAdvertArr;
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
-(NSMutableArray *)ThroughRecord{
    if (!_ThroughRecord) {
        _ThroughRecord = [[NSMutableArray alloc] init];
    }
    return _ThroughRecord;
}

-(NSDictionary *)wuYeNoticeDic{
    if (!_wuYeNotice) {
        _wuYeNotice = [[NSDictionary alloc]init];
    }
    return _wuYeNotice;
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
//    self.extendedLayoutIncludesOpaqueBars = YES;
//    self.edgesForExtendedLayout = UIRectEdgeTop;
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    
    [self setHeaderBtn];
    
    self.startNum = @"1";
    
    self.bleNameArray = [NSMutableArray array];
    self.midArray = [NSMutableArray array];
    self.finalArray = [NSMutableArray array];
    self.cellDic = [[NSMutableDictionary alloc] init];
    self.images = @[@"钥匙管理",@"邀请",@"缴费",@"保修申请",@"投诉",@"资讯",@"投票",@"离线制卡"];
    self.titles = @[@"钥匙管理",@"访客邀请",@"物业缴费",@"物业报修",@"物业投诉",@"最新资讯",@"参与投票",@"IC卡管理"];
    [[NSUserDefaults standardUserDefaults] setObject:@[] forKey:@"ThroughRecord"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self collectionView];
    
    self.bottomView = [[yzIndexBottomView alloc]initWithFrame:CGRectMake(0, mDeviceHeight - kTabBarHeight, mDeviceWidth, kTabBarHeight)];
    [self.bottomView setBackgroundColor:[UIColor whiteColor]];
    self.bottomView.layer.shadowOffset = CGSizeMake(0, 0);
    self.bottomView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.bottomView.layer.shadowOpacity = 0.5;
    self.bottomView.layer.shadowRadius = 5;
    [self.bottomView.btn1 addTarget:self action:@selector(guanjia:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView.btn2 addTarget:self action:@selector(unlock:) forControlEvents:UIControlEventTouchUpInside];
   
    [self.bottomView.btn3 addTarget:self action:@selector(order:) forControlEvents:UIControlEventTouchUpInside];
    
    self.wuganBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.wuganBtn addTarget:self action:@selector(send:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.wuganBtn];
    
    // 单边阴影 顶边
    float shadowPathWidth = self.bottomView.layer.shadowRadius;
    CGRect shadowRect = CGRectMake(0, 0-shadowPathWidth/2.0, self.bottomView.bounds.size.width, shadowPathWidth);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:shadowRect];
    self.bottomView.layer.shadowPath = path.CGPath;

    
    [self.view addSubview:self.bottomView];

    self.unlockBtn = [[UIButton alloc]initWithFrame:CGRectMake(mDeviceWidth/5*2, mDeviceHeight - kTabBarHeight - 36, mDeviceWidth/5, kTabBarHeight + 36)];
    [self.unlockBtn setBackgroundColor:[UIColor clearColor]];
    
    [self.unlockBtn addTarget:self action:@selector(unlock:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.unlockBtn];
    
//    UIView* orangeView = [[UIView alloc]initWithFrame:CGRectMake(mDeviceWidth/3, mDeviceHeight - kTabBarHeight - 20, mDeviceWidth/3, kTabBarHeight + 20)];
//    [orangeView setBackgroundColor:[UIColor orangeColor]];
//
//    [self.view addSubview:orangeView];
//
//    UITapGestureRecognizer* tapO = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
//
//    [orangeView addGestureRecognizer:tapO];
    
    
    self.equalIDs = @[@"11111111111111111111111111111111",@"22222222222222222222222222222222",@"33333333333333333333333333333333",@"44444444444444444444444444444444",@"55555555555555555555555555555555"].mutableCopy;
   
//    self.typeArr = @[@"1",@"1",@"1",@"1",@"2",@"1",@"1",@"1",@"1",@"1",@"1",@"2",@"1",@"1",@"1",@"1",@"2"];
    self.typeArr = [NSArray array];
    self.titleArr = @[@"消息",@"扫一扫"];
    self.imageArr = @[@"消息",@"扫码"];
    
  
    [self.collectionView setMj_header:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        
        [self getQuList];

        
        [self.collectionView.mj_header endRefreshing];
    }]];
    self.collectionView.mj_header.automaticallyChangeAlpha = YES;
    

    [self getPublicData];

    // 创建外设管理器，会回调peripheralManagerDidUpdateState方法
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    self.centeralManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    
    
   
   

    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    
    self.locationVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];


    NSString *urlString=@"http://itunes.apple.com/lookup?id=1458318717"; //自己应用在App Store里的地址
    
    NSURL *url = [NSURL URLWithString:urlString];//这个URL地址是该app在iTunes connect里面的相关配置信息。其中id是该app在app store唯一的ID编号。
    
    NSString *jsonResponseString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
    NSData *data = [jsonResponseString dataUsingEncoding:NSUTF8StringEncoding];
    
    //    解析json数据
    
//    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//    
//    NSArray *array = json[@"results"];
//    
//    for (NSDictionary *dic in array) {
//        
//           self.onlineVersion = [dic valueForKey:@"version"]; // appStore 的版本号
//        
//    }
    NSString *first = [self.locationVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString *second = [self.onlineVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    if ([second integerValue] > [first integerValue]) {
//         [SELUpdateAlert showUpdateAlertWithVersion:self.locationVersion Description:[NSString stringWithFormat:@"尊敬的悦宅云会员，诚邀您参与悦宅云YUE%@版本的优先体验！",self.onlineVersion]];
    }
    
   
   
    
    
}
-(void)send:(UIButton*)sender{
    NSLog(@"自动调用无感按钮");
    if (!self.open) {
       
        return;
    }
    
    
    if ([self.quModel.unLockStatus isEqualToString:@"0"]) {

        return;
    }
    

    if (self.midArray.count==0) {

        return;
    }
    
    for (NSDictionary* dic1 in self.bleNameArray) {
        for (NSDictionary* dic2 in self.midArray) {
            
            if ([[dic1 objectForKey:@"name"] isEqualToString:[dic2 objectForKey:@"sysDeviceDiantiCode"]]) {
                NSMutableDictionary* mutDic = [NSMutableDictionary dictionaryWithDictionary:dic1];
                [mutDic setObject:[dic2 objectForKey:@"type"] forKey:@"type"];
                [mutDic setObject:[dic2 objectForKey:@"id"] forKey:@"id"];
                [mutDic setObject:[dic2 objectForKey:@"sysDeviceDiantiCode"] forKey:@"sysDeviceDiantiCode"];
                [self.finalArray addObject:mutDic];
            }
        }
    }
    
    
    
    for (int i = 0; i < self.finalArray.count; i++) {
        for (int j = i+1; j < self.finalArray.count; j++) {
            if ([[self.finalArray[i] objectForKey:@"rssi"] intValue] < [[self.finalArray[j] objectForKey:@"rssi"] intValue]) {
                [self.finalArray exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    
    if (self.finalArray.count>0) {
        //        NSString* type = [self.finalArray[0] objectForKey:@"type"];
        
        self.dianTiId = [self.finalArray[0] objectForKey:@"id"];
        self.sysDeviceDiantiCode = [self.finalArray[0] objectForKey:@"sysDeviceDiantiCode"];
        self.tiDoor = [self.sysDeviceDiantiCode substringWithRange:NSMakeRange(self.sysDeviceDiantiCode.length - 2,1)];
        self.target = [self.sysDeviceDiantiCode substringFromIndex:self.sysDeviceDiantiCode.length - 2];
        
        
        //F 门禁
        if (![self.tiDoor isEqualToString:@"F"]) {
            //            if (self.scan) {
            //是否可开门
            //                if ([self.quModel.unLockStatus isEqualToString:@"0"]) {
            //                    self.sendAllNum = [NSString stringWithFormat:@"AAFF000000000000000000000055"];
            //                    self.scanType = @"3";
            //                    [self openTheDoorByNum:self.sendAllNum isScan:YES];
            //                }else{
            self.sendAllNum = [NSString stringWithFormat:@"AAFF%@00%@55",self.target,self.quModel.fangChanId];
            self.scanType = @"wugan";
            [self openTheDoorByNum:self.sendAllNum isScan:YES];
            //                }
            //            }else{
            //                [DDProgressHUD showErrorImageWithInfo:@"当前控制信号弱，未能成功开启，请靠近门禁或移步到电梯内再次触发通行按钮"];
            //                [self uploadThroughRecordWithModel:[self throughRecordByCurrenttime:[self getNowTime] currentType:[self.tiDoor isEqualToString:@"F"] ? @"1" : @"2" currenterType:[self.quModel.isMain isEqualToString:@"是"] ? @"1" : @"2" currentState:@"1" phoneSystem:@"IOS" remarks:@"" platenumber:@"" accessObject:self.quModel.roomId proXiaoquId:self.quModel.xiaoqu_id openState:@"0"]];
            //
            //            }
            
        }else{
            //开门禁
            self.sendAllNum = [NSString stringWithFormat:@"AAFF%@00000000%@000055",self.target,self.quModel.xiaoQuAutoonly];
            
            self.scanType = @"wugan";
            [self openTheDoorByNum:self.sendAllNum isScan:YES];
            
            
        }
        self.openTime = [self getNowTime];
    }else{
        [DDProgressHUD showErrorImageWithInfo:@"当前控制信号弱，未能成功开启，请靠近门禁或移步到电梯内再次触发通行按钮"];
        [self uploadThroughRecordWithModel:[self throughRecordByCurrenttime:[self getNowTime] currentType:[self.tiDoor isEqualToString:@"F"] ? @"1" : @"2" currenterType:[self.quModel.isMain isEqualToString:@"是"] ? @"1" : @"2" currentState:@"1" phoneSystem:@"IOS" remarks:@"" platenumber:@"" accessObject:self.quModel.roomId proXiaoquId:self.quModel.xiaoqu_id openState:@"0"]];
    }
}
-(void)tap{
    NSLog(@"tap");
}

#pragma mark -- 网络检测
- (void)afnReachabilityTest {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 一共有四种状态
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
            {
                self.wangluo = @"0";
                
//                [DDProgressHUD showErrorImageWithInfo:@"暂无网络"];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                self.wangluo = @"1";
                NSLog(@"AFNetworkReachability Reachable via WWAN");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                self.wangluo = @"1";
                NSLog(@"AFNetworkReachability Reachable via WiFi");
                break;
            case AFNetworkReachabilityStatusUnknown:
            default:
            {
                self.wangluo = @"0";
//                [DDProgressHUD showErrorImageWithInfo:@"未知网络"];
            }
                break;
        }
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
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
//            NSLog(@"locError:{%ld - %@}",(long)error.code,error.localizedDescription);
            if (error.code == AMapLocationErrorLocateFailed) {
                return ;
            }
        }
        
        
        self.point = MAMapPointForCoordinate(CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude));

        
        //创建信号量
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(2);
        // 创建全局并行
        dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //小区  获取小区信息
        dispatch_async(quene, ^{
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            if ([self.wangluo isEqualToString:@"1"]) {
                [self getQuList];
            }else{
                //[self outlineLocation];
                //获取小区数据
                NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"XiaoQuArray"];
                self.xiaoquArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"XiaoQuModel"];
                    self.quModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                    self.midArray = self.quModel.bleArray;
                    
                    
                    
                    if ([BBUserData stringChangeNull:self.quModel.xiaoqu_name replaceWith:@""].length==0) {
                        [self.locationBtn setTitle:@"暂无小区" forState:UIControlStateNormal];
                    }else{
                    
                    if (self.quModel.louYu.length==1) {
                        self.quModel.louYu = [@"0" stringByAppendingString:self.quModel.louYu];
                    }
                    if (self.quModel.danYuan.length==1) {
                        self.quModel.danYuan = [@"0" stringByAppendingString:self.quModel.danYuan];
                    }
                    if (self.quModel.floor.length==1) {
                        self.quModel.floor = [@"0" stringByAppendingString:self.quModel.floor];
                    }
                    [self.locationBtn setTitle:[NSString stringWithFormat:@"%@-%@-%@-%@",self.quModel.xiaoqu_name,self.quModel.louYu,self.quModel.danYuan,self.quModel.room] forState:UIControlStateNormal];
                    }
//                    [self.bottomView.btn2 sendActionsForControlEvents:(UIControlEventTouchUpInside)];
                    [self.wuganBtn sendActionsForControlEvents:(UIControlEventTouchUpInside)];
                });
            }
            
            dispatch_semaphore_signal(semaphore);
        });
        if (regeocode) {
//            NSLog(@"reGeocode:%@",regeocode);
        }
        
        
    }];
}
#pragma mark -- 离线状态定位
-(void)outlineLocation{
    //获取小区数据
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"XiaoQuArray"];
    self.xiaoquArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (self.xiaoquArray.count>0) {
        for (int i = 0; i < self.xiaoquArray.count ; i ++) {
            yzXiaoQuModel* quModel = [self.xiaoquArray objectAtIndex:i];
            NSString* str = [BBUserData stringChangeNull:quModel.location replaceWith:@""];
            
//            NSLog(@"小区位置==%@",str);
            
            if (str.length>0) {
                str = [str stringByReplacingOccurrencesOfString:@"{" withString:@""];
                str = [str stringByReplacingOccurrencesOfString:@"}" withString:@""];
                
                [self.pointArray addObject:str];
            }else{
                self.pointArray = @[@"39.0676441571,117.1747538030"].mutableCopy;
            }
        }
        if (self.pointArray.count>0) {
            
            self.distanceArray = [[NSMutableArray alloc]init];
            for (int i = 0; i<self.pointArray.count; i++) {
                NSArray* arr = [self.pointArray[i] componentsSeparatedByString:@","];
                CLLocationDegrees latitude = [[arr objectAtIndex:0] doubleValue];
                 
                CLLocationDegrees longitude = [[arr objectAtIndex:1] doubleValue];
                MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(latitude,longitude));
                //2.计算距离
                CLLocationDistance distance = MAMetersBetweenMapPoints(self.point,point2);
//                NSLog(@"计算出的距离==%f",distance);
                
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
                
                self.quModel = self.xiaoquArray[min_index];
                self.midArray = self.quModel.bleArray;
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.locationBtn setTitle:[NSString stringWithFormat:@"%@-%@-%@-%@",self.quModel.xiaoqu_name,self.quModel.louYu,self.quModel.danYuan,self.quModel.room] forState:UIControlStateNormal];
                });
                
                
                if (self.quModel.louYu.length==1) {
                    self.quModel.louYu = [@"0" stringByAppendingString:self.quModel.louYu];
                }
                if (self.quModel.danYuan.length==1) {
                    self.quModel.danYuan = [@"0" stringByAppendingString:self.quModel.danYuan];
                }
                if (self.quModel.floor.length==1) {
                    self.quModel.floor = [@"0" stringByAppendingString:self.quModel.floor];
                }
            }
        }else{
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"XiaoQuModel"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self.locationBtn setTitle:@"暂无小区" forState:UIControlStateNormal];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"first"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
        }
    }
}
#pragma mark -- 设置顶部按钮
-(void)setHeaderBtn{
    //左侧我的按钮
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
    
    
    self.locationBtn = [[UIButton alloc]init];
    self.locationBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.locationBtn.titleLabel.font = YSize(14.0);
    //    [self.locationBtn setTitle:@"123" forState:UIControlStateNormal];
    self.locationBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.locationBtn addTarget:self action:@selector(showTopView:) forControlEvents:UIControlEventTouchUpInside];
    [self.locationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.locationBtn setFrame:CGRectMake(0, 0, headView.frame.size.width/3*2, 32)];
    [headView addSubview:self.locationBtn];
    
    
    
    
    if (![yzUserInfoModel getisLogin]) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:@"检测到您的账号在其它设备登录，请重新登录"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  //响应事件
                                                                  yzLoginViewController* loginVC = [[yzLoginViewController alloc]init];
                                                                  [self.navigationController presentViewController:[yzProductPubObject navc:loginVC] animated:YES completion:nil];
                                                              }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                                 //响应事件
                                                                 exit(0);
                                                             }];
        
        [alert addAction:defaultAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    [self afnReachabilityTest];
    
    
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
    
    
    
    
    
    //消息
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuBtn setImage:[UIImage imageNamed:@"iconfontadd"] forState:UIControlStateNormal];
    [menuBtn setBackgroundColor:[UIColor clearColor]];
    [menuBtn setFrame:CGRectMake(0, 0, AutoWitdh(32), AutoWitdh(32))];
    [menuBtn addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    [self.navigationController.visibleViewController.navigationItem setRightBarButtonItem:menuItem];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:YES];
    //解决滑动视图顶部空出状态栏高度的问题
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
    [self setStatusBarBackgroundColor:RGBA(255, 255, 255, 0)];
    [self.navigationController.navigationBar setBackgroundColor:RGBA(255, 255, 255, 0)];
    
    

    
   
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.centeralManager stopScan];
}


//- (void)tapGestureRecognizer:(UIGestureRecognizer *)sender {
//    [self showGuideCover];
//}

- (void)showGuideCover
{
    WBGuideCoverItem *item = [[WBGuideCoverItem alloc] init];
    
    item.bezierPath = WBBezierPathSquare;
    
    WBGuideCoverItem *itemAnother = [[WBGuideCoverItem alloc] init];
    
   
    itemAnother.bezierPath = WBBezierPathRound;
    
    
    WBGuideCoverItem *item1 = [[WBGuideCoverItem alloc] init];
  
    
    item1.bezierPath = WBBezierPathRound;
    
    WBGuideCoverItem *item2 = [[WBGuideCoverItem alloc] init];
 
    
    item2.bezierPath = WBBezierPathRound;
    
    WBGuideCoverItem *item3 = [[WBGuideCoverItem alloc] init];
 
    
    item3.bezierPath = WBBezierPathRound;
    
    WBGuideCoverItem *item4 = [[WBGuideCoverItem alloc] init];

    
    item4.bezierPath = WBBezierPathRound;
    
    if (IS_IPHONE_5S) {
        item.frame = CGRectMake(50.0f, 24.0f, 150.0f, 36.0f);
        itemAnother.frame = CGRectMake(18.0f, (mDeviceWidth - 80)/2.67 + 68 + 47.5 + kSaveTopSpace, (mDeviceWidth - 3)/4 - 30, (mDeviceWidth - 3)/4 - 30);
        item1.frame = CGRectMake(19.5f, 31.0f, 24.0f, 24.0f);
        item2.frame = CGRectMake(18.0f, (mDeviceWidth - 80)/2.67 + 68 + 47.5 + kSaveTopSpace, (mDeviceWidth - 3)/4 - 30, (mDeviceWidth - 3)/4 - 30);
        
        item3.frame = CGRectMake(179.5f, (mDeviceWidth - 80)/2.67 + 68 + 47.5 + kSaveTopSpace, (mDeviceWidth - 3)/4 - 30, (mDeviceWidth - 3)/4 - 30);
        item4.frame = CGRectMake(mDeviceWidth/2 - 22, mDeviceHeight - 73, 52.0f, 52.0f);
    }else if (IS_IPHONE_7){
        
        item.frame = CGRectMake(50.0f, 24.0f, 180.0f, 36.0f);
        itemAnother.frame = CGRectMake(15.0f, (mDeviceWidth - 80)/2.67 + 80 + 47.5 + kSaveTopSpace, (mDeviceWidth - 3)/4 - 30, (mDeviceWidth - 3)/4 - 30);
        item1.frame = CGRectMake(19.5f, 29.5f, 24.0f, 24.0f);
        
        item2.frame = CGRectMake(15.0f, (mDeviceWidth - 80)/2.67 + 80 + 47.5 + kSaveTopSpace, (mDeviceWidth - 3)/4 - 30, (mDeviceWidth - 3)/4 - 30);
        
        item3.frame = CGRectMake(203.0f, (mDeviceWidth - 80)/2.67 + 80 + 47.5 + kSaveTopSpace, (mDeviceWidth - 3)/4 - 30, (mDeviceWidth - 3)/4 - 30);
        item4.frame = CGRectMake(mDeviceWidth/2 - 24, mDeviceHeight - 76, 48.0f, 48.0f);
        
    }else if (IS_IPHONE_7P){
        
        item.frame = CGRectMake(50.0f, 24.0f, 180.0f, 36.0f);
        
        itemAnother.frame = CGRectMake(14.5f, (mDeviceWidth - 80)/2.67 + 80 + 57.5 + kSaveTopSpace, (mDeviceWidth - 3)/4 - 36, (mDeviceWidth - 3)/4 - 36);
        
        item1.frame = CGRectMake(25.0f, 29.5f, 23.0f, 23.0f);
        
        item2.frame = CGRectMake(14.5f, (mDeviceWidth - 80)/2.67 + 80 + 57.5 + kSaveTopSpace, (mDeviceWidth - 3)/4 - 36, (mDeviceWidth - 3)/4 - 36);
        
        item3.frame = CGRectMake(222.0f, (mDeviceWidth - 80)/2.67 + 80 + 57.5 + kSaveTopSpace, (mDeviceWidth - 3)/4 - 36, (mDeviceWidth - 3)/4 - 36);
        
        item4.frame = CGRectMake(mDeviceWidth/2 - 25, mDeviceHeight - 76, 45.0f, 45.0f);
        
    }else if (IS_IPHONE_Xr){
        
        item.frame = CGRectMake(50.0f, 24.0f + 24, 180.0f, 36.0f);
        itemAnother.frame = CGRectMake(14.5f, (mDeviceWidth - 80)/2.67 + 80 + 47.5 + 10.5, (mDeviceWidth - 3)/4 - 36, (mDeviceWidth - 3)/4 - 36);
        item1.frame = CGRectMake(25.0f, 29.5f + 24, 22.0f, 22.0f);
        
        item2.frame = CGRectMake(14.5f, (mDeviceWidth - 80)/2.67 + 80 + 47.5 + 10.5, (mDeviceWidth - 3)/4 - 36, (mDeviceWidth - 3)/4 - 36);
        
        item3.frame = CGRectMake(222.0f, (mDeviceWidth - 80)/2.67 + 80 + 47.5 + 10.5, (mDeviceWidth - 3)/4 - 36, (mDeviceWidth - 3)/4 - 36);
        item4.frame = CGRectMake(mDeviceWidth/2 - 26, mDeviceHeight - 76 - 34, 46.0f, 46.0f);
    }else if (IS_IPHONE_Xs_Max){
        item.frame = CGRectMake(50.0f, 24.0f + 24, 180.0f, 36.0f);
        itemAnother.frame = CGRectMake(14.5f, (mDeviceWidth - 80)/2.67 + 80 + 47.5 + 10.5, (mDeviceWidth - 3)/4 - 36, (mDeviceWidth - 3)/4 - 36);
        item1.frame = CGRectMake(25.0f, 29.5f + 24, 22.0f, 22.0f);
        
        item2.frame = CGRectMake(14.5f, (mDeviceWidth - 80)/2.67 + 80 + 47.5 + 10.5, (mDeviceWidth - 3)/4 - 36, (mDeviceWidth - 3)/4 - 36);
        
        item3.frame = CGRectMake(222.0f, (mDeviceWidth - 80)/2.67 + 80 + 47.5 + 10.5, (mDeviceWidth - 3)/4 - 36, (mDeviceWidth - 3)/4 - 36);
        item4.frame = CGRectMake(mDeviceWidth/2 - 26, mDeviceHeight - 76 - 34, 46.0f, 46.0f);
    }else if (IS_IPHONE_X){
        item.frame = CGRectMake(50.0f, 24.0f + 24, 180.0f, 36.0f);
        itemAnother.frame = CGRectMake(15.5f, (mDeviceWidth - 80)/2.67 + 80 + 47.5 + 2.5, (mDeviceWidth - 3)/4 - 32, (mDeviceWidth - 3)/4 - 32);
        item1.frame = CGRectMake(20.0f, 29.5f + 25, 23.0f, 23.0f);
        
        item2.frame = CGRectMake(15.5f, (mDeviceWidth - 80)/2.67 + 80 + 47.5 + 2.5, (mDeviceWidth - 3)/4 - 32, (mDeviceWidth - 3)/4 - 32);
        
        item3.frame = CGRectMake(203.0f, (mDeviceWidth - 80)/2.67 + 80 + 47.5 + 2.5, (mDeviceWidth - 3)/4 - 32, (mDeviceWidth - 3)/4 - 32);
        item4.frame = CGRectMake(mDeviceWidth/2 - 24, mDeviceHeight - 76 - 32, 47.0f, 47.0f);
    }
   
    
    
    [[WBGuideCover getInstance].guideCoverItems addObjectsFromArray:@[@[item,itemAnother], @[item1], @[item2], @[item3], @[item4]]];
    [[WBGuideCover getInstance].images addObjectsFromArray:@[@"dialog_1",@"dialog_2",@"dialog_3",@"dialog_4",@"dialog_5"]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[WBGuideCover getInstance] showGuideCoverInView:self.navigationController.view completion:^(BOOL finished) {
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"show"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }];
    });
    
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    if(offsetY > 0){
        [self.navigationController.navigationBar setBackgroundColor:RGBA(255, 255, 255, ((offsetY - 50 ) / 150))];
        [self setStatusBarBackgroundColor:RGBA(255, 255, 255, ((offsetY - 50 ) / 150))];
    }
    
    //footerView
    if (scrollView == self.collectionView) {
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



#pragma mark  --  collectionView

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 4;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 8;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return self.shopGoodsArray.count;
            break;
        default:
            break;
    }
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
       
        indexAdPicViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell1" forIndexPath:indexPath];
        UIImageView* headB = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mDeviceWidth, (mDeviceWidth - 80)/1.53)];
        headB.image = [UIImage imageNamed:@"headB"];
        headB.userInteractionEnabled = YES;
        [cell addSubview:headB];
        
        
        
        NSArray *imageArray = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1537459349378&di=91ef08121afbaf39f0ac21f6fcb4028b&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fwallpaper%2Fb%2F55597435bb036.jpg",@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1554952423&di=1a4f1d4e309efb1289d5939f5b2c93be&src=http://img15.3lian.com/2015/f2/57/d/93.jpg",@"http://h.hiphotos.baidu.com/image/pic/item/18d8bc3eb13533fa65021ddba5d3fd1f40345b8b.jpg"];
        if (_headerImages.count>0) {
            if (!cell.dcCycleS) {
                cell.dcCycleS = [DCCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 80 + kSaveTopSpace, self.view.frame.size.width, (mDeviceWidth - 80)/2.67) shouldInfiniteLoop:YES imageGroups:_headerImages.count == 0 ? imageArray : _headerImages];
                
            }
        }
        
       
       
        cell.dcCycleS.itemSpace = -4;
        cell.dcCycleS.autoScrollTimeInterval = 5;
        cell.dcCycleS.autoScroll = YES;
        cell.dcCycleS.isZoom = YES;
        //    banner.itemSpace = 0;
        cell.dcCycleS.imgCornerRadius = 10;
        cell.dcCycleS.itemWidth = self.view.frame.size.width - 100;
        cell.dcCycleS.delegate = self;

        [headB addSubview:cell.dcCycleS];

        
        return cell;
    }else if (indexPath.section==1){
        yzMenuCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell2" forIndexPath:indexPath];
        [cell setBackgroundColor:[UIColor whiteColor]];
        [cell setImage:self.images[indexPath.row] title:self.titles[indexPath.row]];
        
        return cell;
    }else if (indexPath.section==2){
        
        NSString *identifier = [NSString stringWithFormat:@"cellMsg%ld,%ld",indexPath.section,indexPath.row];
        [self.collectionView registerClass:[indexMsgViewCell class] forCellWithReuseIdentifier:identifier];
        
        indexMsgViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        [cell setBackgroundColor:[UIColor whiteColor]];
        if (![self.notice isEqualToString:@""]) {
           [cell getMessageByDic:self.wuYeNotice];
        }
        
//        NSArray* imageArr = @[@"洗衣",@"开锁",@"保洁"];
        
        for (int i = 0; i<self.bottomAdvertArr.count; i++) {
//            NSLog(@"底部信息==%@",self.bottomAdvertArr);
            UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(10 + (10 + (mDeviceWidth - 40)/3)*i, 60, (mDeviceWidth - 40)/3, (mDeviceWidth - 40)/3)];

            
            [btn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[self.bottomAdvertArr[i] objectForKey:@"picUrl"]]] forState:UIControlStateNormal];
            
//            [btn setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
            btn.tag = 100  + i;
            [btn addTarget:self action:@selector(fuwu:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn];
        }
        
        [cell.contentBtn addTarget:self action:@selector(gonggao:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    else{
//    // 每次先从字典中根据IndexPath取出唯一标识符
//    NSString *identifier = [_cellDic objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
//    // 如果取出的唯一标示符不存在，则初始化唯一标示符，并将其存入字典中，对应唯一标示符注册Cell
//    if (identifier == nil) {
//        identifier = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@", indexPath]];
//        [_cellDic setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
//        // 注册Cell
//        [self.collectionView registerClass:[productViewCell class]  forCellWithReuseIdentifier:identifier];
//    }
//        NSLog(@"++++%@",_cellDic);
        
        NSString *identifier = [NSString stringWithFormat:@"cellId%ld,%ld",indexPath.section,indexPath.row];
        [self.collectionView registerClass:[productViewCell class] forCellWithReuseIdentifier:identifier];
        
        
        productViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
       
        
        yzIndexShopGoodsModel *model = self.shopGoodsArray[indexPath.row];

        [cell getMessageByModel:model];
    
        
        return cell;
    }
    return nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return CGSizeMake(mDeviceWidth, (mDeviceWidth - 80)/1.53 + 30);
    }else if (indexPath.section==1){
        return CGSizeMake((mDeviceWidth - 3)/4, (mDeviceWidth - 3)/4 + 10);
    }else if (indexPath.section==2){
        return CGSizeMake(mDeviceWidth, 75 + (mDeviceWidth - 40)/3);
    }else{
        yzIndexShopGoodsModel *model = self.shopGoodsArray[indexPath.row];
        if (![model.goodsId isEqualToString:@"<null>"]) {

            return CGSizeMake((mDeviceWidth - 6)/2, (mDeviceWidth - 6)/2);

        }else{

            return CGSizeMake(mDeviceWidth, mDeviceWidth/2.96);

        }
    }
    return CGSizeMake(0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (section==3) {
        return 5;
    }
    return 0;
}
// 两个cell之间的最小间距，是由API自动计算的，只有当间距小于该值时，cell会进行换行
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (section==3) {
        return 5;
    }
    return 0;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
      if (section==1) {
        return CGSizeMake(mDeviceWidth, 5);
    }else if (section==2){
        return CGSizeMake(mDeviceWidth, 5);
    }else if (section==3){
        return CGSizeMake(mDeviceWidth, 5);
    }
    else
        return CGSizeMake(0, 0);
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        if (![yzUserInfoModel getisLogin]) {
            yzLoginViewController *loginView = [[yzLoginViewController alloc] init];
            [loginView setLoginSuccessBlock:^{
                
            }];
            [self.navigationController presentViewController:[yzProductPubObject navc:loginView] animated:YES completion:nil];
        }else{
            
            NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"XiaoQuModel"];
            yzXiaoQuModel* quModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            
            NSString* xiaoquId  = [BBUserData stringChangeNull:self.quModel.xiaoqu_id replaceWith:@""];
          
//            NSLog(@"seleroom==%@==%@==%@==%@",quModel.roomId,quModel.xiaoqu_name,quModel.atime,quModel.bleArray);
            
            
            if ([xiaoquId isEqualToString:@""]) {
                [DDProgressHUD showErrorImageWithInfo:@"暂无小区"];
                return;
            }
            
            switch (indexPath.row) {
                case 0:
                {
                    //钥匙管理
           
                    
                    yzKeyListController* keyVC = [[yzKeyListController alloc]init];
                    keyVC.fangChanId = self.quModel.fangChanId;
//                    keyVC.atime = self.quModel.atime;
                    keyVC.roomId = self.quModel.roomId;
                    keyVC.dianTiList = quModel.bleArray;
                    keyVC.unLockStatus = quModel.unLockStatus;
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
//                    yzWuYePayController* wyPayVC = [[yzWuYePayController alloc]init];
//                    wyPayVC.quStr = self.locationBtn.titleLabel.text;
//                    wyPayVC.roomId = self.quModel.roomId;
//                    [self.navigationController pushViewController:wyPayVC animated:YES];
                    
                    yzPayListController* payList = [[yzPayListController alloc]init];
                    payList.title = self.locationBtn.titleLabel.text;
                    payList.roomId = self.quModel.roomId;
                    payList.xiaoquArray = self.xiaoquArray;
                    [self.navigationController pushViewController:payList animated:YES];
                    
                }
                    break;
                case 3:{
                    //物业报修
                    yzRepairsController *repairVC = [[yzRepairsController alloc] init];
                    repairVC.name = self.locationBtn.titleLabel.text;
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
            
                    
                    
                }
                    break;
                case 7:
                {
//                    NSLog(@"isMain==%@",self.quModel.isMain);
                    if ([self.quModel.isMain isEqualToString:@"是"]) {
                        ICCardController *ICVC = [[ICCardController alloc] init];
                        ICVC.fangChanId = self.quModel.fangChanId;
                        ICVC.dianTiList = self.quModel.bleArray;
                        ICVC.state = @"0";
                        [self.navigationController pushViewController:ICVC animated:YES];
                    }else{
                        [DDProgressHUD showErrorImageWithInfo:@"只有户主才具备IC卡管理权限"];
                    }
                    
        
                    
                }
                    break;
                    
                    
                default:
                    break;
            }
        }
    }
    if (indexPath.section==3) {
//        yzGoodsDetailViewController* detailVC = [[yzGoodsDetailViewController alloc]init];
//        yzIndexShopGoodsModel* model = self.shopGoodsArray[indexPath.row];
//        if (model.have_attr) {
//            detailVC.type = @"2";
//        }else{
//            detailVC.type = @"1";
//        }
//        detailVC.model = model;
//        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
}



/** 功能管理 */
-(void)toGnViewClick:(NSInteger)currentIndex{
    if (![yzUserInfoModel getisLogin]) {
        yzLoginViewController *loginView = [[yzLoginViewController alloc] init];
        [loginView setLoginSuccessBlock:^{
            
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
                wyPayVC.quStr = self.locationBtn.titleLabel.text;
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
                infomationView.wuyeId = self.quModel.wuye_id;
                
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

                
            }
                break;
       
            
            default:
                break;
        }
    }
}


#pragma mark -- 点击轮播图
/** 点击图片回调 */
- (void)cycleScrollView:(DCCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if (_headerImages.count>0) {
        NSString* appAdvUrl = [BBUserData stringChangeNull:[_headerImages[index] objectForKey:@"appAdvUrl"] replaceWith:@""];
        if (appAdvUrl.length>0) {
//            NSLog(@"有图片链接");
            yzHeaderDetailController* headerVC = [[yzHeaderDetailController alloc]init];
            headerVC.advURL = appAdvUrl;
            [self.navigationController pushViewController:headerVC animated:YES];
        }else{
//            NSLog(@"无图片链接");
//            yzHeaderDetailController* headerVC = [[yzHeaderDetailController alloc]init];
//            [self.navigationController pushViewController:headerVC animated:YES];
        }
    }
    
}


/** 我的 */
-(void)myClick:(id)sender{

    
    yzMyViewController* myVC = [[yzMyViewController alloc]init];
    [self.navigationController pushViewController:myVC animated:YES];
}

/** 消息事件 */
-(void)menuClick:(id)sender{

    if (mDeviceWidth==320) {
        [SGDropMenu showDropMenuFrame:CGRectMake(self.view.frame.size.width - 132, kNavBarHeight, 120, 108) ArrowOffset:102.f TitleArr:self.titleArr ImageArr:self.imageArr Type:SGDropMenuTypeQQ LayoutType:SGDropMenuLayoutTypeNormal RowHeight:50.f Delegate:self];
    }else if(mDeviceWidth==375){
        [SGDropMenu showDropMenuFrame:CGRectMake(self.view.frame.size.width - 135, kNavBarHeight, 120, 108) ArrowOffset:102.f TitleArr:self.titleArr ImageArr:self.imageArr Type:SGDropMenuTypeQQ LayoutType:SGDropMenuLayoutTypeNormal RowHeight:50.f Delegate:self];
    }else{
        [SGDropMenu showDropMenuFrame:CGRectMake(self.view.frame.size.width - 142, kNavBarHeight, 120, 108) ArrowOffset:102.f TitleArr:self.titleArr ImageArr:self.imageArr Type:SGDropMenuTypeQQ LayoutType:SGDropMenuLayoutTypeNormal RowHeight:50.f Delegate:self];
    }
    
    
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
/** 点击公告 */
-(void)gonggao:(UIButton*)sender{
   NSString* str = [BBUserData stringChangeNull:self.quModel.wuye_id replaceWith:@""];
    if (str.length>0) {
        yzNewInformationController *infomationView = [[yzNewInformationController alloc] init];
        [self.navigationController pushViewController:infomationView animated:YES];
    }else{
        [DDProgressHUD showErrorImageWithInfo:@"暂无小区"];
    }
 
}

/** 洗衣  开锁  保洁 */
-(void)fuwu:(UIButton*)sender{
//    if (sender.tag==100) {
//        NSLog(@"洗衣");
//        yzFuWuWebController* VC = [[yzFuWuWebController alloc]init];
//        VC.webStr = @"https://tj.58.com";
//        [self.navigationController pushViewController:VC animated:YES];
//    }else if (sender.tag==101){
//         NSLog(@"开锁");
//        yzFuWuWebController* VC = [[yzFuWuWebController alloc]init];
//        VC.webStr = @"https://tj.58.com";
//        [self.navigationController pushViewController:VC animated:YES];
//    }else{
//         NSLog(@"保洁");
//        yzFuWuWebController* VC = [[yzFuWuWebController alloc]init];
//        VC.webStr = @"https://tj.58.com";
//        [self.navigationController pushViewController:VC animated:YES];
//    }
    
    yzFuWuWebController* VC = [[yzFuWuWebController alloc]init];
    VC.webStr = [NSString stringWithFormat:@"%@",[self.bottomAdvertArr[sender.tag - 100] objectForKey:@"cliUrl"]];
    [self.navigationController pushViewController:VC animated:YES];
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
//            [self.listTableView.mj_header beginRefreshing];
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
    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/biku/saveShoppingCar",postUrl] version:Token parameters:@{@"goodId":goods_id,@"attrId":attr_id,@"count":count,@"userId":[yzUserInfoModel getLoginUserInfo:@"userId"],@"token":[yzUserInfoModel getLoginUserInfo:@"token"]} success:^(id object) {
//        [yzUserInfoModel getLoginUserInfo:@"userId"]
        [DDProgressHUD dismiss];
        NSDictionary *json = object;
        if ([[json objectForKey:@"code"] intValue] == 200) {
            [DDProgressHUD showSuccessImageWithInfo:[json objectForKey:@"message"]];
            //关闭视图
            [self.productView closeClick:nil];
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


#pragma mark --  调用接口
/** 获取物业店铺信息 */
-(void)getShopData{
//    [DDProgressHUD show];
    
    [CCAFNetWork get:[NSString stringWithFormat:@"%@app/biku/homeGoodsWithAdv",postUrl] version:Token parameters:nil success:^(id object) {
        [DDProgressHUD dismiss];
        NSDictionary *json = object;
        
        
        self.shopGoodsArray = [NSMutableArray array];
        if ([[json objectForKey:@"code"] intValue] == 200) {
            NSMutableArray* goods = [json objectForKey:@"data"];
            
            for (int i = 0; i < goods.count; i ++) {
                yzIndexShopGoodsModel *model = [[yzIndexShopGoodsModel alloc] init:goods[i]];
                [self.shopGoodsArray addObject:model];
  
            }
//            for (int i = 0; i < 1; i ++) {
//                yzIndexShopGoodsModel *model = [[yzIndexShopGoodsModel alloc] init:goods[goods.count - 1]];
//                [self.shopGoodsArray addObject:model];
//            }
           [self.collectionView reloadData];
            
        }else{
//            [DDProgressHUD showErrorImageWithInfo:[json objectForKey:@"message"]];
        }
       
    } failure:^(NSError *error) {
        [DDProgressHUD showErrorImageWithInfo:error.localizedDescription];
    }];
    
    
}


#pragma mark -- 获取小区信息
-(void)getQuList{
    
    self.sendAllNum = @"";
    
    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/index/getindexdata",postUrl] version:Token parameters:@{@"appUserId":[yzUserInfoModel getLoginUserInfo:@"userId"]} success:^(id object) {
        
        NSDictionary *json = object;
        self.wuYeNotice = [[NSDictionary alloc]init];
        self.headerImages = [NSMutableArray array];
        self.bottomAdvertArr = [NSMutableArray array];
        if ([[json objectForKey:@"code"] intValue] == 200) {
  
            NSDictionary *userDict = json[@"data"];
            
            NSArray* images = [userDict objectForKey:@"adv"];
            
            [self.bottomAdvertArr addObjectsFromArray:[userDict objectForKey:@"appSynopsisList"]];
            
            
            self.notice = [BBUserData stringChangeNull:[userDict objectForKey:@"wuYeNotice"] replaceWith:@""];
            if (![self.notice isEqualToString:@""]) {
                self.wuYeNotice = [userDict objectForKey:@"wuYeNotice"];
            }
            
       
            
            if (images.count>0) {
                [self.headerImages addObjectsFromArray:images];
            }
           
            
            
            
      
           [self getPublicData];
  

            
            
            
            //存储小区数据
            NSMutableArray *xiaoQuListArray = [userDict objectForKey:@"xiaoQu"];
            NSMutableArray *quListArray = [[NSMutableArray alloc] init];
            self.pointArray = [[NSMutableArray alloc]init];
            if (xiaoQuListArray.count>0) {
                for (int i = 0; i < xiaoQuListArray.count ; i ++) {
                    NSDictionary *quDict = [xiaoQuListArray objectAtIndex:i];
                    
                    yzXiaoQuModel* quModel = [[yzXiaoQuModel alloc] init];
                    quModel.bleArray = [NSMutableArray array];
                    quModel.atime = [yzProductPubObject withStringReturn:quDict[@"atime"]];
                    quModel.xiaoqu_id = [yzProductPubObject withStringReturn:quDict[@"id"]];
                    quModel.xiaoqu_name = [yzProductPubObject withStringReturn:quDict[@"name"]];
                    quModel.wuye_id = [yzProductPubObject withStringReturn:quDict[@"wuYeId"]];
                    quModel.location = [yzProductPubObject withStringReturn:quDict[@"location"]];
                    quModel.louYu = [yzProductPubObject withStringReturn:quDict[@"louYu"]];
                    quModel.danYuan = [yzProductPubObject withStringReturn:quDict[@"danYuan"]];
                    quModel.floor = [yzProductPubObject withStringReturn:quDict[@"floor"]];
                    quModel.room = [yzProductPubObject withStringReturn:quDict[@"room"]];
                    quModel.danYuanId = [yzProductPubObject withStringReturn:quDict[@"danYuanId"]];
                    quModel.fangChanId = [yzProductPubObject withStringReturn:quDict[@"fangChanId"]];
                    quModel.roomId = [yzProductPubObject withStringReturn:quDict[@"roomId"]];
                    quModel.xiaoQuAutoonly = [yzProductPubObject withStringReturn:quDict[@"xiaoQuAutoonly"]];
                    quModel.unLockStatus = [yzProductPubObject withStringReturn:quDict[@"unLockStatus"]];
                    quModel.isMain = [yzProductPubObject withStringReturn:quDict[@"isMain"]];
                    //
                    NSArray* dianTi = quDict[@"dianTiList"];
                    if (dianTi.count>0) {
                        for (NSDictionary* dic in dianTi) {
                            NSMutableDictionary* mutDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                            [mutDic setObject:@"电梯" forKey:@"type"];
                            [quModel.bleArray addObject:mutDic];
                        }
                    }
                    
                    NSArray* door = quDict[@"doorList"];
                    if (door.count>0) {
                        for (NSDictionary* dic in door) {
                            NSMutableDictionary* mutDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                            [mutDic setObject:@"门" forKey:@"type"];
                            [quModel.bleArray addObject:mutDic];
                        }
                    }
                    [quListArray addObject:quModel];
                    
                    
                    NSString* str = [BBUserData stringChangeNull:quModel.location replaceWith:@""];
                 
                    if (str.length>0) {
                        str = [str stringByReplacingOccurrencesOfString:@"{" withString:@""];
                        str = [str stringByReplacingOccurrencesOfString:@"}" withString:@""];
                        
                        [self.pointArray addObject:str];
                    }else{
                        
                        self.pointArray = @[@"39.0676441571,117.1747538030"].mutableCopy;
                    }
                }
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:quListArray] forKey:@"XiaoQuArray"];
             [self.xiaoquArray removeAllObjects];
         
            if (quListArray.count>0&&self.pointArray.count>0) {
                [self.xiaoquArray addObjectsFromArray:quListArray];
                
                if (![self.first isEqualToString:@"1"]) {
                    self.distanceArray = [[NSMutableArray alloc]init];
                    for (int i = 0; i<self.pointArray.count; i++) {
                        NSArray* arr = [self.pointArray[i] componentsSeparatedByString:@","];
                        CLLocationDegrees latitude = [[arr objectAtIndex:0] doubleValue];
                         
                        CLLocationDegrees longitude = [[arr objectAtIndex:1] doubleValue];
                        MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(latitude,longitude));
                        //2.计算距离
                        CLLocationDistance distance = MAMetersBetweenMapPoints(self.point,point2);
//                        NSLog(@"计算出的距离==%f",distance);
                        
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
                        
                        self.quModel = quListArray[min_index];
                        self.midArray = self.quModel.bleArray;
//                        NSLog(@"mid===%@",self.midArray);
                        if (self.quModel.louYu.length==1) {
                            self.quModel.louYu = [@"0" stringByAppendingString:self.quModel.louYu];
                        }
                        if (self.quModel.danYuan.length==1) {
                            self.quModel.danYuan = [@"0" stringByAppendingString:self.quModel.danYuan];
                        }
                        if (self.quModel.floor.length==1) {
                            self.quModel.floor = [@"0" stringByAppendingString:self.quModel.floor];
                        }
                        [self.locationBtn setTitle:[NSString stringWithFormat:@"%@-%@-%@-%@",self.quModel.xiaoqu_name,self.quModel.louYu,self.quModel.danYuan,self.quModel.room] forState:UIControlStateNormal];
                        
                        

                        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject: self.quModel] forKey:@"XiaoQuModel"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        
                        
                    }
                    self.show = [[NSUserDefaults standardUserDefaults] objectForKey:@"show"];
                    if (![self.show isEqualToString:@"1"]) {
                        [self showGuideCover];
                    }
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"first"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
               
            }else{

                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"XiaoQuModel"];
                [[NSUserDefaults standardUserDefaults] synchronize];
        
                [self.locationBtn setTitle:@"暂无小区" forState:UIControlStateNormal];
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"first"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
            }
//              [self.bottomView.btn2 sendActionsForControlEvents:(UIControlEventTouchUpInside)];
            [self.wuganBtn sendActionsForControlEvents:(UIControlEventTouchUpInside)];
        }else if ([[json objectForKey:@"code"] intValue] == -6){
            [DDProgressHUD dismiss];
            [yzUserInfoModel userLoginOut];
            [yzUserInfoModel setLoginState:NO];
           
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                           message:@"检测到您的账号在其它设备登录，请重新登录"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      //响应事件
                                                                      [yzUserInfoModel userLoginOut];
                                                                      [yzUserInfoModel setLoginState:NO];
                                                                      yzLoginViewController* loginVC = [[yzLoginViewController alloc]init];
                                                                      [self.navigationController presentViewController:[yzProductPubObject navc:loginVC] animated:YES completion:nil];
                                                                  }];
            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * action) {
                                                                     //响应事件
                                                                     exit(0);
                                                                 }];
            
            [alert addAction:defaultAction];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else{
            [DDProgressHUD showErrorImageWithInfo:[json objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [DDProgressHUD showErrorImageWithInfo:error.localizedDescription];
        
    }];
}

#pragma mark -- 底部三个按钮
-(void)guanjia:(UIButton*)sender{
    if (![yzUserInfoModel getisLogin]) {
        yzLoginViewController *loginView = [[yzLoginViewController alloc] init];
        [loginView setLoginSuccessBlock:^{
            
        }];
        [self.navigationController presentViewController:[yzProductPubObject navc:loginView] animated:YES completion:nil];
    }else{
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"XiaoQuModel"];
        yzXiaoQuModel* quModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        NSString* xiaoquId  = [BBUserData stringChangeNull:quModel.xiaoqu_id replaceWith:@""];
        if ([xiaoquId isEqualToString:@""]) {
            [DDProgressHUD showErrorImageWithInfo:@"暂无小区"];
            return;
        }
        
        yzHouseKeepController* keepVC = [[yzHouseKeepController alloc]init];
        [self.navigationController pushViewController:keepVC animated:YES];
    }
}
-(void)unlock:(UIButton*)sender{


    
    if (!self.open) {
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"蓝牙未开启，请先打开蓝牙再使用" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertController addAction:sureAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    

    if ([self.quModel.unLockStatus isEqualToString:@"0"]) {
        [DDProgressHUD showErrorImageWithInfo:@"您的物业费已到期，请及时续费"];
   
        return;
    }
    
    
  
    
    
//    if ([self.scanType isEqualToString:@"2"]) {
//
//        return;
//    }
    if (self.midArray.count==0) {
        [DDProgressHUD showErrorImageWithInfo:@"没有电梯"];
        return;
    }
    
    for (NSDictionary* dic1 in self.bleNameArray) {
        for (NSDictionary* dic2 in self.midArray) {
            
            if ([[dic1 objectForKey:@"name"] isEqualToString:[dic2 objectForKey:@"sysDeviceDiantiCode"]]) {
                NSMutableDictionary* mutDic = [NSMutableDictionary dictionaryWithDictionary:dic1];
                [mutDic setObject:[dic2 objectForKey:@"type"] forKey:@"type"];
                [mutDic setObject:[dic2 objectForKey:@"id"] forKey:@"id"];
                [mutDic setObject:[dic2 objectForKey:@"sysDeviceDiantiCode"] forKey:@"sysDeviceDiantiCode"];
                [self.finalArray addObject:mutDic];
            }
        }
    }
   
 
    
    for (int i = 0; i < self.finalArray.count; i++) {
        for (int j = i+1; j < self.finalArray.count; j++) {
            if ([[self.finalArray[i] objectForKey:@"rssi"] intValue] < [[self.finalArray[j] objectForKey:@"rssi"] intValue]) {
                [self.finalArray exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    
    if (self.finalArray.count>0) {
//        NSString* type = [self.finalArray[0] objectForKey:@"type"];
        
        self.dianTiId = [self.finalArray[0] objectForKey:@"id"];
        self.sysDeviceDiantiCode = [self.finalArray[0] objectForKey:@"sysDeviceDiantiCode"];
        self.tiDoor = [self.sysDeviceDiantiCode substringWithRange:NSMakeRange(self.sysDeviceDiantiCode.length - 2,1)];
        self.target = [self.sysDeviceDiantiCode substringFromIndex:self.sysDeviceDiantiCode.length - 2];
        
        
        //F 门禁
        if (![self.tiDoor isEqualToString:@"F"]) {
//            if (self.scan) {
                //是否可开门
//                if ([self.quModel.unLockStatus isEqualToString:@"0"]) {
//                    self.sendAllNum = [NSString stringWithFormat:@"AAFF000000000000000000000055"];
//                    self.scanType = @"3";
//                    [self openTheDoorByNum:self.sendAllNum isScan:YES];
//                }else{
                    self.sendAllNum = [NSString stringWithFormat:@"AAFF%@00%@55",self.target,self.quModel.fangChanId];
                    self.scanType = @"1";
                    [self openTheDoorByNum:self.sendAllNum isScan:YES];
//                }
//            }else{
//                [DDProgressHUD showErrorImageWithInfo:@"当前控制信号弱，未能成功开启，请靠近门禁或移步到电梯内再次触发通行按钮"];
//                [self uploadThroughRecordWithModel:[self throughRecordByCurrenttime:[self getNowTime] currentType:[self.tiDoor isEqualToString:@"F"] ? @"1" : @"2" currenterType:[self.quModel.isMain isEqualToString:@"是"] ? @"1" : @"2" currentState:@"1" phoneSystem:@"IOS" remarks:@"" platenumber:@"" accessObject:self.quModel.roomId proXiaoquId:self.quModel.xiaoqu_id openState:@"0"]];
//
//            }
            
        }else{
            //开门禁
             self.sendAllNum = [NSString stringWithFormat:@"AAFF%@00000000%@000055",self.target,self.quModel.xiaoQuAutoonly];

            self.scanType = @"4";
            [self openTheDoorByNum:self.sendAllNum isScan:YES];
            
            
        }
        self.openTime = [self getNowTime];
    }else{
        [DDProgressHUD showErrorImageWithInfo:@"当前控制信号弱，未能成功开启，请靠近门禁或移步到电梯内再次触发通行按钮"];
        [self uploadThroughRecordWithModel:[self throughRecordByCurrenttime:[self getNowTime] currentType:[self.tiDoor isEqualToString:@"F"] ? @"1" : @"2" currenterType:[self.quModel.isMain isEqualToString:@"是"] ? @"1" : @"2" currentState:@"1" phoneSystem:@"IOS" remarks:@"" platenumber:@"" accessObject:self.quModel.roomId proXiaoquId:self.quModel.xiaoqu_id openState:@"0"]];
    }
    
    

}
#pragma mark -- 获取当前时间
-(NSString*)getNowTime{
    NSDate *datenow = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    //设置时区,这个对于时间的处理有时很重要
    
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"zh_CN"]];
    NSString *dateString = [formatter stringFromDate: datenow];
    
    return dateString;
}

#pragma mark -- 更新通行记录

-(void)uploadThroughRecordWithModel:(yzThroughRecordModel*)model{
    @try {
        BOOL insertB = [[yzThroughRecordModel_Helper getInstance] insertOneData:model];
        self.ThroughRecord = [NSMutableArray array];
        if (insertB) {
//            NSLog(@"插入成功");
            
            NSMutableArray* mutArr = [[yzThroughRecordModel_Helper getInstance] queryData];

            for (int i = 0; i < mutArr.count; i ++) {
                yzThroughRecordModel* model = mutArr[i];
                NSMutableDictionary* mutDic = [NSMutableDictionary dictionary];
                [mutDic setObject:model.currenttime forKey:@"currenttime"];
                NSString* str1 = [BBUserData stringChangeNull:model.currentType replaceWith:@""];
                [mutDic setObject:[NSDictionary dictionaryWithObject:str1 forKey:@"value"] forKey:@"currentType"];
                
                NSString* str2 = [BBUserData stringChangeNull:model.currenterType replaceWith:@""];
                [mutDic setObject:[NSDictionary dictionaryWithObject:str2 forKey:@"value"] forKey:@"currenterType"];
                
                NSString* str3 = [BBUserData stringChangeNull:model.currentState replaceWith:@""];
                [mutDic setObject:[NSDictionary dictionaryWithObject:str3 forKey:@"value"] forKey:@"currentState"];
                [mutDic setObject:model.phoneSystem forKey:@"phoneSystem"];
                [mutDic setObject:model.remarks forKey:@"remarks"];
                [mutDic setObject:model.platenumber forKey:@"platenumber"];
                [mutDic setObject:model.accessObject forKey:@"accessObject"];
                [mutDic setObject:model.proXiaoquId forKey:@"proXiaoquId"];
                [mutDic setObject:model.appUserId forKey:@"appUserId"];
                [mutDic setObject:model.openState forKey:@"openState"];
                
                [self.ThroughRecord addObject:mutDic];
                if (i == mutArr.count - 1) {
                    
                    
                    if ([self.wangluo isEqualToString:@"1"]) {
                        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                        
                        NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@app/currentrecord/saveSysCurrentRecord",postUrl] parameters:self.ThroughRecord error:nil];
                        request.timeoutInterval = 10.f;
                        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                        [request setValue:Token forHTTPHeaderField:@"Authorization"];
                        NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                            
                            if (!error) {
                                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                    // 请求成功数据处理
//                                    [DDProgressHUD showSuccessImageWithInfo:[responseObject objectForKey:@"message"]];
//                                    NSLog(@"+++++%@",[responseObject objectForKey:@"message"]);
                                    BOOL delete = [[yzThroughRecordModel_Helper getInstance] deleteAllData];
                                    if (delete) {
                                        NSLog(@"删除成功");
                                    }
                                } else {
//                                    [DDProgressHUD showSuccessImageWithInfo:[responseObject objectForKey:@"message"]];
//                                     NSLog(@"-----%@",[responseObject objectForKey:@"message"]);
                                }
                            } else {
                                NSLog(@"请求失败error=%@", error);
                            }
                        }];
                        
                        [task resume];
                        
                    }else{
                        
                    }
                }
            }
            
            
        }
    } @catch (NSException *exception) {
//        NSLog(@"错误原因==%@",exception.reason);
    } @finally {
//        NSLog(@"不做处理");
    }
    

    
}
//model转化为字典
- (NSDictionary *)dicFromObject:(NSObject *)object {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([object class], &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertyList[i];
        const char *cName = property_getName(property);
        NSString *name = [NSString stringWithUTF8String:cName];
        NSObject *value = [object valueForKey:name];//valueForKey返回的数字和字符串都是对象
        
        if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
            //string , bool, int ,NSinteger
            if ([name isEqualToString:@"currentType"]) {
                NSMutableDictionary* mutDic = [NSMutableDictionary dictionary];
                                              [mutDic setObject:value forKey:@"value"];
                [dic setObject:mutDic forKey:name];
            }
            
            if ([name isEqualToString:@"currenterType"]) {
                NSMutableDictionary* mutDic = [NSMutableDictionary dictionary];
                [mutDic setObject:value forKey:@"value"];
                [dic setObject:mutDic forKey:name];
            }
            
            if ([name isEqualToString:@"currentState"]) {
                NSMutableDictionary* mutDic = [NSMutableDictionary dictionary];
                [mutDic setObject:value forKey:@"value"];
                [dic setObject:mutDic forKey:name];
            }
          
            [dic setObject:value forKey:name];
            
        } else {
            //model
            [dic setObject:[self dicFromObject:value] forKey:name];
        }
    }
    
    return [dic copy];
}
#pragma mark -- 获取服务器时间
-(void)getOnLineTime{
    
    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/index/getSystemTime",postUrl] version:Token parameters:nil success:^(id object) {
        if ([[object objectForKey:@"code"] intValue]== 200) {
            
            NSString* curtime = [object objectForKey:@"data"];
            
            NSDate *datenow = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
            //设置时区,这个对于时间的处理有时很重要
            
            [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"zh_CN"]];
            NSString *dateString = [formatter stringFromDate: datenow];
            
            NSDate *now = [formatter dateFromString:dateString];;//现在时间,你可以输出来看下是什么格式
            NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)([now timeIntervalSince1970]*1000)];
            
            
            
            
            NSInteger finalTime = [curtime integerValue] - [timeSp integerValue];
        
            self.scanType = @"5";
            NSString* timeV = [NSString stringWithFormat:@"AAFF%@%@",self.target,[self getTimeWithTime:finalTime]];
            
            [self openTheDoorByNum:timeV isScan:YES];
            
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark -- 是否是节假日
-(void)getHoliday{
    
//    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"XiaoQuModel"];
//    self.quModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];

//    NSString* str = [self.quModel.fangChanId substringToIndex:self.quModel.fangChanId.length - 2];
  
//    NSLog(@"板子是否为节假日==%@",self.holidayStr);
    
    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/device/isholiday",postUrl] version:Token parameters:@{@"deviceId":self.dianTiId} success:^(id object) {
        if ([[object objectForKey:@"code"] intValue]== 200) {
            BOOL isHoliday = [[object objectForKey:@"data"] boolValue];
         

            
            self.scanType = @"2";
            if (isHoliday==YES) {
//                if (self.quModel.fangChanId.length==20) {
                    self.sendAllNum = [NSString stringWithFormat:@"AAFF%@05%@55",self.target,self.quModel.fangChanId];
//                self.sendAllNum = @"AAFF05哈哈哈哈哈哈哈哈哈哈哈55";
//                }else{
//                    self.sendAllNum = [NSString stringWithFormat:@"AA05%@55",self.quModel.fangChanId];
//                }
                [self openTheDoorByNum:self.sendAllNum isScan:YES];
            }else if(isHoliday==NO){
                //08  取消节假日标志
//                if (self.quModel.fangChanId.length==20) {
                    self.sendAllNum = [NSString stringWithFormat:@"AAFF%@01%@55",self.target,self.quModel.fangChanId];
//                }else{
//                    self.sendAllNum = [NSString stringWithFormat:@"AA08%@55",self.quModel.fangChanId];
//                }
                [self openTheDoorByNum:self.sendAllNum isScan:YES];
            }
            NSLog(@"节假日==%@",self.sendAllNum);
            
         
        }
    } failure:^(NSError *error) {
        
    }];
    
}




-(void)order:(UIButton*)sender{
    if (![yzUserInfoModel getisLogin]) {
        yzLoginViewController *loginView = [[yzLoginViewController alloc] init];
        [loginView setLoginSuccessBlock:^{
            
        }];
        [self.navigationController presentViewController:[yzProductPubObject navc:loginView] animated:YES completion:nil];
    }else{
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"XiaoQuModel"];
        yzXiaoQuModel* quModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        NSString* xiaoquId  = [BBUserData stringChangeNull:quModel.xiaoqu_id replaceWith:@""];
        if ([xiaoquId isEqualToString:@""]) {
            [DDProgressHUD showErrorImageWithInfo:@"暂无小区"];
            return;
        }
        yzOrderListController* orderVC = [[yzOrderListController alloc]init];
        [self.navigationController pushViewController:orderVC animated:YES];
    }
}

#pragma mark -- CBCenterManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    switch (central.state) {
        case CBCentralManagerStateUnknown:
            NSLog(@"CBCentralManagerStateUnknown");
            break;
        case CBCentralManagerStateResetting:
            NSLog(@"CBCentralManagerStateResetting");
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@"CBCentralManagerStateUnsupported");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@"CBCentralManagerStateUnauthorized");
            break;
        case CBCentralManagerStatePoweredOff:
            NSLog(@"CBCentralManagerStatePoweredOff");
            
            break;
        case CBCentralManagerStatePoweredOn: {
            NSLog(@"CBCentralManagerStatePoweredOn");
   
            [self.centeralManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@(NO)}];
        }
            break;
        default:
            break;
    }
}
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI{
//    NSLog(@"发现设备：%@ 信号: %ld  data:%@",peripheral.name,(long)[RSSI intValue],advertisementData);//
    
//    [@"kCBAdvDataManufacturerData"]
    
    
//    NSLog(@"%@",self.bleNameArray);

    if ([BBUserData stringChangeNull:peripheral.name replaceWith:@""].length>0) {

        
        if ([RSSI intValue] > -95) {
//            if ([BBUserData isValid:peripheral.name]) {
                NSDictionary* dic = @{@"name":peripheral.name,@"rssi":@([RSSI intValue])};
                bool isSave = true;
                if (self.bleNameArray.count>0) {
                    for (int i = 0; i < self.bleNameArray.count; i++) {
                        if ([[self.bleNameArray[i] objectForKey:@"name"] isEqualToString:[dic objectForKey:@"name"]]) {
                            self.bleNameArray[i] = dic;
                            isSave = false;
                            break;
                        }
                    }
                    if (isSave) {
                        [self.bleNameArray addObject:dic];
                    }
                }else{
                    [self.bleNameArray addObject:dic];
                }
//            }
            
//            NSLog(@"蓝牙数组==%@",self.bleNameArray);
            
            
//            self.scanType = @"2";
            self.scan = YES;
            NSString * temp2;
            NSString* str = [NSString stringWithFormat:@"%@",advertisementData[@"kCBAdvDataManufacturerData"]];
            
            str = [BBUserData stringChangeNull:str replaceWith:@""];
            if (str.length>0) {
                str = [str stringByReplacingOccurrencesOfString:@"<" withString:@""];
                str = [str stringByReplacingOccurrencesOfString:@">" withString:@""];
                str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
                
        
                
                self.holidayStr = [str substringWithRange:NSMakeRange(6, 1)];
                str = [str substringFromIndex:4];
                temp2 = [self inputValue:[self getBinaryByHex:str]];
                NSString* string = [temp2 substringWithRange:NSMakeRange([self.quModel.floor intValue] - 1, 1)];
                self.holidayStr = string;
//                NSLog(@"对应楼层数:%@",temp2);
                if ([string isEqualToString:@"1"]) {
                    if (self.sendAllNum.length>0) {
                        self.sendAllNum = [self.sendAllNum stringByReplacingCharactersInRange:NSMakeRange(5, 1) withString:@"1"];
//                        self.scanType = @"2";
                    }
                    
                }else{
                    if (self.sendAllNum.length>0) {
                        self.sendAllNum = [self.sendAllNum stringByReplacingCharactersInRange:NSMakeRange(5, 1) withString:@"0"];
//                        self.scanType = @"1";
                    }
                    
                    
                }
            }
        }else{
            self.scanType = @"0";
            self.scan = NO;
            
        }
    }
    else{
//        NSLog(@"没有符合条件的信号");
    }
}

/**
 十六进制转换为二进制
 
 @param hex 十六进制数
 @return 二进制数
 */
- (NSString *)getBinaryByHex:(NSString *)hex {
    
    NSMutableDictionary *hexDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    [hexDic setObject:@"0000" forKey:@"0"];
    [hexDic setObject:@"0001" forKey:@"1"];
    [hexDic setObject:@"0010" forKey:@"2"];
    [hexDic setObject:@"0011" forKey:@"3"];
    [hexDic setObject:@"0100" forKey:@"4"];
    [hexDic setObject:@"0101" forKey:@"5"];
    [hexDic setObject:@"0110" forKey:@"6"];
    [hexDic setObject:@"0111" forKey:@"7"];
    [hexDic setObject:@"1000" forKey:@"8"];
    [hexDic setObject:@"1001" forKey:@"9"];
    [hexDic setObject:@"1010" forKey:@"A"];
    [hexDic setObject:@"1011" forKey:@"B"];
    [hexDic setObject:@"1100" forKey:@"C"];
    [hexDic setObject:@"1101" forKey:@"D"];
    [hexDic setObject:@"1110" forKey:@"E"];
    [hexDic setObject:@"1111" forKey:@"F"];
    
    NSString *binary = @"";
    for (int i=0; i<[hex length]; i++) {
        
        NSString *key = [hex substringWithRange:NSMakeRange(i, 1)];
        NSString *value = [hexDic objectForKey:key.uppercaseString];
        if (value) {
            
            binary = [binary stringByAppendingString:value];
        }
    }
    return binary;
}

//字符串倒序
-(NSString *)inputValue:(NSString *)str{
    
    NSMutableString* string = [[NSMutableString alloc]init];
        for(int i=0;i<str.length;i++){
                [string appendString:[str substringWithRange:NSMakeRange(str.length-i-1, 1)]];
            }
        return string;
    
}
#pragma mark --- 记录通行记录合成类
/**
 1.通行时间 格式yyyy-MM-dd HH:mm:ss
 2.通行类型 1门禁 2电梯 3道闸
 3.通行者类型  1业主 2访客
 4.通行状态 1进入 2离开
 5.通行设备 Android  or  ios
 6.备注
 7.车牌
 8.访问对象 roomID
 9.小区ID
 10.用户ID
 */

-(yzThroughRecordModel*)throughRecordByCurrenttime:(NSString*)currenttime currentType:(NSString*)currentType currenterType:(NSString*)currenterType currentState:(NSString*)currentState phoneSystem:(NSString*)phoneSystem remarks:(NSString*)remarks platenumber:(NSString*)platenumber accessObject:(NSString*)accessObject proXiaoquId:(NSString*)proXiaoquId openState:(NSString*)openState{
    
    
   
    
    yzThroughRecordModel* recordModel = [[yzThroughRecordModel alloc]init];
    recordModel.currenttime = currenttime;
    recordModel.currentType = currentType;
    recordModel.currenterType = currenterType;
    recordModel.currentState = currentState;
    recordModel.phoneSystem = phoneSystem;
    recordModel.remarks = remarks;
    recordModel.platenumber = platenumber;
    recordModel.accessObject = accessObject;
    recordModel.proXiaoquId = proXiaoquId;
    recordModel.openState = openState;
    recordModel.appUserId = [yzUserInfoModel getLoginUserInfo:@"userId"];
    return recordModel;
}

#pragma mark --- 蓝牙部分

-(void)openTheDoorByNum:(NSString*)str  isScan:(BOOL)isScan{
    
    
    
    
    if (self.characteristic) {
        if (self.peripheralManager.isAdvertising) {
            [self.peripheralManager stopAdvertising];
            
            // 根据服务的UUID开始广播
            [self.peripheralManager startAdvertising:@{CBAdvertisementDataServiceUUIDsKey:@[[CBUUID UUIDWithString:SERVICE_UUID]],CBAdvertisementDataLocalNameKey:str}];//
            
        }else{
            // 根据服务的UUID开始广播
            [self.peripheralManager startAdvertising:@{CBAdvertisementDataServiceUUIDsKey:@[[CBUUID UUIDWithString:SERVICE_UUID]],CBAdvertisementDataLocalNameKey:str}];
        }
        
        
        BOOL sendSuccess = [self.peripheralManager updateValue:[str dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:self.characteristic onSubscribedCentrals:nil];
     
        
        
        if (sendSuccess) {
 
           
           
            
            if (isScan) {
                __weak typeof(self) weakSelf = self;
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5/*延迟执行时间*/ * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
               
                    [weakSelf.centeralManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@(NO)}];
                });

                 
                
                if ([self.scanType isEqualToString:@"1"]) {
                    [DDProgressHUD showSuccessImageWithInfo:@"开启成功"];
                    if ([self.wangluo isEqualToString:@"0"]) {
                        self.scanType = @"2";
                        self.sendAllNum = [NSString stringWithFormat:@"AAFF%@00%@55",self.target,self.quModel.fangChanId];
                        [self openTheDoorByNum:self.sendAllNum isScan:YES];
                        //同时创建计时器 开始倒计时
                        [self createTimer];
                    }else{
                        [self getHoliday];
                    }
                    
                }else if ([self.scanType isEqualToString:@"2"]){
                    //同时创建计时器 开始倒计时
              
                    
                    
                    [self getOnLineTime];
                    
                }else if ([self.scanType isEqualToString:@"3"]){
                    [DDProgressHUD showErrorImageWithInfo:@"您的物业费已到期，请及时续费"];
                    //同时创建计时器 开始倒计时
                    [self createTimer];
                }else if ([self.scanType isEqualToString:@"4"]){
                    [DDProgressHUD showSuccessImageWithInfo:@"开启成功"];
                    self.scanType = @"1";
                    //同时创建计时器 开始倒计时
                    [self createTimer];
                }else if ([self.scanType isEqualToString:@"5"]){
                    NSLog(@"发送时间校验成功");
                    self.scanType = @"1";
                    //同时创建计时器 开始倒计时
                    [self createTimer];
                }else if ([self.scanType isEqualToString:@"wugan"]){
                    [self createTimer];
                }
             
                
                
                [self uploadThroughRecordWithModel:[self throughRecordByCurrenttime:[self getNowTime] currentType:[self.tiDoor isEqualToString:@"F"] ? @"1" : @"2" currenterType:[self.quModel.isMain isEqualToString:@"是"] ? @"1" : @"2" currentState:@"1" phoneSystem:@"IOS" remarks:@"" platenumber:@"" accessObject:self.quModel.roomId proXiaoquId:self.quModel.xiaoqu_id openState:@"1"]];

            }else{
                [self.centeralManager stopScan];
                [self createTimer];
              
            }
        }else {
            if ([self.scanType isEqualToString:@"1"]) {

                NSLog(@"数据发送失败");
                
            }else if ([self.scanType isEqualToString:@"2"]){
                self.scanType = @"1";
            }
             [self uploadThroughRecordWithModel:[self throughRecordByCurrenttime:[self getNowTime] currentType:[self.tiDoor isEqualToString:@"F"] ? @"1" : @"2" currenterType:[self.quModel.isMain isEqualToString:@"是"] ? @"1" : @"2" currentState:@"1" phoneSystem:@"IOS" remarks:@"" platenumber:@"" accessObject:self.quModel.roomId proXiaoquId:self.quModel.xiaoqu_id openState:@"0"]];
        }
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
            self.open = YES;
            // 创建Service（服务）和Characteristics（特征）
            [self setupServiceAndCharacteristics];
        }
            break;
        case CBPeripheralManagerStatePoweredOff:
        {
            NSLog(@"蓝牙关闭");
            self.open = NO;
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
    
  
    
//    if ([self.startNum isEqualToString:@"1"]) {
//        NSData *locadata = [[NSUserDefaults standardUserDefaults] objectForKey:@"XiaoQuArray"];
//        self.xiaoquArray = [NSKeyedUnarchiver unarchiveObjectWithData:locadata];
//        if (self.xiaoquArray.count>0) {
//            yzXiaoQuModel* model = self.xiaoquArray[0];
//            if (model.bleArray.count>0) {
//
//                self.sysDeviceDiantiCode = [model.bleArray[0] objectForKey:@"sysDeviceDiantiCode"];
//                self.target = [self.sysDeviceDiantiCode substringFromIndex:self.sysDeviceDiantiCode.length - 2];
//                self.sendAllNum = [NSString stringWithFormat:@"AAFF%@00%@55",self.target,model.fangChanId];
//                [self openTheDoorByNum:self.sendAllNum isScan:YES];
//                self.startNum = @"2";
//
//            }
//
//        }
//    }
  
    
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
       
                
                if ([self.scanType isEqualToString:@"5"])
                {
//                    self.scanType = @"6";
//                    NSString* timeV = [NSString stringWithFormat:@"AAFF%@%@",self.target,[self getTimeWithTime:<#(NSInteger)#>]];
//
//                    [self openTheDoorByNum:timeV isScan:YES];
                    
//                    NSLog(@"时间校验==%@",timeV);
                }else{
                    if (weakSelf.peripheralManager.isAdvertising) {
                        [weakSelf.peripheralManager stopAdvertising];
                    }
                }
            });
        }
    });
    
    dispatch_resume(timer);
}


#pragma mark  -- 小区下拉选项
//显示topView
-(void)showTopView:(UIButton *)button{
//    NSLog(@"===%lu",(unsigned long)self.xiaoquArray.count);
    if (self.xiaoquArray.count<=0) {
        
        return;
    }
    
    WEAKSELF
    if (self.isShowTop) {
        //隐藏
        [self.topLocationView _tapGesturePressed];
    }else{
        self.topLocationView = [[indexTopLocationView alloc] initWithFrame:CGRectMake(0, DCTopNavHeight, mDeviceWidth, self.xiaoquArray.count*44 <= (mDeviceHeight - kSaveTopSpace - 64)?self.xiaoquArray.count*44:mDeviceHeight - kSaveTopSpace - 64)];
        [self.topLocationView option_show];
        [self.topLocationView setPxCookModel:self.xiaoquArray];
        
        [self.topLocationView setSelectedQuBlock:^(yzXiaoQuModel *model) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject: model] forKey:@"XiaoQuModel"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [weakSelf.locationBtn setTitle:[NSString stringWithFormat:@"%@-%@-%@-%@",model.xiaoqu_name,model.louYu,model.danYuan,model.room] forState:UIControlStateNormal];

//                weakSelf.sendAllNum = [NSString stringWithFormat:@"AAFF00%@55",weakSelf.quModel.fangChanId];

            weakSelf.midArray = model.bleArray;
            
            NSLog(@"切换电梯==%@",weakSelf.midArray);
            weakSelf.quModel = model;
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject: weakSelf.quModel] forKey:@"XiaoQuModel"];
            [[NSUserDefaults standardUserDefaults] synchronize];

        }];
        
       
    }
    self.isShowTop = !self.isShowTop;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.isShowTop) {
        //隐藏
        [self.topLocationView _tapGesturePressed];
    }
    self.isShowTop = !self.isShowTop;
    [self.centeralManager stopScan];
}

-(NSString*)getTimeWithTime:(NSInteger)midtime{
    
    NSDate *datenow = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    //设置时区,这个对于时间的处理有时很重要
    
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"zh_CN"]];
    NSString *dateString = [formatter stringFromDate: datenow];
    
    NSDate *now = [formatter dateFromString:dateString];;//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)([now timeIntervalSince1970]*1000)];
    
    
    NSInteger finalTime = [timeSp integerValue] + midtime;
    
    
    NSTimeInterval interval = finalTime / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    
    
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    
    self.week = [BBUserData getweekDayStringWithDate:[NSDate date]];
    
    
    NSInteger year =(NSInteger) [dateComponent year];
    NSInteger month = (NSInteger) [dateComponent month];
    NSInteger day = (NSInteger) [dateComponent day];
    NSInteger hour = (NSInteger) [dateComponent hour];
    NSInteger minute = (NSInteger) [dateComponent minute];
    NSInteger second = (NSInteger) [dateComponent second];
    
    
    self.year = [[NSString stringWithFormat:@"%ld",(long)year] substringFromIndex:2];
    NSLog(@"%@",self.year);
    
    if (month>=10) {
        self.mouth = [NSString stringWithFormat:@"%ld",(long)month];
    }else{
        self.mouth = [NSString stringWithFormat:@"0%ld",(long)month];
    }
    
    
    if (day>=10) {
        self.day = [NSString stringWithFormat:@"%ld",(long)day];
    }else{
        self.day = [NSString stringWithFormat:@"0%ld",(long)day];
    }
    
    if (hour>=10) {
        self.hour = [NSString stringWithFormat:@"%ld",(long)hour];
    }else{
        self.hour = [NSString stringWithFormat:@"0%ld",(long)hour];
    }
    
    if (minute>=10) {
        self.minute = [NSString stringWithFormat:@"%ld",(long)minute];
    }else{
        self.minute = [NSString stringWithFormat:@"0%ld",(long)minute];
    }
    
    if (second>=10) {
        self.second = [NSString stringWithFormat:@"%ld",(long)second];
    }else{
        self.second = [NSString stringWithFormat:@"0%ld",(long)second];
    }
    
    int final = 0.0;
    
    
    
    
    
    
    //字符串开始拼接
    NSString *allstr=[self.hour stringByAppendingString:self.day];
    NSString *allstr1=[allstr stringByAppendingString:self.minute];
    NSString *allstr2=[allstr1 stringByAppendingString:self.mouth];
    NSString *allstr3=[allstr2 stringByAppendingString:@"00"];
    //    NSString *allstr4=[allstr3 stringByAppendingString:self.minute];
    //    NSString *allstr5=[allstr4 stringByAppendingString:self.mouth];
    
    
    NSString* shiliujinzhi = [self ToHex:[allstr3 integerValue]];
    
    
    
    NSLog(@"十六进制==%@==%@",allstr3,shiliujinzhi);
    
    
    NSMutableArray* allArr = [NSMutableArray array];
    
    NSString* time = [NSString stringWithFormat:@"%@%@%@%@",self.week,self.second,self.year,allstr3];
    
    NSLog(@"time==%@",time);
    for (int i = 0; i<time.length;i++) {
        [allArr addObject:[time substringWithRange:NSMakeRange(i, 1)]];
    }
    for (NSString* count in allArr) {
        final += [count intValue];
    }
    
    NSString* finalStr = [NSString stringWithFormat:@"%d",final];
    
    //校验码
    if (final>99) {
        self.verify1 = [finalStr substringFromIndex:finalStr.length - 2];
    }else{
        self.verify1 = [NSString stringWithFormat:@"%d",final];
    }
    
    self.sendAll = [NSString stringWithFormat:@"0B%@%@%@%@00%@55",self.week,self.second,self.year,shiliujinzhi,self.verify1];
    
    return self.sendAll;
}
//数字转16进制
//将十进制转化为十六进制
-(NSString *)ToHex:(long long int)tmpid{
    NSString *nLetterValue;
    NSString *str =@"";
    long long int ttmpig;
    for (int i = 0; i<10; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:nLetterValue=[[NSString alloc]initWithFormat:@"%lli",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
        
    }
    return str;
}
@end
