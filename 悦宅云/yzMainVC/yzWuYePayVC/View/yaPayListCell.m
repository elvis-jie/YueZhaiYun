//
//  yaPayListCell.m
//  悦宅云
//
//  Created by 尚广杰 on 2019/11/19.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import "yaPayListCell.h"

@implementation yaPayListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, mDeviceWidth - 20, (mDeviceWidth - 20)/2.5)];
        
        [self addSubview:self.backImage];
        
        self.houseImage = [[UIImageView alloc]initWithFrame:CGRectMake(25, 15, 20, 18)];
        
        [self.backImage addSubview:self.houseImage];
        
        self.costLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.houseImage.frame) + 5, self.houseImage.frame.origin.y, mDeviceWidth/2, 18)];
        
        self.costLabel.font = YSize(15.0);
        self.costLabel.textAlignment = NSTextAlignmentLeft;
        
        [self.backImage addSubview:self.costLabel];
        
        self.locationLabel = [[UILabel alloc]init];
//        self.locationLabel.text = @"天津市南开区\n花港里16号楼1-1-4-1";
        self.locationLabel.numberOfLines = 0;
        self.locationLabel.font = YSize(13.0);
      
        [self.backImage addSubview:self.locationLabel];
        
        
        //立即缴费
        self.nowPayBtn = [[UIButton alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(self.backImage.frame) - 40, 70, 25)];
        [self.nowPayBtn setBackgroundColor:[UIColor colorWithRed:224/255.0 green:66/255.0 blue:44/255.0 alpha:1]];
        [self.nowPayBtn setTitle:@"立即缴费" forState:UIControlStateNormal];
        self.nowPayBtn.titleLabel.font = YSize(13.0);
        [self.nowPayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.nowPayBtn.layer.cornerRadius = 5;
        self.nowPayBtn.layer.masksToBounds = YES;
        [self.backImage addSubview:self.nowPayBtn];
        
        
        //天数
        self.circleView = [[UIView alloc]initWithFrame:CGRectMake(mDeviceWidth - (mDeviceWidth - 20)/2.5, (mDeviceWidth - 20)/2.5/6, (mDeviceWidth - 20)/2.5/3*2, (mDeviceWidth - 20)/2.5/3*2)];
        self.circleView.layer.cornerRadius = (mDeviceWidth - 20)/2.5/3;
        self.circleView.layer.masksToBounds = YES;
        self.circleView.layer.borderColor = [UIColor colorWithRed:224/255.0 green:66/255.0 blue:44/255.0 alpha:1].CGColor;
        self.circleView.layer.borderWidth = 1.0;
        
        [self.backImage addSubview:self.circleView];
        
        
        self.dayCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, self.circleView.frame.size.height/4, self.circleView.frame.size.width - 10, self.circleView.frame.size.height/4)];
//        self.dayCountLabel.text = @"143天";
        self.dayCountLabel.font = YSize(20.0);
        self.dayCountLabel.textColor = [UIColor colorWithRed:224/255.0 green:66/255.0 blue:44/255.0 alpha:1];
        
       
        
  
        
        
        self.dayCountLabel.textAlignment = NSTextAlignmentCenter;
        [self.circleView addSubview:self.dayCountLabel];
        
        self.dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, self.circleView.frame.size.height/2, self.circleView.frame.size.width - 10, self.circleView.frame.size.height/4)];
        
        self.dayLabel.font = YSize(13.0);
        self.dayLabel.textAlignment = NSTextAlignmentCenter;
        [self.circleView addSubview:self.dayLabel];
        
    }
    return self;
}

-(void)getMessageByDic:(NSDictionary *)dic beginTime:(nonnull NSString *)beginTime{

    NSLog(@"dic===%@",dic);
        NSString *str;
    if ([[dic objectForKey:@"type"] isEqualToString:@"物业费"]) {
        self.backImage.image = [UIImage imageNamed:@"物业费背景"];
        self.houseImage.image = [UIImage imageNamed:@"house"];
        self.costLabel.text = @"物业费";
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        NSDate *beginDate = [dateFormatter dateFromString:beginTime];
        //物业时间
        NSDate *endDate = [dateFormatter dateFromString:[dic objectForKey:@"atime"]];
        //信用天数
        NSDate *endDatePlus = [dateFormatter dateFromString:[dic objectForKey:@"activeTimePlus"]];
        
        //先计算物业费   物业费时间为0再计算剩余信用天数
        //物业费剩余时间
        NSInteger wuyeInteger = [self calcDaysFromBegin:beginDate end:endDate];
        //信用天数剩余时间
        NSInteger plusInteger = [self calcDaysFromBegin:beginDate end:endDatePlus];
    
        if (wuyeInteger > 0) {
            str = [NSString stringWithFormat:@"%ld天",wuyeInteger];
            self.dayLabel.text = @"剩余天数";
        }
        if (wuyeInteger <= 0 && plusInteger > 0) {
            str = [NSString stringWithFormat:@"%ld天",plusInteger];
            self.dayLabel.text = @"信用天数";
        }
        
        if (wuyeInteger <= 0 && plusInteger <= 0) {
            str = [NSString stringWithFormat:@"0天"];
            self.dayLabel.text = @"剩余天数";
        }
        
        
    }else{
        self.backImage.image = [UIImage imageNamed:@"车位费背景"];
        self.houseImage.image = [UIImage imageNamed:@"redcar"];
        self.costLabel.text = @"车位费";
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        NSDate *beginDate = [dateFormatter dateFromString:beginTime];
        //物业时间
        NSDate *endDate = [dateFormatter dateFromString:[dic objectForKey:@"atime"]];

        
        //先计算物业费   物业费时间为0再计算剩余信用天数
        //物业费剩余时间
        NSInteger carTime = [self calcDaysFromBegin:beginDate end:endDate];
        
        str = [NSString stringWithFormat:@"%ld天",carTime];
        self.dayLabel.text = @"剩余天数";
        
      
        
        
    }
    
    self.locationLabel.text = [BBUserData stringChangeNull:[dic objectForKey:@"name"] replaceWith:@""];
    
    CGRect rect = Rect(self.locationLabel.text, mDeviceWidth - (mDeviceWidth - 20)/2.5/3*2 - 70, YSize(13.0));
    self.locationLabel.frame = CGRectMake(25, CGRectGetMaxY(self.houseImage.frame) + 10, rect.size.width, rect.size.height);
    
    
    
   
   
    
    
    //富文本
    //把动态获取到的值传给富文本AttributedStr。
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
    //第一个参数addAttribute说明在下面有说明，第二个参数value设置改变Lable的字体和大小，第三个参数range是修改Lable文字的范围。
    [AttributedStr addAttribute:NSFontAttributeName
                          value:YSize(15.0)
                          range:NSMakeRange(str.length - 1, 1)];
    self.dayCountLabel.attributedText = AttributedStr;
    
}

#pragma mark -- 计算天数
- (NSInteger) calcDaysFromBegin:(NSDate *)beginDate end:(NSDate *)endDate

{

     
     NSTimeInterval time=[endDate timeIntervalSinceDate:beginDate];
     
     int days=((int)time)/(3600*24);

     
     if (days<0) {
     days = 0;
     }
     
      return days;
    
    
}
@end
