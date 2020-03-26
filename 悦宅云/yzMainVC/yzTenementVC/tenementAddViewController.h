//
//  tenementAddViewController.h
//  yzProduct
//
//  Created by LiuHQ on 2018/9/27.
//  Copyright © 2018年 CC. All rights reserved.
// 物业报修

#import "yzBaseUIViewController.h"

@interface tenementAddViewController : yzBaseUIViewController
@property (weak, nonatomic) IBOutlet UIButton *roomName; //小区
@property (weak, nonatomic) IBOutlet UIButton *typeOne;  //设备
@property (weak, nonatomic) IBOutlet UIButton *typeTwo;     //房屋
@property (weak, nonatomic) IBOutlet UIButton *typeThree;    //其他
@property (weak, nonatomic) IBOutlet UITextField *tenName;  //姓名
@property (weak, nonatomic) IBOutlet UITextField *tenMobile;    //手机号
@property (weak, nonatomic) IBOutlet UITextView *renRemark;     //描述
@property (weak, nonatomic) IBOutlet UIButton *tenPicAdd;       //添加图片
@property (weak, nonatomic) IBOutlet UIView *tenPicView;        //图片view
- (IBAction)submitClick:(id)sender;
- (IBAction)addPicClick:(id)sender;
- (IBAction)typeClick:(id)sender;
- (IBAction)selectedQuClick:(id)sender;

@end
