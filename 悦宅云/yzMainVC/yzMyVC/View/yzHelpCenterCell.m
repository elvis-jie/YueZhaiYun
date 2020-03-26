//
//  yzHelpCenterCell.m
//  悦宅云
//
//  Created by 尚广杰 on 2019/4/18.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import "yzHelpCenterCell.h"

@implementation yzHelpCenterCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //标题
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.font = YSize(15.0);
        
        [self addSubview:self.titleLabel];
        //箭头
        self.jianTou = [[UIImageView alloc]init];
        
        [self addSubview:self.jianTou];
        //答案
        self.answerLabel = [[UILabel alloc]init];
        self.answerLabel.textAlignment = NSTextAlignmentLeft;
        self.answerLabel.font = YSize(13.0);
        self.answerLabel.numberOfLines = 0;
        [self addSubview:self.answerLabel];
    }
    return self;
}

-(void)getMessageByDic:(NSDictionary *)dic type:(NSString *)type{

    
    self.titleLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"question"]];
    CGRect rect = Rect(self.titleLabel.text, mDeviceWidth - 40, YSize(15.0));
    self.titleLabel.frame = CGRectMake(10, 22 - rect.size.height/2, rect.size.width, rect.size.height);
    
    self.jianTou.frame = CGRectMake(mDeviceWidth - 10 - rect.size.height, self.titleLabel.frame.origin.y + rect.size.height/4, rect.size.height, rect.size.height/2);
    
    self.answerLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"answer"]];
    CGRect rectAnswer = Rect(self.answerLabel.text, mDeviceWidth - 20, YSize(13.0));
    self.answerLabel.frame = CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame) + 10, rectAnswer.size.width, rectAnswer.size.height);
    if ([type isEqualToString:@"0"]) {
        self.jianTou.image = [UIImage imageNamed:@"展开下"];
        self.answerLabel.hidden = YES;
        self.finalH = 44;
    }else{
        self.jianTou.image = [UIImage imageNamed:@"展开上"];
        self.answerLabel.hidden = NO;
        self.finalH = CGRectGetMaxY(self.answerLabel.frame) + 10;
    }
}
@end
