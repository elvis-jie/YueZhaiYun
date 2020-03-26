//
//  yzHouseKeepCell.m
//  悦宅云
//
//  Created by 尚广杰 on 2019/4/19.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import "yzHouseKeepCell.h"

@implementation yzHouseKeepCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.headImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 90, 90)];
//        self.headImage.layer.cornerRadius = 30;
        self.headImage.image = [UIImage imageNamed:@"管家"];
      
        [self addSubview:self.headImage];
        
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.font = YSize(13.0);
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.frame = CGRectMake(80, 15, mDeviceWidth - 80 - 65, 20);
        [self addSubview:self.nameLabel];
        
//        self.workLabel = [[UILabel alloc]init];
//        self.workLabel.font = YSize(13.0);
//        self.workLabel.textAlignment = NSTextAlignmentLeft;
//        self.workLabel.frame = CGRectMake(100, CGRectGetMaxY(self.nameLabel.frame), mDeviceWidth - 100 - 65, 20);
//        [self addSubview:self.workLabel];
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"XiaoQuModel"];
        
        
        yzXiaoQuModel* quModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        self.quLabel = [[UILabel alloc]init];
        self.quLabel.font = YSize(13.0);
         self.quLabel.text = [NSString stringWithFormat:@"负责小区：%@",quModel.xiaoqu_name];;
        self.quLabel.textAlignment = NSTextAlignmentLeft;
        self.quLabel.frame = CGRectMake(80, CGRectGetMaxY(self.nameLabel.frame), mDeviceWidth - 80 - 65, 20);
        [self addSubview:self.quLabel];
        
        
        self.contentLabel = [[UILabel alloc]init];
        self.contentLabel.font = YSize(13.0);
        self.contentLabel.textAlignment = NSTextAlignmentLeft;
        self.contentLabel.frame = CGRectMake(80, CGRectGetMaxY(self.quLabel.frame), mDeviceWidth - 80 - 60, 20);
        [self addSubview:self.contentLabel];
        
        self.telBtn = [[UIButton alloc]initWithFrame:CGRectMake(mDeviceWidth - 65, 20, 50, 50)];
        [self.telBtn setImage:[UIImage imageNamed:@"电话"] forState:UIControlStateNormal];
        [self.telBtn addTarget:self action:@selector(telBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.telBtn];
        
        
        _callCenter = [[CTCallCenter alloc] init];
        
        _callCenter.callEventHandler = ^(CTCall *call) {
            
            if ([call.callState isEqualToString:CTCallStateDisconnected])
                
            {
                
                NSLog(@"挂断了电话咯Call has been disconnected");
                
            }
            
            else if ([call.callState isEqualToString:CTCallStateConnected])
                
            {
                
                NSLog(@"电话通了Call has just been connected");
                
            }
            
            else if([call.callState isEqualToString:CTCallStateIncoming])
                
            {
                
                NSLog(@"来电话了Call is incoming");
                
                
                
            }
            
            else if ([call.callState isEqualToString:CTCallStateDialing])
                
            {
                
                NSLog(@"正在播出电话call is dialing");
                
            }
            
            else
                
            {
                
                NSLog(@"嘛都没做Nothing is done");
                
            }
            
        };
    }
    return self;
}
-(void)getMessageByModel:(yzHouseKeepModel *)model{
    self.keepModel = model;
    self.nameLabel.text = [NSString stringWithFormat:@"姓名：%@",model.keep_name];
//    self.workLabel.text = @"工作经验：3-5年";
   
    self.contentLabel.text = [NSString stringWithFormat:@"工作内容：%@",model.keep_workInfo];
}
-(void)telBtn:(UIButton*)sender{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.keepModel.keep_tel];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self addSubview:callWebview];
}
@end
