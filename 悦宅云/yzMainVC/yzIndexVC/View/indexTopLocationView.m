//
//  indexTopLocationView.m
//  yzProduct
//
//  Created by CC on 2018/9/20.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "indexTopLocationView.h"
#import "locationListCell.h"

@interface indexTopLocationView()
@property (nonatomic, strong) NSMutableArray *jsonArray;
@end

@implementation indexTopLocationView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.listTableView = [[UITableView alloc] init];
        [self.listTableView setTableFooterView:[UIView new]];
        [self.listTableView setDelegate:self];
        [self.listTableView setDataSource:self];
//        [self.listTableView setBackgroundColor:RGB(240, 240, 240)];
        [self.listTableView setBackgroundColor:[UIColor whiteColor]];
        [self.listTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self addSubview:self.listTableView];
        [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(0);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
        }];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    return self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.jsonArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    locationListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"locationListCell"];
    if (!cell) {
        cell = (locationListCell *)[[[NSBundle mainBundle] loadNibNamed:@"locationListCell" owner:self options:nil] lastObject];
    }
    if ([[self.jsonArray objectAtIndex:indexPath.row] isKindOfClass:[yzPxCookInfoModel class]]) {
        yzPxCookInfoModel *infoModel = (yzPxCookInfoModel *)[self.jsonArray objectAtIndex:indexPath.row];
        [cell.locationName setText:[NSString stringWithFormat:@"%@",infoModel.room_msg]];
    }else if ([[self.jsonArray objectAtIndex:indexPath.row] isKindOfClass:[yzXiaoQuModel class]]){
        yzXiaoQuModel *infoModel = (yzXiaoQuModel *)[self.jsonArray objectAtIndex:indexPath.row];
        
        if (infoModel.louYu.length==1) {
            infoModel.louYu = [@"0" stringByAppendingString:infoModel.louYu];
        }
        if (infoModel.danYuan.length==1) {
            infoModel.danYuan = [@"0" stringByAppendingString:infoModel.danYuan];
        }
//        if (infoModel.floor.length==1) {
//            infoModel.floor = [@"0" stringByAppendingString:infoModel.floor];
//        }
        
        [cell.locationName setText:[NSString stringWithFormat:@"%@-%@-%@-%@",infoModel.xiaoqu_name,infoModel.louYu,infoModel.danYuan,infoModel.room]];
    }else if ([[self.jsonArray objectAtIndex:indexPath.row] isKindOfClass:[NSDictionary class]]){
        NSDictionary* dic = [self.jsonArray objectAtIndex:indexPath.row];
        [cell.locationName setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"roomName"]]];
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[self.jsonArray objectAtIndex:indexPath.row] isKindOfClass:[yzPxCookInfoModel class]]) {
        yzPxCookInfoModel *infoModel = (yzPxCookInfoModel *)[self.jsonArray objectAtIndex:indexPath.row];
        if (self.selectedRoomBlock) {
            self.selectedRoomBlock(infoModel.cook_id, infoModel.room_msg,@"");
        }
    }else if ([[self.jsonArray objectAtIndex:indexPath.row] isKindOfClass:[yzXiaoQuModel class]]){
        yzXiaoQuModel *infoModel = (yzXiaoQuModel *)[self.jsonArray objectAtIndex:indexPath.row];
        

        if (self.selectedQuBlock) {
            self.selectedQuBlock(infoModel);
        }
    }else if ([[self.jsonArray objectAtIndex:indexPath.row] isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dic = [self.jsonArray objectAtIndex:indexPath.row];
        if (self.selectedRoomBlock) {
            self.selectedRoomBlock([dic objectForKey:@"roomId"], @"",@"");
        }
    }
    [self _tapGesturePressed];
}
-(void)refreshData{
    [self.listTableView reloadData];
}
-(NSMutableArray *)jsonArray{
    if (!_jsonArray) {
        _jsonArray = [[NSMutableArray alloc] init];
    }
    return _jsonArray;
}
-(void)setPxCookModel:(NSMutableArray *)jsonArray{
    
    NSLog(@"++++%@",jsonArray);
    
    self.jsonArray = jsonArray;
    [self.listTableView reloadData];
}
-(void)option_show{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [self.listTableView reloadData];
    }];
}
// 点击消失
- (void) _tapGesturePressed {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
