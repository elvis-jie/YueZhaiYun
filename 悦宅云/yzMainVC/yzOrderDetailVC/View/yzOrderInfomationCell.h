//
//  yzOrderInfomationCell.h
//  yzProduct
//
//  Created by 尚广杰 on 2019/2/15.
//  Copyright © 2019 CC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "yzOrderDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface yzOrderInfomationCell : UITableViewCell
@property(nonatomic,strong)UILabel* redLine;     //竖线
@property(nonatomic,strong)UILabel* orderInfo;     //订单信息
@property(nonatomic,strong)UILabel* orderCode;     //订单编号
@property(nonatomic,strong)UILabel* payTime;     //付款时间
@property(nonatomic,assign)CGFloat finalH;

-(void)getMessageByModel:(yzOrderDetailModel*)model;
@end

NS_ASSUME_NONNULL_END
