//
//  yzQuListViewController.h
//  悦宅云
//
//  Created by 尚广杰 on 2019/11/5.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import "yzBaseUIViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface yzQuListViewController : yzBaseUIViewController
@property(nonatomic,strong)NSArray* dianTi;
@property(nonatomic,strong)NSArray* quLists;
@property(nonatomic,assign)NSInteger midTime;
@property(nonatomic,strong)NSString* localityTime;
@property(nonatomic,strong)NSString* roleId;
@end

NS_ASSUME_NONNULL_END
