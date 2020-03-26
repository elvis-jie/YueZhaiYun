//
//  indexGoodsProductAttrView.h
//  LemonTree
//
//  Created by LiuHQ on 2018/7/26.
//  Copyright © 2018年 CC. All rights reserved.
// 加入购物车 产品规格选择view

#import <UIKit/UIKit.h>
#import "yzIndexGoodsModel.h"
#import "yzIndexShopGoodsModel.h"
@interface indexGoodsProductAttrView : UIView
@property (weak, nonatomic) IBOutlet UIView *bgView; //底部主view
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage; //产品图片
//@property (weak, nonatomic) IBOutlet UILabel *goodsPrice; //产品价格
@property (weak, nonatomic) IBOutlet UILabel *goodsAttrCount;
@property (weak, nonatomic) IBOutlet UILabel *goodsNumber; //产品数量
@property (weak, nonatomic) IBOutlet UIButton *closeBtn; //关闭按钮
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UIView *specView; //规格视图
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewHeight; //底部主视图view高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *specViewHeight; //规格视图view高度
@property (weak, nonatomic) IBOutlet UILabel *specLabel; //显示已选中规格
- (IBAction)closeClick:(id)sender; //关闭事件
- (IBAction)jianClick:(id)sender; //减数量事件
- (IBAction)addClick:(id)sender; //加数量事件
- (IBAction)okClick:(id)sender; //确认事件
@property (nonatomic, strong) NSMutableArray *jsonArray;
@property (nonatomic, copy)void(^CloseClickBlock)(void);

-(void)setGoodsInfoModel:(yzIndexShopGoodsModel *)model;
-(void)getGoodsAttr:(NSString*)goods_id;

/** 添加购物车 */
@property (nonatomic, copy)void(^addGoodsCartBlock)(NSString* goods_id,NSString *attr_id,NSString *count);
@end

