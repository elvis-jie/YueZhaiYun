//
//  yzOnePassController.h
//  yzProduct
//
//  Created by 尚广杰 on 2019/3/14.
//  Copyright © 2019 CC. All rights reserved.
//

#import "yzBaseUIViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface yzOnePassController : yzBaseUIViewController
@property(nonatomic,strong)NSArray* dianTi;
@property(nonatomic,strong)NSString* autoonly;      //id
@property(nonatomic,strong)NSString* autoHexString; //小区id转16进制
@property(nonatomic,strong)NSString* code;          //校验码
@property(nonatomic,strong)NSString* roleId;        //是否是超管
@property(nonatomic,strong)NSString* quId;          //id
@property(nonatomic,assign)NSInteger midTime;       //算出的差值
@end

NS_ASSUME_NONNULL_END
