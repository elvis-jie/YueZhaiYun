//
//  yzPayOrderCell.h
//  yzProduct
//
//  Created by 尚广杰 on 2019/2/23.
//  Copyright © 2019 CC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface yzPayOrderCell : UITableViewCell
@property(nonatomic,strong)UIButton* iconBtn;
@property(nonatomic,strong)UILabel* titleLab;
@property(nonatomic,strong)UILabel* quLab;
@property(nonatomic,strong)UILabel* timeLab;
@property(nonatomic,strong)UILabel* priceLab;
@property(nonatomic,strong)UILabel* typeLab;
-(void)getMessageByDic:(NSDictionary*)dic;
@end

NS_ASSUME_NONNULL_END
