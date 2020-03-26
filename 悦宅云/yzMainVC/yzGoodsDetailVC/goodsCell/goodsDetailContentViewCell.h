//
//  goodsDetailContentViewCell.h
//  yzProduct
//
//  Created by LiuHQ on 2018/9/21.
//  Copyright © 2018年 CC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface goodsDetailContentViewCell : UITableViewCell<UIWebViewDelegate>
@property (nonatomic,weak)IBOutlet UIWebView *detailWebView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webviewHeightLayout;
-(void)setDetailHtml:(NSString *)detailHtml;
@end
