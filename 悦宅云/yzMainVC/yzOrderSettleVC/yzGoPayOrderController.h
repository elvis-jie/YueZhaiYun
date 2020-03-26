//
//  yzGoPayOrderController.h
//  yzProduct
//
//  Created by 尚广杰 on 2019/2/24.
//  Copyright © 2019 CC. All rights reserved.
//

#import "yzBaseUIViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface yzGoPayOrderController : yzBaseUIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableV;
@property (weak, nonatomic) IBOutlet UIButton *payMoney;
@property (nonatomic,strong) NSMutableArray* jsonArray;
@property (nonatomic,strong) NSString* orderNo;

@property (nonatomic,strong) NSString* detailType;

@property (nonatomic,assign) float finalMoney;
@end

NS_ASSUME_NONNULL_END
