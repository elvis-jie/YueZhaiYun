//
//  yzOrderSettleViewController.h
//  yzProduct
//
//  Created by LiuHQ on 2018/9/25.
//  Copyright © 2018年 CC. All rights reserved.
// 结算单页面

#import "yzBaseUIViewController.h"

@interface yzOrderSettleViewController : yzBaseUIViewController<UITableViewDelegate,UITableViewDataSource>
- (IBAction)createOrderClick:(id)sender;

@property (nonatomic, weak) IBOutlet UITableView *listTableView;
@property (nonatomic, copy)void(^cartViewRefreshBlock)(void);

@end
