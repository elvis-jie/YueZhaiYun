//
//  tenementListViewCell.h
//  悦宅云
//
//  Created by 尚广杰 on 2019/4/22.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tenementInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface tenementListViewCell : UITableViewCell
@property(nonatomic,strong)UILabel* titleLabel;
@property(nonatomic,strong)UILabel* timeLabel;
@property(nonatomic,strong)UILabel* stateLabel;
@property(nonatomic,strong)UILabel* contentLabel;
@property(nonatomic,strong)UIButton* btn1;
@property(nonatomic,strong)UIButton* btn2;
@property(nonatomic,strong)UIButton* btn3;
@property(nonatomic,strong)UILabel* line;
@property(nonatomic,strong)UILabel* nowStateLabel;
@property(nonatomic,assign)float finalH;
-(void)setTenementModel:(tenementInfoModel *)model;
@end

NS_ASSUME_NONNULL_END
