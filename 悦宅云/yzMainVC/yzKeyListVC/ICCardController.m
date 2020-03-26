//
//  ICCardController.m
//  悦宅云
//
//  Created by 尚广杰 on 2019/10/28.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import "ICCardController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#define SERVICE_UUID @"CDD1"
#define CHARACTERISTIC_UUID @"CDD2"
@interface ICCardController ()<CBPeripheralManagerDelegate,CBCentralManagerDelegate>
@property(nonatomic,strong)UIButton* addBtn;
@property(nonatomic,strong)UIButton* deleBtn;
@property(nonatomic,strong)UIButton* postponeBtn;

@property (nonatomic, strong) CBPeripheralManager *peripheralManager;
@property (nonatomic, strong) CBMutableCharacteristic *characteristic;

@property (nonatomic,strong) CBCentralManager* centeralManager;
@property (nonatomic,strong) NSMutableArray <CBPeripheral*>* scanedDevices;

@property (nonatomic,strong) NSString* sendAllNum;       //发送的广播信息

@property (nonatomic,strong) NSString* type;             //1  添卡  2  删卡   3  延期

@property (nonatomic,strong) NSString* postponeTime;     //延期数据
@property (nonatomic,strong) NSString* deleId;     //删卡需要的id

//@property (nonatomic,assign) BOOL sendBool;              //是否发送消息
@property (nonatomic,strong) NSMutableArray* bleNameArray;    //搜索到的蓝牙数组
@property (nonatomic,strong) NSMutableArray* finalArray;

@property (nonatomic, strong) NSString* sysDeviceDiantiCode;
@property (nonatomic, strong) NSString* target;      //目标指令   电梯名称后两位

@end

@implementation ICCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1]];

        self.automaticallyAdjustsScrollViewInsets = NO;
    self.bleNameArray = [NSMutableArray array];
    self.finalArray = [NSMutableArray array];
    
    [self setButton];

    NSLog(@"===%@==%@",self.fangChanId,self.dianTiList);
    // 创建外设管理器，会回调peripheralManagerDidUpdateState方法
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    self.centeralManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    if ([self.state isEqualToString:@"1"]) {
        [self updateAtime];
    }
    
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
    [titleLabel setText:@"IC卡管理"];
    [titleLabel setFrame:CGRectMake(0, 0, mDeviceWidth/2, NavTopHeight)];
    [titleLabel setFont:YSize(18.0)];
    [titleLabel setTextColor:RGB(22, 22, 22)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.navigationController.visibleViewController.navigationItem setTitleView:titleLabel];
    
    
    
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


//设置按钮
-(void)setButton{
    //添加IC
    self.addBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 15 + kNavBarHeight, mDeviceWidth - 30, mDeviceWidth/2)];
    self.addBtn.layer.cornerRadius = 5;
    [self.addBtn setBackgroundColor:[UIColor whiteColor]];
    
    // 阴影颜色
    self.addBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    // 阴影偏移量 默认为(0,3)
    self.addBtn.layer.shadowOffset = CGSizeZero;
    // 阴影透明度
    self.addBtn.layer.shadowOpacity = 0.7;
    [self.addBtn addTarget:self action:@selector(addIC:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.addBtn];
    
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake((mDeviceWidth - 30)/2 - 30, 20, 60, 60)];
    imageView.image = [UIImage imageNamed:@"addIC"];
    [self.addBtn addSubview:imageView];
    
    UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, mDeviceWidth/2 - 60, mDeviceWidth - 50, 18)];
    titleLabel.text = @"添加IC卡";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = YSize(15.0);
    [self.addBtn addSubview:titleLabel];
    
    UILabel* contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, mDeviceWidth/2 - 35, mDeviceWidth - 50, 18)];
    contentLabel.text = @"点击添加，灯绿后，将IC卡贴近读写器";
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.font = YSize(13.0);
    [self.addBtn addSubview:contentLabel];
    
    
    //延期按钮
    self.postponeBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.addBtn.frame) + 40, mDeviceWidth - 30, mDeviceWidth/2)];
    self.postponeBtn.layer.cornerRadius = 5;
    [self.postponeBtn setBackgroundColor:[UIColor whiteColor]];
    
    // 阴影颜色
    self.postponeBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    // 阴影偏移量 默认为(0,3)
    self.postponeBtn.layer.shadowOffset = CGSizeZero;
    // 阴影透明度
    self.postponeBtn.layer.shadowOpacity = 0.7;
    [self.postponeBtn addTarget:self action:@selector(postponeBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.postponeBtn];
    
    
    UIImageView* imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake((mDeviceWidth - 30)/2 - 30, 20, 60, 60)];
    imageView1.image = [UIImage imageNamed:@"延期"];
    [self.postponeBtn addSubview:imageView1];
    
    UILabel* titleLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(10, mDeviceWidth/2 - 60, mDeviceWidth - 50, 18)];
    titleLabel1.text = @"IC卡续期";
    titleLabel1.textAlignment = NSTextAlignmentCenter;
    titleLabel1.font = YSize(15.0);
    [self.postponeBtn addSubview:titleLabel1];
    
    UILabel* contentLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(10, mDeviceWidth/2 - 35, mDeviceWidth - 50, 18)];
    contentLabel1.text = @"缴完物业费后，在电梯内给IC卡续期";
    contentLabel1.textAlignment = NSTextAlignmentCenter;
    contentLabel1.font = YSize(13.0);
    [self.postponeBtn addSubview:contentLabel1];
    
    
    //删除
    
    self.deleBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.postponeBtn.frame) + 40, mDeviceWidth, 44)];
    [self.deleBtn setBackgroundColor:[UIColor whiteColor]];
    [self.deleBtn setTitle:@"删除IC卡" forState:UIControlStateNormal];
    [self.deleBtn setTitleColor:[UIColor colorWithRed:217/255.0 green:23/255.0 blue:24/255.0 alpha:1] forState:UIControlStateNormal];
    self.deleBtn.titleLabel.font = YSize(15.0);
    [self.deleBtn addTarget:self action:@selector(deleBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.deleBtn];
    
    
    
    
    
}

#pragma mark --- 蓝牙部分

-(void)icCardManage:(NSString*)str{
    
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

            
            if ([self.type isEqualToString:@"1"]) {
                [DDProgressHUD showSuccessImageWithInfo:@"制卡成功"];
            }else if([self.type isEqualToString:@"2"]){
                [DDProgressHUD showSuccessImageWithInfo:@"删卡成功"];
            }else{
                [DDProgressHUD showSuccessImageWithInfo:@"续期成功"];
            }
            
            
            
            [self createTimer];
  
        }else {
            NSLog(@"失败");
            
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
    NSLog(@"%@==%d",peripheral.name,[RSSI intValue]);
    
    if ([BBUserData stringChangeNull:peripheral.name replaceWith:@""].length>0) {
        if ([RSSI intValue] > -95) {
//            self.sendBool = YES;
            if ([BBUserData isValid:peripheral.name]) {
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
//            else{
//            self.sendBool = NO;
//        }
    }
    else{
        //         self.sendBool = NO;
        NSLog(@"没有符合条件的信号");
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


//添加
-(void)addIC:(UIButton*)sender{
    
    NSLog(@"制卡");
    
    
    if (self.dianTiList.count==0) {
        [DDProgressHUD showErrorImageWithInfo:@"抱歉，请在您被授权使用的电梯内操作"];
        return;
    }
    
    for (NSDictionary* dic1 in self.bleNameArray) {
        for (NSDictionary* dic2 in self.dianTiList) {
            
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
        self.sysDeviceDiantiCode = [self.finalArray[0] objectForKey:@"sysDeviceDiantiCode"];
        self.target = [self.sysDeviceDiantiCode substringFromIndex:self.sysDeviceDiantiCode.length - 2];
//        if (self.sendBool) {
            self.type = @"1";
//            if (self.fangChanId.length==20) {
                self.sendAllNum = [NSString stringWithFormat:@"AAFF%@06%@55",self.target,self.fangChanId];
//            }else{
//                self.sendAllNum = [NSString stringWithFormat:@"AA%@06%@55",self.target,self.fangChanId];
//            }
            [self icCardManage:self.sendAllNum];
            NSLog(@"%@",self.sendAllNum);
//        }else{
//            [DDProgressHUD showErrorImageWithInfo:@"当前控制信号弱，请靠近门禁或移步到电梯内再次出发通行按钮"];
//        }
    }else{
        [DDProgressHUD showErrorImageWithInfo:@"抱歉，请在您被授权使用的电梯内操作"];
    }
    
    
    
    
    
  
}
//删除
-(void)deleBtn:(UIButton*)sender{
    NSLog(@"删卡");
    if (self.dianTiList.count==0) {
        [DDProgressHUD showErrorImageWithInfo:@"抱歉，请在您被授权使用的电梯内操作"];
        return;
    }
    
    for (NSDictionary* dic1 in self.bleNameArray) {
        for (NSDictionary* dic2 in self.dianTiList) {
            
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
        
        self.sysDeviceDiantiCode = [self.finalArray[0] objectForKey:@"sysDeviceDiantiCode"];
        self.target = [self.sysDeviceDiantiCode substringFromIndex:self.sysDeviceDiantiCode.length - 2];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"警告，您名下所有IC卡将被删除清空掉" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消按钮被点击了");
        }];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            if (self.sendBool) {
                self.type = @"2";
//                if (self.fangChanId.length==20) {
                    self.sendAllNum = [NSString stringWithFormat:@"AAFF%@07%@55",self.target,self.fangChanId];
//                }else{
//                    self.sendAllNum = [NSString stringWithFormat:@"AA%@07%@55",self.target,self.fangChanId];
//                }
                [self icCardManage:self.sendAllNum];
                NSLog(@"%@",self.sendAllNum);
//            }else{
//                [DDProgressHUD showErrorImageWithInfo:@"当前控制信号弱，请靠近门禁或移步到电梯内再次出发通行按钮"];
//            }
        }];
        
        //修改按钮字体颜色
//        [sureAction setValue:[UIColor greenColor] forKey:@"titleTextColor"];
        
        [alertController addAction:cancelAction];
        [alertController addAction:sureAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        [DDProgressHUD showErrorImageWithInfo:@"抱歉，请在您被授权使用的电梯内操作"];
    }
    
    
    
    
    
    
   
}
//续期
-(void)postponeBtn:(UIButton*)sender{
    NSLog(@"续期");
    if (self.dianTiList.count==0) {
        [DDProgressHUD showErrorImageWithInfo:@"抱歉，请在您被授权使用的电梯内操作"];
        return;
    }
    
    for (NSDictionary* dic1 in self.bleNameArray) {
        for (NSDictionary* dic2 in self.dianTiList) {
            
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
        self.sysDeviceDiantiCode = [self.finalArray[0] objectForKey:@"sysDeviceDiantiCode"];
        self.target = [self.sysDeviceDiantiCode substringFromIndex:self.sysDeviceDiantiCode.length - 2];
//        if (self.sendBool) {
            self.type = @"3";
            self.sendAllNum = [NSString stringWithFormat:@"AAFF%@09%@55",self.target,self.fangChanId];
            [self icCardManage:self.sendAllNum];
            NSLog(@"%@",self.sendAllNum);
//        }else{
//            [DDProgressHUD showErrorImageWithInfo:@"当前控制信号弱，请靠近门禁或移步到电梯内再次出发通行按钮"];
//        }
    }else{
        [DDProgressHUD showErrorImageWithInfo:@"抱歉，请在您被授权使用的电梯内操作"];
    }
    
    
   
}


#pragma mark -- 获取时间
-(void)updateAtime{
    [DDProgressHUD show];
    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/index/updateAtime",postUrl] version:Token parameters:@{@"roomId":self.roomId,@"appUserId":[yzUserInfoModel getLoginUserInfo:@"userId"]} success:^(id object) {
        [DDProgressHUD dismiss];
        NSDictionary *json = object;
        
        if ([[json objectForKey:@"code"] intValue] == 200) {
           self.fangChanId = [json objectForKey:@"data"];
//            NSArray* arr = [str componentsSeparatedByString:@","];
//            self.postponeTime = arr[0];
//            self.fangChanId = arr[1];
            
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


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.centeralManager stopScan];
}
@end
