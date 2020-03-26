//
//  yzInviteListCell.h
//  yzProduct
//
//  Created by 尚广杰 on 2019/4/12.
//  Copyright © 2019 CC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface yzInviteListCell : UITableViewCell
@property(nonatomic,strong)UILabel* nameLabel;     //姓名
@property(nonatomic,strong)UILabel* telLabel;       //电话
@property(nonatomic,strong)UILabel* cardLabel;      //车牌号
@property(nonatomic,strong)UILabel* timeLabel;      //时间
@property(nonatomic,strong)UITextView* content;     //备注
@property(nonatomic,assign)float finalH;

-(void)getMessageByDic:(NSDictionary*)dic;
@end

NS_ASSUME_NONNULL_END
