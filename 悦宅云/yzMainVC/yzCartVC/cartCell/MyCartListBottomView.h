//
//  MyCartListBottomView.h
//  tjcclzShopC
//
//  Created by LiuHQ on 2018/5/10.
//  Copyright © 2018年 CC. All rights reserved.
// 我的购物车底部结算按钮

#import <UIKit/UIKit.h>
#import "yzCartGoodsModel.h"


@interface MyCartListBottomView : UIView
-(instancetype)initWithFrame:(CGRect)frame;
-(void)setCartTotalInfo:(yzCartCountModel *)model;
@property (nonatomic, copy)void(^cartGoodsSelectedBlock)(yzCartCountModel *model);
@property (nonatomic, copy)void(^cartGotoPayBlock)(void);
@end
