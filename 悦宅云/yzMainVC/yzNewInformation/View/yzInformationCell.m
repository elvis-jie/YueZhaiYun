//
//  yzInformationCell.m
//  悦宅云
//
//  Created by 尚广杰 on 2019/4/19.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import "yzInformationCell.h"
#import "SDImageCache.h"
@implementation yzInformationCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backView = [[UIView alloc]init];
        [self.backView setBackgroundColor:[UIColor whiteColor]];
        self.backView.layer.cornerRadius = 5;
        self.backView.layer.masksToBounds = NO;
        self.backView.layer.shadowColor = [UIColor blackColor].CGColor;
        // 阴影偏移，默认(0, -3)
        self.backView.layer.shadowOffset = CGSizeMake(0,0);
        // 阴影透明度，默认0
        self.backView.layer.shadowOpacity = 0.3;
        // 阴影半径，默认3
        self.backView.layer.shadowRadius = 3;
        [self addSubview:self.backView];
        
        
        self.titleLabel = [[UILabel alloc]init];
        
//        self.titleLabel.font = YSize(15.0);
        self.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
    
        
        [self.backView addSubview:self.titleLabel];
        
        
        self.contentLabel = [[UILabel alloc]init];
       
        self.contentLabel.font = YSize(13.0);
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.textAlignment = NSTextAlignmentLeft;
        
        
        [self.backView addSubview:self.contentLabel];
        
        
        self.imageV = [[UIImageView alloc]init];
        self.imageV.contentMode = UIViewContentModeScaleToFill;
        [self.backView addSubview:self.imageV];
        
    
        
    }
    return self;
}
-(void)getMessageByDic:(NSDictionary *)dic{
 
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"tittle"]];
    CGRect titleRect = Rect(self.titleLabel.text, mDeviceWidth - 40, [UIFont boldSystemFontOfSize:15.0]);
    self.titleLabel.frame = CGRectMake(10, 10, titleRect.size.width, titleRect.size.height);
    
    self.contentLabel.text = [NSString stringWithFormat:@"       %@",[BBUserData stringChangeNull:[dic objectForKey:@"keyWord"] replaceWith:@""]];
    CGRect contentRect = Rect(self.contentLabel.text, mDeviceWidth - 40, YSize(13.0));
    self.contentLabel.frame = CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame) + 5, contentRect.size.width, contentRect.size.height);
    
    
    self.imageV.frame = CGRectMake(10, CGRectGetMaxY(self.contentLabel.frame) + 10, mDeviceWidth - 40, (mDeviceWidth - 40)/3.14);
    
//    [self.imageV sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"img"]] placeholderImage:FaultShopIconImg options:SDWebImageRefreshCached];
    
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"img"]] placeholderImage:FaultShopIconImg];
    
    self.finalH = CGRectGetMaxY(self.imageV.frame) + 10;
    self.backView.frame = CGRectMake(10, 0, mDeviceWidth - 20, self.finalH);
}


@end
