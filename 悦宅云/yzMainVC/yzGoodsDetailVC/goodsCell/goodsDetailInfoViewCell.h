//
//  goodsDetailInfoViewCell.h
//  yzProduct
//
//  Created by LiuHQ on 2018/9/21.
//  Copyright © 2018年 CC. All rights reserved.
// 详情页产品基础信息

#import <UIKit/UIKit.h>
#import "yzIndexGoodsModel.h"
#import "yzIndexShopGoodsModel.h"
#import "yzIndexShopGoodDetailModel.h"
@interface goodsDetailInfoViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
@property (weak, nonatomic) IBOutlet UILabel *goodsMarketPrice;
-(void)setGoodsData:(yzIndexGoodsModel *)model;
-(void)setShopGoodsData:(yzIndexShopGoodDetailModel *)model;
@end
