//
//  tenementHeaderView.m
//  yzProduct
//
//  Created by LiuHQ on 2018/9/27.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "tenementHeaderView.h"

@interface tenementHeaderView()
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) NSMutableArray *jsonArray;
@end

@implementation tenementHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(NSMutableArray *)jsonArray{
    if (!_jsonArray) {
        _jsonArray = [[NSMutableArray alloc] init];
    }
    return _jsonArray;
}
-(NSMutableArray *)buttonArray{
    if (!_buttonArray) {
        _buttonArray = [[NSMutableArray alloc] init];
    }
    return _buttonArray;
}
-(void)setStateClassArray:(NSMutableArray *)array{
    self.jsonArray = array;
    int buttonWidth = (mDeviceWidth-(15*(array.count+1)))/array.count;
    for (int i = 0; i < array.count; i ++) {
        tenementClassModel *classModel = (tenementClassModel *)[self.jsonArray objectAtIndex:i];
        UIButton *selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        selectedButton.frame = CGRectMake((i+1)*15+(i*buttonWidth), 0, buttonWidth, 47);
        [selectedButton setTitle:classModel.t_display forState:UIControlStateNormal];
        [selectedButton setTitleColor:RGB(22, 22, 22) forState:UIControlStateNormal];
        [selectedButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [selectedButton.titleLabel setFont:YSize(15.0)];
//        [selectedButton setBackgroundImage:[UIImage imageNamed:@"yz_repairs_selected_btn"] forState:UIControlStateSelected];
        [selectedButton setBackgroundImage:nil forState:UIControlStateNormal];
        if (i == 0) {
            selectedButton.selected = YES;
        }
        selectedButton.tag = i;
        [selectedButton addTarget:self action:@selector(typeClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:selectedButton];
        [self.buttonArray addObject:selectedButton];
    }
    self.line = [[UILabel alloc]initWithFrame:CGRectMake(5, 46, mDeviceWidth/4 - 10, 1)];
    [self.line setBackgroundColor:[UIColor redColor]];
    [self addSubview:self.line];
    
//    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, mDeviceWidth, 1)];
//    [topLabel setBackgroundColor:RGB(240, 240, 240)];
//    [self addSubview:topLabel];
//    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 46, mDeviceWidth, 1)];
//    [bottomLabel setBackgroundColor:RGB(240, 240, 240)];
//    [self addSubview:bottomLabel];
}

- (void)typeClick:(UIButton *)sender {
    for (int i = 0; i < self.jsonArray.count; i ++) {
        UIButton *button = (UIButton *)[self.buttonArray objectAtIndex:i];
        tenementClassModel *classModel = (tenementClassModel *)[self.jsonArray objectAtIndex:i];
        if (i == sender.tag) {
            
            CGRect rect = self.line.frame;
            rect.origin.x = mDeviceWidth/4*i + 5;
            
            self.line.frame = rect;
            button.selected = YES;
            if (self.typeClickBlock) {
                self.typeClickBlock(classModel.t_id);
            }
        }else{
            button.selected = NO;
        }
    }
    
}
@end
