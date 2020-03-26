//
//  WBGuideCover.m
//  WBKit_Example
//
//  Created by penghui8 on 2018/8/2.
//  Copyright © 2018年 huipengo. All rights reserved.
//

#import "WBGuideCover.h"

#define MAIN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define MAIN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define wScreenRate (375.0f / MAIN_WIDTH)
#define wAutoFloat(float) (float / wScreenRate)
#define wAutoSize(width, height) CGSizeMake(width / wScreenRate, height / wScreenRate)
#define wAutoPoint(x, y) CGPointMake(x / wScreenRate, y / wScreenRate)
#define wAutoRect(x, y, width, heigth) CGRectMake(x / wScreenRate, y / wScreenRate, width / wScreenRate, heigth / wScreenRate)

static CGFloat const wArrowsImageViewWidth  = 60.0f;
static CGFloat const wArrowsImageViewHeight = 46.0f;

@implementation WBGuideCoverItem

@end

@interface WBGuideCover ()

@property (nonatomic, strong) CAShapeLayer *dashLayer;

@property (nonatomic, strong) UIImageView *arrowsImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *superView;

@property (nonatomic, copy) void(^finishedCompletion)(BOOL finished);

@end

@implementation WBGuideCover

- (void)dealloc {
    
}

- (NSMutableArray<WBGuideCoverItem *> *)guideCoverItems {
    if (!_guideCoverItems) {
        _guideCoverItems = [NSMutableArray array];
    }
    return _guideCoverItems;
}
- (NSMutableArray *)images {
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}
static id _instance = nil;
static dispatch_once_t once_predicate;
+ (instancetype)getInstance {
    dispatch_once(&once_predicate, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (void)showGuideCoverInView:(UIView *)superView completion:(void(^)(BOOL finished))completion {
    if (self.guideCoverItems.count <= 0) {
        
        self.superView = nil;
        !self.finishedCompletion?:self.finishedCompletion(YES);
        
        _instance = nil;
        once_predicate = 0;
        
        return;
    };
    
    self.finishedCompletion = completion;
    
    self.superView = superView?:[UIApplication sharedApplication].keyWindow;
    
    UIView *coverView = [[UIView alloc] initWithFrame:superView.bounds];
    coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.55f];
    [coverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)]];
    [superView addSubview:coverView];
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:superView.bounds];
    
    NSArray* arr = self.guideCoverItems.firstObject;
    if (arr.count>0) {
        for (WBGuideCoverItem *coverItem in arr) {
            if (coverItem.bezierPath == WBBezierPathRound) {
                CGPoint point = wAutoPoint(coverItem.frame.origin.x + coverItem.frame.size.width/2.0f, coverItem.frame.origin.y + coverItem.frame.size.height/2.0f);
                CGFloat radius = coverItem.radius;
                if (radius == 0.0f) {
                    radius = coverItem.frame.size.height/2.0f;
                }
                
                UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:point radius:radius startAngle:0.0f endAngle:2 * M_PI clockwise:NO];
                [bezierPath appendPath:path];
                
                /* 贝塞尔曲线路径 */
                self.dashLayer.path = [UIBezierPath bezierPathWithArcCenter:point radius:radius + 2.0f startAngle:0.0f endAngle:2 * M_PI clockwise:NO].CGPath;
            }
            else if (coverItem.bezierPath == WBBezierPathSquare) {
                CGFloat cornerRadius = 3.0f;
                
                UIBezierPath *path = [[UIBezierPath bezierPathWithRoundedRect:coverItem.frame cornerRadius:cornerRadius] bezierPathByReversingPath];
                [bezierPath appendPath:path];
                
                CGRect c_frame = coverItem.frame;
                CGFloat space = 3.0f;
                c_frame.origin.x -= space;
                c_frame.origin.y -= space;
                c_frame.size.width += (2 * space);
                c_frame.size.height += (2 * space);
                
                /* 贝塞尔曲线路径 */
                self.dashLayer.path = [[UIBezierPath bezierPathWithRoundedRect:c_frame cornerRadius:cornerRadius] bezierPathByReversingPath].CGPath;
            }
            /// 绘制透明区域
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            /* 贝塞尔曲线路径 */
            shapeLayer.path = bezierPath.CGPath;
            [coverView.layer setMask:shapeLayer];
            
            [coverView.layer insertSublayer:self.dashLayer below:shapeLayer];
            
            
            [self resetSubViewsFrame:coverItem.frame superView:coverView imageName:self.images[0]];
        }
        
    }
//    WBGuideCoverItem *coverItem = self.guideCoverItems.firstObject;
    
    
    
   
    [self.images removeObjectAtIndex:0];
    [self.guideCoverItems removeObjectAtIndex:0];
}

- (void)tapGestureRecognizer:(UIGestureRecognizer *)recognizer {
    UIView *coverView = recognizer.view;
    [coverView removeFromSuperview];
    [coverView removeGestureRecognizer:recognizer];
    [[coverView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    coverView = nil;
    
    [self showGuideCoverInView:self.superView completion:self.finishedCompletion];
}

- (void)resetSubViewsFrame:(CGRect)frame superView:(UIView *)view imageName:(NSString*)name{
    
    
    self.arrowsImageView.image = [UIImage imageNamed:name];
    
    if ([name isEqualToString:@"dialog_1"]) {
        if (IS_IPHONE_5S) {
            self.arrowsImageView.frame = CGRectMake(45, 45 + kSaveTopSpace, 256, 234);
        }else if (IS_IPHONE_Xr) {
            self.arrowsImageView.frame = CGRectMake(45, 55 + 24, 256, 234);
        }else if (IS_IPHONE_7P){
            self.arrowsImageView.frame = CGRectMake(45, 45 + kSaveTopSpace, 316, 294);
        }
        else{
        self.arrowsImageView.frame = CGRectMake(45, 55 + kSaveTopSpace, 256, 234);
        }
    }else if([name isEqualToString:@"dialog_2"]){
        if (IS_IPHONE_Xr) {
             self.arrowsImageView.frame = CGRectMake(45, 55 + 24, mDeviceWidth/2, mDeviceWidth/2 + 10);
        }
        else{
        self.arrowsImageView.frame = CGRectMake(45, 55 + kSaveTopSpace, mDeviceWidth/2, mDeviceWidth/2 + 10);
        }
    }else if ([name isEqualToString:@"dialog_3"]){
        if (IS_IPHONE_5S) {
            self.arrowsImageView.frame = CGRectMake(70, 200 + kSaveTopSpace, mDeviceWidth/3*2, mDeviceWidth/3*2 - 10);
        }else if (IS_IPHONE_7){
        self.arrowsImageView.frame = CGRectMake(80, 235 + kSaveTopSpace, mDeviceWidth/3*2, mDeviceWidth/3*2 - 10);
        }else if (IS_IPHONE_7P){
            self.arrowsImageView.frame = CGRectMake(80, 235 + kSaveTopSpace, mDeviceWidth/3*2, mDeviceWidth/3*2 - 10);
        }else if (IS_IPHONE_Xr){
             self.arrowsImageView.frame = CGRectMake(80, 235 + 24, mDeviceWidth/3*2, mDeviceWidth/3*2 - 10);
        }else if (IS_IPHONE_Xs_Max){
            self.arrowsImageView.frame = CGRectMake(80, 235 + 24, mDeviceWidth/3*2, mDeviceWidth/3*2 - 10);
        }else if (IS_IPHONE_X){
            self.arrowsImageView.frame = CGRectMake(80, 235, mDeviceWidth/3*2, mDeviceWidth/3*2 - 10);
        }
    }else if ([name isEqualToString:@"dialog_4"]){
        if (IS_IPHONE_5S) {
            self.arrowsImageView.frame = CGRectMake(10, 210 + kSaveTopSpace, mDeviceWidth/2 + 10, mDeviceWidth/2);
        }else if (IS_IPHONE_7){
        self.arrowsImageView.frame = CGRectMake(45, 255 + kSaveTopSpace, mDeviceWidth/2 + 10, mDeviceWidth/2);
        }else if (IS_IPHONE_7P){
            self.arrowsImageView.frame = CGRectMake(25, 275 + kSaveTopSpace, mDeviceWidth/2 + 10, mDeviceWidth/2);
        }
        else if (IS_IPHONE_Xr){
             self.arrowsImageView.frame = CGRectMake(45, 255 + 24, mDeviceWidth/2 + 10, mDeviceWidth/2);
        }else if (IS_IPHONE_Xs_Max){
            self.arrowsImageView.frame = CGRectMake(45, 255 + 24, mDeviceWidth/2 + 10, mDeviceWidth/2);
        }else if (IS_IPHONE_X){
            self.arrowsImageView.frame = CGRectMake(45, 255 + 14, mDeviceWidth/2 + 10, mDeviceWidth/2);
        }
    }else{
        if (IS_IPHONE_Xr) {
             self.arrowsImageView.frame = CGRectMake(mDeviceWidth/2, mDeviceHeight - mDeviceWidth/3 - 80 - 34, mDeviceWidth/3, mDeviceWidth/3 - 10);
        }else{
        self.arrowsImageView.frame = CGRectMake(mDeviceWidth/2, mDeviceHeight - mDeviceWidth/3 - 80 - kSaveBottomSpace, mDeviceWidth/3, mDeviceWidth/3 - 10);
        }
    }
    
    
    

    if (![self.arrowsImageView isDescendantOfView:view]) {
        [view addSubview:self.arrowsImageView];
    }

}



- (CAShapeLayer *)dashLayer {
    if (!_dashLayer) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        /// 虚线的颜色
        layer.strokeColor = [UIColor whiteColor].CGColor;
        /// 填充虚线内的颜色
        layer.fillColor = nil;
        /// 虚线宽度
        layer.lineWidth = 0.7f;
        /* The cap style used when stroking the path. Options are `butt', `round'
         * and `square'. Defaults to `butt'. */
        layer.lineCap = @"square";
        /// 虚线的每个点长和两个点之间的空隙
        layer.lineDashPattern = @[@3, @2];
        _dashLayer = layer;
    }
    return _dashLayer;
}

//- (UILabel *)titleLabel {
//    if (!_titleLabel) {
//        _titleLabel = [[UILabel alloc] init];
//        _titleLabel.textColor = [UIColor whiteColor];
//        _titleLabel.numberOfLines = 0;
//        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15.0/wScreenRate];
//    }
//    return _titleLabel;
//}

- (UIImageView *)arrowsImageView {
    if (!_arrowsImageView) {
        _arrowsImageView = [[UIImageView alloc] init];
        
    }
    return _arrowsImageView;
}

- (CGSize)sizeWithBoundingRectSize:(CGSize)rectSize attributeFont:(UIFont *)attributeFont text:(NSString *)text {
    if (!([text isKindOfClass:[NSString class]] && text.length > 0)) {
        return CGSizeZero;
    }
    NSDictionary *attributes = @{NSFontAttributeName: attributeFont};
    CGSize stringSize = [text boundingRectWithSize:rectSize
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                        attributes:attributes
                                           context:nil].size;
    return CGSizeMake(ceilf(stringSize.width), ceilf(stringSize.height));
}

+ (NSBundle *)wb_guideCoverBundle
{
    static NSBundle *bundle = nil;
    if (bundle == nil) {
        // 这里不使用mainBundle是为了适配pod 1.x和0.x
        NSString *bundlePath = [[NSBundle bundleForClass:[WBGuideCover class]] pathForResource:@"WBGuideCover" ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath:bundlePath];
    }
    return bundle;
}

@end
