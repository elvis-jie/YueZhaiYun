//
//  BBTabViewController.m
//  BearWeding
//
//  Created by Tom on 16/3/30.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import "BBTabViewController.h"
#import "BBNaviViewController.h"
#import "yzIndexViewController.h"



@interface BBTabViewController ()

@end

@implementation BBTabViewController
+(instancetype)shareTab{

    static BBTabViewController *shareTab;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        shareTab = [[BBTabViewController alloc]init];

      
        
        
    });

  
    return shareTab;
}
+(void)pushAdViewCntroller{

    
    BBTabViewController *tabVC  =[BBTabViewController shareTab];
    
    BBNaviViewController *mainNavi = tabVC.viewControllers.firstObject;
    [mainNavi pushViewController:[[yzIndexViewController alloc]init] animated:YES];
}


@end
