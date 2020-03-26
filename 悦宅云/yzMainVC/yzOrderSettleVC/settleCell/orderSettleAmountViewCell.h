//
//  orderSettleAmountViewCell.h
//  yzProduct
//
//  Created by LiuHQ on 2018/9/25.
//  Copyright © 2018年 CC. All rights reserved.
// 结算产品总计cell

#import <UIKit/UIKit.h>
#import "yzCartGoodsModel.h"
#import "yzIndexGoodsModel.h"
#import "yzIndexShopGoodDetailModel.h"   //物业商品信息
@interface orderSettleAmountViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *goodsAmount;
-(void)setGoodsAmountData:(yzCartCountModel *)model;
-(void)setGoodsAmouData:(yzIndexGoodsModel *)model;
-(void)setShopGoodsAmouData:(yzIndexShopGoodDetailModel *)model;
-(void)setGoodsPrice:(float)price;
@end
