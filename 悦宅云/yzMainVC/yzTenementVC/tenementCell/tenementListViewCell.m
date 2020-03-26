//
//  tenementListViewCell.m
//  悦宅云
//
//  Created by 尚广杰 on 2019/4/22.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import "tenementListViewCell.h"

@implementation tenementListViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //标题
        self.titleLabel = [[UILabel alloc]init];
        
        self.titleLabel.font = YSize(15.0);
      self.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.titleLabel];
        //时间
        self.timeLabel = [[UILabel alloc]init];
        
        self.timeLabel.font = YSize(14.0);
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
    
        [self addSubview:self.timeLabel];
        //状态
        self.stateLabel = [[UILabel alloc]init];
        
        self.stateLabel.font = YSize(15.0);
        self.stateLabel.textAlignment = NSTextAlignmentRight;
        self.stateLabel.textColor = [UIColor redColor];
        
        [self addSubview:self.stateLabel];
        //内容
        self.contentLabel = [[UILabel alloc]init];
        
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.font = YSize(15.0);
        self.contentLabel.textAlignment = NSTextAlignmentLeft;
      
        [self addSubview:self.contentLabel];
        
        
        self.btn1 = [[UIButton alloc]init];
   
//        [self.btn1 setBackgroundColor:[UIColor redColor]];
        
        [self addSubview:self.btn1];
        
        self.btn2 = [[UIButton alloc]init];
        
//        [self.btn2 setBackgroundColor:[UIColor redColor]];
        
        [self addSubview:self.btn2];
        
        self.btn3 = [[UIButton alloc]init];
        
//        [self.btn3 setBackgroundColor:[UIColor redColor]];
        
        [self addSubview:self.btn3];
        
        //横线
        self.line = [[UILabel alloc]init];
        
        [self.line setBackgroundColor:[UIColor lightGrayColor]];
        [self addSubview:self.line];
        //正在处理
        self.nowStateLabel = [[UILabel alloc]init];
        
        self.nowStateLabel.font = YSize(15.0);
        self.nowStateLabel.textAlignment = NSTextAlignmentCenter;
        self.nowStateLabel.layer.cornerRadius = 5;
        self.nowStateLabel.layer.borderWidth = 1;
        self.nowStateLabel.layer.borderColor = [UIColor redColor].CGColor;
        self.nowStateLabel.textColor = [UIColor redColor];

        [self addSubview:self.nowStateLabel];
        
  
    }
    return self;
}
-(void)setTenementModel:(tenementInfoModel *)model{
    NSLog(@"====%@",model.list_baoxiuTime);
   
    self.titleLabel.text = [NSString stringWithFormat:@"%@",model.list_baoxiuName];
    CGRect titleRect = Rect(self.titleLabel.text, mDeviceWidth/2, YSize(15.0));
    self.titleLabel.frame = CGRectMake(10, 10, titleRect.size.width, titleRect.size.height);
    
    [self.timeLabel setText:[BBUserData stringChangeNull:model.list_baoxiuTime replaceWith:@""]];
    
    
    
    
    
    CGRect timeRect = Rect(self.timeLabel.text, mDeviceWidth/2, YSize(14.0));
    self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + 10, 10 + (titleRect.size.height - timeRect.size.height)/2, timeRect.size.width, timeRect.size.height);
    if (model.list_baoxiuState.t_value == 1) {
        self.stateLabel.text = @"待处理";
        self.nowStateLabel.text = @"待处理";
    }else if (model.list_baoxiuState.t_value == 2) {
        [self.stateLabel setText:@"处理中"];
     self.nowStateLabel.text = @"处理中";
    }else if (model.list_baoxiuState.t_value == 3){
        [self.stateLabel setText:@"已完成"];
self.nowStateLabel.text = @"已完成";
    }else{
        [self.stateLabel setText:@"已取消"];
self.nowStateLabel.text = @"已取消";
    }
   
    self.stateLabel.frame = CGRectMake(mDeviceWidth - 110, 10, 100, titleRect.size.height);
    
    
    self.contentLabel.text = model.list_baoxiuInfo;
    CGRect contentRect = Rect(self.contentLabel.text, mDeviceWidth - 20, YSize(15.0));
    self.contentLabel.frame = CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame) + 20, contentRect.size.width, contentRect.size.height);
    
     self.btn1.frame = CGRectMake(10, CGRectGetMaxY(self.contentLabel.frame) + 10, 90, 70);
    self.btn2.frame = CGRectMake(CGRectGetMaxX(self.btn1.frame) + 10, CGRectGetMaxY(self.contentLabel.frame) + 10, 90, 70);
    self.btn3.frame = CGRectMake(CGRectGetMaxX(self.btn2.frame) + 10, CGRectGetMaxY(self.contentLabel.frame) + 10, 90, 70);
    if (model.list_baoxiuPic1.length > 0) {
//        [self.btn1.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.btn1 sd_setImageWithURL:[NSURL URLWithString:model.list_baoxiuPic1] forState:UIControlStateNormal placeholderImage:FaultClassImg options:SDWebImageRefreshCached];

    }
    if (model.list_baoxiuPic2.length > 0) {
//   [self.btn2.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.btn2 sd_setImageWithURL:[NSURL URLWithString:model.list_baoxiuPic2] forState:UIControlStateNormal placeholderImage:FaultClassImg options:SDWebImageRefreshCached];
       
    }
    if (model.list_baoxiuPic3.length > 0) {
//       [self.btn3.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.btn3 sd_setImageWithURL:[NSURL URLWithString:model.list_baoxiuPic3] forState:UIControlStateNormal placeholderImage:FaultClassImg options:SDWebImageRefreshCached];
    }
    
    if (model.list_baoxiuPic1.length == 0) {
         self.line.frame = CGRectMake(5, CGRectGetMaxY(self.contentLabel.frame) + 20, mDeviceWidth - 10, 1);
    }else{
    
    self.line.frame = CGRectMake(5, CGRectGetMaxY(self.btn1.frame) + 20, mDeviceWidth - 10, 1);
    
  
    }
    
    CGRect nowRect = Rect(self.nowStateLabel.text, mDeviceWidth/2, YSize(15.0));
    self.nowStateLabel.frame = CGRectMake(mDeviceWidth - nowRect.size.width - 30, CGRectGetMaxY(self.line.frame) + 10, nowRect.size.width + 20, nowRect.size.height + 10);
          self.finalH = CGRectGetMaxY(self.nowStateLabel.frame) + 10;
   
}
@end
