//
//  yzOrderListCell.m
//  悦宅云
//
//  Created by 尚广杰 on 2019/4/22.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import "yzOrderListCell.h"

@implementation yzOrderListCell

-(void)setFrame:(CGRect)frame{
    frame.origin.x += 15;
    frame.size.width -= 30;
    [super setFrame:frame];
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.layer.cornerRadius = 5;
        //店铺
        
        self.dianImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
        self.dianImage.image = [UIImage imageNamed:@"dian"];
        [self addSubview:self.dianImage];
        
        self.dianBtn = [[UIButton alloc]init];
        self.dianBtn.frame = CGRectMake(35, 0, 100, 40);
        
        [self.dianBtn setTitleColor:RGB(22, 22, 22) forState:UIControlStateNormal];
        self.dianBtn.titleLabel.font = YSize(13.0);
        self.dianBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self addSubview:self.dianBtn];
        
        
        self.statusLab = [[UILabel alloc]init];
        
        self.statusLab.font = YSize(13.0);
        self.statusLab.textColor = RGB(255, 128, 0);
        self.statusLab.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.statusLab];
        
        
        //删除
//        self.deleteBtn = [[UIButton alloc]init];
//        self.deleteBtn.frame = CGRectMake(mDeviceWidth - 65, 13, 14, 14);
//        [self.deleteBtn setImage:[UIImage imageNamed:@"lemon_cart_close"] forState:UIControlStateNormal];
        
//        [self.deleteBtn setBackgroundImage:[UIImage imageNamed:@"lemon_cart_close"] forState:UIControlStateNormal];
//        [self addSubview:self.deleteBtn];
        
        //产品图
        
        self.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 40, 80, 60)];
//        self.imageV.image = [UIImage imageNamed:@""];
//        [self.imageV setBackgroundColor:[UIColor redColor]];
        [self addSubview:self.imageV];
        
        //产品名
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.font = YSize(14.0);
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
     
        [self addSubview:self.titleLabel];
        //价格
//        self.moneyLabel = [[UILabel alloc]init];
//        self.moneyLabel.font = YSize(14.0);
//        self.moneyLabel.textAlignment = NSTextAlignmentRight;
//        [self addSubview:self.moneyLabel];
        //数量
//        self.countLabel = [[UILabel alloc]init];
//        self.countLabel.font = YSize(14.0);
//        self.countLabel.textAlignment = NSTextAlignmentLeft;
//        [self addSubview:self.countLabel];
        //总计
        
        self.allLabel = [[UILabel alloc]init];
        self.allLabel.font = YSize(13.0);
        self.allLabel.textAlignment = NSTextAlignmentRight;
       
        [self addSubview:self.allLabel];
        
        self.rightBtn = [[UIButton alloc]init];
        
        [self.rightBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.rightBtn.titleLabel.font = YSize(13.0);
        self.rightBtn.layer.cornerRadius = 10;
        self.rightBtn.layer.borderWidth = 1;
        self.rightBtn.layer.borderColor = [UIColor blackColor].CGColor;
        
        [self addSubview:self.rightBtn];
        
        self.leftBtn = [[UIButton alloc]init];
        
        [self.leftBtn setTitle:@"待付款" forState:UIControlStateNormal];
        [self.leftBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.leftBtn.titleLabel.font = YSize(13.0);
        self.leftBtn.layer.cornerRadius = 10;
        self.leftBtn.layer.borderWidth = 1;
        self.leftBtn.layer.borderColor = [UIColor redColor].CGColor;
        
        [self addSubview:self.leftBtn];
        
    }
    return self;
}
-(void)getDataByModel:(orderFuWuModel *)model{
    [self.dianBtn setTitle:[NSString stringWithFormat:@" %@ >",model.t_shopName] forState:UIControlStateNormal];
   
    
    
    
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageUrl,model.t_image]] placeholderImage:FaultShopIconImg options:SDWebImageRefreshCached];
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@",model.t_orderName];
    CGRect rect = Rect(self.titleLabel.text, mDeviceWidth - 130, YSize(15.0));
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.imageV.frame) + 5, self.imageV.frame.origin.y, rect.size.width, 16);
    
//    self.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",[model.t_price floatValue]/100];
//    self.moneyLabel.frame = CGRectMake(mDeviceWidth - 90 - 30, self.imageV.frame.origin.y, 80, rect.size.height);
//    self.countLabel.text = [NSString stringWithFormat:@"X %@",model.t_count];
//    self.countLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, CGRectGetMaxY(self.titleLabel.frame), 80, rect.size.height);
    
    
    self.allLabel.text = [NSString stringWithFormat:@"共计%@件商品    合计：￥%.2f",model.t_count,[model.t_price floatValue]/100];
    
    CGRect allRect = Rect(self.allLabel.text, mDeviceWidth - 160, YSize(13.0));
    self.allLabel.frame = CGRectMake(mDeviceWidth - allRect.size.width - 40, CGRectGetMaxY(self.imageV.frame) - rect.size.height + 5, allRect.size.width, allRect.size.height);
    if ([model.t_payStatus isEqualToString:@"0"]) {
        self.statusLab.text = @"等待付款";
        self.rightBtn.frame = CGRectMake(mDeviceWidth - 110, CGRectGetMaxY(self.allLabel.frame) + 15, 70, 20);
        self.leftBtn.frame = CGRectMake(mDeviceWidth - 110 - 90, CGRectGetMaxY(self.allLabel.frame) + 15, 70, 20);
        self.finalH = CGRectGetMaxY(self.rightBtn.frame) + 10;
        self.rightBtn.hidden = NO;
        self.leftBtn.hidden = NO;
    }else if ([model.t_payStatus isEqualToString:@"1"]){
        self.statusLab.text = @"交易成功";
        self.finalH = CGRectGetMaxY(self.allLabel.frame) + 10;
        self.rightBtn.hidden = YES;
        self.leftBtn.hidden = YES;
    }else if ([model.t_payStatus isEqualToString:@"-1"]){
        self.statusLab.text = @"交易失败";
        self.finalH = CGRectGetMaxY(self.allLabel.frame) + 10;
        self.rightBtn.hidden = YES;
        self.leftBtn.hidden = YES;
    }else if ([model.t_payStatus isEqualToString:@"00"]){
        self.statusLab.text = @"取消订单";
        self.finalH = CGRectGetMaxY(self.allLabel.frame) + 10;
        self.rightBtn.hidden = YES;
        self.leftBtn.hidden = YES;
    }else if ([model.t_payStatus isEqualToString:@"11"]){
        self.statusLab.text = @"订单完成";
        self.finalH = CGRectGetMaxY(self.allLabel.frame) + 10;
        self.rightBtn.hidden = YES;
        self.leftBtn.hidden = YES;
    }
  self.statusLab.frame = CGRectMake(mDeviceWidth - 160, 0, 120, 40);
}
@end
