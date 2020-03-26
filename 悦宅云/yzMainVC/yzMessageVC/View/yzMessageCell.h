//
//  yzMessageCell.h
//  yzProduct
//
//  Created by 尚广杰 on 2019/1/29.
//  Copyright © 2019 CC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface yzMessageCell : UITableViewCell
@property(nonatomic,strong)UIView* backView;
@property(nonatomic,strong)UILabel* titleLab;    //标题
@property(nonatomic,strong)UILabel* timeLab;     //时间
@property(nonatomic,strong)UILabel* contentLab;  //内容
@property(nonatomic,assign)CGFloat finalH;

-(void)getMessageByDic:(NSDictionary*)dic;

@end

NS_ASSUME_NONNULL_END
