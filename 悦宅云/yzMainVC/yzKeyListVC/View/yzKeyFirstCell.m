//
//  yzKeyFirstCell.m
//  悦宅云
//
//  Created by 尚广杰 on 2019/4/25.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import "yzKeyFirstCell.h"

@implementation yzKeyFirstCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

        self.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 17, 19, 16)];
        self.imageV.image = [UIImage imageNamed:@"椭圆2"];
        [self addSubview:self.imageV];
        
        self.titleLab = [[UILabel alloc]init];
        self.titleLab.font = YSize(14.0);
        self.titleLab.textAlignment = NSTextAlignmentLeft;
//        self.titleLab.text = @"仁爱濠景庄园仁景园10-02";
        self.titleLab.frame = CGRectMake(29, 0, mDeviceWidth - 110, 50);
        [self addSubview:self.titleLab];
        
        self.jiantou = [[UIImageView alloc]init];
        self.jiantou.image = [UIImage imageNamed:@"grayright"];
        self.jiantou.frame = CGRectMake(mDeviceWidth - 41, 17, 6, 16);
        [self addSubview:self.jiantou];
        
        
        //是否可用
        self.usableLabel = [[UILabel alloc]init];
//        self.usableLabel.text = @"可用";
        self.usableLabel.textAlignment = NSTextAlignmentRight;
        self.usableLabel.font = YSize(14.0);
        self.usableLabel.textColor = RGB(44, 162, 61);
        self.usableLabel.frame = CGRectMake(mDeviceWidth - 120, 0, 70, 50);
        [self addSubview:self.usableLabel];
    }
    return self;
}
-(void)setPxCookModel:(yzPxCookInfoModel *)model{
    [self.titleLab setText:model.room_msg];
    [self.usableLabel setText:model.user_state];
}
@end
