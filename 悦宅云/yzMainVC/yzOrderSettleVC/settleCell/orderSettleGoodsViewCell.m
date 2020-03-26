//
//  orderSettleGoodsViewCell.m
//  yzProduct
//
//  Created by LiuHQ on 2018/9/25.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "orderSettleGoodsViewCell.h"

@implementation orderSettleGoodsViewCell
-(void)setGoodInfoData:(yzIndexGoodsModel *)model{
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:model.biku_goods_img1] placeholderImage:FaultGoodsImg options:SDWebImageHandleCookies];
    self.goodsName.text = model.biku_goods_name;
    self.goodsPrice.text = [NSString stringWithFormat:@"￥%.2f",model.biku_goods_shop_price/100];
    self.goodsNumber.text = [NSString stringWithFormat:@"x1"];
}

-(void)setShopGoodsInfoData:(yzIndexShopGoodDetailModel *)model{
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:model.goodsUrl] placeholderImage:FaultGoodsImg options:SDWebImageHandleCookies];
    self.goodsName.text = model.goodsName;
    self.goodsPrice.text = [NSString stringWithFormat:@"￥%.2f",model.goodsPrice/100];
    self.goodsNumber.text = [NSString stringWithFormat:@"x1"];
}


-(void)setGoodsInfoData:(yzCartShopGoodsModel *)model{
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:model.biku_goods_img1] placeholderImage:FaultGoodsImg options:SDWebImageHandleCookies];
    self.goodsName.text = model.biku_goods_name;
    self.goodsPrice.text = [NSString stringWithFormat:@"￥%.2f",model.biku_goods_shop_price/100];
    self.goodsNumber.text = [NSString stringWithFormat:@"x%d",model.biku_goods_count];
}
-(void)setGoToPayData:(yzOrderDetailModel *)model{
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:model.biku_goods_img1] placeholderImage:FaultGoodsImg options:SDWebImageHandleCookies];
    self.goodsName.text = model.biku_goods_name;
    self.goodsPrice.text = [NSString stringWithFormat:@"￥%.2f",[model.biku_goods_price floatValue]/100];
    self.goodsNumber.text = [NSString stringWithFormat:@"x%@",model.biku_goods_count];
}
@end
