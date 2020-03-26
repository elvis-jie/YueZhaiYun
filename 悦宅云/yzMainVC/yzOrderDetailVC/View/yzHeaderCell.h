//
//  yzHeaderCell.h
//  yzProduct
//
//  Created by 尚广杰 on 2019/2/15.
//  Copyright © 2019 CC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "yzOrderDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface yzHeaderCell : UITableViewCell
@property(nonatomic,strong)UIView* redView;              //红色背景
@property(nonatomic,strong)UILabel* typeLabel;           //发货状态
@property(nonatomic,strong)UIImageView* carImageV;       //小车标
@property(nonatomic,strong)UIImageView* locationImageV;  //定位标
@property(nonatomic,strong)UILabel* nameLabel;           //姓名
@property(nonatomic,strong)UILabel* addressLabel;        //地址
@property(nonatomic,assign)CGFloat finalH;


-(void)getMessageByModel:(yzOrderDetailModel*)model address:(NSDictionary*)dic;
@end

NS_ASSUME_NONNULL_END
