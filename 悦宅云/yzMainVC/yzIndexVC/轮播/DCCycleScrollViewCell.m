//
//  DCCycleScrollViewCell.m
//  DCCycleScrollView
//
//  Created by cheyr on 2018/2/27.
//  Copyright © 2018年 cheyr. All rights reserved.
//

#import "DCCycleScrollViewCell.h"
#import <AVFoundation/AVFoundation.h>
@interface DCCycleScrollViewCell()

@end

@implementation DCCycleScrollViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.iconImgLogo];
        [self.contentView addSubview:self.nameLabel];
    }
    return self;
}
-(void)layoutSubviews
{
    self.imageView.frame = self.bounds;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.imageView.bounds cornerRadius:self.imgCornerRadius];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = self.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    _imageView.layer.mask = maskLayer;
    
    
    self.iconImgLogo.frame = CGRectMake(mDeviceWidth/75, mDeviceWidth/21.42857, mDeviceWidth/11.71875, mDeviceWidth/11.71875);
    self.iconImgLogo.image = [UIImage imageNamed:@"tp5"];
    self.iconImgLogo.layer.cornerRadius = 5;
    self.iconImgLogo.layer.masksToBounds = YES;
    
//    self.nameLabel.frame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
//    self.nameLabel.text = @"我是人物姓名";
//    self.nameLabel.font = YSizeFont5;
    
    
    
}

-(UIImageView *)imageView
{
    if(_imageView == nil)
    {
        _imageView = [[UIImageView alloc]init];
    }
    return _imageView;
}
-(UIImageView *)iconImgLogo{
    
    if (_iconImgLogo == nil) {
        _iconImgLogo = [[UIImageView alloc]init];
    }
    return _iconImgLogo;
}
-(UILabel *)nameLabel{
    
    
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc]init];
    }
    return _nameLabel;
}
@end
