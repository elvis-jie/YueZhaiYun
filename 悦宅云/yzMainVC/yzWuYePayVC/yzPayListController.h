//
//  yzPayListController.h
//  悦宅云
//
//  Created by 尚广杰 on 2019/11/19.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import "yzBaseUIViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface yzPayListController : yzBaseUIViewController
@property(nonatomic,copy)NSString* title;
@property(nonatomic,copy)NSString* roomId;
@property(nonatomic,strong)NSMutableArray* xiaoquArray;
@end

NS_ASSUME_NONNULL_END
