//
//  yzStoreViewController.h
//  悦宅云
//
//  Created by 尚广杰 on 2019/4/22.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import "yzBaseUIViewController.h"
#import "yzIndexGoodsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface yzStoreViewController : yzBaseUIViewController
@property(nonatomic,strong)yzIndexGoodsModel* goodsModel;      //店铺id
@end

NS_ASSUME_NONNULL_END
