//
//  yzInformationCell.h
//  悦宅云
//
//  Created by 尚广杰 on 2019/4/19.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface yzInformationCell : UITableViewCell
@property(nonatomic,strong)UIView* backView;
@property(nonatomic,strong)UILabel* titleLabel;
@property(nonatomic,strong)UILabel* contentLabel;
@property(nonatomic,strong)UIImageView* imageV;
@property(nonatomic,assign)float finalH;

-(void)getMessageByDic:(NSDictionary*)dic;
@end

NS_ASSUME_NONNULL_END
