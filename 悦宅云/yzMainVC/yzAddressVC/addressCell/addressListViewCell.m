//
//  addressListViewCell.m
//  yzProduct
//
//  Created by LiuHQ on 2018/9/25.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "addressListViewCell.h"

@interface addressListViewCell()
@property (nonatomic, strong) NSString *address_id;

@end

@implementation addressListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.contactAddress setAdjustsFontSizeToFitWidth:YES];
}
-(void)setAddressInfoModel:(yzAddressModel *)model{
    self.address_id = model.address_id;
    self.contactName.text = [BBUserData stringChangeNull:model.address_name replaceWith:@""];
    self.contactMobile.text = model.address_mobile;
    self.contactAddress.text = model.address_info;
    self.selectedBtn.selected = model.isDefault;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)selectedClick:(id)sender {
    if (self.addressSelectedBlock) {
        self.addressSelectedBlock(self.address_id);
    }
}

- (IBAction)deleteClick:(id)sender {
    if (self.addressDeleteBlock) {
        self.addressDeleteBlock(self.address_id);
    }
}

- (IBAction)editClick:(id)sender {
    if (self.addressEditBlock) {
        self.addressEditBlock(self.address_id);
    }
}


@end
