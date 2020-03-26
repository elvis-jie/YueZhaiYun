//
//  FeedImagesView.h
//  tjcclzShopC
//
//  Created by LiuHQ on 2018/5/9.
//  Copyright © 2018年 CC. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^feedImageclickBlock)(NSInteger index);

@interface FeedImagesView : UIView
@property(nonatomic, strong)NSArray *feedimagesArray;

@property(nonatomic, strong)UIImageView *feedpicView;//缩略图
@property(nonatomic, copy)feedImageclickBlock feedImageclickBlock;

-(void)setImagesArrays:(NSMutableArray *)imagesArray;

-(void)setImagesArray:(NSMutableArray *)imagesArray;
@end
