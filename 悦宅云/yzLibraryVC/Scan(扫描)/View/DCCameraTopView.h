//
//  DCCameraTopView.h
//  STOExpressDelivery
//
//  Created by LiuHQ on 2018/1/09.
//Copyright © 2018年 CC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCCameraTopView : UIView

/** 左边Item点击 */
@property (nonatomic, copy) dispatch_block_t leftItemClickBlock;
/** 右边Item点击 */
@property (nonatomic, copy) dispatch_block_t rightItemClickBlock;
/** 灯点击 */
@property (nonatomic, copy) dispatch_block_t lightItemClickBlock;
/** 右边第二个Item点击 */
@property (nonatomic, copy) dispatch_block_t rightRItemClickBlock;


@end
