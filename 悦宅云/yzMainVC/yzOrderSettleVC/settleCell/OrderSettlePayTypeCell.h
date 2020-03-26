//
//  OrderSettlePayTypeCell.h
//  tjcclzShopC
//
//  Created by LiuHQ on 2018/5/15.
//  Copyright © 2018年 CC. All rights reserved.
// 支付方式

#import <UIKit/UIKit.h>
#import "yzSettlePayModel.h"

@interface OrderSettlePayTypeCell : UITableViewCell
/** 支付方式图片 */
@property (weak, nonatomic) IBOutlet UIImageView *payImg;
/** 支付方式名称 */
@property (weak, nonatomic) IBOutlet UILabel *payName;
/** 支付选中状态 */
@property (weak, nonatomic) IBOutlet UIImageView *payIsSelected;

-(void)setSettlePayModel:(yzSettlePayModel *)payModel;
@end
