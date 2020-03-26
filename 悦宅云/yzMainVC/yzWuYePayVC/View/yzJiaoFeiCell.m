//
//  yzJiaoFeiCell.m
//  悦宅云
//
//  Created by 尚广杰 on 2019/4/26.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import "yzJiaoFeiCell.h"

@implementation yzJiaoFeiCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //icon
        self.iconBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 15, 38, 33)];
        [self.iconBtn setBackgroundImage:[UIImage imageNamed:@"yz_house_left_bg"] forState:UIControlStateNormal];
        [self.iconBtn setTitle:@"缴" forState:UIControlStateNormal];
        self.iconBtn.titleLabel.font = YSize(15);
        [self.iconBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.iconBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [self addSubview:self.iconBtn];
        
        //标题
        self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(63, 5, mDeviceWidth - 63 - 80, 20)];
        self.titleLab.text = @"基础物业费（月计）";
        self.titleLab.font = YSize(15);
        self.titleLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.titleLab];
        
        self.priceLab = [[UILabel alloc]initWithFrame:CGRectMake(mDeviceWidth - 95 - 30, 5, 80, 20)];
        
        self.priceLab.textColor = [UIColor colorWithRed:222/255.0 green:58/255.0 blue:36/255.0 alpha:1];
        self.priceLab.font = YSize(15);
        self.priceLab.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.priceLab];
        
        
        
        
        self.quLab = [[UILabel alloc]initWithFrame:CGRectMake(63, 30, mDeviceWidth - 63 - 100, 20)];
        self.quLab.text = @"金福里";
        self.quLab.font = YSize(15);
        self.quLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.quLab];
        
        self.typeLab = [[UILabel alloc]initWithFrame:CGRectMake(mDeviceWidth - 95 - 30, 30, 80, 20)];
        
        self.typeLab.textColor = [UIColor colorWithRed:222/255.0 green:58/255.0 blue:36/255.0 alpha:1];
        self.typeLab.font = YSize(15);
        self.typeLab.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.typeLab];
        
        
        self.timeLab = [[UILabel alloc]initWithFrame:CGRectMake(63, 55, mDeviceWidth - 63 - 80, 20)];
        
        self.timeLab.font = YSize(15);
        self.timeLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.timeLab];
        
    }
    return self;
}
-(void)getMessageByDic:(NSDictionary *)dic{
    self.titleLab.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"orderName"]];
    self.quLab.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"shopName"]];
    self.timeLab.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"orderTime"]];
    
    self.priceLab.text = [NSString stringWithFormat:@"￥%.2f",[[dic objectForKey:@"price"] floatValue]/100];
    NSString* type = [NSString stringWithFormat:@"%@",[dic objectForKey:@"payStatus"]];
    
    if ([type isEqualToString:@"0"]) {
        self.typeLab.text = @"未支付";
    }else if ([type isEqualToString:@"1"]){
        self.typeLab.text = @"已支付";
    }else{
        self.typeLab.text = @"已取消";
    }
}

@end
