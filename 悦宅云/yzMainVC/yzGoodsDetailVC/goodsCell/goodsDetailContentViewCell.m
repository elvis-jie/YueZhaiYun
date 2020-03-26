//
//  goodsDetailContentViewCell.m
//  yzProduct
//
//  Created by LiuHQ on 2018/9/21.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "goodsDetailContentViewCell.h"

@implementation goodsDetailContentViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.detailWebView.delegate = self;
}
#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    float height = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight"]floatValue]; //此方法获取webview的内容高度（建议使用）
    self.webviewHeightLayout.constant = height;
    //设置通知或者代理来传高度
    [[NSNotificationCenter defaultCenter]postNotificationName:@"getCellHightNotification" object:nil userInfo:@{@"height":[NSNumber numberWithFloat:height]}];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
}
-(void)setDetailHtml:(NSString *)detailHtml{
    [self.detailWebView loadHTMLString:detailHtml baseURL:nil];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
