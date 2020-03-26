//
//  yzOrderViewController.h
//  yzProduct
//
//  Created by 尚广杰 on 2019/2/19.
//  Copyright © 2019 CC. All rights reserved.
//

#import "yzBaseUIViewController.h"
#import "yzIndexGoodsModel.h"
#import "yzBiKuAttr.h"
#import "yzIndexShopGoodDetailModel.h"   //物业商品信息
NS_ASSUME_NONNULL_BEGIN

@interface yzOrderViewController : yzBaseUIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)yzIndexGoodsModel *goodsModel;           //比酷
@property (nonatomic, strong)yzIndexShopGoodDetailModel* shopGoodModel;
@property (nonatomic, strong)yzBiKuAttr *attrModel;
@property (nonatomic, strong)NSString* type;            //

@property (weak, nonatomic) IBOutlet UITableView *tableV;
@property (weak, nonatomic) IBOutlet UIButton *payMoney;

@end

NS_ASSUME_NONNULL_END
