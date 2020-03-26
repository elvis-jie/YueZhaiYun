//
//  yzJiaoFeiHeaderCell.m
//  yzProduct
//
//  Created by 尚广杰 on 2019/2/24.
//  Copyright © 2019 CC. All rights reserved.
//

#import "yzJiaoFeiHeaderCell.h"

@implementation yzJiaoFeiHeaderCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //红色背景
        self.redView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mDeviceWidth, 80.0f)];
        [self.redView setBackgroundColor:[UIColor redColor]];
        [self addSubview:self.redView];
        //发货状态
        self.typeLabel = [[UILabel alloc]init];
        self.typeLabel.textColor = [UIColor whiteColor];
        self.typeLabel.textAlignment = NSTextAlignmentLeft;
        self.typeLabel.font = [UIFont systemFontOfSize:16.0];
        
        self.typeLabel.frame = CGRectMake(15, 30, 200, 20);
        [self addSubview:self.typeLabel];
        //        CGRect rect = [self.typeLabel.text boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.typeLabel.font} context:nil];
        
       
        
        //定位标
        self.locationImageV = [[UIImageView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.redView.frame) + 15, AutoWitdh(45), AutoWitdh(45))];
        self.locationImageV.image = [UIImage imageNamed:@"location"];
        [self addSubview:self.locationImageV];

        
        
        
        
        //地址
        self.addressLabel = [[UILabel alloc]init];
        
        self.addressLabel.numberOfLines = 1;
        self.addressLabel.font = [UIFont systemFontOfSize:15.0];
        self.addressLabel.textAlignment = NSTextAlignmentLeft;
        self.addressLabel.frame = CGRectMake(CGRectGetMaxX(self.locationImageV.frame) + 15, CGRectGetMaxY(self.redView.frame) + 15 + 12.5, mDeviceWidth - AutoWitdh(45) - 45, 20);
        [self addSubview:self.addressLabel];
        
        self.finalH = CGRectGetMaxY(self.locationImageV.frame) + 15;
        
    }
    return self;
}

-(void)getMessageByDic:(NSDictionary *)dic{
    NSString* payState = [NSString stringWithFormat:@"%@",[dic objectForKey:@"payState"]];
    NSDictionary* quDic = [dic objectForKey:@"xiaoQu"];
    NSDictionary* danYuanDic = [dic objectForKey:@"danYuan"];
    NSDictionary* louYuDic = [danYuanDic objectForKey:@"louYu"];
    
    if ([payState isEqualToString:@"0"]) {
        self.typeLabel.text = @"未支付";
    }else if ([payState isEqualToString:@"1"]){
        self.typeLabel.text = @"已支付";
    }else{
        self.typeLabel.text = @"已取消";
    }
    self.addressLabel.text = [NSString stringWithFormat:@"%@ %@号楼 %@单元",[quDic objectForKey:@"name"],[louYuDic objectForKey:@"name"],[danYuanDic objectForKey:@"name"]];
//    self.addressLabel.text = [NSString stringWithFormat:@"%@  %@",[]]
}
@end
