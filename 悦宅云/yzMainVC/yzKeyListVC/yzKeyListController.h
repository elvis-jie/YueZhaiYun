//
//  yzKeyListController.h
//  悦宅云
//
//  Created by 尚广杰 on 2019/4/24.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import "yzBaseUIViewController.h"
#import "yzXiaoQuModel.h" //小区model
NS_ASSUME_NONNULL_BEGIN

@interface yzKeyListController : yzBaseUIViewController
@property(nonatomic,strong)yzXiaoQuModel* quModel;
@property(nonatomic,strong)NSString* fangChanId;
@property(nonatomic,strong)NSString* mainEndDate;
@property(nonatomic,strong)NSString* xinYongTianShu;
@property(nonatomic,strong)NSString* roomId;
@property(nonatomic,strong)NSArray* dianTiList;
@property(nonatomic,strong)NSString* unLockStatus;
@end

NS_ASSUME_NONNULL_END
