//
//  yzKeySecondCell.m
//  悦宅云
//
//  Created by 尚广杰 on 2019/4/25.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import "yzKeySecondCell.h"

@implementation yzKeySecondCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (mDeviceWidth-30)/2, 80)];
        self.backImage.image = [UIImage imageNamed:@"keyBack"];
        [self addSubview:self.backImage];
        
        self.titleLab = [[UILabel alloc]init];
        
//        self.titleLab.text = @"迎水东里17号楼4单元";
        self.titleLab.font = YSize(14.0);
        self.titleLab.numberOfLines = 0;
        self.titleLab.textAlignment = NSTextAlignmentLeft;
        
        [self.backImage addSubview:self.titleLab];
        
        self.statusLab = [[UILabel alloc]init];
        
//        self.statusLab.text = @"可用";
        self.statusLab.font = YSize(14.0);
        self.statusLab.textAlignment = NSTextAlignmentLeft;
        self.statusLab.textColor =  RGB(44, 162, 61);
        [self.backImage addSubview:self.statusLab];
    }
    return self;
}
-(void)setPxCookModel:(yzPxCookInfoModel *)model{
    CGRect rect = [model.room_msg boundingRectWithSize:CGSizeMake((mDeviceWidth-30)/2 - 10, 40) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:YSize(14.0)} context:nil];
    self.titleLab.frame = CGRectMake(5, 10, rect.size.width, rect.size.height);
    
    self.statusLab.frame = CGRectMake(5, CGRectGetMaxY(self.titleLab.frame) + 5, self.titleLab.frame.size.width, 16);
    
    [self.titleLab setText:model.room_msg];
    [self.statusLab setText:model.user_state];
}
@end
