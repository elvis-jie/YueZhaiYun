//
//  yzJiaoFeiOrderController.h
//  yzProduct
//
//  Created by 尚广杰 on 2019/2/24.
//  Copyright © 2019 CC. All rights reserved.
//

#import "yzBaseUIViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface yzJiaoFeiOrderController : yzBaseUIViewController
@property(nonatomic,strong)NSString* orderNo;
@property(nonatomic,strong)void (^successJiaoFeiBlock)(NSString* payState);
@end

NS_ASSUME_NONNULL_END
