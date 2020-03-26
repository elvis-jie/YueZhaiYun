//
//  yzOneUpViewController.m
//  悦宅云
//
//  Created by 尚广杰 on 2019/12/27.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import "yzOneUpViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "yzUploadViewCell.h"
#define SERVICE_UUID @"CDD1"
#define CHARACTERISTIC_UUID @"CDD2"
@interface yzOneUpViewController ()<CBPeripheralManagerDelegate,CBCentralManagerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) CBPeripheralManager *peripheralManager;
@property (nonatomic, strong) CBMutableCharacteristic *characteristic;
@property (nonatomic, strong) CBCentralManager* centeralManager;
@property (nonatomic) CGRect rect;
@property (nonatomic, strong) UIButton* uploadMessage;      //上传用户信息
@property (nonatomic, strong) NSMutableArray* danYuanLists; //所有单元信息
@property (nonatomic, strong) NSMutableArray* roomLists;    //单元下所有房屋信息

@property (nonatomic, strong) NSMutableArray* bleNameArray; //搜索到的蓝牙名称
@property (nonatomic, strong) NSMutableArray* sysDiantiList; //获取单元下可用的所有电梯

@property (nonatomic, strong) NSMutableArray* finalArray;    //对比之后最后的电梯数组
@property (nonatomic, strong) NSString* sysDeviceDiantiCode; //最终电梯名
@property (nonatomic, strong) NSString* target;              //电梯名后两位
@property (nonatomic, strong) NSMutableArray* seleType;      //选中状态
//@property (nonatomic, assign) bool complete;             //发送完成

@property (nonatomic, strong) NSString* sendFalse;           //发送失败的信息
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation yzOneUpViewController
    
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        //自动网格布局
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _rect = CGRectMake(0, 0, mDeviceWidth, mDeviceHeight - kSaveBottomSpace); //-60
//        CGFloat realWi = [self fixSlitWith:_rect colCount:3 space:0];
        flowLayout.itemSize = CGSizeMake((mDeviceWidth - 20)/3, 60);
        //网格布局
        _collectionView = [[UICollectionView alloc]initWithFrame:_rect collectionViewLayout:flowLayout];
        _collectionView.showsVerticalScrollIndicator = YES;
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        //注册cell
        [_collectionView registerClass:[yzUploadViewCell class] forCellWithReuseIdentifier:@"Cell"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        [_collectionView setBackgroundColor:[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1]];
        //设置数据源代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
    
}
    
- (CGFloat)fixSlitWith:(CGRect)rect colCount:(CGFloat)colCount space:(CGFloat)space {
    //    space = 0;
    CGFloat totalSpace = (colCount - 1) * space;//总共留出的距离
    CGFloat itemWidth = (rect.size.width - totalSpace) / colCount;// 按照真实屏幕算出的cell宽度 （iPhone6 375*667）93.75
    CGFloat fixValue = 1 / [UIScreen mainScreen].scale; //(6为1px=0.5pt,6Plus为3px=1pt)1个点有两个像素
    CGFloat realItemWidth = floor(itemWidth) + fixValue;//取整加fixValue  floor:如果参数是小数，则求最大的整数但不大于本身.
    if (realItemWidth < itemWidth) {// 有可能原cell宽度小数点后一位大于0.5
        realItemWidth += fixValue;
    }
    
    CGFloat realWidth = colCount * realItemWidth + totalSpace;//算出屏幕等分后满足`1px=0.5pt`实际的宽度
    CGFloat pointX = (realWidth - rect.size.width) / 2; //偏移距离
    rect.origin.x = -pointX;//向左偏移
    rect.size.width = realWidth;
    _rect = rect;
    return realItemWidth;//(rect.size.width - totalSpace) / colCount; //每个cell的真实宽度
}

    
    
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:RGB(240, 240, 240)];
    self.bleNameArray = [NSMutableArray array];
  
    [self.view addSubview:self.collectionView];
    [self getHouseMessage];
    
    self.centeralManager = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_get_main_queue() options:nil];
    
    // 创建外设管理器，会回调peripheralManagerDidUpdateState方法
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    
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
    [titleLabel setText:@"上传住户信息"];
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
    
#pragma mark -- collectionView
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.danYuanLists.count;
}
    
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    yzUploadViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if (self.danYuanLists.count>0) {
        [cell setBackgroundColor:[self.seleType[indexPath.row] isEqualToString:@"0"] ? [UIColor whiteColor] : [UIColor orangeColor]];
        [cell getTitleByString:[NSString stringWithFormat:@"%@号楼%@单元",[self.danYuanLists[indexPath.row] objectForKey:@"louyuName"],[self.danYuanLists[indexPath.row] objectForKey:@"danyuanName"]]];
    }
    
    return cell;
}
    
#pragma mark - 视图内容
    
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    // 视图添加到 UICollectionReusableView 创建的对象中
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        if (!self.uploadMessage) {
            //一键上传
            self.uploadMessage = [[UIButton alloc]initWithFrame:CGRectMake(15, 10, mDeviceWidth - 30, 50)];
            [self.uploadMessage setTitle:@"上传所选单元信息" forState:UIControlStateNormal];
            self.uploadMessage.titleLabel.font = YSize(15.0);
            [self.uploadMessage setTitleColor:RGB(223, 15, 15) forState:UIControlStateNormal];
            self.uploadMessage.layer.cornerRadius = 5;
            [self.uploadMessage setBackgroundColor:[UIColor whiteColor]];
            // 阴影颜色
            self.uploadMessage.layer.shadowColor = [UIColor blackColor].CGColor;
            // 阴影偏移量 默认为(0,3)
            self.uploadMessage.layer.shadowOffset = CGSizeZero;
            // 阴影透明度
            self.uploadMessage.layer.shadowOpacity = 0.7;
            [self.uploadMessage addTarget:self action:@selector(uploadMessage:) forControlEvents:UIControlEventTouchUpInside];
            [headerView addSubview:self.uploadMessage];
        }
 
        
        
        return headerView;
        
    }else {
        return nil;
    }
}
    //footer的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{

    return CGSizeZero;
    
}
    
    //header的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(mDeviceWidth, 70);
    
}
    
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.sysDiantiList = [NSMutableArray array];
    [self.sysDiantiList addObjectsFromArray:[self.danYuanLists[indexPath.row] objectForKey:@"sysDiantiList"]];
    [self seleOneElementWithDanYuanId:[NSString stringWithFormat:@"%@",[self.danYuanLists[indexPath.row] objectForKey:@"danyuanId"]]];
    for (int i = 0; i < self.seleType.count; i++) {
        if (i==indexPath.row) {
            self.seleType[i] = @"1";
        }else{
            self.seleType[i] = @"0";
        }
    }
    [self.collectionView reloadData];
}

#pragma mark -- 上传住户信息
-(void)uploadMessage:(UIButton*)sender{
    
 
    
    
    self.finalArray = [NSMutableArray array];
    if (self.danYuanLists.count==0) {
        [DDProgressHUD showErrorImageWithInfo:@"没有电梯"];
        return;
    }
    if (self.sysDiantiList.count==0) {
        [DDProgressHUD showErrorImageWithInfo:@"请选择单元或者该单元没有房间信息"];
        return;
    }
    for (NSDictionary* dic1 in self.bleNameArray) {
        for (NSDictionary* dic2 in self.sysDiantiList) {
            
            if ([[dic1 objectForKey:@"name"] isEqualToString:[dic2 objectForKey:@"sysDeviceDiantiCode"]]) {
                
                NSMutableDictionary* mutDic = [NSMutableDictionary dictionaryWithDictionary:dic1];
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
        
        self.sysDeviceDiantiCode = [self.finalArray[0] objectForKey:@"sysDeviceDiantiCode"];
        self.target = [self.sysDeviceDiantiCode substringFromIndex:self.sysDeviceDiantiCode.length - 2];
        if (self.roomLists.count>0) {
            NSString* sendNum = [NSString stringWithFormat:@"AAFF%@00%@55",self.target,[self.roomLists[0] objectForKey:@"fangchanId"]];
            [self openTheDoorByNum:sendNum];
            [self.roomLists removeObjectAtIndex:0];
            [DDProgressHUD showWithStatus:@"正在上传"];
        }
        
        if (self.roomLists.count>0) {
            self.timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
        }else{
            [DDProgressHUD showSuccessImageWithInfo:@"上传完成"];
        }
       
       

 
    }else{
        
        [DDProgressHUD showErrorImageWithInfo:@"抱歉，请在被授权使用的电梯内操作"];
    }



   
}
- (void)timerRun {
    
    NSString* sendNum = [NSString stringWithFormat:@"AAFF%@00%@55",self.target,[self.roomLists[0] objectForKey:@"fangchanId"]];
    [self openTheDoorByNum:sendNum];
    [self.roomLists removeObjectAtIndex:0];
    
    if (self.roomLists.count==0) {
        [DDProgressHUD showSuccessImageWithInfo:@"上传完成"];
        [self.timer invalidate];
    }
}

- (void)dealloc {
    [self.timer invalidate];
    NSLog(@"%s", __func__);
}
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
         
            [self createTimer];
            NSLog(@"数据发送成功==%@",str);



        }else {
         
        
            self.sendFalse = str;


            NSLog(@"数据发送失败==%@",str);
            
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
-(void)peripheralManagerIsReadyToUpdateSubscribers:(CBPeripheralManager *)peripheral{
 

    [self openTheDoorByNum:self.sendFalse];
    
   
    
}
-(void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error {
    if (error) {
        NSLog(@"Error advertising: %@", [error localizedDescription]);
    }
}

#pragma mark -- 数据请求
//所有单元
-(void)getHouseMessage{
 [DDProgressHUD show];
    [CCAFNetWork post:[NSString stringWithFormat:@"%@prouser/getDanyuanList",postUrl] version:Token parameters:@{@"xiaoquId":self.xiaoQuId} success:^(id object) {
         self.danYuanLists = [NSMutableArray array];
         self.seleType = [NSMutableArray array];
        NSDictionary *json = object;
        if ([[json objectForKey:@"code"] intValue] == 200) {
            [DDProgressHUD dismiss];
            
            self.danYuanLists = [json objectForKey:@"data"];
            for (NSString* str in self.danYuanLists) {
                [self.seleType addObject:@"0"];
            }
            [DDProgressHUD showSuccessImageWithInfo:@"暂无数据"];
            [self.collectionView reloadData];
            
        }else{
            [DDProgressHUD showErrorImageWithInfo:[json objectForKey:@"message"]];
        }
        
    } failure:^(NSError *error) {
        [DDProgressHUD showErrorImageWithInfo:error.localizedDescription];
    }];
}
//选中某一单元
-(void)seleOneElementWithDanYuanId:(NSString*)danyuanId{
    [DDProgressHUD show];
    [CCAFNetWork post:[NSString stringWithFormat:@"%@prouser/getRoomList",postUrl] version:Token parameters:@{@"danyuanId":danyuanId} success:^(id object) {
        self.roomLists = [NSMutableArray array];
        NSDictionary *json = object;
        if ([[json objectForKey:@"code"] intValue] == 200) {
            [DDProgressHUD dismiss];
            
            [self.roomLists addObjectsFromArray:[json objectForKey:@"data"]];
            
        }else{
            [DDProgressHUD showErrorImageWithInfo:[json objectForKey:@"message"]];
        }
        
    } failure:^(NSError *error) {
        [DDProgressHUD showErrorImageWithInfo:error.localizedDescription];
    }];

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
            NSLog(@"蓝牙关闭");
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

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI{
//    NSLog(@"发现设备：%@ 信号: %ld",peripheral.name,(long)[RSSI intValue]);//,advertisementData[@"kCBAdvDataManufacturerData"]
    
    

  
    if ([BBUserData stringChangeNull:peripheral.name replaceWith:@""].length>0) {
        if ([RSSI intValue] > -95) {
//             NSLog(@"发现设备：%@ 信号: %ld",peripheral.name,(long)[RSSI intValue]);//,advertisementData[@"kCBAdvDataManufacturerData"]
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
            }
        
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


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.peripheralManager.isAdvertising) {
        [self.peripheralManager stopAdvertising];
    }
    [self.centeralManager stopScan];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.centeralManager stopScan];
}

#pragma mark - 定时器 (GCD)
- (void)createTimer {
    
    //设置倒计时时间
    //通过检验发现，方法调用后，timeout会先自动-1，所以如果从15秒开始倒计时timeout应该写16
    //__block 如果修饰指针时，指针相当于弱引用，指针对指向的对象不产生引用计数的影响
    __block int timeout;
//    if (self.textField.text.length>0) {
//        timeout = [self.textField.text intValue];
//    }else{
        timeout = 2;
//    }
    
    
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
                
//                if (weakSelf.peripheralManager.isAdvertising) {
//                    [weakSelf.peripheralManager stopAdvertising];
//                }
                [self.peripheralManager removeAllServices];
                self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
            });
        }
    });
    
    dispatch_resume(timer);
}
@end
