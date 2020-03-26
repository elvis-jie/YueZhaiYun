//
//  JMDropMenu.h
//  JMDropMenu
//
//  Created by JM on 2017/12/20.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JMDropMenuModel;
@class JMDropMenuCell;

typedef void(^BlockSelectedMenu)(JMDropMenuModel* model);

@protocol JMDropMenuDelegate<NSObject>

- (void)didSelectRowAtIndex:(NSString*)index Title:(NSString *)title;

@end

@interface JMDropMenu : UIView

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
+ (instancetype)showDropMenuFrame:(CGRect)frame ArrowOffset:(CGFloat)arrowOffset TitleArr:(NSArray *)titleArr RowHeight:(CGFloat)rowHeight Delegate:(id<JMDropMenuDelegate>)delegate;

- (instancetype)initWithFrame:(CGRect)frame ArrowOffset:(CGFloat)arrowOffset TitleArr:(NSArray *)titleArr RowHeight:(CGFloat)rowHeight Delegate:(id<JMDropMenuDelegate>)delegate;

/** 移除下拉菜单 */
- (void)removeDropMenu;


/** 文字颜色 */
@property (nonatomic, strong) UIColor *titleColor;
/** 线条颜色 */
@property (nonatomic, strong) UIColor *lineColor;
/** 箭头x偏移值 */
@property (nonatomic, assign) CGFloat arrowOffset;
/** 箭头的颜色(UIColor类型) */
@property (nonatomic, strong) UIColor *arrowColor;
/** 箭头的颜色(16进制类型, 传16进制值即可, 例 #ffffff) */
@property (nonatomic, copy) NSString *arrowColor16;
/** 代理 */
@property (nonatomic, weak) id <JMDropMenuDelegate>delegate;

/**
 *  click
 */
@property (nonatomic, copy) BlockSelectedMenu blockSelectedMenu;

@end





@class JMDropMenuModel;
@interface JMDropMenuCell : UITableViewCell

+ (instancetype)dropMenuCellWithTableView:(UITableView *)tableView;

/** 数据模型 */
@property (nonatomic, strong) JMDropMenuModel *model;
/** 图片 */
@property (nonatomic, strong) UIImageView *imageIV;
/** 标题 */
@property (nonatomic, strong) UILabel *titleL;
/** 线条 */
@property (nonatomic, strong) UIImageView *line1;

@end



@interface JMDropMenuModel : NSObject

/** 文字 */
@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSString* idStr;

- (instancetype)initWithDictonary:(NSDictionary *)dict;
+ (instancetype)dropMenuWithDictonary:(NSDictionary *)dict;

@end
