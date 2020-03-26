//
//  yzKeyHeadViewCell.m
//  悦宅云
//
//  Created by 尚广杰 on 2019/4/24.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import "yzKeyHeadViewCell.h"

@implementation yzKeyHeadViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        self.headImage = [[UIImageView alloc]init];
        self.headImage.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.headImage];
        
        self.smallLabel = [[UILabel alloc]init];
        self.smallLabel.textAlignment = NSTextAlignmentLeft;
        self.smallLabel.font = YSize(13.0);
        self.smallLabel.textColor = [UIColor lightGrayColor];
        
        
        [self addSubview:self.smallLabel];
    }
    return self;
}
-(void)setMessageByDic:(NSDictionary *)dic withIndex:(NSIndexPath *)indexPath{
    
    self.headImage.image = [UIImage imageNamed:[dic objectForKey:@"image"]];
    
    self.smallLabel.text = [dic objectForKey:@"title"];
    if (indexPath.section==0) {
        self.headImage.frame = CGRectMake(15, 13, 96, 24);
        self.smallLabel.frame = CGRectMake(CGRectGetMaxX(self.headImage.frame) + 5, 0, 120, 50);
    }else{
        self.headImage.frame = CGRectMake(15, 13, 110, 24);
        self.smallLabel.frame = CGRectMake(CGRectGetMaxX(self.headImage.frame) + 5, 0, 120, 50);
    }
    
}
@end
