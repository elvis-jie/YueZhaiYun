//
//  goodsDetailInfoViewCell.m
//  yzProduct
//
//  Created by LiuHQ on 2018/9/21.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "goodsDetailInfoViewCell.h"

@implementation goodsDetailInfoViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setGoodsData:(yzIndexGoodsModel *)model{
    [self.goodsName setText:model.biku_goods_name];
    [self.goodsPrice setText:[NSString stringWithFormat:@"￥%.2f",model.biku_goods_shop_price/100]];
    [self.goodsMarketPrice setText:[NSString stringWithFormat:@"￥%.2f",model.biku_goods_market_price/100]];
    //中划线
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:self.goodsMarketPrice.text attributes:attribtDic];
    self.goodsMarketPrice.attributedText = attribtStr;
}
-(void)setShopGoodsData:(yzIndexShopGoodDetailModel *)model{
    [self.goodsName setText:model.goodsName];
    [self.goodsPrice setText:[NSString stringWithFormat:@"￥%.2f",model.goodsPrice/100]];
    [self.goodsMarketPrice setText:[NSString stringWithFormat:@"￥%.2f",model.goodsMarketPrice/100]];
    //中划线
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:self.goodsMarketPrice.text attributes:attribtDic];
    self.goodsMarketPrice.attributedText = attribtStr;
}

@end
