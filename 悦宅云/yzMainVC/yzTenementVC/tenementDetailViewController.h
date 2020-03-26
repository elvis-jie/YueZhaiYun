//
//  tenementDetailViewController.h
//  yzProduct
//
//  Created by LiuHQ on 2018/9/27.
//  Copyright © 2018年 CC. All rights reserved.
//  报修详情

#import "yzBaseUIViewController.h"

@interface tenementDetailViewController : yzBaseUIViewController
@property (weak, nonatomic) IBOutlet UISlider *tenStateSlider;
@property (weak, nonatomic) IBOutlet UILabel *tenStateOne;
@property (weak, nonatomic) IBOutlet UILabel *tenStateTwo;
@property (weak, nonatomic) IBOutlet UILabel *tenStateThree;
@property (weak, nonatomic) IBOutlet UILabel *tenState;
@property (weak, nonatomic) IBOutlet UILabel *tenQuName;
@property (weak, nonatomic) IBOutlet UILabel *tenBName;
@property (weak, nonatomic) IBOutlet UILabel *tenMobile;
@property (weak, nonatomic) IBOutlet UILabel *tenRemarks;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tenRemarkHeightLayou;
@property (weak, nonatomic) IBOutlet UILabel *tenPicNum;
@property (weak, nonatomic) IBOutlet UIButton *tenPicOne;
@property (weak, nonatomic) IBOutlet UIButton *tenPicTwo;
@property (weak, nonatomic) IBOutlet UIButton *tenPicThree;
@property (nonatomic, strong) NSString *ten_id;//保修单id
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;  //取消报修
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;    //完成

- (IBAction)cancelClick:(id)sender;
- (IBAction)okClick:(id)sender;
@end
