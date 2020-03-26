//
//  yzKeySecondCell.h
//  悦宅云
//
//  Created by 尚广杰 on 2019/4/25.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "yzPxCookInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface yzKeySecondCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView* backImage;
@property(nonatomic,strong)UILabel* titleLab;
@property(nonatomic,strong)UILabel* statusLab;
-(void)setPxCookModel:(yzPxCookInfoModel *)model;
@end

NS_ASSUME_NONNULL_END
