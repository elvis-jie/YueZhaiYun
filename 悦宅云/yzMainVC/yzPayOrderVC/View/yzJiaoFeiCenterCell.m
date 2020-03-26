//
//  yzJiaoFeiCenterCell.m
//  yzProduct
//
//  Created by 尚广杰 on 2019/2/24.
//  Copyright © 2019 CC. All rights reserved.
//

#import "yzJiaoFeiCenterCell.h"

@implementation yzJiaoFeiCenterCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, mDeviceWidth - 90, 44)];
        
        self.titleLable.textAlignment = NSTextAlignmentLeft;
        self.titleLable.font = [UIFont systemFontOfSize:18.0];
        self.titleLable.numberOfLines = 1;
        [self addSubview:self.titleLable];
        
        self.moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(mDeviceWidth - 155, 24, 140, 20)];

        self.moneyLabel.textAlignment = NSTextAlignmentRight;
        self.moneyLabel.font = [UIFont boldSystemFontOfSize:15.0];
        self.moneyLabel.textColor = [UIColor colorWithRed:222/255.0 green:58/255.0 blue:36/255.0 alpha:1];
        [self addSubview:self.moneyLabel];
        
        
        self.line = [[UILabel alloc]initWithFrame:CGRectMake(15, 44, mDeviceWidth - 30, 1)];
        self.line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:self.line];
        
        self.wuLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.line.frame) + 10, mDeviceWidth - 30, 20)];
        self.wuLabel.textAlignment = NSTextAlignmentLeft;
        self.wuLabel.font = [UIFont systemFontOfSize:15.0];
        
        
        [self addSubview:self.wuLabel];
        
        
        self.sureLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.wuLabel.frame) + 20, 150, 20)];
        self.sureLabel.textAlignment = NSTextAlignmentLeft;
        self.sureLabel.font = [UIFont systemFontOfSize:15.0];
        self.sureLabel.text = @"实付款";
        
        [self addSubview:self.sureLabel];
        
        
        self.surePriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(mDeviceWidth - 115, CGRectGetMaxY(self.wuLabel.frame) + 20, 100, 20)];
        self.surePriceLabel.textAlignment = NSTextAlignmentRight;
        self.surePriceLabel.font = [UIFont systemFontOfSize:15.0];
        
        
        [self addSubview:self.surePriceLabel];
        
        self.finalH = CGRectGetMaxY(self.sureLabel.frame) + 10;
    }
    return self;
}
-(void)getMessageByDic:(NSDictionary *)dic{

    
    
    NSDictionary* payItem = [dic objectForKey:@"payItem"];
    NSDictionary* zhouQi = [payItem objectForKey:@"zhouQi"];
    NSDictionary* type = [payItem objectForKey:@"type"];
    self.titleLable.text = [NSString stringWithFormat:@"%@",[type objectForKey:@"display"]];//@"基础物业费(月计)";
    
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f/%@",[[dic objectForKey:@"yingJiao"] floatValue]/100,[zhouQi objectForKey:@"display"]];
    
    self.wuLabel.text = [NSString stringWithFormat:@"%@",[BBUserData stringChangeNull:[payItem objectForKey:@"title"] replaceWith:@"null"]];
    
    self.surePriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[[dic objectForKey:@"shiJiao"] floatValue]/100];
}
@end
