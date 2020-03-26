//
//  yzJiaoFeiBottomCell.m
//  yzProduct
//
//  Created by 尚广杰 on 2019/2/24.
//  Copyright © 2019 CC. All rights reserved.
//

#import "yzJiaoFeiBottomCell.h"

@implementation yzJiaoFeiBottomCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //订单信息
        self.orderInfo = [[UILabel alloc]init];
        self.orderInfo.text = @"订单信息";
        self.orderInfo.font = [UIFont systemFontOfSize:16.0];
        self.orderInfo.textAlignment = NSTextAlignmentLeft;
        CGRect infoRect = Rect(self.orderInfo.text, 200, self.orderInfo.font);
        self.orderInfo.frame = CGRectMake(20, 10, infoRect.size.width, infoRect.size.height);
        [self addSubview:self.orderInfo];
        
        //竖线
        self.redLine = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 1, infoRect.size.height)];
        self.redLine.backgroundColor = [UIColor redColor];
        [self addSubview:self.redLine];
        
        //订单编号
        self.orderCode = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.orderInfo.frame) + 10, mDeviceWidth - 40, 20)];
        
        self.orderCode.font = [UIFont systemFontOfSize:14.0];
        self.orderCode.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.orderCode];
        //付款时间
        self.payTime = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.orderCode.frame) + 10, mDeviceWidth - 40, 20)];
        
        self.payTime.font = [UIFont systemFontOfSize:14.0];
        self.payTime.textAlignment = NSTextAlignmentLeft;
        
        [self addSubview:self.payTime];
        
        self.finalH = CGRectGetMaxY(self.payTime.frame) + 10;
    }
    return self;
}
-(void)getMessageByDic:(NSDictionary *)dic{
    
    self.orderCode.text = [NSString stringWithFormat:@"订单编号：%@",[dic objectForKey:@"id"]];
    self.payTime.text = [NSString stringWithFormat:@"付款时间：%@",[dic objectForKey:@"payDate"]];
}

@end
