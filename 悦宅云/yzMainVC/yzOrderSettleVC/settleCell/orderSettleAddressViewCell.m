//
//  orderSettleAddressViewCell.m
//  yzProduct
//
//  Created by LiuHQ on 2018/9/25.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "orderSettleAddressViewCell.h"

@implementation orderSettleAddressViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.contactAddress setAdjustsFontSizeToFitWidth:YES];
    [self.showAddressView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedAddressClick:)];
    [self.showAddressView addGestureRecognizer:tap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setAddressInfoData:(yzAddressModel *)model{
    if (model.isHaveData) {
        self.showAddressView.hidden = NO;
        self.contactName.text = model.address_name;
        self.contactMobile.text = model.address_mobile;
        self.contactAddress.text = model.address_info;
    }else{
        self.showAddressView.hidden = YES;
    }
}
- (IBAction)selectedAddressClick:(id)sender {
    if (self.toAddressBlock) {
        self.toAddressBlock();
    }
}
@end
