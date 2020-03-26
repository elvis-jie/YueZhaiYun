//
//  yzInviteListCell.m
//  yzProduct
//
//  Created by 尚广杰 on 2019/4/12.
//  Copyright © 2019 CC. All rights reserved.
//

#import "yzInviteListCell.h"

@implementation yzInviteListCell
-(void)setFrame:(CGRect)frame{
    frame.origin.x += 15;
    frame.size.width -= 2 * 15;
    [super setFrame:frame];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
        //名字
        self.nameLabel = [[UILabel alloc]init];
       
        self.nameLabel.font = YSize(15.0);
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        
        [self addSubview:self.nameLabel];
        //电话
        self.telLabel = [[UILabel alloc]init];
        
        self.telLabel.font = YSize(13.0);
        self.telLabel.textAlignment = NSTextAlignmentLeft;
        
        [self addSubview:self.telLabel];
        //车牌
        self.cardLabel = [[UILabel alloc]init];
        
        self.cardLabel.font = YSize(13.0);
        self.cardLabel.textAlignment = NSTextAlignmentRight;
   
       
        [self addSubview:self.cardLabel];
        
        //时间
        self.timeLabel = [[UILabel alloc]init];
        
        self.timeLabel.font = YSize(13.0);
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        
       
        [self addSubview:self.timeLabel];
        //备注
        self.content = [[UITextView alloc]init];
        self.content.editable = NO;
        
        self.content.font = YSize(13.0);
        self.content.layer.cornerRadius = 5;
        self.content.layer.masksToBounds = YES;
        [self addSubview:self.content];
        
       
    }
    return self;
}

-(void)getMessageByDic:(NSDictionary *)dic{
    NSString* name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"inviteName"]];
    
    NSString* count = [NSString stringWithFormat:@"%@",[dic objectForKey:@"inviteNum"]];
    if ([count isEqualToString:@"0"]||[count isEqualToString:@"<null>"]) {
        self.nameLabel.text = name;
    }else{
        count = [NSString stringWithFormat:@"(等%@人来访)",count];
    NSString* all = [NSString stringWithFormat:@"%@%@",name,count];
    NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:all];
    [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(name.length, count.length)];
    [attriStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(name.length, count.length)];
    
     self.nameLabel.attributedText = attriStr;
    }
    CGRect rect = Rect(self.nameLabel.text, mDeviceWidth - 30, YSize(15.0));
    self.nameLabel.frame = CGRectMake(15, 10, rect.size.width, rect.size.height);
    
    self.telLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"invitePhone"]];
    CGRect rectTel = Rect(self.telLabel.text, mDeviceWidth - 30, YSize(15.0));
    self.telLabel.frame = CGRectMake(15, CGRectGetMaxY(self.nameLabel.frame), rectTel.size.width, rectTel.size.height);
    
    
    self.cardLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"inviteCarCode"]];
     self.cardLabel.frame = CGRectMake(mDeviceWidth/2 - 45, CGRectGetMaxY(self.telLabel.frame), mDeviceWidth/2, rectTel.size.height);
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@%@到访",[dic objectForKey:@"inviteDate"],[[dic objectForKey:@"inviteTime"] objectForKey:@"display"]];;
    
     self.timeLabel.frame = CGRectMake(15, CGRectGetMaxY(self.cardLabel.frame), mDeviceWidth - 60, rectTel.size.height);
    
    self.content.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"inviteRemark"]];
     self.content.frame = CGRectMake(15, CGRectGetMaxY(self.timeLabel.frame) + 5, mDeviceWidth - 60, 60);
    if (self.content.text.length==0) {
        self.content.hidden =YES;
        self.finalH = CGRectGetMaxY(self.timeLabel.frame) + 10;
    }else{
        self.content.hidden = NO;
        self.finalH = CGRectGetMaxY(self.content.frame) + 10;
    }
    
}

@end
