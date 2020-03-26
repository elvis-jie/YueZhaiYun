//
//  yzCartViewController.h
//  yzProduct
//
//  Created by LiuHQ on 2018/9/20.
//  Copyright © 2018年 CC. All rights reserved.
// 购物车

#import "yzBaseUIViewController.h"

@interface yzCartViewController : yzBaseUIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet UIView *cartBottomView;

@end
