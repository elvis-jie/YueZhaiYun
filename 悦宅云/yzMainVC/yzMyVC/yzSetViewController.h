//
//  yzSetViewController.h
//  悦宅云
//
//  Created by 尚广杰 on 2019/5/6.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import "yzBaseUIViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface yzSetViewController : yzBaseUIViewController
@property (nonatomic, copy)void(^loginOutBlock)(void);
@end

NS_ASSUME_NONNULL_END
