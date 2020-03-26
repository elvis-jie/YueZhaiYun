//
//  orderSettleHeaderView.h
//  yzProduct
//
//  Created by LiuHQ on 2018/9/25.
//  Copyright © 2018年 CC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "yzCartGoodsModel.h"
#import "yzIndexGoodsModel.h"
#import "yzOrderDetailModel.h"
#import "yzIndexShopGoodDetailModel.h"
@interface orderSettleHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *shopLogo;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
-(void)setShopData:(yzCartGoodsModel *)model;
-(void)setShopIndexData:(yzIndexGoodsModel *)model;
-(void)setWuYeIndexData:(yzIndexShopGoodDetailModel *)model;
-(void)setGoToPayData:(yzOrderDetailModel *)model;
@end
