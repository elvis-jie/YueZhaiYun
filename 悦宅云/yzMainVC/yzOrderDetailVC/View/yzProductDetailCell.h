//
//  yzProductDetailCell.h
//  yzProduct
//
//  Created by 尚广杰 on 2019/2/15.
//  Copyright © 2019 CC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "yzOrderDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface yzProductDetailCell : UITableViewCell

@property(nonatomic,strong)UIImageView* productImageV;      //产品图片
@property(nonatomic,strong)UILabel* introduceLabel;         //产品名称
@property(nonatomic,strong)UILabel* moneyLabel;             //价格
@property(nonatomic,strong)UILabel* countLabel;             //数量
//@property(nonatomic,strong)UIButton* rebateBtn;             //退款按钮
//@property(nonatomic,strong)UILabel* freightLabel;           //运费
//@property(nonatomic,strong)UILabel* freightMoneyLabel;      //运费钱
//@property(nonatomic,strong)UILabel* surePayLabel;           //实付款
//@property(nonatomic,strong)UILabel* surePayMoneyLabel;      //实付款钱
@property(nonatomic,assign)CGFloat finalH;

-(void)getProductByModel:(yzOrderDetailModel*)model;
@end

NS_ASSUME_NONNULL_END
