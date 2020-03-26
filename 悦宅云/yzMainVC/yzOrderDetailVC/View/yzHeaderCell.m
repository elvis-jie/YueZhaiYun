//
//  yzHeaderCell.m
//  yzProduct
//
//  Created by 尚广杰 on 2019/2/15.
//  Copyright © 2019 CC. All rights reserved.
//

#import "yzHeaderCell.h"

@implementation yzHeaderCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //红色背景
        self.redView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mDeviceWidth, 120.0f)];
        [self.redView setBackgroundColor:[UIColor redColor]];
        [self addSubview:self.redView];
        //发货状态
        self.typeLabel = [[UILabel alloc]init];
        self.typeLabel.textColor = [UIColor whiteColor];
        self.typeLabel.textAlignment = NSTextAlignmentLeft;
        self.typeLabel.font = [UIFont systemFontOfSize:16.0];
      
        
        [self addSubview:self.typeLabel];
//        CGRect rect = [self.typeLabel.text boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.typeLabel.font} context:nil];
       
        //车标
        self.carImageV = [[UIImageView alloc]init];
        self.carImageV.contentMode = UIViewContentModeScaleAspectFit;
        
        [self addSubview:self.carImageV];
        
        [self.carImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.redView).offset(-50);
            make.centerY.mas_equalTo(self.redView);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(45);
        }];
        
        //定位标
        self.locationImageV = [[UIImageView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.redView.frame) + 30, AutoWitdh(45), AutoWitdh(45))];
        self.locationImageV.image = [UIImage imageNamed:@"location"];
        [self addSubview:self.locationImageV];
        //姓名
        self.nameLabel = [[UILabel alloc]init];
//        self.nameLabel.text = @"杨光    13467892345";
        self.nameLabel.numberOfLines = 1;
        self.nameLabel.font = [UIFont systemFontOfSize:15.0];
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        
        [self addSubview:self.nameLabel];
      
        
      
        
        //地址
        self.addressLabel = [[UILabel alloc]init];
//        self.addressLabel.text = @"天津市  南开区  风荷园小区12号楼4单元606";
        self.addressLabel.numberOfLines = 0;
        self.addressLabel.font = [UIFont systemFontOfSize:15.0];
        self.addressLabel.textAlignment = NSTextAlignmentLeft;
       
        [self addSubview:self.addressLabel];
      
    }
    return self;
}


-(void)getMessageByModel:(yzOrderDetailModel *)model address:(nonnull NSDictionary *)dic{
    
    if ([model.pay_status isEqualToString:@"0"]) {
        self.typeLabel.text = @"订单未支付";
        [self.carImageV setImage:[UIImage imageNamed:@"wallet"]];
    }else if ([model.pay_status isEqualToString:@"1"]){
        self.typeLabel.text = @"订单已发货";
        [self.carImageV setImage:[UIImage imageNamed:@"car"]];
    }else{
    self.typeLabel.text = @"订单关闭";
        [self.carImageV setImage:[UIImage imageNamed:@""]];
    }
    CGRect rect = Rect(self.typeLabel.text, 200, self.typeLabel.font);
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.redView).offset(15);
        make.centerY.mas_equalTo(self.redView);
        make.width.mas_equalTo(mDeviceWidth/2);
        make.height.mas_equalTo(rect.size.height);
        
    }];
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@    %@",[dic objectForKey:@"name"],[dic objectForKey:@"phone"]];
    CGRect nameRect = Rect(self.nameLabel.text, mDeviceWidth - 80, self.nameLabel.font);
    self.nameLabel.frame = CGRectMake(70, CGRectGetMaxY(self.redView.frame) + 25, nameRect.size.width, nameRect.size.height);
    
    self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",[dic objectForKey:@"country"],[dic objectForKey:@"city"],[dic objectForKey:@"qu"],[dic objectForKey:@"info"]];
    CGRect addressRect = Rect(self.addressLabel.text, mDeviceWidth - 80, self.addressLabel.font);
    self.addressLabel.frame = CGRectMake(self.nameLabel.frame.origin.x, CGRectGetMaxY(self.nameLabel.frame)+5, addressRect.size.width, addressRect.size.height);
    
    self.finalH = CGRectGetMaxY(self.locationImageV.frame) + 30;
}
@end
