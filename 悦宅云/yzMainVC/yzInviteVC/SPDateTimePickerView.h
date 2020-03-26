//
//  SPDateTimePickerView.h
//  SPDateTimePickerViewDemo
//
//  Created by 123456789 on 2018/2/2.
//  Copyright © 2018年 123456789. All rights reserved.
//

#import <UIKit/UIKit.h>




@protocol SPDateTimePickerViewDelegate <NSObject>
@optional
/**
 * 确定按钮
 */
- (void)didClickFinishDateTimePickerView:(NSString*)date dic:(NSDictionary*)dic;
/**
 * 取消按钮
 */
- (void)didClickCancelDateTimePickerView;
@end

@interface SPDateTimePickerView : UIView
/**
 * 设置当前时间
 */
@property(nonatomic, strong)NSDate *currentDate;
/**
 * 设置中心标题文字
 */
@property(nonatomic, copy)NSString *title;

@property(nonatomic, strong)id<SPDateTimePickerViewDelegate>delegate;


/**
 * 隐藏
 */
- (void)hideDateTimePickerView;
/**
 * 显示
 */
- (void)showDateTimePickerView;
@end
