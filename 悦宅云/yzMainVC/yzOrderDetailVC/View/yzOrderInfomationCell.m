//
//  yzOrderInfomationCell.m
//  yzProduct
//
//  Created by 尚广杰 on 2019/2/15.
//  Copyright © 2019 CC. All rights reserved.
//

#import "yzOrderInfomationCell.h"

@implementation yzOrderInfomationCell

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
        self.orderCode = [[UILabel alloc]init];
        
        self.orderCode.font = [UIFont systemFontOfSize:14.0];
        self.orderCode.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.orderCode];
        //付款时间
        self.payTime = [[UILabel alloc]init];
        
        self.payTime.font = [UIFont systemFontOfSize:14.0];
        self.payTime.textAlignment = NSTextAlignmentLeft;
       
        [self addSubview:self.payTime];
        
        self.finalH = CGRectGetMaxY(self.payTime.frame) + 20;
    }
    return self;
}
-(void)getMessageByModel:(yzOrderDetailModel *)model{
    self.orderCode.text = [NSString stringWithFormat:@"订单编号：%@",model.biku_order_no];
    CGRect codeRect = Rect(self.orderCode.text, mDeviceWidth - 40, self.orderCode.font);
    self.orderCode.frame = CGRectMake(20, CGRectGetMaxY(self.orderInfo.frame) + 15, codeRect.size.width, codeRect.size.height);
    self.payTime.text = [NSString stringWithFormat:@"付款时间：%@",model.ctime];
    CGRect timeRect = Rect(self.payTime.text, mDeviceWidth - 40, self.payTime.font);
    self.payTime.frame = CGRectMake(20, CGRectGetMaxY(self.orderCode.frame) + 5, timeRect.size.width, timeRect.size.height);
    self.finalH = CGRectGetMaxY(self.payTime.frame) + 20;
}
@end
