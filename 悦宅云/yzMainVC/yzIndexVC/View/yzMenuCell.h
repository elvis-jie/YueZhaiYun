//
//  yzMenuCell.h
//  悦宅云
//
//  Created by 尚广杰 on 2019/5/5.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface yzMenuCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView* showImage;    //产品活动图片
@property(nonatomic,strong)UILabel* titleLabel;         //标题
-(void)setImage:(NSString*)image title:(NSString*)title;
@end

NS_ASSUME_NONNULL_END
