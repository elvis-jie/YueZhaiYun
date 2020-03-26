//
//  yzBaseUIViewController.m
//  yzProduct
//
//  Created by LiuHQ on 2018/9/20.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "yzBaseUIViewController.h"

@interface yzBaseUIViewController ()

@end

@implementation yzBaseUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //解决滑动视图顶部空出状态栏高度的问题
    if (@available(iOS 11.0, *)) {
  
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
}





@end
