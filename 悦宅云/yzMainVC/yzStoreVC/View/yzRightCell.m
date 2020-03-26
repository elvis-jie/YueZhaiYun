//
//  yzRightCell.m
//  悦宅云
//
//  Created by 尚广杰 on 2019/4/23.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import "yzRightCell.h"

@implementation yzRightCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 80, 80)];
        
        [self addSubview:self.imageV];
        
        
        self.nameLabel = [[UILabel alloc]init];
        
        self.nameLabel.numberOfLines = 0;
        self.nameLabel.font = YSize(14.0);
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        
        [self addSubview:self.nameLabel];
        
        self.moneyLabel = [[UILabel alloc]init];
        
        self.moneyLabel.textAlignment = NSTextAlignmentLeft;
        self.moneyLabel.textColor = [UIColor redColor];
        self.moneyLabel.font = YSize(14.0);
        
        [self addSubview:self.moneyLabel];
        
        
        self.addBtn = [[UIButton alloc]initWithFrame:CGRectMake((mDeviceWidth - 10)/4*3 - 30, 72, 20, 20)];
        [self.addBtn setImage:[UIImage imageNamed:@"红添加"] forState:UIControlStateNormal];
        [self addSubview:self.addBtn];
    }
    return self;
}
-(void)getMessageBymodel:(yzIndexShopGoodsModel *)model{

     [self.imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageUrl,model.goodsUrl]] placeholderImage:FaultShopIconImg options:SDWebImageRefreshCached];
    
    self.nameLabel.text = model.goodsName;
    CGRect rect = Rect(self.nameLabel.text, (mDeviceWidth - 10)/4*3 - 110, YSize(14.0));
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.imageV.frame) + 10, 10, rect.size.width, rect.size.height);
    
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",model.goodsPrice/100];
    self.moneyLabel.frame = CGRectMake(self.nameLabel.frame.origin.x, 75, 120, 15);
}
@end
