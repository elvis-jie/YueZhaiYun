//
//  indexGNViewCell.h
//  yzProduct
//
//  Created by CC on 2018/9/20.
//  Copyright © 2018年 CC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol indexGNViewCellDelegate<NSObject>
-(void)toGnViewClick:(NSInteger)currentIndex;
@end

@interface indexGNViewCell : UITableViewCell
- (IBAction)gnClick:(id)sender;
@property (nonatomic, assign)id<indexGNViewCellDelegate>delegate;
@end
