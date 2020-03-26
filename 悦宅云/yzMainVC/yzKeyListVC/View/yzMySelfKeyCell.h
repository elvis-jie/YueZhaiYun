//
//  yzMySelfKeyCell.h
//  悦宅云
//
//  Created by 尚广杰 on 2019/4/25.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "yzPxCookInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface yzMySelfKeyCell : UITableViewCell
@property(nonatomic,strong)UIImageView* imageV;
@property(nonatomic,strong)UILabel* titleLable;
@property(nonatomic,strong)UILabel* nameLable;
@property(nonatomic,strong)UILabel* timeLable;
@property(nonatomic,strong)UISwitch* switchBtn;
-(void)setPxCookModel:(yzPxCookInfoModel *)model;
/** 可用与不可用 */
@property (nonatomic, copy)void(^updateSwitchBlock)(BOOL isOpen);
@end

NS_ASSUME_NONNULL_END
