//
//  goodsDetailShopViewCell.m
//  yzProduct
//
//  Created by LiuHQ on 2018/9/21.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "goodsDetailShopViewCell.h"

@implementation goodsDetailShopViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setGoodsModel:(yzIndexGoodsModel *)model{
    [self.shopName setText:model.biku_store_name];
    [self.shopImage sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:FaultShopIconImg options:SDWebImageRefreshCached];
}
-(void)setShopGoodsModel:(yzIndexShopGoodDetailModel *)model{
    [self.shopName setText:model.shopName];
    [self.shopImage sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:FaultShopIconImg options:SDWebImageRefreshCached];
}

@end
