//
//  SGDropMenu.h
//  yzProduct
//
//  Created by 尚广杰 on 2019/4/11.
//  Copyright © 2019 CC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SGDropMenuModel;
@class SGDropMenuCell;

typedef NS_ENUM(NSInteger, SGDropMenuLayoutType) {
    SGDropMenuLayoutTypeNormal,  //图片在左, 文字在右
    SGDropMenuLayoutTypeTitle,   //只有文字
};

typedef NS_ENUM(NSInteger, SGDropMenuType) {
    SGDropMenuTypeWeChat, //仿微信
    SGDropMenuTypeQQ, //仿QQ
};

@protocol SGDropMenuDelegate<NSObject>

- (void)didSelectRowAtIndex:(NSInteger)index Title:(NSString *)title Image:(NSString *)image;

@end
@interface SGDropMenu : UIView
/**
 * 显示下拉菜单
 * frame  显示的位置以及大小
 * arrowOffset  箭头的x偏移值
 * titleArr  标题数组
 * imageArr  如果不需要显示图片可穿空
 * layoutType 显示图片和文字或者只显示文字(默认显示图片和文字)
 * type 仿qq还是微信 (如果是自定义可以传任何正整数)
 * rowHeight 每一行的高度
 */
+ (instancetype)showDropMenuFrame:(CGRect)frame ArrowOffset:(CGFloat)arrowOffset TitleArr:(NSArray *)titleArr ImageArr:(NSArray *)imageArr Type:(SGDropMenuType)type LayoutType:(SGDropMenuLayoutType)layoutType RowHeight:(CGFloat)rowHeight Delegate:(id<SGDropMenuDelegate>)delegate;

- (instancetype)initWithFrame:(CGRect)frame ArrowOffset:(CGFloat)arrowOffset TitleArr:(NSArray *)titleArr ImageArr:(NSArray *)imageArr Type:(SGDropMenuType)type LayoutType:(SGDropMenuLayoutType)layoutType RowHeight:(CGFloat)rowHeight Delegate:(id<SGDropMenuDelegate>)delegate;

/** 移除下拉菜单 */
- (void)removeDropMenu;


/** 文字颜色 */
@property (nonatomic, strong) UIColor *titleColor;
/** 线条颜色 */
@property (nonatomic, strong) UIColor *lineColor;
/** 箭头x偏移值 */
@property (nonatomic, assign) CGFloat arrowOffset;
/** 布局类型 (图片再左, 文字在右) */
@property (nonatomic, assign) SGDropMenuLayoutType LayoutType;
/** 箭头的颜色(UIColor类型) */
@property (nonatomic, strong) UIColor *arrowColor;
/** 箭头的颜色(16进制类型, 传16进制值即可, 例 #ffffff) */
@property (nonatomic, copy) NSString *arrowColor16;
/** 代理 */
@property (nonatomic, weak) id <SGDropMenuDelegate>delegate;
@end

@class SGDropMenuModel;
@interface SGDropMenuCell : UITableViewCell

+ (instancetype)dropMenuCellWithTableView:(UITableView *)tableView;

/** 数据模型 */
@property (nonatomic, strong) SGDropMenuModel *model;
/** 图片 */
@property (nonatomic, strong) UIImageView *imageIV;
/** 标题 */
@property (nonatomic, strong) UILabel *titleL;
/** 线条 */
@property (nonatomic, strong) UIImageView *line1;

@end



@interface SGDropMenuModel : NSObject

/** 图片 */
@property (nonatomic, copy) NSString *image;
/** 文字 */
@property (nonatomic, copy) NSString *title;
/** type */
@property (nonatomic, assign) SGDropMenuType type;
/** layoutType */
@property (nonatomic, assign) SGDropMenuLayoutType layoutType;

- (instancetype)initWithDictonary:(NSDictionary *)dict;
+ (instancetype)dropMenuWithDictonary:(NSDictionary *)dict;

@end


NS_ASSUME_NONNULL_END
