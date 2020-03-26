//
//  yzGoodsDetailViewController.h
//  yzProduct
//
//  Created by LiuHQ on 2018/9/21.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "yzBaseUIViewController.h"
#import "yzIndexShopGoodsModel.h"
@interface yzGoodsDetailViewController : yzBaseUIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak)IBOutlet UITableView *listTableView;
//@property (nonatomic, strong) NSString* wugood_id;
//@property (nonatomic, strong) NSString* goods_id;
@property (nonatomic, strong) NSString* type;    //1物业  2悦宅
@property (nonatomic, strong) yzIndexShopGoodsModel* model;
@end
