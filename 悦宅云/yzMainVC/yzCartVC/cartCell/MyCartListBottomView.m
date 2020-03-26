//
//  MyCartListBottomView.m
//  tjcclzShopC
//
//  Created by LiuHQ on 2018/5/10.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "MyCartListBottomView.h"

@interface MyCartListBottomView()
/** 背景 */
@property (nonatomic, strong) UIView *bgView;
/** 选中与为选中按钮 */
@property (nonatomic, strong) UIButton *selectedBtn;
/** 总金额 */
@property (nonatomic, strong) UILabel *goodsAmount;
/** 去结算 */
@property (nonatomic, strong) UIButton *goPay;
@property (nonatomic, strong) yzCartCountModel *countModel;
@end
@implementation MyCartListBottomView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
/** 设置视图 */
-(void)setupUI{
    /** 背景 */
    self.bgView = [[UIView alloc] init];
    [self.bgView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    self.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    self.layer.shadowOffset = CGSizeMake(0,-2);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    self.layer.shadowOpacity = 0.1;//阴影透明度，默认0
    self.layer.shadowRadius = 2;//阴影半径，默认3
    /** 选择按钮 */
    self.selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectedBtn setBackgroundColor:[UIColor clearColor]];
    [self.selectedBtn setImage:[UIImage imageNamed:@"tjcclz_cart_circle_selected_nor"] forState:UIControlStateNormal];
    [self.selectedBtn setImage:[UIImage imageNamed:@"tjcclz_cart_circle_selected_pre"] forState:UIControlStateSelected];
    [self.selectedBtn setTitle:@"全选" forState:UIControlStateNormal];
    [self.selectedBtn setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
    [self.selectedBtn.titleLabel setFont:[UIFont fontWithName:@"HYJinChangTiJ" size:13]];
    
    [self.selectedBtn addTarget:self action:@selector(selectedClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.selectedBtn];
    [self.selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(AutoWitdh(10));
        make.centerY.equalTo(self.bgView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(60, 25));
    }];
    /** 去结算 */
    self.goPay = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.goPay setBackgroundColor:NewAppDefaultColor];
    [self.goPay setTitle:@"结算" forState:UIControlStateNormal];
    [self.goPay.layer setMasksToBounds:YES];
    [self.goPay.layer setCornerRadius:19.5];
    [self.goPay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.goPay addTarget:self action:@selector(toPayClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.goPay.titleLabel setFont:[UIFont fontWithName:@"HYJinChangTiJ" size:16]];
    [self.bgView addSubview:self.goPay];
    [self.goPay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.mas_right).offset(-15);
        make.centerY.equalTo(self.bgView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(106.5, 39));
       
    }];
    /** 总金额 */
    self.goodsAmount = [[UILabel alloc] init];
    [self.goodsAmount setTextColor:RGB(22, 22, 22)];
    [self.goodsAmount setTextAlignment:NSTextAlignmentLeft];
    [self.goodsAmount setBackgroundColor:[UIColor clearColor]];
    [self.goodsAmount setFont:[UIFont fontWithName:@"HYJinChangTiJ" size:16]];
    [self.bgView addSubview:self.goodsAmount];
    [self.goodsAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_top);
        make.left.equalTo(self.selectedBtn.mas_right).offset(AutoWitdh(15));
        make.bottom.equalTo(self.bgView.mas_bottom);
        make.right.equalTo(self.goPay.mas_left);
    }];
}
-(void)setCartTotalInfo:(yzCartCountModel *)model{
    self.selectedBtn.selected = model.allCheck;
    self.countModel = model;
    if (model.price > 0) {
        self.goodsAmount.text = [NSString stringWithFormat:@"合计:￥%.2f",model.price/100];

        
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:self.goodsAmount.text];
        [AttributedStr addAttribute:NSFontAttributeName value:YSize(14.0) range:NSMakeRange(3, self.goodsAmount.text.length-3)];
        [AttributedStr addAttribute:NSForegroundColorAttributeName value:NewAppDefaultColor range:NSMakeRange(3, self.goodsAmount.text.length-3)];
        self.goodsAmount.attributedText = AttributedStr;
    }else{
        model.price = 0.00;
        self.goodsAmount.text = [NSString stringWithFormat:@"合计:￥%.2f",model.price/100];
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:self.goodsAmount.text];
        [AttributedStr addAttribute:NSFontAttributeName value:YSize(14) range:NSMakeRange(3, self.goodsAmount.text.length-3)];
        [AttributedStr addAttribute:NSForegroundColorAttributeName value:NewAppDefaultColor range:NSMakeRange(3, self.goodsAmount.text.length-3)];
        self.goodsAmount.attributedText = AttributedStr;
    }
    if (model.count > 0) {
        [self.goPay setTitle:[NSString stringWithFormat:@"结算(%d)",model.count] forState:UIControlStateNormal];
    }else{
       [self.goPay setTitle:@"结算" forState:UIControlStateNormal];
    }
}
/** 选择 */
-(void)selectedClick:(id)sender{
    if (self.cartGoodsSelectedBlock) {
        self.cartGoodsSelectedBlock(self.countModel);
    }
}
/** 结算 */
-(void)toPayClick:(id)sender{
    if ([yzUserInfoModel getisLogin]) {
        if (self.countModel.count == 0) {
            [DDProgressHUD showErrorImageWithInfo:@"请选择结算产品"];
            return;
        }
        if (self.cartGotoPayBlock) {
            self.cartGotoPayBlock();
        }
    }else{
        [DDProgressHUD showErrorImageWithInfo:@"请先登录"];
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
