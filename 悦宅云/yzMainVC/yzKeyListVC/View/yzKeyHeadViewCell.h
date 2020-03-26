//
//  yzKeyHeadViewCell.h
//  悦宅云
//
//  Created by 尚广杰 on 2019/4/24.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface yzKeyHeadViewCell : UICollectionReusableView
@property(nonatomic,strong)UIImageView* headImage;
@property(nonatomic,strong)UILabel* smallLabel;
-(void)setMessageByDic:(NSDictionary*)dic withIndex:(NSIndexPath*)indexPath;
@end

NS_ASSUME_NONNULL_END
