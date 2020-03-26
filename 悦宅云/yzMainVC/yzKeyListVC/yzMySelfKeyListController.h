//
//  yzMySelfKeyListController.h
//  悦宅云
//
//  Created by 尚广杰 on 2019/4/25.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import "yzBaseUIViewController.h"
#import "yzPxCookInfoModel.h" //钥匙model
NS_ASSUME_NONNULL_BEGIN

@interface yzMySelfKeyListController : yzBaseUIViewController
@property (nonatomic, strong) yzPxCookInfoModel *infoModel;
@property (nonatomic, strong) NSString* fangChanId;
@property (nonatomic, strong) NSString* roomId;
@property (nonatomic, strong) NSString* mainEndDate;
@property (nonatomic, strong) NSString* xinYongTianShu;
@property (nonatomic, strong) NSString* finalTime;        //物业到期时间+信用天数
@property (nonatomic, strong) NSArray* dianTiList;
@end

NS_ASSUME_NONNULL_END
