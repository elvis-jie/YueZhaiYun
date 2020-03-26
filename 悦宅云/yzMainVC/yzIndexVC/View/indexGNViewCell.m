//
//  indexGNViewCell.m
//  yzProduct
//
//  Created by CC on 2018/9/20.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "indexGNViewCell.h"

@implementation indexGNViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)gnClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    if ([self.delegate respondsToSelector:@selector(toGnViewClick:)]) {
        [self.delegate toGnViewClick:button.tag];
    }
}
@end
