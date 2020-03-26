//
//  TjcclzCirleImageCell.m
//  tjcclzShopC
//
//  Created by LiuHQ on 2018/4/13.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "TjcclzCirleImageCell.h"


@interface TjcclzCirleImageCell ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation TjcclzCirleImageCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleToFill;
        
        [_imageView setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:_imageView];
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.contentView.bounds;
}

- (void)setImagePathStr:(NSString *)imagePathStr {
    _imagePathStr = imagePathStr;
    
//    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imagePathStr] placeholderImage:self.placeholderImage options:SDWebImageRefreshCached];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imagePathStr] placeholderImage:self.placeholderImage];
}

- (void)setLocalImageName:(NSString *)localImageName {
    _localImageName = localImageName;
    
    UIImage *image = [UIImage imageNamed:localImageName];
    if (!image) {
        image = [UIImage imageWithContentsOfFile:localImageName];
    }
    self.imageView.image = image;
}
@end
