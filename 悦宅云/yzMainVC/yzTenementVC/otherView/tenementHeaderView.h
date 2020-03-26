//
//  tenementHeaderView.h
//  yzProduct
//
//  Created by LiuHQ on 2018/9/27.
//  Copyright © 2018年 CC. All rights reserved.
// 列表headview

#import <UIKit/UIKit.h>
#import "tenementClassModel.h"

@interface tenementHeaderView : UIView
@property (nonatomic, copy)void(^typeClickBlock)(NSString *currentIndex);
-(void)setStateClassArray:(NSMutableArray *)array;
@property(nonatomic,strong)UILabel* line;
@end
