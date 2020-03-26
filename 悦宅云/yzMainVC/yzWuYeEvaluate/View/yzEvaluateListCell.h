//
//  yzEvaluateListCell.h
//  yzProduct
//
//  Created by 尚广杰 on 2019/3/8.
//  Copyright © 2019 CC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface yzEvaluateListCell : UITableViewCell
@property(nonatomic,strong)UIImageView* headImageView;
@property(nonatomic,strong)UILabel* titleLabel;
@property(nonatomic,strong)UILabel* timeLable;
-(void)getMessageByDic:(NSDictionary*)dic;
@end

NS_ASSUME_NONNULL_END
