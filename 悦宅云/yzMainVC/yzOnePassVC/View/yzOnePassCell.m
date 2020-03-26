//
//  yzOnePassCell.m
//  yzProduct
//
//  Created by 尚广杰 on 2019/3/14.
//  Copyright © 2019 CC. All rights reserved.
//

#import "yzOnePassCell.h"

@implementation yzOnePassCell
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self)
    {
       
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//        [self.titleLabel setTextColor:[UIColor colorWithRed:169/255.0 green:169/255.0 blue:169/255.0 alpha:1]];
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.titleLabel setFont:[UIFont fontWithName:@"HYJinChangTiJ" size:13]];
        [self.contentView addSubview:self.titleLabel];
        
        
        
    }
    
    return self;
}

-(void)getTitleByString:(NSString *)title{
    self.titleLabel.text = title;
}
@end
