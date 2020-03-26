//
//  DCCycleScrollViewCell.h
//  DCCycleScrollView
//
//  Created by cheyr on 2018/2/27.
//  Copyright © 2018年 cheyr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCCycleScrollViewCell : UICollectionViewCell
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,assign) CGFloat imgCornerRadius;
@property (nonatomic,strong) UIImageView *iconImgLogo;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *detailLabel;
@property (nonatomic,strong) UIImageView *leftImgV;
@property (nonatomic,strong) UILabel *leftLabel;
@property (nonatomic,strong) UIImageView *rightImgV;
@property (nonatomic,strong) UILabel *rightLabel;
@end
