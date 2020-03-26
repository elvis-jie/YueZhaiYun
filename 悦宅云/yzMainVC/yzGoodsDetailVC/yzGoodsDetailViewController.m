//
//  yzGoodsDetailViewController.m
//  yzProduct
//
//  Created by LiuHQ on 2018/9/21.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "yzGoodsDetailViewController.h"
#import "goodsDetailPicViewCell.h" //顶部缩略图
#import "yzIndexGoodsModel.h"       //比酷商品信息
#import "yzIndexShopGoodDetailModel.h"   //物业商品信息
#import "goodsDetailInfoViewCell.h" //基础信息
#import "goodsDetailShopViewCell.h" //店铺信息
#import "goodsDetailCommentViewCell.h" //评论信息
#import "goodsDetailContentViewCell.h" //图文信息
#import "tenementListViewController.h"  //物业报修
#import "goodsDetailBottomView.h" //底部视图
#import "yzStoreViewController.h"    //店铺详情
#import "indexGoodsProductAttrView.h"
#import "yzCartViewController.h"    //购物车

#import "yzBiKuAttr.h"
#import "yzAddressModel.h" //收货地址
#import "yzOrderViewController.h"
@interface yzGoodsDetailViewController ()
@property (nonatomic, strong) yzIndexGoodsModel *goodsModel;           //比酷
@property (nonatomic, strong) yzIndexShopGoodDetailModel *shopGoodsModel;   //物业
@property (nonatomic, assign) float webcellHight;
@property (nonatomic, strong) goodsDetailBottomView *bottomView;
@property (nonatomic, strong) indexGoodsProductAttrView *productView;
@property (nonatomic, strong) yzBiKuAttr* bikuAttrModel;
@end

@implementation yzGoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.listTableView setTableFooterView:[UIView new]];
    /** 监听webviewcell的高度 */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setTableViewCellHight:)  name:@"getCellHightNotification" object:nil];
    WEAKSELF
    self.bottomView = (goodsDetailBottomView *)[[[NSBundle mainBundle] loadNibNamed:@"goodsDetailBottomView" owner:self options:nil] lastObject];
    
    [self.bottomView setGoCarBlock:^{
        yzCartViewController* cartVC = [[yzCartViewController alloc]init];
        [weakSelf.navigationController pushViewController:cartVC animated:YES];
    }];
    
    //立即购买
    [self.bottomView setToPayBlock:^{
        yzOrderViewController *settleView = [[yzOrderViewController alloc] init];
        settleView.goodsModel = weakSelf.goodsModel;
        settleView.attrModel = weakSelf.bikuAttrModel;
        settleView.type = weakSelf.type;
        [weakSelf.navigationController pushViewController:settleView animated:YES];
        
//        if ([weakSelf.type isEqualToString:@"1"]) {
//            yzOrderViewController *settleView = [[yzOrderViewController alloc] init];
//            settleView.goodsModel = weakSelf.goodsModel;
//            settleView.type = weakSelf.type;
//            [weakSelf.navigationController pushViewController:settleView animated:YES];
//        }else{
//            yzOrderViewController *settleView = [[yzOrderViewController alloc] init];
//            settleView.goodsModel = weakSelf.goodsModel;
//            settleView.attrModel = weakSelf.bikuAttrModel;
//            settleView.type = weakSelf.type;
//            [weakSelf.navigationController pushViewController:settleView animated:YES];
//        }
        
    }];
    //加入购物车
    [self.bottomView setAddCartBlock:^{
        WEAKSELF
       if (self.goodsModel.have_attr) {
           //打开规格选择
           [UIView animateWithDuration:0.5f animations:^{
               
               self.productView.frame = CGRectMake(0, 0, mDeviceWidth, mDeviceHeight);
               [self.productView.goodsNumber setText:@"1"];
          
               
               [self.productView setAddGoodsCartBlock:^(NSString* goods_id, NSString *attr_id, NSString *count) {
                   [weakSelf addGoodsCart:goods_id attrId:attr_id count:count];
               }];
           } completion:^(BOOL finished) {
               [self.productView setGoodsInfoModel:self.model];
               [self.productView getGoodsAttr:[NSString stringWithFormat:@"%d",self.goodsModel.biku_goods_id]];
               self.productView.backgroundColor = RGBA(0, 0, 0, 0.4);
           }];
       }else{
           [self addGoodsCart:[NSString stringWithFormat:@"%d",self.goodsModel.biku_goods_id] attrId:@"" count:@"1"];
       }
 
        
    }];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.listTableView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottomMargin);
    }];
    
    [self getGoodsDetail];

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
    [titleLabel setText:@"商品详情"];
    [titleLabel setFrame:CGRectMake(0, 0, mDeviceWidth/2, NavTopHeight)];
    [titleLabel setFont:[UIFont fontWithName:@"HYJinChangTiJ" size:18]];
    [titleLabel setTextColor:RGB(22, 22, 22)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.navigationController.visibleViewController.navigationItem setTitleView:titleLabel];
    
    [self.navigationController.visibleViewController.navigationItem setRightBarButtonItem:nil];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
}
//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:{
//            if ([self.type isEqualToString:@"1"]) {
//                return self.shopGoodsModel.goodsUrl.length>0?1:0;
//            }else{
            return self.goodsModel.biku_goods_img1.length>0?1:0;
//            }
            break;
        }
        case 1:
        case 2:
        case 3:
            return 1;
        default:
            return 1;
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return mDeviceWidth;
            break;
        case 1:
            return 70;
            break;
        case 2:
            return 49;
            break;
        case 3:
            return 48;
            break;
        default:
            return self.webcellHight;
            break;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            {
                goodsDetailPicViewCell *picCell = [tableView dequeueReusableCellWithIdentifier:@"goodsDetailPicViewCell"];
                if (!picCell) {
                   picCell = (goodsDetailPicViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"goodsDetailPicViewCell" owner:self options:nil] lastObject];
                }
                   NSMutableArray *picArray = [[NSMutableArray alloc] init];
//                if ([self.type isEqualToString:@"1"]) {
//                    if (self.shopGoodsModel.goodsUrl.length > 0) {
//                        [picArray addObject:self.shopGoodsModel.goodsUrl];
//                    }
//                }else{
                //拼顶部图
             
                if (self.goodsModel.biku_goods_img1.length > 0) {
                    [picArray addObject:self.goodsModel.biku_goods_img1];
                }
                if (self.goodsModel.biku_goods_img2.length > 0) {
                    [picArray addObject:self.goodsModel.biku_goods_img2];
                }
                if (self.goodsModel.biku_goods_img3.length > 0) {
                    [picArray addObject:self.goodsModel.biku_goods_img3];
                }
//                }
                [picCell setAdModel:picArray];
                [picCell setSelectionStyle:UITableViewCellSelectionStyleNone];
                
                return picCell;
            }
            
            break;
        case 1:{
            goodsDetailInfoViewCell *picCell = [tableView dequeueReusableCellWithIdentifier:@"goodsDetailInfoViewCell"];
            if (!picCell) {
                picCell = (goodsDetailInfoViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"goodsDetailInfoViewCell" owner:self options:nil] lastObject];
            }
//            if ([self.type isEqualToString:@"1"]) {
//                [picCell setShopGoodsData:self.shopGoodsModel];
//            }else{
            [picCell setGoodsData:self.goodsModel];
//            }
            [picCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return picCell;
        }
            break;
        case 2:{
            goodsDetailShopViewCell *picCell = [tableView dequeueReusableCellWithIdentifier:@"goodsDetailShopViewCell"];
            if (!picCell) {
                picCell = (goodsDetailShopViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"goodsDetailShopViewCell" owner:self options:nil] lastObject];
            }
//            if ([self.type isEqualToString:@"1"]) {
//                [picCell setShopGoodsModel:self.shopGoodsModel];
//            }else{
            [picCell setGoodsModel:self.goodsModel];
//            }
            [picCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return picCell;
        }
            break;
        case 3:{
            goodsDetailCommentViewCell *comCell = [tableView dequeueReusableCellWithIdentifier:@"goodsDetailCommentViewCell"];
            if (!comCell) {
                comCell = (goodsDetailCommentViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"goodsDetailCommentViewCell" owner:self options:nil] lastObject];
            }
            [comCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return comCell;
        }
        default:{
            goodsDetailContentViewCell *conCell = [tableView dequeueReusableCellWithIdentifier:@"goodsDetailContentViewCell"];
            if (!conCell) {
                conCell = (goodsDetailContentViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"goodsDetailContentViewCell" owner:self options:nil] lastObject];
            }
//            if ([self.type isEqualToString:@"1"]) {
//
//            }else{
            
            if (![self.goodsModel.biku_goods_info isEqualToString:@""]) {
                 [conCell setDetailHtml:[yzProductPubObject addHtmlString:self.goodsModel.biku_goods_info]];
            }
            
           
//            }
            [conCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return conCell;
        }
            
            break;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==2) {
        yzStoreViewController* storeVC = [[yzStoreViewController alloc]init];
        storeVC.goodsModel = self.goodsModel;
        [self.navigationController pushViewController:storeVC animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)backClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setTableViewCellHight:(NSNotification *)info
{
    NSDictionary * dic=info.userInfo;
    //判断通知中的参数是否与原来的值一致,防止死循环
    if (self.webcellHight != [[dic objectForKey:@"height"]floatValue])
    {
        self.webcellHight=[[dic objectForKey:@"height"]floatValue];
        [self.listTableView reloadData];
    }
}
-(yzIndexGoodsModel *)goodsModel{
    if (!_goodsModel) {
        _goodsModel = [[yzIndexGoodsModel alloc] init];
    }
    return _goodsModel;
}
/** 获取详情 */
-(void)getGoodsDetail{
    [DDProgressHUD show];

    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/biku/getGoods",postUrl] version:Token parameters:@{@"bikuGoodsId":self.model.goodsId,@"userId":[yzUserInfoModel getLoginUserInfo:@"userId"]} success:^(id object) {
        NSDictionary *json = object;
        
        if ([[json objectForKey:@"code"] intValue] == 200) {
            [DDProgressHUD dismiss];
            NSDictionary *detail = [[json objectForKey:@"data"] JSONValue];
            
            self.goodsModel = [[yzIndexGoodsModel alloc] init:detail];
            
            self.bottomView.cartNum.text = [NSString stringWithFormat:@"%d",self.goodsModel.biku_store_count];
            self.bottomView.cartPrice.text = [NSString stringWithFormat:@"%.2f",self.goodsModel.biku_store_allPrice/100];
            
//            if (self.goodsModel.have_attr) {
                [self getBiKuList];
//            }
        }else if ([[json objectForKey:@"code"] intValue] == -6){
            [DDProgressHUD dismiss];
            [yzUserInfoModel userLoginOut];
            [yzUserInfoModel setLoginState:NO];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
        }else{
            [DDProgressHUD showErrorImageWithInfo:[json objectForKey:@"message"]];
        }
        [self.listTableView reloadData];
    } failure:^(NSError *error) {
        
    }];

 
}

//比酷商品列表
-(void)getBiKuList{
    [CCAFNetWork get:[NSString stringWithFormat:@"%@app/biku/listHomeGoodsAttr",postUrl] version:Token parameters:@{@"bikuGoodsId":[NSString stringWithFormat:@"%d",self.goodsModel.biku_goods_id]} success:^(id object) {
        
        NSDictionary *json = object;
        
        NSArray *detail = [[json objectForKey:@"data"] JSONValue];
        if ([[json objectForKey:@"code"] intValue] == 200) {
            if (detail.count>0) {
                self.bikuAttrModel = [[yzBiKuAttr alloc] init:detail[0]];
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
        [DDProgressHUD showErrorImageWithInfo:error.localizedDescription];
    }];
}



/**加入购物车 */
-(void)addGoodsCart:(NSString*)goods_id attrId:(NSString *)attr_id count:(NSString *)count{
    [DDProgressHUD show];
    [CCAFNetWork post:[NSString stringWithFormat:@"%@app/biku/saveShoppingCar",postUrl] version:Token parameters:@{@"goodId":goods_id,@"attrId":attr_id,@"count":count,@"userId":[yzUserInfoModel getLoginUserInfo:@"userId"]} success:^(id object) {
        [DDProgressHUD dismiss];
        NSDictionary *json = object;
        if ([[json objectForKey:@"code"] intValue] == 200) {
            [DDProgressHUD showSuccessImageWithInfo:[json objectForKey:@"message"]];
            
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
@end
