//
//  ICCardController.h
//  悦宅云
//
//  Created by 尚广杰 on 2019/10/28.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "yzXiaoQuModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ICCardController : UIViewController
@property(nonatomic,strong)yzXiaoQuModel* quModel;
@property (nonatomic, strong) NSString* fangChanId;
@property(nonatomic,strong)NSString* roomId;
@property(nonatomic,strong)NSArray* dianTiList;
@property(nonatomic,strong)NSString* state;     //0 主页进来不调接口  1 调接口
@end

NS_ASSUME_NONNULL_END
