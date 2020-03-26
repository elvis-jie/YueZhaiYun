//
//  yzXiaoQuModel.h
//  yzProduct
//
//  Created by LiuHQ on 2018/9/26.
//  Copyright © 2018年 CC. All rights reserved.
// 小区model

#import <Foundation/Foundation.h>

@interface yzXiaoQuModel : NSObject<NSCoding>
@property (nonatomic, strong) NSString *atime;

@property (nonatomic, strong) NSString *xiaoqu_id;
@property (nonatomic, strong) NSString *xiaoqu_name;
@property (nonatomic, strong) NSString *wuye_id;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *louYu;
@property (nonatomic, strong) NSString *danYuan;
@property (nonatomic, strong) NSString *floor;
@property (nonatomic, strong) NSString *room;

@property (nonatomic, strong) NSString *danYuanId;
@property (nonatomic, strong) NSString *fangChanId;
@property (nonatomic, strong) NSString *roomId;
@property (nonatomic, strong) NSString *xiaoQuAutoonly;
@property (nonatomic, strong) NSString *unLockStatus;
@property (nonatomic, strong) NSString *isMain;
@property (nonatomic, strong) NSMutableArray* bleArray;


@property (nonatomic, assign) BOOL isSelected;

@end
