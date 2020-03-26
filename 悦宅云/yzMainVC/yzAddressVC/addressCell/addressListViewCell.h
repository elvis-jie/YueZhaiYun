//
//  addressListViewCell.h
//  yzProduct
//
//  Created by LiuHQ on 2018/9/25.
//  Copyright © 2018年 CC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "yzAddressModel.h"

@interface addressListViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contactName;
@property (weak, nonatomic) IBOutlet UILabel *contactMobile;
@property (weak, nonatomic) IBOutlet UILabel *contactAddress;
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
- (IBAction)selectedClick:(id)sender;
- (IBAction)deleteClick:(id)sender;
- (IBAction)editClick:(id)sender;
-(void)setAddressInfoModel:(yzAddressModel *)model;

@property (nonatomic, copy)void(^addressEditBlock)(NSString *address_id);
@property (nonatomic, copy)void(^addressDeleteBlock)(NSString *address_id);
@property (nonatomic, copy)void(^addressSelectedBlock)(NSString *address_id);


@end
