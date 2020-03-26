//
//  addressListViewController.h
//  yzProduct
//
//  Created by LiuHQ on 2018/9/25.
//  Copyright © 2018年 CC. All rights reserved.
//  收货地址列表

#import "yzBaseUIViewController.h"

@interface addressListViewController : yzBaseUIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
- (IBAction)addClick:(id)sender;
@property (nonatomic, weak) IBOutlet UITableView *listTableView;
@property (nonatomic, copy)void(^settleOrderRefreshBlock)(void);
@end
