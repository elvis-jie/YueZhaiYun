//
//  yzUploadViewCell.h
//  悦宅云
//
//  Created by 尚广杰 on 2019/12/30.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface yzUploadViewCell : UICollectionViewCell
@property(nonatomic,strong)UILabel* titleLabel;
-(void)getTitleByString:(NSString*)title;
@end

NS_ASSUME_NONNULL_END
