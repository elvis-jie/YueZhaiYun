//
//  tenementAddResultViewController.m
//  yzProduct
//
//  Created by LiuHQ on 2018/9/27.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "tenementAddResultViewController.h"
#import "tenementDetailViewController.h" //详情

@interface tenementAddResultViewController ()

@end

@implementation tenementAddResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.view.backgroundColor = RGB(255, 111, 74);
//    self.backBtn.layer.cornerRadius = 5;
    self.backBtn.layer.borderWidth = 1;
    self.backBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    [self.backBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
//    self.goHomeBtn.layer.cornerRadius = 5;
    self.goHomeBtn.layer.borderWidth = 1;
    self.goHomeBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    [self.goHomeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
//    [self.AddSuccessView setBackgroundColor:RGB(255, 111, 74)];
//    [self.AddErrorView setBackgroundColor:RGB(255, 111, 74)];
    
//    UIImageView* imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, mDeviceHeight/2, mDeviceWidth, mDeviceHeight)];
//    imageV.image = [UIImage imageNamed:@"波纹"];
    
    if (self.result) {
        [self.AddSuccessView setHidden:NO];
        [self.AddErrorView setHidden:YES];
//        [self.AddSuccessView addSubview:imageV];
//        [self.AddSuccessView sendSubviewToBack:imageV];
    }else{
        [self.AddSuccessView setHidden:YES];
        [self.AddErrorView setHidden:NO];
//        [self.AddErrorView addSubview:imageV];
//        [self.AddErrorView sendSubviewToBack:imageV];
    }
}


- (IBAction)backIndexClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)toDetailClick:(id)sender {
    tenementDetailViewController *detail = [[tenementDetailViewController alloc] init];
    detail.ten_id = self.ten_id;
    [self.navigationController pushViewController:detail animated:YES];
}

- (IBAction)backClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
