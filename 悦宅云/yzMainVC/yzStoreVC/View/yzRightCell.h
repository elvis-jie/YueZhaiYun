//
//  yzRightCell.h
//  悦宅云
//
//  Created by 尚广杰 on 2019/4/23.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "yzIndexShopGoodsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface yzRightCell : UITableViewCell
@property(nonatomic,strong)UIImageView* imageV;     //产品图片
@property(nonatomic,strong)UILabel* nameLabel;      //产品名
@property(nonatomic,strong)UILabel* moneyLabel;     //价格
@property(nonatomic,strong)UIButton* addBtn;        //加入购物车
-(void)getMessageBymodel:(yzIndexShopGoodsModel*)model;
@end

NS_ASSUME_NONNULL_END
