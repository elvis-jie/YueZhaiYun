//
//  yzUploadViewCell.m
//  悦宅云
//
//  Created by 尚广杰 on 2019/12/30.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import "yzUploadViewCell.h"

@implementation yzUploadViewCell
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self)
    {
       
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];

        
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
