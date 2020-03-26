//
//  orderSettleAmountViewCell.m
//  yzProduct
//
//  Created by LiuHQ on 2018/9/25.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "orderSettleAmountViewCell.h"

@implementation orderSettleAmountViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setGoodsAmouData:(yzIndexGoodsModel *)model{
     [self.goodsAmount setText:[NSString stringWithFormat:@"￥%.2f",model.biku_goods_shop_price/100]];
}
-(void)setGoodsAmountData:(yzCartCountModel *)model{
    [self.goodsAmount setText:[NSString stringWithFormat:@"￥%.2f",model.price/100]];
}
-(void)setGoodsPrice:(float)price{
    [self.goodsAmount setText:[NSString stringWithFormat:@"￥%.2f",price/100]];
}

-(void)setShopGoodsAmouData:(yzIndexShopGoodDetailModel *)model{
    [self.goodsAmount setText:[NSString stringWithFormat:@"￥%.2f",model.goodsPrice/100]];
}
@end
