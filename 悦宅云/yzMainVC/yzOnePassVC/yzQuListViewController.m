//
//  yzQuListViewController.m
//  悦宅云
//
//  Created by 尚广杰 on 2019/11/5.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import "yzQuListViewController.h"
#import "yzOnePassController.h"
#import <CoreBluetooth/CoreBluetooth.h>

#define SERVICE_UUID @"CDD1"
#define CHARACTERISTIC_UUID @"CDD2"
@interface yzQuListViewController ()<CBPeripheralManagerDelegate,CBCentralManagerDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)NSMutableArray* seleInteger;

@property(nonatomic,strong)NSString* year;         //年
@property(nonatomic,strong)NSString* mouth;        //月
@property(nonatomic,strong)NSString* day;          //日
@property(nonatomic,strong)NSString* hour;         //时
@property(nonatomic,strong)NSString* minute;       //分
@property(nonatomic,strong)NSString* second;       //秒
@property(nonatomic,strong)NSString* week;         //周几

@property(nonatomic,strong)NSString* verify;

@property(nonatomic,strong)NSString* sendAll;

@property (nonatomic, strong) CBPeripheralManager *peripheralManager;
@property (nonatomic, strong) CBMutableCharacteristic *characteristic;
@property (nonatomic, strong) CBCentralManager* centeralManager;
@end

@implementation yzQuListViewController
-(UITableView*)tableV{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, mDeviceWidth, mDeviceHeight - KSAFEBAR_HEIGHT - kNavBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //解决滑动视图顶部空出状态栏高度的问题
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//            _tableView.estimatedSectionHeaderHeight = 0;
//            _tableView.estimatedSectionFooterHeight = 0;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
            
        }
//        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
//        _tableView.separatorInset = UIEdgeInsetsZero;
        [self.view addSubview:self.tableView];
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.seleInteger = [NSMutableArray array];
    if (self.quLists.count>0) {
        for (NSDictionary* dic in self.quLists) {
            [self.seleInteger addObject:@"0"];
        }
    }
//    self.seleInteger = @[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"].mutableCopy;
    
    [self tableV];
    
    
    self.centeralManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
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
    [titleLabel setText:@"小区"];
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
     [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.quLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (self.quLists.count>0) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[self.quLists[indexPath.row] objectForKey:@"name"]];
        if ([self.seleInteger[indexPath.row] isEqualToString:@"1"]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    yzOnePassController* onePassVC = [[yzOnePassController alloc]init];
    for (int i = 0; i < self.seleInteger.count; i++) {
        if (i==indexPath.row) {
            self.seleInteger[i] = @"1";
        }else{
            self.seleInteger[i] = @"0";
        }
    }
    onePassVC.dianTi = self.dianTi;
    onePassVC.roleId = self.roleId;
    onePassVC.autoHexString = [self.quLists[indexPath.row] objectForKey:@"autoHexString"];
    onePassVC.autoonly = [self.quLists[indexPath.row] objectForKey:@"autoonly"];
    onePassVC.quId = [self.quLists[indexPath.row] objectForKey:@"id"];
    onePassVC.code = [self.quLists[indexPath.row] objectForKey:@"code"];
    onePassVC.midTime = self.midTime;
    [self.navigationController pushViewController:onePassVC animated:YES];
    [self.tableView reloadData];
}

-(NSString*)getTime{
    NSDate *now = [NSDate date];
    
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    self.week = [BBUserData getweekDayStringWithDate:[NSDate date]];
    
    
    int year =(int) [dateComponent year];
    int month = (int) [dateComponent month];
    int day = (int) [dateComponent day];
    int hour = (int) [dateComponent hour];
    int minute = (int) [dateComponent minute];
    int second = (int) [dateComponent second];
  
    
    self.year = [[NSString stringWithFormat:@"%d",year] substringFromIndex:2];
    NSLog(@"%@",self.year);
    
    if (month>=10) {
        self.mouth = [NSString stringWithFormat:@"%d",month];
    }else{
        self.mouth = [NSString stringWithFormat:@"0%d",month];
    }
    
    
    if (day>=10) {
        self.day = [NSString stringWithFormat:@"%d",day];
    }else{
        self.day = [NSString stringWithFormat:@"0%d",day];
    }
    
    if (hour>=10) {
        self.hour = [NSString stringWithFormat:@"%d",hour];
    }else{
        self.hour = [NSString stringWithFormat:@"0%d",hour];
    }
    
    if (minute>=10) {
        self.minute = [NSString stringWithFormat:@"%d",minute];
    }else{
        self.minute = [NSString stringWithFormat:@"0%d",minute];
    }
    
    if (second>=10) {
        self.second = [NSString stringWithFormat:@"%d",second];
    }else{
        self.second = [NSString stringWithFormat:@"0%d",second];
    }
    
    int final = 0.0;
    

    
 
    

    //字符串开始拼接
    NSString *allstr=[self.week stringByAppendingString:self.second];
    NSString *allstr1=[allstr stringByAppendingString:self.year];
    NSString *allstr2=[allstr1 stringByAppendingString:self.hour];
    NSString *allstr3=[allstr2 stringByAppendingString:self.day];
    NSString *allstr4=[allstr3 stringByAppendingString:self.minute];
    NSString *allstr5=[allstr4 stringByAppendingString:self.mouth];
    
    NSMutableArray* allArr = [NSMutableArray array];
    
    for (int i = 0; i<allstr5.length;i++) {
        [allArr addObject:[allstr5 substringWithRange:NSMakeRange(i, 1)]];
    }
    for (NSString* count in allArr) {
        final += [count intValue];
    }
    NSLog(@"%@====%d",allArr,final);
    NSString* finalStr = [NSString stringWithFormat:@"%d",final];
    if (final>99) {
        self.verify = [finalStr substringFromIndex:finalStr.length - 2];
    }else{
        self.verify = [NSString stringWithFormat:@"%d",final];
    }
    NSString *allstr6=[allstr5 stringByAppendingString:@"0000"];
    NSString *DateTime=[allstr6 stringByAppendingString:self.verify];

    self.sendAll = [NSString stringWithFormat:@"AAFF0B%@55",DateTime];
  
    return self.sendAll;
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

//            [self.centeralManager stopScan];
            NSLog(@"停止扫描");
            NSLog(@"数据发送成功：%@",str);
            [self createTimer];
            [DDProgressHUD showSuccessImageWithInfo:@"数据发送成功"];
            
            NSLog(@"99999999999");
            
            //            }
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
    
//    NSInteger time = [self.currentTimeMillis integerValue] - [self.localityTime integerValue];
//    if (time>0&&time<1500) {
//        [self openTheDoorByNum:[self getTime]];
//
//    }
    
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
        NSLog(@"发现设备：%@ 信号: %ld",peripheral.name,(long)[RSSI intValue]);//,advertisementData[@"kCBAdvDataManufacturerData"]
    
    
    
    
   
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
    if (self.peripheralManager.isAdvertising) {
        [self.peripheralManager stopAdvertising];
    }
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
                
                if (weakSelf.peripheralManager.isAdvertising) {
                    [weakSelf.peripheralManager stopAdvertising];
                }
            });
        }
    });
    
    dispatch_resume(timer);
}
@end
