//
//  goodsDetailBottomView.m
//  yzProduct
//
//  Created by LiuHQ on 2018/9/21.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "goodsDetailBottomView.h"

@implementation goodsDetailBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)addCartClick:(id)sender {
    if (self.addCartBlock) {
        self.addCartBlock();
    }
}

- (IBAction)toPayClick:(id)sender {
    if (self.toPayBlock) {
        self.toPayBlock();
    }
}

- (IBAction)goCarClick:(id)sender {
    if (self.goCarBlock) {
        self.goCarBlock();
    }
}

@end
