//
//  MyCartListHeaderView.h
//  tjcclzShopC
//
//  Created by LiuHQ on 2018/5/10.
//  Copyright © 2018年 CC. All rights reserved.
// 购物车列表header

#import <UIKit/UIKit.h>
#import "yzCartGoodsModel.h"

@protocol MyCartListHeaderViewDelegate<NSObject>
/** 选择 */
-(void)headerSelectedBlock:(yzCartGoodsModel *)model;
/** 进入店铺 */
-(void)headerToShopInfo:(int)shopId;
@end

@interface MyCartListHeaderView : UIView
@property (nonatomic, assign) id<MyCartListHeaderViewDelegate>delegate;
-(instancetype)initWithFrame:(CGRect)frame;

/**
 设置数据

 @param shopModel 数据
 */
-(void)setCartShopInfo:(yzCartGoodsModel *)shopModel;// isSelected:(BOOL)isSelected indexSection:(NSInteger)indexSection;
@end
