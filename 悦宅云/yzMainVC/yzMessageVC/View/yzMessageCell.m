//
//  yzMessageCell.m
//  yzProduct
//
//  Created by 尚广杰 on 2019/1/29.
//  Copyright © 2019 CC. All rights reserved.
//

#import "yzMessageCell.h"

@implementation yzMessageCell
//- (void)setFrame:(CGRect)frame {
//    frame.origin.x += 10;
//    frame.size.width -= 2 * 10;
//    [super setFrame:frame];
//}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
//        self.layer.cornerRadius = 10;
//        self.layer.masksToBounds = YES;

        [self setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
        
        self.backView = [[UIView alloc]init];
        
        [self.backView setBackgroundColor:[UIColor whiteColor]];
        self.backView.layer.cornerRadius = 10;
        self.backView.layer.masksToBounds = YES;
        
        [self addSubview:self.backView];
        
        
        //标题
        self.titleLab = [[UILabel alloc]init];
//        self.titleLab.text = @"标题";
        self.titleLab.textAlignment = NSTextAlignmentLeft;
        self.titleLab.font = [UIFont systemFontOfSize:15.0];
        self.titleLab.textColor = [UIColor blackColor];
        self.titleLab.frame = CGRectMake(10, 10, mDeviceWidth/2, 15);
        [self.backView addSubview:self.titleLab];
        //时间
        self.timeLab = [[UILabel alloc]init];
//        self.timeLab.text = @"2019-01-30";
        self.timeLab.textAlignment = NSTextAlignmentRight;
        self.timeLab.font = [UIFont systemFontOfSize:15.0];
        self.timeLab.textColor = [UIColor blackColor];
        self.timeLab.frame = CGRectMake(mDeviceWidth/2 - 10, 10, mDeviceWidth/2 - 20, 15);
        [self.backView addSubview:self.timeLab];
        //内容
        self.contentLab = [[UILabel alloc]init];
//        self.contentLab.text = @"来点消息消息消息消息消息消息消息";
        self.contentLab.numberOfLines = 0;
        self.contentLab.textAlignment = NSTextAlignmentLeft;
        self.contentLab.font = [UIFont systemFontOfSize:15.0];
        self.contentLab.textColor = [UIColor blackColor];
        
        [self.backView addSubview:self.contentLab];
        
        
    }
    return self;
}
-(void)getMessageByDic:(NSDictionary *)dic{
    self.titleLab.text = [BBUserData stringChangeNull:[dic objectForKey:@"sysMessageTitle"] replaceWith:@""];
    NSString* time = [BBUserData stringChangeNull:[dic objectForKey:@"cdate"] replaceWith:@""];
    time = [time substringWithRange:NSMakeRange(0, 10)];
    self.timeLab.text = time;
    self.contentLab.text = [BBUserData stringChangeNull:[dic objectForKey:@"sysMessageInfo"] replaceWith:@""];
    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc]initWithString:self.contentLab.text];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc]init];
    
    paragraphStyle1.alignment = NSTextAlignmentJustified;
    NSDictionary* dic1 = @{NSParagraphStyleAttributeName:paragraphStyle1,
                           NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleNone]};
    [attributedString1 setAttributes:dic1 range:NSMakeRange(0, attributedString1.length)];
    
    [self.contentLab setAttributedText:attributedString1];
    
    CGRect rect = Rect(self.contentLab.text, mDeviceWidth - 40, self.contentLab.font);
    self.contentLab.frame = CGRectMake(10, 45, rect.size.width, rect.size.height);
    self.finalH = CGRectGetMaxY(self.contentLab.frame) + 10;
    
   self.backView.frame = CGRectMake(10, 0, mDeviceWidth - 20, self.finalH);
}
@end
