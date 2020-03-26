//
//  yzSearchCell.m
//  悦宅云
//
//  Created by 尚广杰 on 2019/12/26.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import "yzSearchCell.h"

@implementation yzSearchCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
       //标题
        self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, mDeviceWidth - 95, 35)];
        self.titleLab.font = YSize(15.0);
        self.titleLab.numberOfLines = 0;
        self.titleLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.titleLab];
        //时间
        self.timeLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 35, mDeviceWidth - 95, 35)];
        self.timeLab.font = YSize(15.0);
        self.timeLab.numberOfLines = 0;
        self.timeLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.timeLab];
        
        //按钮
        
        self.makeCard = [[UIButton alloc]initWithFrame:CGRectMake(mDeviceWidth - 70, 10, 60, 50)];
        [self.makeCard setTitle:@"制卡" forState:UIControlStateNormal];
        [self.makeCard setBackgroundColor:[UIColor orangeColor]];
        [self.makeCard setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.makeCard.titleLabel.font = YSize(15.0);
        [self addSubview:self.makeCard];
        
    }
    
    return self;
}
-(void)getTitleByDic:(NSDictionary *)dic{
    self.titleLab.text = [BBUserData stringChangeNull:[dic objectForKey:@"concat"] replaceWith:@""];
    self.timeLab.text = [NSString stringWithFormat:@"物业到期时间:%@",[BBUserData stringChangeNull:[dic objectForKey:@"atime"] replaceWith:@""]];
}
@end


