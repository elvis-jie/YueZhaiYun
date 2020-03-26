//
//  yzHouseKeepCell.h
//  悦宅云
//
//  Created by 尚广杰 on 2019/4/19.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "yzHouseKeepModel.h"
#import "yzXiaoQuModel.h"

#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import <CallKit/CXCallObserver.h>
#import <CallKit/CXCall.h>

NS_ASSUME_NONNULL_BEGIN

@interface yzHouseKeepCell : UITableViewCell
@property(nonatomic,strong)UIImageView* headImage;  //头像
@property(nonatomic,strong)UILabel* nameLabel;      //名字
//@property(nonatomic,strong)UILabel* workLabel;      //工作经验
@property(nonatomic,strong)UILabel* quLabel;        //负责小区
@property(nonatomic,strong)UILabel* contentLabel;   //工作内容
@property(nonatomic,strong)UIButton* telBtn;        //打电话
-(void)getMessageByModel:(yzHouseKeepModel*)model;
@property(nonatomic,strong)yzHouseKeepModel* keepModel;

@property (nonatomic, strong) CTCallCenter *callCenter;
@end

NS_ASSUME_NONNULL_END
