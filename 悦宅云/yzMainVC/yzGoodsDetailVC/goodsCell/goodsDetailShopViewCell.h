//
//  goodsDetailShopViewCell.h
//  yzProduct
//
//  Created by LiuHQ on 2018/9/21.
//  Copyright © 2018年 CC. All rights reserved.
// 详情页店铺信息

#import <UIKit/UIKit.h>
#import "yzIndexGoodsModel.h"
#import "yzIndexShopGoodsModel.h"
#import "yzIndexShopGoodDetailModel.h"
@interface goodsDetailShopViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *shopImage;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
-(void)setGoodsModel:(yzIndexGoodsModel *)model;
-(void)setShopGoodsModel:(yzIndexShopGoodDetailModel *)model;
@end
