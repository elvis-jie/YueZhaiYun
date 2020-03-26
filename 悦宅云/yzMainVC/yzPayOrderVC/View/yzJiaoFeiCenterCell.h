//
//  yzJiaoFeiCenterCell.h
//  yzProduct
//
//  Created by 尚广杰 on 2019/2/24.
//  Copyright © 2019 CC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface yzJiaoFeiCenterCell : UITableViewCell

@property(nonatomic,strong)UILabel* titleLable;             //缴费名称名称
@property(nonatomic,strong)UILabel* moneyLabel;             //价格
@property(nonatomic,strong)UILabel* line;
@property(nonatomic,strong)UILabel* wuLabel;                //物业费
@property(nonatomic,strong)UILabel* sureLabel;              //实付款
@property(nonatomic,strong)UILabel* surePriceLabel;         //实付款钱数

@property(nonatomic,assign)CGFloat finalH;

-(void)getMessageByDic:(NSDictionary*)dic;
@end

NS_ASSUME_NONNULL_END
