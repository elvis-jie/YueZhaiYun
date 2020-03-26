//
//  addressAddViewController.h
//  yzProduct
//
//  Created by LiuHQ on 2018/9/25.
//  Copyright © 2018年 CC. All rights reserved.
// 添加收货地址

#import "yzBaseUIViewController.h"

@interface addressAddViewController : yzBaseUIViewController<UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *listScrollivew;
@property (weak, nonatomic) IBOutlet UITextField *contactName;
@property (weak, nonatomic) IBOutlet UITextField *contactMobile;
@property (weak, nonatomic) IBOutlet UIButton *contactCountry;
@property (weak, nonatomic) IBOutlet UITextView *contactDetail;
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIView *listScrollContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContentHeight;
- (IBAction)locationClick:(id)sender;
- (IBAction)defaultBtn:(id)sender;
- (IBAction)saveClick:(id)sender;
/** 地址id */
@property (nonatomic, strong) NSString *address_id;
/** 返回刷新数据 */
@property (nonatomic, copy)void(^backRefreshDataBlock)(void);
@end
