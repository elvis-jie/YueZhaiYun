//
//  FeedImagesView.m
//  tjcclzShopC
//
//  Created by LiuHQ on 2018/5/9.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "FeedImagesView.h"
#define ButtonW (mDeviceWidth - AutoWitdh(20) -1/3*5)/4.f

@interface FeedImagesView()
@property(nonatomic, strong)NSMutableArray *buttonArray;
@end

@implementation FeedImagesView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
-(void)setupUI{
    for (int i = 0; i < 8; i ++) {
        NSInteger row1 = i/4;
        NSInteger line2 = i%4;
        
        UIButton *button = [[UIButton alloc] init];
        button.frame = CGRectMake((5/2+ButtonW)*line2, (5/2+ButtonW)*row1, ButtonW, ButtonW);
        button.hidden = YES;
        button.tag = i;
        [button addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonArray addObject:button];
        [self addSubview:button];
    }
}
-(NSArray *)feedimagesArray{
    if (!_feedimagesArray) {
        _feedimagesArray = [[NSArray alloc] init];
    }
    return _feedimagesArray;
}
-(void)setImagesArrays:(NSMutableArray *)imagesArray{
    self.feedimagesArray = imagesArray;
    NSInteger count = (imagesArray.count-1)/4+1;
    [self.buttonArray enumerateObjectsUsingBlock:^(UIButton *  _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < imagesArray.count) {
            [button setImage:[[imagesArray objectAtIndex:idx] objectForKey:@"image"] forState:UIControlStateNormal];
            button.hidden = NO;
        }else{
            button.hidden = YES;
        }
    }];
    if (imagesArray.count == 0) {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0).priorityMedium();
        }];
    }else{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo((5/2+ButtonW)*count).priorityMedium();
        }];
    }
}

-(void)setImagesArray:(NSMutableArray *)imagesArray{
    self.feedimagesArray = imagesArray;
    NSInteger count = (imagesArray.count-1)/4+1;
    [self.buttonArray enumerateObjectsUsingBlock:^(UIButton *  _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < imagesArray.count) {
            [button setImage:[imagesArray objectAtIndex:idx] forState:UIControlStateNormal];
            button.hidden = NO;
        }else{
            button.hidden = YES;
        }
    }];
    if (imagesArray.count == 0) {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0).priorityMedium();
        }];
    }else{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo((5/2+ButtonW)*count).priorityMedium();
        }];
    }
}

-(NSMutableArray *)buttonArray{
    if (!_buttonArray) {
        _buttonArray = [[NSMutableArray alloc] init];
    }
    return _buttonArray;
}

-(void)setPicViewUrl:(NSString *)url VideoUrl:(NSString *)videoUrl{
    if (videoUrl) {
        [self.feedpicView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:FaultClassImg options:SDWebImageHandleCookies];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(AutoWitdh(495.0/2.0)).priorityMedium();
            make.height.mas_equalTo(AutoHeight(265.0/2.0)).priorityMedium();
        }];
        [self.feedpicView setHidden:NO];
    }else{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0).priorityMedium();
        }];
        [self.feedpicView setHidden:YES];
    }
}


/**
 图片点击事件
 
 */
-(void)imageClick:(UIButton *)button{
    if (self.feedImageclickBlock) {
        self.feedImageclickBlock(button.tag);
    }
}

@end
