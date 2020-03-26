//
//  yzJiaoFeiHeaderCell.h
//  yzProduct
//
//  Created by 尚广杰 on 2019/2/24.
//  Copyright © 2019 CC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface yzJiaoFeiHeaderCell : UITableViewCell

@property(nonatomic,strong)UIView* redView;              //红色背景
@property(nonatomic,strong)UILabel* typeLabel;           //发货状态
@property(nonatomic,strong)UIImageView* carImageV;       //小车标
@property(nonatomic,strong)UIImageView* locationImageV;  //定位标
@property(nonatomic,strong)UILabel* nameLabel;           //姓名
@property(nonatomic,strong)UILabel* addressLabel;        //地址
@property(nonatomic,assign)CGFloat finalH;
-(void)getMessageByDic:(NSDictionary*)dic;
@end

NS_ASSUME_NONNULL_END
