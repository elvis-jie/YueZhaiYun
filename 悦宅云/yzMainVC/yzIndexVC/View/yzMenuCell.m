//
//  yzMenuCell.m
//  悦宅云
//
//  Created by 尚广杰 on 2019/5/5.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import "yzMenuCell.h"

@implementation yzMenuCell
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self)
    {
        self.showImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, (mDeviceWidth - 3)/4 - 30, (mDeviceWidth - 3)/4 - 30)];
        
        [self addSubview:self.showImage];
        
        
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.numberOfLines = 1;
        self.titleLabel.font = YSize(14.0);
//        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.frame = CGRectMake(10, CGRectGetMaxY(self.showImage.frame) + 5, (mDeviceWidth - 3)/4 - 20, 20);
        [self addSubview:self.titleLabel];
        
        
    }
    
    return self;
}
-(void)setImage:(NSString *)image title:(NSString *)title{
    self.showImage.image = [UIImage imageNamed:image];
    self.titleLabel.text = title;
}
@end
