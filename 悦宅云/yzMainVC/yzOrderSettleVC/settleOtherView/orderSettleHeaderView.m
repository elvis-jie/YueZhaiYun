//
//  orderSettleHeaderView.m
//  yzProduct
//
//  Created by LiuHQ on 2018/9/25.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "orderSettleHeaderView.h"

@implementation orderSettleHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setShopData:(yzCartGoodsModel *)model{
    [self.shopLogo sd_setImageWithURL:[NSURL URLWithString:model.biku_store_img] placeholderImage:FaultShopIconImg options:SDWebImageRefreshCached];
    [self.shopName setText:model.biku_store_name];
}
-(void)setShopIndexData:(yzIndexGoodsModel *)model{
    [self.shopLogo sd_setImageWithURL:[NSURL URLWithString:model.biku_store_logo] placeholderImage:FaultShopIconImg options:SDWebImageRefreshCached];
    [self.shopName setText:model.biku_store_name];
}
-(void)setWuYeIndexData:(yzIndexShopGoodDetailModel *)model{
    [self.shopLogo sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:FaultShopIconImg options:SDWebImageRefreshCached];
    [self.shopName setText:model.shopName];
}


-(void)setGoToPayData:(yzOrderDetailModel *)model{
    [self.shopLogo sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:FaultShopIconImg options:SDWebImageRefreshCached];
    [self.shopName setText:model.biku_store_name];
}
@end
