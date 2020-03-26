//
//  BBChooseRootVC.m
//  BearWeding
//
//  Created by Tom on 16/5/12.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import "BBChooseRootVC.h"

#import "BBTabViewController.h"

@implementation BBChooseRootVC

+(void)chooseRootViewController{


    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    

    window.rootViewController = [BBTabViewController shareTab];

        
    

}

@end
