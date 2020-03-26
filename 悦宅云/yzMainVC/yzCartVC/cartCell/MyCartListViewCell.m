//
//  MyCartListViewCell.m
//  tjcclzShopC
//
//  Created by LiuHQ on 2018/5/10.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "MyCartListViewCell.h"

@implementation MyCartListViewCell

-(void)setGoodsInfoData:(yzCartShopGoodsModel *)model{
    self.goodsInfoModel = model;
    self.selectedBtn.selected = model.checked;
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:model.biku_goods_img1] placeholderImage:FaultGoodsImg options:SDWebImageHandleCookies];
    self.goodsName.text = model.biku_goods_name;
    self.goodsDesc.text = model.biku_goods_attr_name;
    self.goodsPrice.text = [NSString stringWithFormat:@"￥%.2f",model.biku_goods_shop_price/100];
    [self.goodsMarketPrice setText:[NSString stringWithFormat:@"￥%.2f",model.biku_goods_market_price/100]];
    //中划线
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:self.goodsMarketPrice.text attributes:attribtDic];
    self.goodsMarketPrice.attributedText = attribtStr;
    self.goodsNum.text = [NSString stringWithFormat:@"%d",model.biku_goods_count];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/** 减少数量事件 */
- (IBAction)subtractClick:(id)sender{

    if (self.goodsJianBlock) {
        self.goodsJianBlock(self.goodsInfoModel);
    }
}
/** 增加数量事件 */
- (IBAction)addClick:(id)sender{

    self.goodsInfoModel.biku_goods_count ++;
    if (self.goodsAddBlock) {
        self.goodsAddBlock(self.goodsInfoModel);
    }
}
/** 选中与未选中 */
-(IBAction)selectedClick:(id)sender{
    if (self.goodsCheckBlock) {
        self.goodsCheckBlock(self.goodsInfoModel);
    }
    
}
@end
