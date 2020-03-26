//
//  TjcclzCirleImageCell.h
//  tjcclzShopC
//
//  Created by LiuHQ on 2018/4/13.
//  Copyright © 2018年 CC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TjcclzCirleImageCell : UICollectionViewCell
@property (nonatomic, copy) NSString *imagePathStr;

@property (nonatomic, strong) UIImage *placeholderImage;

@property (nonatomic, copy) NSString *localImageName;
@end
