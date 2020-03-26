//
//  goodsDetailPicViewCell.m
//  yzProduct
//
//  Created by LiuHQ on 2018/9/21.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "goodsDetailPicViewCell.h"

@implementation goodsDetailPicViewCell

-(void)setAdModel:(NSMutableArray *)imageArray{
    NSMutableArray *imageUrlStrings = [[NSMutableArray alloc] init];
    imageUrlStrings = imageArray;
    [self removeFromSuperview];
    
    CGRect frame = CGRectMake(0, 0, mDeviceWidth, mDeviceWidth);
    TjcclzCirclePlayImageView *rotatorImageView = [TjcclzCirclePlayImageView rotatorImageViewWithFrame:frame imageURLStrigArray:imageUrlStrings placeholerImage:nil];
    rotatorImageView.delegate = self;
    rotatorImageView.pageIndicatorColor = RGBA(255, 255, 255, 1);
    rotatorImageView.currentPageIndicatorColor = NewAppDefaultColor;
    rotatorImageView.hidesForSinglePage = YES;
    rotatorImageView.rotateTimeInterval = 3.0f;
    [self addSubview:rotatorImageView];
}

#pragma mark - TjcclzCirclePlayImageViewDelegate
-(void)rotatorImageView:(TjcclzCirclePlayImageView *)rotatorImageView didClickImageIndex:(NSInteger)index{
  
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
