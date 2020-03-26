//
//  yzEvaluateListCell.m
//  yzProduct
//
//  Created by 尚广杰 on 2019/3/8.
//  Copyright © 2019 CC. All rights reserved.
//

#import "yzEvaluateListCell.h"

@implementation yzEvaluateListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //图片
//        self.headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 80, 60)];
//        self.headImageView.image = [UIImage imageNamed:@"kui"];
//        self.headImageView.contentMode = UIViewContentModeScaleAspectFit;
//        [self addSubview:self.headImageView];
        //标题
        self.titleLabel = [[UILabel alloc]init];
//                self.titleLabel.text = @"啊水晶嘎啦果人家两败俱伤的本科生";
        self.titleLabel.font = [UIFont fontWithName:@"HYJinChangTiJ" size:15.0];
        
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.numberOfLines = 0;
      
        [self addSubview:self.titleLabel];
        
        //时间
        self.timeLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 50, mDeviceWidth - 125, 20)];
//        self.timeLable.text = @"2019-03-23 12:23:34";
        self.timeLable.textAlignment = NSTextAlignmentLeft;
        self.timeLable.font = [UIFont fontWithName:@"HYJinChangTiJ" size:13.0];
        [self addSubview:self.timeLable];
    }
    return self;
}
-(void)getMessageByDic:(NSDictionary *)dic{
//    NSString* str = [NSString stringWithFormat:@"%@",[dic objectForKey:@"paperName"]];
//    NSLog(@"%@",str);
//
//    [str stringByRemovingPercentEncoding];
    self.titleLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"paperName"]];
    CGRect rect = Rect(self.titleLabel.text, mDeviceWidth - 125, self.titleLabel.font);
    self.titleLabel.frame = CGRectMake(15, 10, rect.size.width, rect.size.height);
    self.timeLable.text = [NSString stringWithFormat:@"%@",[BBUserData stringChangeNull:[dic objectForKey:@"cdate"] replaceWith:@""]];
}
@end
