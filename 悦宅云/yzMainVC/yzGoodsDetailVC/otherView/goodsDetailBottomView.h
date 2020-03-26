//
//  goodsDetailBottomView.h
//  yzProduct
//
//  Created by LiuHQ on 2018/9/21.
//  Copyright © 2018年 CC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol goodsDetailsBottomDelegate <NSObject>



@end

@interface goodsDetailBottomView : UIView
@property (weak, nonatomic) IBOutlet UILabel *cartNum;
@property (weak, nonatomic) IBOutlet UILabel *cartPrice;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cartNumWidthLayout;
- (IBAction)addCartClick:(id)sender;
- (IBAction)toPayClick:(id)sender;
- (IBAction)goCarClick:(id)sender;


@property (nonatomic, copy)void(^addCartBlock)(void);
@property (nonatomic, copy)void(^toPayBlock)(void);
@property (nonatomic, copy)void(^goCarBlock)(void);
@end
