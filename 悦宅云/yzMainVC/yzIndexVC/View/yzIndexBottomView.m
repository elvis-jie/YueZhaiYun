//
//  yzIndexBottomView.m
//  悦宅云
//
//  Created by 尚广杰 on 2019/4/15.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import "yzIndexBottomView.h"
#import "yzIndexViewController.h"
@implementation yzIndexBottomView

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        [self createUI];
        
    }
    return self;
}

-(void)createUI{
    self.btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn1.frame = CGRectMake(0, 0, mDeviceWidth/3, 49);
    [self.btn1 setImage:[UIImage imageNamed:@"客服"] forState:UIControlStateNormal];
    [self.btn1 setTitle:@"管家" forState:UIControlStateNormal];
    self.btn1.titleLabel.font = YSize(12.0);
    [self.btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    CGFloat img_W = self.btn1.imageView.frame.size.width;
    CGFloat img_H = self.btn1.imageView.frame.size.height;
    CGFloat tit_W = self.btn1.titleLabel.frame.size.width;
    CGFloat tit_H = self.btn1.titleLabel.frame.size.height;
    
    self.btn1.titleEdgeInsets = (UIEdgeInsets){
        .top    =   (tit_H / 2 + 5),
        .left   = - (img_W / 2),
        .bottom = - (tit_H / 2 + 5),
        .right  =   (img_W / 2),
    };
    
    self.btn1.imageEdgeInsets = (UIEdgeInsets){
        .top    = - (img_H / 2),
        .left   =   (tit_W / 2),
        .bottom =   (img_H / 2 - 5),
        .right  = - (tit_W / 2),
    };
    
    
    
    [self addSubview:self.btn1];
    
    
    self.btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn2.frame = CGRectMake(mDeviceWidth/3, 0, mDeviceWidth/3, 49);
    [self.btn2 setImage:[UIImage imageNamed:@"底部开锁"] forState:UIControlStateNormal];
    [self.btn2 setTitle:@"通行" forState:UIControlStateNormal];
    self.btn2.titleLabel.font = YSize(12.0);
    [self.btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    CGFloat img_W2 = self.btn2.imageView.frame.size.width;
    CGFloat img_H2 = self.btn2.imageView.frame.size.height;
    CGFloat tit_W2 = self.btn2.titleLabel.frame.size.width;
    CGFloat tit_H2 = self.btn2.titleLabel.frame.size.height;
    
    self.btn2.titleEdgeInsets = (UIEdgeInsets){
        .top    =   (tit_H2 / 2 + 5),
        .left   = - (img_W2 / 2),
        .bottom = - (tit_H2 / 2 + 5),
        .right  =   (img_W2 / 2),
    };
    
    self.btn2.imageEdgeInsets = (UIEdgeInsets){
        .top    = - (img_H2 / 2 + 15),
        .left   =   (tit_W2 / 2 - 5),
        .bottom =   (img_H2 / 2 - 5),
        .right  = - (tit_W2 / 2) - 5,
    };
    [self addSubview:self.btn2];
    
    
    self.btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn3.frame = CGRectMake(mDeviceWidth/3*2, 0, mDeviceWidth/3, 49);
    [self.btn3 setImage:[UIImage imageNamed:@"订单"] forState:UIControlStateNormal];
    [self.btn3 setTitle:@"订单" forState:UIControlStateNormal];
    self.btn3.titleLabel.font = YSize(12.0);
    [self.btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.btn3.titleEdgeInsets = (UIEdgeInsets){
        .top    =   (tit_H / 2 + 5),
        .left   = - (img_W / 2),
        .bottom = - (tit_H / 2 + 5),
        .right  =   (img_W / 2),
    };
    
    self.btn3.imageEdgeInsets = (UIEdgeInsets){
        .top    = - (img_H / 2),
        .left   =   (tit_W / 2),
        .bottom =   (img_H / 2 - 5),
        .right  = - (tit_W / 2),
    };
    [self addSubview:self.btn3];
    
    
}




@end
