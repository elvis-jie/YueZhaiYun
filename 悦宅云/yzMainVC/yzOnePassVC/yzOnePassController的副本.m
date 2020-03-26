//
//  yzOnePassController.m
//  yzProduct
//
//  Created by 尚广杰 on 2019/3/14.
//  Copyright © 2019 CC. All rights reserved.
//

#import "yzOnePassController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "yzOnePassCell.h"
#define SERVICE_UUID @"CDD1"
#define CHARACTERISTIC_UUID @"CDD2"
@interface yzOnePassController ()<UITableViewDelegate,UITableViewDataSource,CBPeripheralManagerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong)UITableView* tableV;
@property(nonatomic,strong)UICollectionView* collectionView;
@property(nonatomic,strong)NSArray* listArr;
@property (nonatomic, strong) CBPeripheralManager *peripheralManager;
@property (nonatomic, strong) CBMutableCharacteristic *characteristic;
@property (nonatomic) CGRect rect;

@property(nonatomic,strong)NSString* sendAllNum;     //最终发送的楼宇信息

@property(nonatomic,strong)UITextField* textField;
@end

@implementation yzOnePassController

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        //自动网格布局
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _rect = CGRectMake(0, 0, mDeviceWidth, mDeviceHeight);
        CGFloat realWi = [self fixSlitWith:_rect colCount:6 space:0];
        flowLayout.itemSize = CGSizeMake(realWi, 60);
        //网格布局
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:flowLayout];
        _collectionView.showsVerticalScrollIndicator = YES;
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        //注册cell
        [_collectionView registerClass:[yzOnePassCell class] forCellWithReuseIdentifier:@"Cell"];
        //设置数据源代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
    
}

-(UITextField*)textField{
    if (!_textField) {
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(50, mDeviceHeight - 50, mDeviceWidth - 100, 40)];
        _textField.delegate = self;
//        _textField.keyboardType = UIKeyboardType;
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.placeholder = @"输入广播时间";
        _textField.returnKeyType = UIReturnKeyDone;
    }
    return _textField;
}


//只要itemSize的width的小数点后只有1位且最小为5也就是满足1px=0.5pt这个等式。
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

-(UITableView *)tableV{
    if (!_tableV) {
        _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, mDeviceWidth, mDeviceHeight - 64) style:UITableViewStyleGrouped];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        //解决滑动视图顶部空出状态栏高度的问题
        if (@available(iOS 11.0, *)) {
            _tableV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
             self.automaticallyAdjustsScrollViewInsets = NO;
            
        }
        _tableV.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _tableV.sectionFooterHeight = 0;
        _tableV.separatorInset = UIEdgeInsetsZero;
        [self.view addSubview:self.tableV];
    }
    return _tableV;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
//    NSString *louYu = [[NSUserDefaults standardUserDefaults] objectForKey:@"louYu"];
//    NSString *danYuan = [[NSUserDefaults standardUserDefaults] objectForKey:@"danYuan"];
//    NSString *floor = [[NSUserDefaults standardUserDefaults] objectForKey:@"floor"];
//    if (louYu.length==1) {
//        louYu = [@"0" stringByAppendingString:louYu];
//    }
//    if (danYuan.length==1) {
//        danYuan = [@"0" stringByAppendingString:danYuan];
//    }
//    if (floor.length==1) {
//        floor = [@"0" stringByAppendingString:floor];
//    }
//    
//    self.sendAllNum = [NSString stringWithFormat:@"AAFF%@%@%@55",louYu,danYuan,floor];
//    NSLog(@"最终发送的楼宇信息：%@",self.sendAllNum);
    
    
    self.listArr = @[@"AAFF00010155",@"AAFF00010255",@"AAFF00010355",@"AAFF00010455",@"AAFF00010555",@"AAFF00010655",@"AAFF00010755",@"AAFF00010855",@"AAFF00010955",@"AAFF00011055",@"AAFF00011155",@"AAFF00011255",@"AAFF00011355",@"AAFF00011455",@"AAFF00011555",@"AAFF00011655",@"AAFF00011755",@"AAFF00011855",@"AAFF00011955",@"AAFF00012055",@"AAFF00012155",@"AAFF00012255",@"AAFF00012355",@"AAFF00012455"];
    
    [self.view addSubview:self.collectionView];
    
    [self.view addSubview:self.textField];
    
//    [self tableV];
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
    [titleLabel setText:@"一键通行"];
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
#pragma mark -- tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.listArr[indexPath.row]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld楼",indexPath.row+1];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self openTheDoorByNum:self.listArr[indexPath.row]];
}
#pragma mark -- collectionView
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.listArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    yzOnePassCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor orangeColor]];
    NSString* title = [NSString stringWithFormat:@"%ld 楼",indexPath.row + 1];
    [cell getTitleByString:title];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self openTheDoorByNum:self.listArr[indexPath.row]];
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
            [DDProgressHUD showSuccessImageWithInfo:@"数据发送成功"];
//            if (self.textField.text.length>0) {
                [self createTimer];
//            }
            NSLog(@"数据发送成功");
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
    
    
}

///** 中心设备读取数据的时候回调 */
//- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request {
//    // 请求中的数据，这里把文本框中的数据发给中心设备
//    request.value = [self.textField.text dataUsingEncoding:NSUTF8StringEncoding];
//    // 成功响应请求
//    [peripheral respondToRequest:request withResult:CBATTErrorSuccess];
//}
//
//
///** 中心设备写入数据的时候回调 */
//- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray<CBATTRequest *> *)requests {
//    // 写入数据的请求
//    CBATTRequest *request = requests.lastObject;
//    // 把写入的数据显示在文本框中
//    self.textField.text = [[NSString alloc] initWithData:request.value encoding:NSUTF8StringEncoding];
//}

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
    if (self.textField.text.length>0) {
        timeout = [self.textField.text intValue];
    }else{
        timeout = 2;
    }
    
    
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



-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
