//
//  indexTopLocationView.h
//  yzProduct
//
//  Created by CC on 2018/9/20.
//  Copyright © 2018年 CC. All rights reserved.
// 首页顶部选择地区view

#import <UIKit/UIKit.h>
#import "yzPxCookInfoModel.h"
#import "yzXiaoQuModel.h"
@interface indexTopLocationView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *listTableView;
-(void)refreshData;
-(void)option_show;
-(void)_tapGesturePressed;

-(void)setPxCookModel:(NSMutableArray *)jsonArray;
@property (nonatomic, copy)void(^selectedRoomBlock)(NSString *room_id,NSString *room_name,NSString* wuye_id);
@property (nonatomic, copy)void(^selectedQuBlock)(yzXiaoQuModel * model);
@end
