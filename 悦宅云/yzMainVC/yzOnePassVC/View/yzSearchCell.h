//
//  yzSearchCell.h
//  悦宅云
//
//  Created by 尚广杰 on 2019/12/26.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface yzSearchCell : UITableViewCell
@property(nonatomic,strong)UILabel* titleLab;    //标题
@property(nonatomic,strong)UILabel* timeLab;     //时间
@property(nonatomic,strong)UIButton* makeCard;   //制卡按钮
-(void)getTitleByDic:(NSDictionary*)dic;
@end

NS_ASSUME_NONNULL_END
