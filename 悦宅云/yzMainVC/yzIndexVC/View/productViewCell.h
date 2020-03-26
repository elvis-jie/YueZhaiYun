//
//  productViewCell.h
//  yzProduct
//
//  Created by 尚广杰 on 2019/4/11.
//  Copyright © 2019 CC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "yzIndexShopGoodsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface productViewCell : UICollectionViewCell
@property(nonatomic,strong)UIView* backView;
@property(nonatomic,strong)UIImageView* showImage;    //产品活动图片
@property(nonatomic,strong)UILabel* titleLabel;         //标题
@property(nonatomic,strong)UILabel* oldPrice;           //原价
@property(nonatomic,strong)UILabel* nowPrice;           //现价
//@property(nonatomic,strong)UIButton* addBtn;            //加入购物车
-(void)getMessageByModel:(yzIndexShopGoodsModel*)model;
@property(nonatomic,strong)yzIndexShopGoodsModel *model;
@end

NS_ASSUME_NONNULL_END
