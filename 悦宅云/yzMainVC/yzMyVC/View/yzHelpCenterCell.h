//
//  yzHelpCenterCell.h
//  悦宅云
//
//  Created by 尚广杰 on 2019/4/18.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface yzHelpCenterCell : UITableViewCell
@property(nonatomic,strong)UILabel* titleLabel;
@property(nonatomic,strong)UIImageView* jianTou;
@property(nonatomic,strong)UILabel* answerLabel;
@property(nonatomic,assign)float finalH;
-(void)getMessageByDic:(NSDictionary*)dic type:(NSString*)type;
@end

NS_ASSUME_NONNULL_END
