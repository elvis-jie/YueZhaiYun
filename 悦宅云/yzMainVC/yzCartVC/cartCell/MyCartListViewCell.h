//
//  MyCartListViewCell.h
//  tjcclzShopC
//
//  Created by LiuHQ on 2018/5/10.
//  Copyright © 2018年 CC. All rights reserved.
// 购物车列表cell

#import <UIKit/UIKit.h>
#import "yzCartGoodsModel.h" //购物车产品

@protocol MyCartListViewCellDelegate<NSObject>
///** 增加或减少数量 */
//-(void)goodsNumAddBlock:(CartGoodsInfosModel *)model;
/** 选中与未选中事件 */
//-(void)goodsSelectedBlock:(yzCartShopGoodsModel *)model;
@end

@interface MyCartListViewCell : UITableViewCell
@property (nonatomic, assign) id<MyCartListViewCellDelegate>delegate;
/** 选中按钮 */
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
/** 产品图片 */
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
/** 产品名称 */
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
/** 产品描述 */
@property (weak, nonatomic) IBOutlet UILabel *goodsDesc;
/** 产品价格 */
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
@property (weak, nonatomic) IBOutlet UILabel *goodsMarketPrice;
/** 产品减少数量 */
@property (weak, nonatomic) IBOutlet UIButton *subtractBtn;
/** 产品数量 */
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
/** 产品增加数量 */
@property (weak, nonatomic) IBOutlet UILabel *goodsNum;
/** 减少数量事件 */
- (IBAction)subtractClick:(id)sender;
/** 增加数量事件 */
- (IBAction)addClick:(id)sender;
/** 选中与未选中 */
-(IBAction)selectedClick:(id)sender;

/** 选中产品 */
@property (nonatomic, copy) void (^goodsCheckBlock)(yzCartShopGoodsModel *model);
/** 产品减少 */
@property (nonatomic, copy) void (^goodsJianBlock)(yzCartShopGoodsModel *model);
/** 产品增加 */
@property (nonatomic, copy) void (^goodsAddBlock)(yzCartShopGoodsModel *model);

@property (nonatomic, strong) yzCartShopGoodsModel *goodsInfoModel;

-(void)setGoodsInfoData:(yzCartShopGoodsModel *)model;

@end
