//
//  yzLoginViewController.h
//  yzProduct
//
//  Created by LiuHQ on 2018/9/20.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "yzBaseUIViewController.h"

@interface yzLoginViewController : yzBaseUIViewController<UITextViewDelegate>
@property(nonatomic, strong) UIImageView* logoImage;
@property(nonatomic, strong) UIButton* seleBtn;
@property(nonatomic, strong) UITextView* textView;


@property (weak, nonatomic) IBOutlet UITextField *loginMobile;
@property (weak, nonatomic) IBOutlet UITextField *loginCode;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;
@property (weak, nonatomic) IBOutlet UIImageView *backImage;
- (IBAction)getCodeClick:(id)sender;
- (IBAction)loginClick:(id)sender;
- (IBAction)wechatClick:(id)sender;
@property (nonatomic, copy)void(^loginSuccessBlock)(void);
@end
