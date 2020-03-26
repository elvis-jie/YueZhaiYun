//
//  yzOrderListCell.h
//  悦宅云
//
//  Created by 尚广杰 on 2019/4/22.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "orderFuWuModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface yzOrderListCell : UITableViewCell
@property(nonatomic,strong)UIImageView* dianImage;
@property(nonatomic,strong)UIButton* dianBtn;         //店铺
//@property(nonatomic,strong)UIButton* deleteBtn;       //删除按钮
@property(nonatomic,strong)UIImageView* imageV;       //产品图片
@property(nonatomic,strong)UILabel* titleLabel;       //标题
@property(nonatomic,strong)UILabel* statusLab;        //状态
//@property(nonatomic,strong)UILabel* moneyLabel;       //价格
//@property(nonatomic,strong)UILabel* countLabel;       //数量
@property(nonatomic,strong)UILabel* allLabel;         //总计

@property(nonatomic,strong)UIButton* rightBtn;
@property(nonatomic,strong)UIButton* leftBtn;

@property(nonatomic,assign)float finalH;
-(void)getDataByModel:(orderFuWuModel*)model;
@end

NS_ASSUME_NONNULL_END
