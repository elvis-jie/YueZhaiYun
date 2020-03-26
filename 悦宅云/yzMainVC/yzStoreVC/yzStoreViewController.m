//
//  yzStoreViewController.m
//  悦宅云
//
//  Created by 尚广杰 on 2019/4/22.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import "yzStoreViewController.h"
#import "yzRightCell.h"
#import "yzIndexShopGoodsModel.h"
#import "indexGoodsProductAttrView.h"
#import "yzCartViewController.h"
#import "yzOrderSettleViewController.h"
#import "yzGoodsDetailViewController.h" //产品详情
@interface yzStoreViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView* leftTableV;
@property(nonatomic,strong)UITableView* rightTableV;

@property(nonatomic,strong)NSArray* leftArr;
@property(nonatomic,strong)NSMutableArray* rightArr;

@property (nonatomic, strong) indexGoodsProductAttrView *productView;
@property(nonatomic,strong)UIImageView* advertImage;   //顶部广告图
@property(nonatomic,strong)UILabel* nameLabel;
@property(nonatomic,strong)UIView* backView;
@property(nonatomic,strong)UIView* bottomView;
@property(nonatomic,strong)UIButton* goCarBtn;         //购物车按钮
@property(nonatomic,strong)UILabel* allMoneyLab;       //总价格
@property(nonatomic,strong)UIButton* goPayBtn;         //去结算
@property(nonatomic,strong)NSDictionary* dic;          //总价格和个数
@property(nonatomic,strong)UILabel* countLabel;        //购物车右上角数量

@property(nonatomic,assign)BOOL isfinish;
@property(nonatomic,assign)int pageNum;
@property(nonatomic,strong)NSString* goodType;
@end

@implementation yzStoreViewController
-(indexGoodsProductAttrView *)productView{
    if (!_productView) {
        _productView = [[indexGoodsProductAttrView alloc] initWithFrame:CGRectMake(0, mDeviceHeight, mDeviceWidth, mDeviceHeight)];
        [_productView setBackgroundColor:RGBA(0, 0, 0, 0)];
        
    
            self.automaticallyAdjustsScrollViewInsets = NO;
            
        
        
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
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.dic = [[NSDictionary alloc]init];
    self.rightArr = [NSMutableArray array];
    [self setUI];
    
    [self getPublicData];
    
    
    self.pageNum = 1;
    
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
        [self getStoreData];
        dispatch_semaphore_signal(semaphore);
    });
    
  
    
}
    


-(void)getStoreData{
    [DDProgressHUD show];
    self.leftArr = [NSArray array];
    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/biku/getTypes",postUrl] version:Token parameters:@{@"storeId":[NSString stringWithFormat:@"%d",self.goodsModel.biku_store_id]} success:^(id object) {
        NSDictionary *json = object;
        
        if ([[json objectForKey:@"code"] intValue] == 200) {
            [DDProgressHUD dismiss];
            self.leftArr = [json objectForKey:@"data"];
            if (self.leftArr.count>0) {
                self.goodType = self.leftArr[0][@"goodsTypeCode"];
                [self getDetailListByTypeCode:self.goodType];
           
            }
           
            [DDProgressHUD showSuccessImageWithInfo:[json objectForKey:@"message"]];
        }else if ([[json objectForKey:@"code"] intValue] == -6){
            [DDProgressHUD dismiss];
            [yzUserInfoModel userLoginOut];
            [yzUserInfoModel setLoginState:NO];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
            
        }else{
            [DDProgressHUD showSuccessImageWithInfo:[json objectForKey:@"message"]];
        }
        [self.leftTableV reloadData];
    } failure:^(NSError *error) {
        
    }];
}
//右边列表
-(void)getDetailListByTypeCode:(NSString*)TypeCode{
//    self.rightArr = [NSMutableArray array];
    [CCAFNetWork get:[NSString stringWithFormat:@"%@app/biku/listGoods",postUrl] version:Token parameters:@{@"goodsTypeId":TypeCode,@"page":@(self.pageNum),@"size":@(10)} success:^(id object) {
        NSDictionary *json = object;
        
        if ([[json objectForKey:@"code"] intValue] == 200) {
            NSMutableArray* goods = [json objectForKey:@"data"];
            
            for (int i = 0; i < goods.count; i ++) {
                yzIndexShopGoodsModel *model = [[yzIndexShopGoodsModel alloc] init:goods[i]];
                [self.rightArr addObject:model];
            }
            self.isfinish = YES;
            
//            [DDProgressHUD showSuccessImageWithInfo:[json objectForKey:@"message"]];
        }else if ([[json objectForKey:@"code"] intValue] == -6){
            [DDProgressHUD dismiss];
            [yzUserInfoModel userLoginOut];
            [yzUserInfoModel setLoginState:NO];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
            
        }else{
//            [DDProgressHUD showSuccessImageWithInfo:[json objectForKey:@"message"]];
        }
        [self.rightTableV reloadData];
    } failure:^(NSError *error) {
//        [DDProgressHUD showErrorImageWithInfo:[json objectForKey:@"message"]];
    }];
}

-(void)getMoney{

    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/biku/getShopCarCount",postUrl] version:Token parameters:@{@"userId":[yzUserInfoModel getLoginUserInfo:@"userId"]} success:^(id object) {
        NSDictionary *json = object;
        
        if ([[json objectForKey:@"code"] intValue] == 200) {
            self.dic = [json objectForKey:@"data"];
            
            self.allMoneyLab.text = [NSString stringWithFormat:@"￥%.2f",[self.dic[@"price"] floatValue]/100];
            self.countLabel.text = [NSString stringWithFormat:@"%@",self.dic[@"count"]];
        }else if ([[json objectForKey:@"code"] intValue] == -6){
            [DDProgressHUD dismiss];
            [yzUserInfoModel userLoginOut];
            [yzUserInfoModel setLoginState:NO];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
        }else{
            [DDProgressHUD showSuccessImageWithInfo:[json objectForKey:@"message"]];
        }
        [self.rightTableV reloadData];
    } failure:^(NSError *error) {
        
    }];
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
    
    [backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn.titleLabel setFont:[UIFont fontWithName:@"HYJinChangTiJ" size:16]];
    [backBtn setTitleColor:AppBackTitleColor forState:UIControlStateNormal];
    [backBtn setFrame:CGRectMake(0, 0, AutoWitdh(32), AutoWitdh(32))];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationController.visibleViewController.navigationItem setLeftBarButtonItem:backItem];
    
    //顶部信息
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setText:@"悦宅云店铺"];
    [titleLabel setFrame:CGRectMake(0, 0, mDeviceWidth/2, NavTopHeight)];
    [titleLabel setFont:[UIFont fontWithName:@"HYJinChangTiJ" size:18]];
    [titleLabel setTextColor:RGB(22, 22, 22)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.navigationController.visibleViewController.navigationItem setTitleView:titleLabel];
    
    [self.navigationController.visibleViewController.navigationItem setRightBarButtonItem:nil];
    
    //创建信号量
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(2);
    // 创建全局并行
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //任务 获取产品详细信息
    dispatch_async(quene, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        [self getMoney];
        dispatch_semaphore_signal(semaphore);
    });
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

#pragma mark -- 布局
-(void)setUI{
    self.advertImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, mDeviceWidth, mDeviceWidth/75*26)];
    self.advertImage.image = [UIImage imageNamed:@"timg"];
    [self.view addSubview:self.advertImage];
    
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(5, mDeviceWidth/75*26 - 50 + kNavBarHeight, mDeviceWidth - 10, mDeviceHeight - (mDeviceWidth/75*26 - 50) - KSAFEBAR_HEIGHT - kNavBarHeight - 50)];
    [self.backView setBackgroundColor:[UIColor whiteColor]];
    self.backView.layer.cornerRadius = 5;
    [self.view addSubview:self.backView];
    
    UIImageView* logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, -30, 60, 60)];
    logoImage.image = [UIImage imageNamed:@"1024"];
    [self.backView addSubview:logoImage];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 20, self.backView.frame.size.width - 85, 20)];
//    nameLabel.text = @"悦宅云官方旗舰店";
    self.nameLabel.font = YSize(15.0);
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.backView addSubview:self.nameLabel];
    
    UILabel* contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, CGRectGetMaxY(self.nameLabel.frame), self.nameLabel.frame.size.width, 15)];
    contentLabel.text = @"专业冷链配送 即刻享悦美好生活";
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.font = YSize(13.0);
    contentLabel.textColor = [UIColor lightGrayColor];
    [self.backView addSubview:contentLabel];
    
    
    self.leftTableV = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(contentLabel.frame) + 15, self.backView.frame.size.width/4, self.backView.frame.size.height - 70) style:UITableViewStylePlain];
    self.leftTableV.delegate = self;
    self.leftTableV.dataSource = self;
    self.leftTableV.separatorStyle = UITableViewCellSelectionStyleNone;
    self.leftTableV.separatorInset = UIEdgeInsetsZero;
    [self.backView addSubview:self.leftTableV];
    
    self.rightTableV = [[UITableView alloc]initWithFrame:CGRectMake(self.backView.frame.size.width/4, CGRectGetMaxY(contentLabel.frame) + 15, self.backView.frame.size.width/4*3, self.backView.frame.size.height - 70) style:UITableViewStylePlain];
    self.rightTableV.delegate = self;
    self.rightTableV.dataSource = self;
    self.rightTableV.separatorStyle = UITableViewCellSelectionStyleNone;
    self.rightTableV.separatorInset = UIEdgeInsetsZero;
    [self.backView addSubview:self.rightTableV];
    
    
    if (@available(iOS 11.0, *)) {
        self.leftTableV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.leftTableV.estimatedSectionHeaderHeight = 0;
        self.leftTableV.estimatedSectionFooterHeight = 0;
        
        self.rightTableV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.rightTableV.estimatedSectionHeaderHeight = 0;
        self.rightTableV.estimatedSectionFooterHeight = 0;
        
    } else {
        if([UIViewController instancesRespondToSelector:@selector(edgesForExtendedLayout)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        
    }
    
    //底部视图
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, mDeviceHeight - KSAFEBAR_HEIGHT - 50, mDeviceWidth, 50)];
//    self.bottomView.backgroundColor = [UIColor whiteColor];
//    self.bottomView.layer.shadowColor = [UIColor blackColor].CGColor;
//    // 阴影偏移，默认(0, -3)
//    self.bottomView.layer.shadowOffset = CGSizeMake(0,0);
//    // 阴影透明度，默认0
//    self.bottomView.layer.shadowOpacity = 0.5;
//    // 阴影半径，默认3
//    self.bottomView.layer.shadowRadius = 4;
    [self.view addSubview:self.bottomView];
    
    //购物车按钮
    self.goCarBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, -20, 50, 50)];
    [self.goCarBtn setImage:[UIImage imageNamed:@"购物车"] forState:UIControlStateNormal];
    [self.goCarBtn setAdjustsImageWhenHighlighted:NO];
    [self.goCarBtn addTarget:self action:@selector(goCarBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.goCarBtn];
    
    self.countLabel = [[UILabel alloc]initWithFrame:CGRectMake(42, 5, 16, 16)];
    self.countLabel.text = @"0";
    self.countLabel.textColor = [UIColor whiteColor];
    self.countLabel.font = YSize(10);
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    self.countLabel.backgroundColor = RGB(225, 26, 0);
    self.countLabel.layer.cornerRadius = 8;
    self.countLabel.layer.masksToBounds = YES;
    [self.goCarBtn addSubview:self.countLabel];
    
    //总价格
    self.allMoneyLab = [[UILabel alloc]initWithFrame:CGRectMake(70, 0, 120, 50)];
    self.allMoneyLab.textColor = [UIColor redColor];
    self.allMoneyLab.text = @"￥0.0";
    
    self.allMoneyLab.textAlignment = NSTextAlignmentLeft;
    self.allMoneyLab.font = YSize(14.0);
    
    [self.bottomView addSubview:self.allMoneyLab];
    
    //结算
    self.goPayBtn = [[UIButton alloc]initWithFrame:CGRectMake(mDeviceWidth - 120, 0, 120, 50)];
    [self.goPayBtn setTitle:@"去结算" forState:UIControlStateNormal];
    [self.goPayBtn setBackgroundColor:[UIColor redColor]];
    self.goPayBtn.titleLabel.font = YSize(14.0);
    [self.goPayBtn addTarget:self action:@selector(goPayBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.goPayBtn];
    
}





-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==self.leftTableV) {
        return self.leftArr.count;
    }else
        return self.rightArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.leftTableV) {
        static NSString* identifire = @"Cell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifire];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifire];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%@",self.leftArr[indexPath.row][@"goodsType"]];
        self.nameLabel.text = [NSString stringWithFormat:@"%@",self.leftArr[indexPath.row][@"bikuStore"][@"biku_store_name"]];
        cell.backgroundColor = RGB(247, 243, 243);
        cell.textLabel.font = YSize(13.0);
        
        return cell;
    }else if (tableView==self.rightTableV){

        yzRightCell* cell = [[yzRightCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.rightArr.count>0) {
            yzIndexShopGoodsModel* model = self.rightArr[indexPath.row];
            [cell getMessageBymodel:model];
        }
       
        UIButton* btn = cell.addBtn;
        btn.tag = indexPath.row;
        [btn addTarget:self action:@selector(addBtn:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
    return nil;
   
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.leftTableV) {
        self.goodType = self.leftArr[indexPath.row][@"goodsTypeCode"];
         [self getDetailListByTypeCode:self.goodType];
    }else{
        yzGoodsDetailViewController* detailVC = [[yzGoodsDetailViewController alloc]init];
        yzIndexShopGoodsModel* model = self.rightArr[indexPath.row];
        if (model.have_attr) {
            detailVC.type = @"2";
        }else{
            detailVC.type = @"1";
        }
        detailVC.model = model;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.rightTableV) {
        return 100;
    }
    return 44;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    if (row == self.rightArr.count - 2 && self.isfinish) {
        //dataArray是存放数据的数组，isfinish是请求是否完成的标识
        self.pageNum++;//第几页
        [self getDetailListByTypeCode:self.goodType];
    }
}

#pragma mark -- 加入购物车
-(void)addBtn:(UIButton*)sender{
    yzIndexShopGoodsModel *model = self.rightArr[sender.tag];
    WEAKSELF
    if (model.have_attr) {
        //打开规格选择
        [UIView animateWithDuration:0.5f animations:^{
            
            self.productView.frame = CGRectMake(0, 0, mDeviceWidth, mDeviceHeight);
            [self.productView.goodsNumber setText:@"1"];
            
            
            [self.productView setAddGoodsCartBlock:^(NSString* goods_id, NSString *attr_id, NSString *count) {
                [weakSelf addGoodsCart:goods_id attrId:attr_id count:count];
            }];
        } completion:^(BOOL finished) {
            [self.productView setGoodsInfoModel:model];
            [self.productView getGoodsAttr:model.goodsId];
            self.productView.backgroundColor = RGBA(0, 0, 0, 0.4);
        }];
    }else{
        [self addGoodsCart:model.goodsId attrId:@"" count:@"1"];
        
    }
}
#pragma mark -- 去购物车
-(void)goCarBtn:(UIButton*)sender{
    yzCartViewController* cartVC = [[yzCartViewController alloc]init];
    [self.navigationController pushViewController:cartVC animated:YES];
}

//去结算
-(void)goPayBtn:(UIButton*)sender{
    WEAKSELF
    yzOrderSettleViewController *settleView = [[yzOrderSettleViewController alloc] init];
    [settleView setCartViewRefreshBlock:^{
        [weakSelf getMoney];
    }];
    [self.navigationController pushViewController:settleView animated:YES];
}

/**加入购物车 */

-(void)addGoodsCart:(NSString*)goods_id attrId:(NSString *)attr_id count:(NSString *)count{
    [DDProgressHUD show];
    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/biku/saveShoppingCar",postUrl] version:Token parameters:@{@"goodId":goods_id,@"attrId":attr_id,@"count":count,@"userId":[yzUserInfoModel getLoginUserInfo:@"userId"]} success:^(id object) {
        //        [yzUserInfoModel getLoginUserInfo:@"userId"]
        [DDProgressHUD dismiss];
        NSDictionary *json = object;
        if ([[json objectForKey:@"code"] intValue] == 200) {
            [self getMoney];
            [DDProgressHUD showSuccessImageWithInfo:[json objectForKey:@"message"]];
            if (attr_id.length>0) {
                //关闭视图
                [self.productView closeClick:nil];
            }
            
        }else if ([[json objectForKey:@"code"] intValue] == -6){
            [DDProgressHUD dismiss];
            [yzUserInfoModel userLoginOut];
            [yzUserInfoModel setLoginState:NO];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
        }else{
            [DDProgressHUD showSuccessImageWithInfo:[json objectForKey:@"message"]];
        }
        
    } failure:^(NSError *error) {
        [DDProgressHUD showErrorImageWithInfo:error.localizedDescription];
    }];
}



@end
