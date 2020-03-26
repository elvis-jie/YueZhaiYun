//
//  yzJiaoFeiBottomCell.h
//  yzProduct
//
//  Created by 尚广杰 on 2019/2/24.
//  Copyright © 2019 CC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface yzJiaoFeiBottomCell : UITableViewCell
@property(nonatomic,strong)UILabel* redLine;     //竖线
@property(nonatomic,strong)UILabel* orderInfo;     //订单信息
@property(nonatomic,strong)UILabel* orderCode;     //订单编号
@property(nonatomic,strong)UILabel* payTime;     //付款时间
@property(nonatomic,assign)CGFloat finalH;
-(void)getMessageByDic:(NSDictionary*)dic;
@end

NS_ASSUME_NONNULL_END
