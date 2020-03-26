//
//  indexMsgViewCell.m
//  yzProduct
//
//  Created by CC on 2018/9/20.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "indexMsgViewCell.h"

@implementation indexMsgViewCell

{
    UIImageView*advImageView;
   
    float _count;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];

    if (self) {
        _count=0.0;
  
        [self setUpAdvUI];
    }
    return self;
}


- (void)setUpAdvUI
{
    advImageView=[UIImageView new];
    advImageView.image=[UIImage imageNamed:@"通知公告"];

    [self addSubview:advImageView];
    
    
    [advImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(10);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(80);
        
    }];
   

    self.line = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, 1, 40)];
    [self.line setBackgroundColor:[UIColor lightGrayColor]];
    [self addSubview:self.line];
    
    
    self.contentBtn = [[UIButton alloc]initWithFrame:CGRectMake(66, 10, mDeviceWidth - 130, 40)];
    [self.contentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.contentBtn.titleLabel.font = YSize(14.0);
  
    self.contentBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self addSubview:self.contentBtn];
    
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(mDeviceWidth - 70, 10, 60, 40)];
//    self.timeLabel.text = @"09-27";
    self.timeLabel.textColor = [UIColor lightGrayColor];
    self.timeLabel.font = YSize(14.0);
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.timeLabel];
    
    
}

-(void)getMessageByDic:(NSDictionary *)dic{

    
    [self.contentBtn setTitle:[dic objectForKey:@"tittle"] forState:UIControlStateNormal];
    NSString* time = [dic objectForKey:@"insertTime"];
    time = [time substringWithRange:NSMakeRange(5, 5)];
    self.timeLabel.text = time;
    
}

@end
