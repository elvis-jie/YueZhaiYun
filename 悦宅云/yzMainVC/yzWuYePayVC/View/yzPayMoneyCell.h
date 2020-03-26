//
//  yzPayMoneyCell.h
//  yzProduct
//
//  Created by 尚广杰 on 2019/2/1.
//  Copyright © 2019 CC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface yzPayMoneyCell : UITableViewCell
@property(nonatomic,strong)UIView* backView;
@property(nonatomic,strong)UILabel* moneyLabel;
@property(nonatomic,strong)UIView* line;
@property(nonatomic,strong)UILabel* desLabel;
@property(nonatomic,strong)UIImageView* seleImage;
-(void)getWuYeMessageByDic:(NSDictionary*)dic selete:(BOOL)selete;
@end

NS_ASSUME_NONNULL_END
