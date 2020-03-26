//
//  OrderSettlePayTypeCell.m
//  tjcclzShopC
//
//  Created by LiuHQ on 2018/5/15.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "OrderSettlePayTypeCell.h"

@implementation OrderSettlePayTypeCell

//- (void)setFrame:(CGRect)frame {
//    frame.origin.x += 15;
//    frame.size.width -= 2 * 15;
//    [super setFrame:frame];
//}


-(void)setSettlePayModel:(yzSettlePayModel *)payModel{
    [self.payImg setImage:[UIImage imageNamed:payModel.pay_img]];
    self.payName.text = payModel.pay_name;
    if (payModel.isSelected) {
        [self.payIsSelected setImage:[UIImage imageNamed:@"tjcclz_cart_circle_selected_pre"]];
    }else{
        [self.payIsSelected setImage:[UIImage imageNamed:@"tjcclz_cart_circle_selected_nor"]];
    }
    
}


@end
