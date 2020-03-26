//
//  GoodsSpecCollectCell.m
//  LemonTree
//
//  Created by LiuHQ on 2018/7/26.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "GoodsSpecCollectCell.h"

@implementation GoodsSpecCollectCell
-(void)setAttrModel:(yzIndexGoodsAttrModel *)model{
    self.specValueLable.text = model.biku_goods_attr_name;
    if (model.isSelected) {
        [self.specValueLable setBackgroundColor:AppButtonColor];
        [self.specValueLable setTextColor:[UIColor whiteColor]];
    }else{
        [self.specValueLable setBackgroundColor:RGBA(238, 238, 238, 1)];
        [self.specValueLable setTextColor:RGBA(102, 102, 102, 1)];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
