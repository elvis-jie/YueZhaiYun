//
//  yzSearchViewController.m
//  悦宅云
//
//  Created by 尚广杰 on 2019/12/25.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import "yzSearchViewController.h"
#import "yzSearchCell.h"
#import <CoreBluetooth/CoreBluetooth.h>

#define SERVICE_UUID @"CDD1"
#define CHARACTERISTIC_UUID @"CDD2"
@interface yzSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,CBPeripheralManagerDelegate>
@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)NSMutableArray* lists;    //搜索的列表
@property(nonatomic,strong)UITextField* textField;   //输入框
@property(nonatomic,strong)UIButton* makeCard;       //制卡按钮

@property (nonatomic, strong) CBPeripheralManager *peripheralManager;
@property (nonatomic, strong) CBMutableCharacteristic *characteristic;
@end

@implementation yzSearchViewController
-(UITableView*)tableV{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, mDeviceWidth, mDeviceHeight - KSAFEBAR_HEIGHT - kNavBarHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //解决滑动视图顶部空出状态栏高度的问题
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
            
        }
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 2;
        [self.view addSubview:self.tableView];
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
   
    
    [self tableV];
    self.tableView.hidden = YES;
    
    [self getRoomList];
    
    // 创建外设管理器，会回调peripheralManagerDidUpdateState方法
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self setStatusBarBackgroundColor:RGBA(255, 255, 255, 1)];
    [self.navigationController.navigationBar setBackgroundColor:RGBA(255, 255, 255, 1)];
    
    //输入框
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(70, kSaveTopSpace + 14, mDeviceWidth - 140, 36)];
    self.textField.placeholder = @"请输入房间号";
    self.textField.text = @"";
    self.textField.delegate = self;
    self.textField.font = YSize(15.0);
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.tintColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];

    [self.navigationController.visibleViewController.navigationItem setTitleView:self.textField];
    
    
    //左侧返回
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"blackBack"] forState:UIControlStateNormal];
    [backBtn setBackgroundColor:[UIColor clearColor]];
    [backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setTitleColor:AppBackTitleColor forState:UIControlStateNormal];
    [backBtn setFrame:CGRectMake(0, 0, AutoWitdh(32), AutoWitdh(32))];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationController.visibleViewController.navigationItem setLeftBarButtonItem:backItem];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchBtn setBackgroundColor:RGB(223, 15, 15)];
    searchBtn.titleLabel.font = YSize(15.0);
    [searchBtn addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchBtn setFrame:CGRectMake(0, 0, AutoWitdh(50), AutoWitdh(32))];
    searchBtn.layer.cornerRadius = 5.0;
    searchBtn.layer.masksToBounds = YES;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    [self.navigationController.visibleViewController.navigationItem setRightBarButtonItem:rightItem];
    
  
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


#pragma mark -- tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.lists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    yzSearchCell* cell = [[yzSearchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    if (self.lists.count>0) {
        [cell getTitleByDic:self.lists[indexPath.row]];
    }
    cell.makeCard.tag = indexPath.row;
    [cell.makeCard addTarget:self action:@selector(makeCard:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
#pragma mark -- 蓝牙部分
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
#pragma mark -- 搜索
-(void)search:(UIButton*)sender{
    
    
    [self getRoomList];
    
    [self.textField resignFirstResponder];
}

#pragma mark -- 数据请求
-(void)getRoomList{
    
    [DDProgressHUD show];
    [CCAFNetWork post:[NSString stringWithFormat:@"%@prouser/searchRoom",postUrl] version:Token parameters:@{@"xiaoquId":self.quId,@"p":self.textField.text.length>0 ? self.textField.text : @""} success:^(id object) {
         self.lists = [NSMutableArray array];
        NSDictionary *json = object;
        if ([[json objectForKey:@"code"] intValue] == 200) {
            [DDProgressHUD dismiss];
            
            self.lists = [json objectForKey:@"data"];
            if (self.lists.count>0) {
                self.tableView.hidden = NO;
            
            }else{
                self.tableView.hidden = YES;
                [DDProgressHUD showSuccessImageWithInfo:@"暂无数据"];
            }
            [self.tableView reloadData];
            
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

#pragma mark -- 制卡
-(void)makeCard:(UIButton*)sender{
    
    NSDictionary* dic = self.lists[sender.tag];
    NSString* sendNum = [BBUserData stringChangeNull:[dic objectForKey:@"code"] replaceWith:@""];
    if (sendNum.length>0) {
        [self openTheDoorByNum:sendNum];
    }else{
        [DDProgressHUD showErrorImageWithInfo:@"该房间所在单元暂未绑定电梯"];
    }
    
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

            [DDProgressHUD showSuccessImageWithInfo:@"制卡成功"];
            [self createTimer];
        }else {
            [DDProgressHUD showErrorImageWithInfo:@"制卡失败"];
            [self createTimer];
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
@end
