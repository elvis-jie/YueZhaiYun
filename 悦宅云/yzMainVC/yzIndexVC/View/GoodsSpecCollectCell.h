//
//  GoodsSpecCollectCell.h
//  LemonTree
//
//  Created by LiuHQ on 2018/7/26.
//  Copyright © 2018年 CC. All rights reserved.
// 产品规格CollectCell

#import <UIKit/UIKit.h>
#import "yzIndexGoodsAttrModel.h"

@interface GoodsSpecCollectCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *specValueLable;
-(void)setAttrModel:(yzIndexGoodsAttrModel *)model;
@end
