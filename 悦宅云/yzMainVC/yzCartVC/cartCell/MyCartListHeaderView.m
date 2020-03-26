//
//  MyCartListHeaderView.m
//  tjcclzShopC
//
//  Created by LiuHQ on 2018/5/10.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "MyCartListHeaderView.h"
@interface MyCartListHeaderView()
/** 选择按钮 */
@property (nonatomic, strong) UIButton *selectedBtn;
/** 店铺图片 */
@property (nonatomic, strong) UIImageView *shopLogo;
/** 店铺名称 */
@property (nonatomic, strong) UIButton *shopName;
/** 右侧箭头 */
//@property (nonatomic, strong) UIImageView *rightImage;
/** 去结算 */
@property (nonatomic, strong) UIButton *toPayBtn;
//@property (nonatomic, assign) NSInteger indexPathSection;
@property (nonatomic, strong) yzCartGoodsModel *shopModel;
@end

@implementation MyCartListHeaderView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
/** 创建视图 */
-(void)setupUI{
    /** 选择 */
    self.selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectedBtn setBackgroundColor:[UIColor clearColor]];
//    [self.selectedBtn setHidden:YES];
    [self.selectedBtn setImage:[UIImage imageNamed:@"tjcclz_cart_circle_selected_nor"] forState:UIControlStateNormal];
    [self.selectedBtn setImage:[UIImage imageNamed:@"tjcclz_cart_circle_selected_pre"] forState:UIControlStateSelected];
    [self.selectedBtn addTarget:self action:@selector(selectedClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.selectedBtn];
    [self.selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(AutoWitdh(10));
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(AutoWitdh(19), AutoWitdh(19)));
    }];
    /** 店铺图片 */
    self.shopLogo = [[UIImageView alloc] init];
    [self.shopLogo setBackgroundColor:[UIColor clearColor]];
    [self.shopLogo.layer setCornerRadius:12.5f];
    [self.shopLogo.layer setMasksToBounds:YES];
    [self addSubview:self.shopLogo];
    [self.shopLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectedBtn.mas_right).offset(AutoWitdh(15));
        make.centerY.mas_equalTo(self.selectedBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    /** 店铺名称 */
    self.shopName = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.shopName setBackgroundColor:[UIColor clearColor]];
    [self.shopName setTitleColor:RGB(22, 22, 22) forState:UIControlStateNormal];
    [self.shopName setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.shopName addTarget:self action:@selector(shopNameClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.shopName.titleLabel setFont:[UIFont fontWithName:@"HYJinChangTiJ" size:16]];
    [self addSubview:self.shopName];
    [self.shopName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shopLogo.mas_right).offset(AutoWitdh(15));
        make.centerY.mas_equalTo(self.selectedBtn.mas_centerY);
        make.height.mas_equalTo(self.selectedBtn.mas_height);
        make.right.equalTo(self.mas_right).offset(-AutoWitdh(20));
    }];
    /** 箭头 */
    self.toPayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.toPayBtn setImage:[UIImage imageNamed:@"yz_right_gray"] forState:UIControlStateNormal];
    [self.toPayBtn setBackgroundColor:[UIColor whiteColor]];
    [self.toPayBtn addTarget:self action:@selector(shopNameClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.toPayBtn];
    [self.toPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.shopName.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-AutoWitdh(15));
        make.size.mas_equalTo(CGSizeMake(9, 16));
    }];
}
-(void)setCartShopInfo:(yzCartGoodsModel *)shopModel{
    self.shopModel = shopModel;
    self.selectedBtn.selected = shopModel.checked;
    [self.shopName setTitle:[NSString stringWithFormat:@"%@",shopModel.biku_store_name] forState:UIControlStateNormal];
    [self.shopLogo sd_setImageWithURL:[NSURL URLWithString:shopModel.biku_store_img] placeholderImage:FaultShopIconImg options:SDWebImageRefreshCached];
}
/** 选中与未选中 */
-(void)selectedClick:(id)sender{
    self.selectedBtn.selected = !self.selectedBtn.selected;
    if ([self.delegate respondsToSelector:@selector(headerSelectedBlock:)]) {
        [self.delegate headerSelectedBlock:self.shopModel];
    }
}
/** 进入店铺 */
-(void)shopNameClick:(id)sender{
    if ([self.delegate respondsToSelector:@selector(headerToShopInfo:)]) {
        [self.delegate headerToShopInfo:self.shopModel.biku_store_id];
    }
}

@end

