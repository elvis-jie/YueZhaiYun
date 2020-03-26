//
//  yzOnePassCell.h
//  yzProduct
//
//  Created by 尚广杰 on 2019/3/14.
//  Copyright © 2019 CC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface yzOnePassCell : UICollectionViewCell
@property(nonatomic,strong)UILabel* titleLabel;
-(void)getTitleByString:(NSString*)title;
@end

NS_ASSUME_NONNULL_END
