//
//  orderSettleAddressViewCell.h
//  yzProduct
//
//  Created by LiuHQ on 2018/9/25.
//  Copyright © 2018年 CC. All rights reserved.
// 订单结算地址

#import <UIKit/UIKit.h>
#import "yzAddressModel.h"

@interface orderSettleAddressViewCell : UITableViewCell
/** 显示选择收货地址 */
@property (weak, nonatomic) IBOutlet UIView *selectedAddressView;
- (IBAction)selectedAddressClick:(id)sender;
/** 显示收货地址 */
@property (weak, nonatomic) IBOutlet UIView *showAddressView;
@property (weak, nonatomic) IBOutlet UILabel *contactName;
@property (weak, nonatomic) IBOutlet UILabel *contactMobile;
@property (weak, nonatomic) IBOutlet UILabel *contactAddress;

@property (nonatomic, copy) void (^toAddressBlock)(void);
-(void)setAddressInfoData:(yzAddressModel *)model;
@end
