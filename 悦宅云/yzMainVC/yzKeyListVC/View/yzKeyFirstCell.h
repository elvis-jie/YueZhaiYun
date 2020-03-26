//
//  yzKeyFirstCell.h
//  悦宅云
//
//  Created by 尚广杰 on 2019/4/25.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "yzPxCookInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface yzKeyFirstCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView* imageV;
@property(nonatomic,strong)UILabel* titleLab;
@property(nonatomic,strong)UIImageView* jiantou;
@property(nonatomic,strong)UILabel* usableLabel;
-(void)setPxCookModel:(yzPxCookInfoModel *)model;
@end

NS_ASSUME_NONNULL_END
