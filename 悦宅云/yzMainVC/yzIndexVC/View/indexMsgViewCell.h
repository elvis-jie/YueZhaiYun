//
//  indexMsgViewCell.h
//  yzProduct
//
//  Created by CC on 2018/9/20.
//  Copyright © 2018年 CC. All rights reserved.
// 首页消息cell

#import <UIKit/UIKit.h>

@interface indexMsgViewCell : UICollectionViewCell

@property(nonatomic,strong)UILabel* line;           //竖线
@property(nonatomic,strong)UIButton* contentBtn;    //展示内容
@property(nonatomic,strong)UILabel* timeLabel;      //时间

-(void)getMessageByDic:(NSDictionary*)dic;

@end
