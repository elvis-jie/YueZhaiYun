//
//  yaPayListCell.h
//  悦宅云
//
//  Created by 尚广杰 on 2019/11/19.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface yaPayListCell : UITableViewCell
@property(nonatomic,strong)UIImageView* backImage;     //背景图
@property(nonatomic,strong)UIImageView* houseImage;    //标志图
@property(nonatomic,strong)UILabel* costLabel;         //物业费  车位费
@property(nonatomic,strong)UILabel* locationLabel;     //

@property(nonatomic,strong)UIButton* nowPayBtn;        //立即缴费

@property(nonatomic,strong)UIView* circleView;         //橙色圆圈
@property(nonatomic,strong)UILabel* dayCountLabel;     //剩余天数
@property(nonatomic,strong)UILabel* dayLabel;

-(void)getMessageByDic:(NSDictionary*)dic beginTime:(NSString*)beginTime;

@end

NS_ASSUME_NONNULL_END
