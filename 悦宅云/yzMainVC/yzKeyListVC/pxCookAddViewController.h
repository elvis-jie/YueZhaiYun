//
//  pxCookAddViewController.h
//  yzProduct
//
//  Created by LiuHQ on 2018/9/26.
//  Copyright © 2018年 CC. All rights reserved.
// 添加子钥匙数据

#import "yzBaseUIViewController.h"
#import "yzPxCookInfoModel.h"

@interface pxCookAddViewController : yzBaseUIViewController
@property (weak, nonatomic) IBOutlet UITextField *pxcookMobile;
@property (weak, nonatomic) IBOutlet UITextField *pxcookName;
@property (weak, nonatomic) IBOutlet UIButton *pxcookTime;
@property (weak, nonatomic) IBOutlet UITextView *pxcookRemark;

@property (nonatomic, strong) yzPxCookInfoModel *infoModel;
- (IBAction)submitClick:(id)sender;
- (IBAction)selectedTimeClick:(id)sender;
@property(nonatomic,strong)NSString* finalTime;

@property (nonatomic, copy)void(^backRefreshDataBlock)(yzPxCookInfoModel *model);
@end
