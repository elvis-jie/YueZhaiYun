//
//  tenementAddResultViewController.h
//  yzProduct
//
//  Created by LiuHQ on 2018/9/27.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "yzBaseUIViewController.h"

@interface tenementAddResultViewController : yzBaseUIViewController
@property (weak, nonatomic) IBOutlet UIView *AddSuccessView;
@property (weak, nonatomic) IBOutlet UIView *AddErrorView;
- (IBAction)backIndexClick:(id)sender;
- (IBAction)toDetailClick:(id)sender;
- (IBAction)backClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *goHomeBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (nonatomic, strong) NSString *ten_id;//报修单id
@property (nonatomic, assign) NSInteger result;//0失败，1成功
@end
