//
//  yzProductDetailCell.m
//  yzProduct
//
//  Created by 尚广杰 on 2019/2/15.
//  Copyright © 2019 CC. All rights reserved.
//

#import "yzProductDetailCell.h"

@implementation yzProductDetailCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}
//初始化页面
-(void)setUI{
    
    //产品图片
    self.productImageV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 20, AutoWitdh(110), AutoWitdh(85))];
    [self.productImageV setImage:[UIImage imageNamed:@"yz_goods_default"]];
    self.productImageV.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.productImageV];
    //产品名
    self.introduceLabel = [[UILabel alloc]init];
    self.introduceLabel.text = @"--";
    self.introduceLabel.font = [UIFont systemFontOfSize:15.0];
    self.introduceLabel.textAlignment = NSTextAlignmentLeft;
    CGRect rect1 = Rect(self.introduceLabel.text, mDeviceWidth - AutoWitdh(110) - 40, self.introduceLabel.font);
    self.introduceLabel.frame = CGRectMake(CGRectGetMaxX(self.productImageV.frame) + 10, self.productImageV.frame.origin.y, rect1.size.width, rect1.size.height);
    [self addSubview:self.introduceLabel];
    
    //价格
    self.moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.introduceLabel.frame.origin.x, CGRectGetMaxY(self.productImageV.frame) - rect1.size.height, 150, rect1.size.height)];
    self.moneyLabel.textAlignment = NSTextAlignmentLeft;
    
    self.moneyLabel.font = [UIFont systemFontOfSize:15.0];
    [self addSubview:self.moneyLabel];
    //数量
    self.countLabel = [[UILabel alloc]initWithFrame:CGRectMake(mDeviceWidth - 85, self.moneyLabel.frame.origin.y, 70, rect1.size.height)];
    
    self.countLabel.font = [UIFont systemFontOfSize:15.0];
    self.countLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.countLabel];
    //退款
//    self.rebateBtn = [[UIButton alloc]initWithFrame:CGRectMake(mDeviceWidth - 75, CGRectGetMaxY(self.productImageV.frame) + 10, 60, 20)];
//    [self.rebateBtn setTitle:@"退款" forState:UIControlStateNormal];
//    self.rebateBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
//    self.rebateBtn.layer.cornerRadius = 10;
//    self.rebateBtn.layer.masksToBounds = YES;
//    self.rebateBtn.layer.borderWidth = 1;
//    self.rebateBtn.layer.borderColor = [UIColor blackColor].CGColor;
//    [self.rebateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [self addSubview:self.rebateBtn];
    
    
    
    self.finalH = CGRectGetMaxY(self.productImageV.frame) + 15;
}

-(void)getProductByModel:(yzOrderDetailModel *)model{
   
    self.introduceLabel.text = [NSString stringWithFormat:@"%@",model.biku_goods_name];
    CGRect rect1 = Rect(self.introduceLabel.text, mDeviceWidth - AutoWitdh(110) - 40, self.introduceLabel.font);
    self.introduceLabel.frame = CGRectMake(CGRectGetMaxX(self.productImageV.frame) + 10, self.productImageV.frame.origin.y, rect1.size.width, rect1.size.height);
    
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",[model.biku_goods_price floatValue]/100];
    self.countLabel.text = [NSString stringWithFormat:@"× %@",model.biku_goods_count];
    
//    self.surePayMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",[model.biku_order_price floatValue]/100];
}

@end
