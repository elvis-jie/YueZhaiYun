//
//  yzMySelfKeyCell.m
//  悦宅云
//
//  Created by 尚广杰 on 2019/4/25.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import "yzMySelfKeyCell.h"

@implementation yzMySelfKeyCell
//-(void)setFrame:(CGRect)frame{
//    frame.origin.x += 15;
//    frame.size.width -= 30;
//    [super setFrame:frame];
//}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        self.layer.cornerRadius = 5;
        self.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 22, 19, 16)];
        self.imageV.image = [UIImage imageNamed:@"椭圆2"];
        [self addSubview:self.imageV];
        
        
        self.titleLable = [[UILabel alloc]init];
        self.titleLable.textAlignment = NSTextAlignmentLeft;
        self.titleLable.font = YSize(14.0);
//        self.titleLable.text = @"仁爱濠景庄园仁景园10-2仁爱濠景庄园仁景园10-2";
        self.titleLable.frame = CGRectMake(22, 14, mDeviceWidth - 120, 16);
        [self addSubview:self.titleLable];
        
        self.nameLable = [[UILabel alloc]init];
        self.nameLable.textAlignment = NSTextAlignmentRight;
        self.nameLable.font = YSize(14.0);
//        self.nameLable.text = @"小明";
        self.nameLable.frame = CGRectMake(mDeviceWidth - 150, 14, 80, 16);
        [self addSubview:self.nameLable];
        
        
        self.timeLable = [[UILabel alloc]init];
        self.timeLable.textAlignment = NSTextAlignmentLeft;
        self.timeLable.font = YSize(13.0);
//        self.timeLable.text = @"有效期至：2019年4月1日";
        self.timeLable.frame = CGRectMake(22, 30, mDeviceWidth - 100, 15);
        [self addSubview:self.timeLable];
        
        
        
        self.switchBtn = [[UISwitch alloc]init];
        [self.switchBtn addTarget:self action:@selector(switchAction:) forControlEvents: UIControlEventValueChanged];
        self.switchBtn.transform = CGAffineTransformMakeScale(0.75, 0.75);
        [self addSubview:self.switchBtn];
        [self.switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.centerY.equalTo(self);
            make.width.equalTo(@50);
            make.height.equalTo(@26);
        }];
    }
    return self;
}
-(void)setPxCookModel:(yzPxCookInfoModel *)model{

    
    [self.titleLable setText:model.phone];
    [self.timeLable setText:[NSString stringWithFormat:@"有效期至:%@",model.end_time]];
    [self.switchBtn setOn:[model.user_state isEqualToString:@"可用"]?YES:NO];
    [self.nameLable setText:model.appUserName];
}

-(void)switchAction:(UISwitch *)sender{
    if (self.updateSwitchBlock) {
        self.updateSwitchBlock(sender.isOn);
    }
}
@end
