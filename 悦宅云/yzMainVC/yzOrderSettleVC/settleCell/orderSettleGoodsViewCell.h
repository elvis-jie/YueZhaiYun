//
//  orderSettleGoodsViewCell.h
//  yzProduct
//
//  Created by LiuHQ on 2018/9/25.
//  Copyright © 2018年 CC. All rights reserved.
// 订单结算产品cell

#import <UIKit/UIKit.h>
#import "yzCartGoodsModel.h"
#import "yzIndexGoodsModel.h"
#import "yzOrderDetailModel.h"
#import "yzIndexShopGoodDetailModel.h"   //物业商品信息
@interface orderSettleGoodsViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
@property (weak, nonatomic) IBOutlet UILabel *goodsNumber;
-(void)setGoodsInfoData:(yzCartShopGoodsModel *)model;
-(void)setShopGoodsInfoData:(yzIndexShopGoodDetailModel *)model;
-(void)setGoodInfoData:(yzIndexGoodsModel *)model;
-(void)setGoToPayData:(yzOrderDetailModel *)model;
@end
