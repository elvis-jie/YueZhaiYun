//
//  yzPayMoneyCell.m
//  yzProduct
//
//  Created by 尚广杰 on 2019/2/1.
//  Copyright © 2019 CC. All rights reserved.
//

#import "yzPayMoneyCell.h"

@implementation yzPayMoneyCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 95)];
        self.backView.backgroundColor = [UIColor orangeColor];
        self.backView.layer.cornerRadius = 5;
        self.backView.layer.masksToBounds = YES;
        self.backView.layer.shadowColor = [UIColor blackColor].CGColor;
        // 阴影偏移，默认(0, -3)
        self.backView.layer.shadowOffset = CGSizeMake(0,0);
        // 阴影透明度，默认0
        self.backView.layer.shadowOpacity = 0.3;
        // 阴影半径，默认3
        self.backView.layer.shadowRadius = 3;
        
        [self addSubview:self.backView];
        
        
        self.seleImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 17, 17)];
        [self.backView addSubview:self.seleImage];
        //价格
        self.moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, mDeviceWidth - 50, 37)];
        
        self.moneyLabel.font = [UIFont systemFontOfSize:15.0];
        self.moneyLabel.textAlignment = NSTextAlignmentCenter;
        [self.backView addSubview:self.moneyLabel];
        //横线
        self.line = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.moneyLabel.frame), mDeviceWidth - 50, 1)];
        [self.line setBackgroundColor:[UIColor lightGrayColor]];
        [self.backView addSubview:self.line];
        //基础费
        self.desLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.line.frame), mDeviceWidth - 50, 37)];
//        self.desLabel.text = @"基础物业费";
        self.desLabel.font = [UIFont systemFontOfSize:15.0];
        self.desLabel.textAlignment = NSTextAlignmentCenter;
        [self.backView addSubview:self.desLabel];
        
    }
    return self;
}
-(void)getWuYeMessageByDic:(NSDictionary*)dic{
 
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f/%@",[[dic objectForKey:@"price"] floatValue]/100,[dic objectForKey:@"zhouQi"]];
    self.desLabel.text = [NSString stringWithFormat:@"%@ - %@",[dic objectForKey:@"payContent"],[dic objectForKey:@"title"]];
    

}


@end
