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
#import "yzSearchViewController.h"
#import "yzOneUpViewController.h"
#define SERVICE_UUID @"CDD1"
#define CHARACTERISTIC_UUID @"CDD2"
@interface yzOnePassController ()<CBPeripheralManagerDelegate,CBCentralManagerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>
//@property(nonatomic,strong)UITableView* tableV;
@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) NSArray* listArr;
@property (nonatomic, strong) CBPeripheralManager *peripheralManager;
@property (nonatomic, strong) CBMutableCharacteristic *characteristic;
@property (nonatomic, strong) CBCentralManager* centeralManager;
@property (nonatomic) CGRect rect;

@property (nonatomic, strong) NSString* sendAllNum;     //最终发送的楼宇信息
@property (nonatomic, strong) NSString* temp2;          //搜到的广播数据
@property (nonatomic, assign) int floor;

@property (nonatomic, strong) UIButton* btn1;           //删卡
@property (nonatomic, strong) UIButton* btn2;           //制卡

@property (nonatomic, strong) NSMutableArray* bleNameArray;    //搜索到的蓝牙数组
@property (nonatomic, strong) NSMutableArray* finalArray;
//@property(nonatomic,strong)UITextField* textField;

@property (nonatomic,strong) NSString* type;             //1  添卡  2  删卡 
@property (nonatomic,strong) NSString* dianTiId;

//@property (nonatomic,assign) BOOL sendBool;              //是否发送消息

@property (nonatomic, strong) NSString* holidayStr;            //板子广播信息是否是节假日
@property (nonatomic, strong) NSString* scanType;    //0  打开扫一次   1  点击扫描   2  不提示
@property (nonatomic, assign) BOOL scan;
@property (nonatomic, strong) NSString* sysDeviceDiantiCode;

@property (nonatomic, strong) NSString* target;      //目标指令   电梯名称后两位
@property (nonatomic, strong) NSString* verify1;      //校验码时间校验
@property (nonatomic, strong) NSString* verify2;      //校验码l开门校验
@property (nonatomic, strong) NSString* tiDoor;      //判断是电梯还是门

@property (nonatomic,strong) NSString* year;         //年
@property (nonatomic,strong) NSString* mouth;        //月
@property (nonatomic,strong) NSString* day;          //日
@property (nonatomic,strong) NSString* hour;         //时
@property (nonatomic,strong) NSString* minute;       //分
@property (nonatomic,strong) NSString* second;       //秒
@property (nonatomic,strong) NSString* week;         //周几
@property (nonatomic,strong) NSString* sendAll;

@property (nonatomic,strong) UIButton* addHoliday;   //添加节假日
@property (nonatomic,strong) UIButton* delHoliday;   //删除节假日
@property (nonatomic,strong) UIButton* timeVerify;   //时间校验
@property (nonatomic,strong) UIButton* addPersonCard;   //添加业主制卡
@property (nonatomic,strong) UIButton* uploadPerson;   //上传用户信息

@end

@implementation yzOnePassController

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        //自动网格布局
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _rect = CGRectMake(0, 0, mDeviceWidth, mDeviceHeight - kSaveBottomSpace); //-60
        CGFloat realWi = [self fixSlitWith:_rect colCount:6 space:0];
        flowLayout.itemSize = CGSizeMake(realWi, 60);
        //网格布局
        _collectionView = [[UICollectionView alloc]initWithFrame:_rect collectionViewLayout:flowLayout];
        _collectionView.showsVerticalScrollIndicator = YES;
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        //注册cell
        [_collectionView registerClass:[yzOnePassCell class] forCellWithReuseIdentifier:@"Cell"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
        //设置footerView大小
//        if (![self.roleId isEqualToString:@"admin"]) {
//           flowLayout.footerReferenceSize = CGSizeMake(mDeviceWidth, mDeviceWidth/2  +100);
//        }
        [_collectionView setBackgroundColor:[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1]];
        //设置数据源代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
    
}

//-(UITextField*)textField{
//    if (!_textField) {
//        _textField = [[UITextField alloc]initWithFrame:CGRectMake(50, mDeviceHeight - 50, mDeviceWidth - 100, 40)];
//        _textField.delegate = self;
//        _textField.keyboardType = UIKeyboardType;
//        _textField.borderStyle = UITextBorderStyleRoundedRect;
//        _textField.placeholder = @"输入广播时间";
//        _textField.returnKeyType = UIReturnKeyDone;
//    }
//    return _textField;
//}


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

//-(UITableView *)tableV{
//    if (!_tableV) {
//        _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, mDeviceWidth, mDeviceHeight - 64) style:UITableViewStyleGrouped];
//        _tableV.delegate = self;
//        _tableV.dataSource = self;
//        //解决滑动视图顶部空出状态栏高度的问题
//        if (@available(iOS 11.0, *)) {
//            _tableV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        } else {
//             self.automaticallyAdjustsScrollViewInsets = NO;
//
//        }
//        _tableV.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
//        _tableV.sectionFooterHeight = 0;
//        _tableV.separatorInset = UIEdgeInsetsZero;
//        [self.view addSubview:self.tableV];
//    }
//    return _tableV;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.bleNameArray = [NSMutableArray array];
    self.finalArray = [NSMutableArray array];
    self.floor = 1;
    self.sendAllNum = @"AAFF009999999999999999010055";
//    self.sendBool = NO;
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
    
    
//    self.listArr = @[@"AAFF00010155",@"AAFF00010255",@"AAFF00010355",@"AAFF00010455",@"AAFF00010555",@"AAFF00010655",@"AAFF00010755",@"AAFF00010855",@"AAFF00010955",@"AAFF00011055",@"AAFF00011155",@"AAFF00011255",@"AAFF00011355",@"AAFF00011455",@"AAFF00011555",@"AAFF00011655",@"AAFF00011755",@"AAFF00011855",@"AAFF00011955",@"AAFF00012055",@"AAFF00012155",@"AAFF00012255",@"AAFF00012355",@"AAFF00012455"];
    
    [self.view addSubview:self.collectionView];
    
    
    //删卡
//    self.btn1 = [[UIButton alloc]initWithFrame:CGRectMake(10, mDeviceHeight - 50 - kSaveBottomSpace, mDeviceWidth/2 - 20, 40)];
//    [self.btn1 setTitle:@"删卡" forState:UIControlStateNormal];
//    [self.btn1 setBackgroundColor:[UIColor orangeColor]];
//    if ([self.roleId isEqualToString:@"admin"]) {
//        self.btn1.userInteractionEnabled = YES;
//    }else{
//        self.btn1.userInteractionEnabled = NO;
//    }
//    [self.btn1 addTarget:self action:@selector(deleCard:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.btn1];
    //制卡
//    self.btn2 = [[UIButton alloc]initWithFrame:CGRectMake(mDeviceWidth/2 + 10, mDeviceHeight - 50 - kSaveBottomSpace, mDeviceWidth/2 - 20, 40)];
//    [self.btn2 setTitle:@"制卡" forState:UIControlStateNormal];
//    [self.btn2 setBackgroundColor:[UIColor orangeColor]];
//    if ([self.roleId isEqualToString:@"admin"]) {
//        self.btn2.userInteractionEnabled = YES;
//    }else{
//        self.btn2.userInteractionEnabled = NO;
//    }
//    [self.btn2 addTarget:self action:@selector(addCard:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.btn2];
    
//    [self.view addSubview:self.textField];
    
//    [self tableV];
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

#pragma mark -- collectionView
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 48;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    yzOnePassCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor orangeColor]];
    NSString* title;
    if (indexPath.row<9) {
        title = [NSString stringWithFormat:@"0%ld楼",indexPath.row+1];
    }else{
        title = [NSString stringWithFormat:@"%ld楼",indexPath.row+1];
    }
  
    [cell getTitleByString:title];
    return cell;
}

#pragma mark - 视图内容

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    // 视图添加到 UICollectionReusableView 创建的对象中
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        
        if ([self.roleId isEqualToString:@"admin"]) {
            if (!self.addHoliday) {
                //添加节假日
                self.addHoliday = [[UIButton alloc]initWithFrame:CGRectMake(15, 35, (mDeviceWidth - 50)/2, 50)];
                [self.addHoliday setTitle:@"开启节假日" forState:UIControlStateNormal];
                self.addHoliday.titleLabel.font = YSize(15.0);
                [self.addHoliday setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                self.addHoliday.layer.cornerRadius = 5;
                [self.addHoliday setBackgroundColor:[UIColor whiteColor]];
                // 阴影颜色
                self.addHoliday.layer.shadowColor = [UIColor blackColor].CGColor;
                // 阴影偏移量 默认为(0,3)
                self.addHoliday.layer.shadowOffset = CGSizeZero;
                // 阴影透明度
                self.addHoliday.layer.shadowOpacity = 0.7;
                [self.addHoliday addTarget:self action:@selector(addHoliday:) forControlEvents:UIControlEventTouchUpInside];
                [headerView addSubview:self.addHoliday];
            }
            if (!self.delHoliday) {
                //取消节假日
                self.delHoliday = [[UIButton alloc]initWithFrame:CGRectMake(35 + (mDeviceWidth - 50)/2, 35, (mDeviceWidth - 50)/2, 50)];
                [self.delHoliday setTitle:@"关闭节假日" forState:UIControlStateNormal];
                self.delHoliday.titleLabel.font = YSize(15.0);
                [self.delHoliday setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                self.delHoliday.layer.cornerRadius = 5;
                [self.delHoliday setBackgroundColor:[UIColor whiteColor]];
                // 阴影颜色
                self.delHoliday.layer.shadowColor = [UIColor blackColor].CGColor;
                // 阴影偏移量 默认为(0,3)
                self.delHoliday.layer.shadowOffset = CGSizeZero;
                // 阴影透明度
                self.delHoliday.layer.shadowOpacity = 0.7;
                [self.delHoliday addTarget:self action:@selector(delHoliday:) forControlEvents:UIControlEventTouchUpInside];
                [headerView addSubview:self.delHoliday];
            }
            
            if (!self.timeVerify) {
                //时间校验
                self.timeVerify = [[UIButton alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.addHoliday.frame) + 35, mDeviceWidth - 30, 50)];
                [self.timeVerify setTitle:@"时钟信息校验" forState:UIControlStateNormal];
                self.timeVerify.titleLabel.font = YSize(15.0);
                [self.timeVerify setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                self.timeVerify.layer.cornerRadius = 5;
                [self.timeVerify setBackgroundColor:[UIColor whiteColor]];
                // 阴影颜色
                self.timeVerify.layer.shadowColor = [UIColor blackColor].CGColor;
                // 阴影偏移量 默认为(0,3)
                self.timeVerify.layer.shadowOffset = CGSizeZero;
                // 阴影透明度
                self.timeVerify.layer.shadowOpacity = 0.7;
                [self.timeVerify addTarget:self action:@selector(timeVerify:) forControlEvents:UIControlEventTouchUpInside];
                [headerView addSubview:self.timeVerify];
            }
            
            
            if (!self.uploadPerson) {
                //上传用户信息
                self.uploadPerson = [[UIButton alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.timeVerify.frame) + 35, mDeviceWidth - 30, 50)];
                [self.uploadPerson setTitle:@"上传用户信息" forState:UIControlStateNormal];
                self.uploadPerson.titleLabel.font = YSize(15.0);
                [self.uploadPerson setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                self.uploadPerson.layer.cornerRadius = 5;
                [self.uploadPerson setBackgroundColor:[UIColor whiteColor]];
                // 阴影颜色
                self.uploadPerson.layer.shadowColor = [UIColor blackColor].CGColor;
                // 阴影偏移量 默认为(0,3)
                self.uploadPerson.layer.shadowOffset = CGSizeZero;
                // 阴影透明度
                self.uploadPerson.layer.shadowOpacity = 0.7;
                [self.uploadPerson addTarget:self action:@selector(uploadPerson:) forControlEvents:UIControlEventTouchUpInside];
                [headerView addSubview:self.uploadPerson];
            }
            
            
            if (!self.addPersonCard) {
                //给业主制卡
                self.addPersonCard = [[UIButton alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.uploadPerson.frame) + 35, mDeviceWidth - 30, 50)];
                [self.addPersonCard setTitle:@"添加业主IC卡" forState:UIControlStateNormal];
                self.addPersonCard.titleLabel.font = YSize(15.0);
                [self.addPersonCard setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                self.addPersonCard.layer.cornerRadius = 5;
                [self.addPersonCard setBackgroundColor:[UIColor whiteColor]];
                // 阴影颜色
                self.addPersonCard.layer.shadowColor = [UIColor blackColor].CGColor;
                // 阴影偏移量 默认为(0,3)
                self.addPersonCard.layer.shadowOffset = CGSizeZero;
                // 阴影透明度
                self.addPersonCard.layer.shadowOpacity = 0.7;
                [self.addPersonCard addTarget:self action:@selector(addPersonCard:) forControlEvents:UIControlEventTouchUpInside];
                [headerView addSubview:self.addPersonCard];
            }
            
            
            if (!self.btn2) {
                //添加IC
                self.btn2 = [[UIButton alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.addPersonCard.frame) + 35, mDeviceWidth - 30, mDeviceWidth/2)];
                self.btn2.layer.cornerRadius = 5;
                [self.btn2 setBackgroundColor:[UIColor whiteColor]];
                [self.btn2 addTarget:self action:@selector(addCard:) forControlEvents:UIControlEventTouchUpInside];
                // 阴影颜色
                self.btn2.layer.shadowColor = [UIColor blackColor].CGColor;
                // 阴影偏移量 默认为(0,3)
                self.btn2.layer.shadowOffset = CGSizeZero;
                // 阴影透明度
                self.btn2.layer.shadowOpacity = 0.7;
                //        [self.btn2 addTarget:self action:@selector(addIC:) forControlEvents:UIControlEventTouchUpInside];
                
                [headerView addSubview:self.btn2];
                
                
                UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake((mDeviceWidth - 30)/2 - 30, 20, 60, 60)];
                imageView.image = [UIImage imageNamed:@"addIC"];
                [self.btn2 addSubview:imageView];
                
                UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, mDeviceWidth/2 - 60, mDeviceWidth - 50, 18)];
                titleLabel.text = @"添加物业IC卡";
                titleLabel.textAlignment = NSTextAlignmentCenter;
                titleLabel.font = YSize(15.0);
                [self.btn2 addSubview:titleLabel];
                
                UILabel* contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, mDeviceWidth/2 - 35, mDeviceWidth - 50, 18)];
                contentLabel.text = @"点击添加，灯绿后，将IC卡贴近读写器";
                contentLabel.textAlignment = NSTextAlignmentCenter;
                contentLabel.font = YSize(13.0);
                [self.btn2 addSubview:contentLabel];
            }
            
            
            if (!self.btn1) {
                //删除
                
                self.btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.btn2.frame) + 40, mDeviceWidth, 44)];
                [self.btn1 setBackgroundColor:[UIColor whiteColor]];
                [self.btn1 setTitle:@"删除物业IC卡" forState:UIControlStateNormal];
                [self.btn1 setTitleColor:[UIColor colorWithRed:217/255.0 green:23/255.0 blue:24/255.0 alpha:1] forState:UIControlStateNormal];
                self.btn1.titleLabel.font = YSize(15.0);
                [self.btn1 addTarget:self action:@selector(deleCard:) forControlEvents:UIControlEventTouchUpInside];
                [headerView addSubview:self.btn1];
            }
            
            
        }
        
        
        return headerView;
        
    }else {
        return nil;
    }
}
//footer的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    if ([self.roleId isEqualToString:@"admin"]) {
        return CGSizeMake(mDeviceWidth, mDeviceWidth/2 + 174 + 65*2 + 85 * 2);
    }else
        return CGSizeZero;
    
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

 
  
    for (NSDictionary* dic1 in self.bleNameArray) {
        for (NSDictionary* dic2 in self.dianTi) {
            
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
        self.holidayStr = [self.finalArray[0] objectForKey:@"holiday"];
        self.dianTiId = [self.finalArray[0] objectForKey:@"id"];
        self.sysDeviceDiantiCode = [self.finalArray[0] objectForKey:@"sysDeviceDiantiCode"];
        self.tiDoor = [self.sysDeviceDiantiCode substringWithRange:NSMakeRange(self.sysDeviceDiantiCode.length - 2,1)];
        self.target = [self.sysDeviceDiantiCode substringFromIndex:self.sysDeviceDiantiCode.length - 2];
        self.floor = indexPath.row + 1;
        int final = 0.0;
        NSMutableArray* allArr = [NSMutableArray array];
        //        [allArr addObject:self.code];
        NSString* floorStr;
        
        floorStr = [NSString stringWithFormat:@"%@%d",self.autoonly,self.floor];
        
        
        
        for (int i = 0; i<floorStr.length;i++) {
            [allArr addObject:[floorStr substringWithRange:NSMakeRange(i, 1)]];
        }
        for (NSString* count in allArr) {
            final += [count intValue];
        }
        NSString* finalStr = [NSString stringWithFormat:@"%d",final];
        if (final<10) {
            self.verify2 = [NSString stringWithFormat:@"0%d",final];
        }else if (final>=10&&final<=99){
            self.verify2 = [NSString stringWithFormat:@"%d",final];
        }else{
            self.verify2 = [finalStr substringFromIndex:finalStr.length - 2];
        }
     
        
        if ([self.tiDoor isEqualToString:@"F"]) {
            self.sendAllNum = [NSString stringWithFormat:@"AAFF%@00000000%@000055",self.target,self.autoonly];
            
        }else{
            if (self.floor<10) {
                self.sendAllNum = [NSString stringWithFormat:@"AAFF%@0A000000%@0%d%@55",self.target,self.autoHexString,self.floor,self.verify2];
            }else{
                self.sendAllNum = [NSString stringWithFormat:@"AAFF%@0A000000%@%d%@55",self.target,self.autoHexString,self.floor,self.verify2];
            }
        }
        self.type = @"3";
        [self openTheDoorByNum:self.sendAllNum isScan:YES];
        
       

//        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
//        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//            self.type = @"7";
//            [self openTheDoorByNum:timeV isScan:YES];
//        });
        
//        NSString* timeV = [NSString stringWithFormat:@"AAFF%@%@",self.target,[self getTime]];
//
//        NSLog(@"时间校验==%@",timeV);
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            self.type = @"7";
//            [self openTheDoorByNum:timeV isScan:YES];
//
//        });
        
     
        
        
        
        
    }else{
        [DDProgressHUD showErrorImageWithInfo:@"当前控制信号弱，未能成功开启，请靠近门禁或移步到电梯内再次触发通行按钮"];
    }
    
    
    
  

    
    
//    self.floor = indexPath.row + 1;
//    if (self.floor<10) {
//        self.sendAllNum = [NSString stringWithFormat:@"AAFF0099999999999999990%d9955",self.floor];
//    }else{
//        self.sendAllNum = [NSString stringWithFormat:@"AAFF009999999999999999%d9955",self.floor];
//    }
//    [self openTheDoorByNum:self.sendAllNum isScan:NO];

}

-(void)openTheDoorByNum:(NSString*)str isScan:(BOOL)isScan{

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

            if ([self.type isEqualToString:@"1"]) {
                [DDProgressHUD showSuccessImageWithInfo:@"制卡成功"];
                 [self createTimer];
            }else if([self.type isEqualToString:@"2"]){
                [DDProgressHUD showSuccessImageWithInfo:@"删卡成功"];
                 [self createTimer];
            }else if([self.type isEqualToString:@"3"]){
                [DDProgressHUD showSuccessImageWithInfo:@"开门成功"];
                 [self createTimer];

            }else if ([self.type isEqualToString:@"4"]){
                [DDProgressHUD showSuccessImageWithInfo:@"节假日设置成功"];
                 [self createTimer];
            }else if ([self.type isEqualToString:@"5"]){
                [DDProgressHUD showSuccessImageWithInfo:@"节假日取消成功"];
                 [self createTimer];
            }else{

                [DDProgressHUD showSuccessImageWithInfo:@"发送成功"];
                [self createTimer];
            }
            
       
           
            
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
    NSLog(@"发现设备：%@ 信号: %ld",peripheral.name,(long)[RSSI intValue]);//,advertisementData[@"kCBAdvDataManufacturerData"]
    
    

  
    if ([BBUserData stringChangeNull:peripheral.name replaceWith:@""].length>0) {
        if ([RSSI intValue] > -95) {
            NSString* str = [NSString stringWithFormat:@"%@",advertisementData[@"kCBAdvDataManufacturerData"]];
            NSLog(@"==%@",advertisementData[@"kCBAdvDataManufacturerData"]);
            str = [BBUserData stringChangeNull:str replaceWith:@""];
            if (str.length>0) {
                str = [str stringByReplacingOccurrencesOfString:@"<" withString:@""];
                str = [str stringByReplacingOccurrencesOfString:@">" withString:@""];
                str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
                str = [str substringWithRange:NSMakeRange(5, 1)];
            }
            NSDictionary* dic = @{@"name":peripheral.name,@"rssi":@([RSSI intValue]),@"holiday":str};
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
            self.scan = YES;
        }
//    else{
//            self.sendBool = NO;
//        }


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

#pragma mark -- 设置、删除节假日
-(void)addHoliday:(UIButton*)sender{
    if (self.dianTi.count==0) {
        [DDProgressHUD showErrorImageWithInfo:@"抱歉，请在您被授权使用的电梯内操作"];
        return;
    }
    
    for (NSDictionary* dic1 in self.bleNameArray) {
        for (NSDictionary* dic2 in self.dianTi) {
            
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
        if (self.bleNameArray.count>0) {
  
            self.sysDeviceDiantiCode = [self.finalArray[0] objectForKey:@"name"];
            self.target = [self.sysDeviceDiantiCode substringFromIndex:self.sysDeviceDiantiCode.length - 2];
  
 
            self.sendAllNum = [NSString stringWithFormat:@"AAFF%@0500000000000000000055",self.target];
            self.type = @"4";
            [self openTheDoorByNum:self.sendAllNum isScan:YES];
            
      
        }else{
            [DDProgressHUD showErrorImageWithInfo:@"抱歉，请在您被授权使用的电梯内操作"];
        }
    }else{
        [DDProgressHUD showErrorImageWithInfo:@"抱歉，请在您被授权使用的电梯内操作"];
    }
    
}
-(void)delHoliday:(UIButton*)sender{
    if (self.dianTi.count==0) {
        [DDProgressHUD showErrorImageWithInfo:@"抱歉，请在您被授权使用的电梯内操作"];
        return;
    }
    
    for (NSDictionary* dic1 in self.bleNameArray) {
        for (NSDictionary* dic2 in self.dianTi) {
            
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
        if (self.bleNameArray.count>0) {
            
            self.sysDeviceDiantiCode = [self.finalArray[0] objectForKey:@"name"];
            self.target = [self.sysDeviceDiantiCode substringFromIndex:self.sysDeviceDiantiCode.length - 2];
            
            
            self.sendAllNum = [NSString stringWithFormat:@"AAFF%@0100000000000000000055",self.target];
            self.type = @"5";
            [self openTheDoorByNum:self.sendAllNum isScan:YES];
            
        }else{
            [DDProgressHUD showErrorImageWithInfo:@"抱歉，请在您被授权使用的电梯内操作"];
        }
    }else{
        [DDProgressHUD showErrorImageWithInfo:@"抱歉，请在您被授权使用的电梯内操作"];
    }
}

#pragma mark -- 时间校验
-(void)timeVerify:(UIButton*)sender{
    if (self.dianTi.count==0) {
        [DDProgressHUD showErrorImageWithInfo:@"抱歉，请在您被授权使用的电梯内操作"];
        return;
    }
    
    for (NSDictionary* dic1 in self.bleNameArray) {
        for (NSDictionary* dic2 in self.dianTi) {
            
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
        if (self.bleNameArray.count>0) {
            
            self.sysDeviceDiantiCode = [self.finalArray[0] objectForKey:@"name"];
            self.target = [self.sysDeviceDiantiCode substringFromIndex:self.sysDeviceDiantiCode.length - 2];
            
         
            NSString* timeV = [NSString stringWithFormat:@"AAFF%@%@",self.target,[self getTimeWithTime:self.midTime]];
            
            
            self.type = @"7";
            
            [self openTheDoorByNum:timeV isScan:YES];
      
            
        }else{
            [DDProgressHUD showErrorImageWithInfo:@"抱歉，请在您被授权使用的电梯内操作"];
        }
    }else{
        [DDProgressHUD showErrorImageWithInfo:@"抱歉，请在您被授权使用的电梯内操作"];
    }
}


#pragma mark -- 上传用户信息
-(void)uploadPerson:(UIButton*)sender{
    yzOneUpViewController* oneUpVC = [[yzOneUpViewController alloc]init];
    oneUpVC.xiaoQuId = self.quId;
    [self.navigationController pushViewController:oneUpVC animated:YES];
}
#pragma mark -- 给业主制卡
-(void)addPersonCard:(UIButton*)sender{
    yzSearchViewController* searchVC = [[yzSearchViewController alloc]init];
    searchVC.quId = self.quId;
    [self.centeralManager stopScan];
    [self.navigationController pushViewController:searchVC animated:YES];
}


#pragma mark -- 制卡删卡
-(void)deleCard:(UIButton*)sender{
    
    if (self.dianTi.count==0) {
        [DDProgressHUD showErrorImageWithInfo:@"抱歉，请在您被授权使用的电梯内操作"];
        return;
    }
    
    for (NSDictionary* dic1 in self.bleNameArray) {
        for (NSDictionary* dic2 in self.dianTi) {
            
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
        self.sysDeviceDiantiCode = [self.finalArray[0] objectForKey:@"name"];
        self.target = [self.sysDeviceDiantiCode substringFromIndex:self.sysDeviceDiantiCode.length - 2];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"警告，您名下所有IC卡将被删除清空掉" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消按钮被点击了");
        }];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            if (self.sendBool) {
                self.type = @"2";
                
                int code = [self.code intValue];
                if (code<10) {
                    self.sendAllNum = [NSString stringWithFormat:@"AAFF%@0D000000%@000%@55",self.target,self.autoHexString,self.code];
                }else{
                    self.sendAllNum = [NSString stringWithFormat:@"AAFF%@0D000000%@00%@55",self.target,self.autoHexString,self.code];
                }
                
                
                [self openTheDoorByNum:self.sendAllNum isScan:YES];
//            }else{
//                [DDProgressHUD showErrorImageWithInfo:@"当前控制信号弱，未能成功开启，请靠近门禁或移步到电梯内再次触发通行按钮"];
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
-(void)addCard:(UIButton*)sender{
    
    if (self.dianTi.count==0) {
        [DDProgressHUD showErrorImageWithInfo:@"抱歉，请在您被授权使用的电梯内操作"];
        return;
    }
    
    for (NSDictionary* dic1 in self.bleNameArray) {
        for (NSDictionary* dic2 in self.dianTi) {
            
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
        if (self.bleNameArray.count>0) {
//            if (self.sendBool) {
                self.sysDeviceDiantiCode = [self.finalArray[0] objectForKey:@"name"];
                self.target = [self.sysDeviceDiantiCode substringFromIndex:self.sysDeviceDiantiCode.length - 2];
                self.type = @"1";
                int code = [self.code intValue];
                if (code<10) {
                     self.sendAllNum = [NSString stringWithFormat:@"AAFF%@0C000000%@000%@55",self.target,self.autoHexString,self.code];
                }else{
                     self.sendAllNum = [NSString stringWithFormat:@"AAFF%@0C000000%@00%@55",self.target,self.autoHexString,self.code];
                }
               
                [self openTheDoorByNum:self.sendAllNum isScan:YES];
//            }else{
//                [DDProgressHUD showErrorImageWithInfo:@"当前控制信号弱，未能成功开启，请靠近门禁或移步到电梯内再次触发通行按钮"];
//            }
        }else{
            [DDProgressHUD showErrorImageWithInfo:@"抱歉，请在您被授权使用的电梯内操作"];
        }
    }else{
        [DDProgressHUD showErrorImageWithInfo:@"抱歉，请在您被授权使用的电梯内操作"];
    }
    
    
    
    
    
    
  
}

#pragma mark -- 是否是节假日
-(void)getHoliday{
    
  
    
    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/device/isholiday",postUrl] version:Token parameters:@{@"deviceId":self.dianTiId} success:^(id object) {
        if ([[object objectForKey:@"code"] intValue]== 200) {
            BOOL isHoliday = [[object objectForKey:@"data"] boolValue];
            if (isHoliday==YES&&[self.holidayStr isEqualToString:@"0"]) {
                self.sendAllNum = [NSString stringWithFormat:@"AAFF0500%@000055",self.sysDeviceDiantiCode];
                [self openTheDoorByNum:self.sendAllNum isScan:YES];
            }else if(isHoliday==NO&&[self.holidayStr isEqualToString:@"1"]){
                //08  取消节假日标志
                self.sendAllNum = [NSString stringWithFormat:@"AAFF0F00%@000055",self.sysDeviceDiantiCode];

                [self openTheDoorByNum:self.sendAllNum isScan:YES];
            }
        

        }
    } failure:^(NSError *error) {

    }];
    
}
//时间戳变为格式时间
- (NSString *)ConvertStrToTime:(NSString *)timeStr

{
    
//    long long time=[timeStr longLongValue];
    //    如果服务器返回的是13位字符串，需要除以1000，否则显示不正确(13位其实代表的是毫秒，需要除以1000)
        long long time=[timeStr longLongValue] / 1000;
    
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:time];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString*timeString=[formatter stringFromDate:date];
    
    return timeString;
    
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
    

    NSInteger finalTime = [timeSp integerValue] + self.midTime;

    
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

//字符串转16进制
- (NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if ([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
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
