//
//  yzXiaoQuModel.m
//  yzProduct
//
//  Created by LiuHQ on 2018/9/26.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "yzXiaoQuModel.h"

@implementation yzXiaoQuModel
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.atime forKey:@"atime"];
    [aCoder encodeObject:self.xiaoqu_id forKey:@"xiaoqu_id"];
    [aCoder encodeObject:self.xiaoqu_name forKey:@"xiaoqu_name"];
    [aCoder encodeObject:self.wuye_id forKey:@"xiaoqu_wuyeid"];
    [aCoder encodeObject:self.location forKey:@"location"];
    [aCoder encodeObject:self.louYu forKey:@"louYu"];
    [aCoder encodeObject:self.danYuan forKey:@"danYuan"];
    [aCoder encodeObject:self.floor forKey:@"floor"];
    [aCoder encodeObject:self.room forKey:@"room"];
    [aCoder encodeBool:self.isSelected forKey:@"isSelected"];

    [aCoder encodeObject:self.danYuanId forKey:@"danYuanId"];
    [aCoder encodeObject:self.fangChanId forKey:@"fangChanId"];
    [aCoder encodeObject:self.roomId forKey:@"roomId"];
    [aCoder encodeObject:self.unLockStatus forKey:@"unLockStatus"];
    [aCoder encodeObject:self.isMain forKey:@"isMain"];
    [aCoder encodeObject:self.xiaoQuAutoonly forKey:@"xiaoQuAutoonly"];
    [aCoder encodeObject:self.bleArray forKey:@"dianTiList"];
 
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.atime = [aDecoder decodeObjectForKey:@"atime"];
        self.xiaoqu_id = [aDecoder decodeObjectForKey:@"xiaoqu_id"];
        self.xiaoqu_name = [aDecoder decodeObjectForKey:@"xiaoqu_name"];
        self.wuye_id = [aDecoder decodeObjectForKey:@"xiaoqu_wuyeid"];
        self.location = [aDecoder decodeObjectForKey:@"location"];
        self.louYu = [aDecoder decodeObjectForKey:@"louYu"];
        self.danYuan = [aDecoder decodeObjectForKey:@"danYuan"];
        self.floor = [aDecoder decodeObjectForKey:@"floor"];
        self.room = [aDecoder decodeObjectForKey:@"room"];
        self.unLockStatus = [aDecoder decodeObjectForKey:@"unLockStatus"];
        self.danYuanId = [aDecoder decodeObjectForKey:@"danYuanId"];
        self.fangChanId = [aDecoder decodeObjectForKey:@"fangChanId"];
        self.roomId = [aDecoder decodeObjectForKey:@"roomId"];
        self.xiaoQuAutoonly = [aDecoder decodeObjectForKey:@"xiaoQuAutoonly"];
        self.bleArray = [aDecoder decodeObjectForKey:@"dianTiList"];
        self.isSelected = [aDecoder decodeBoolForKey:@"isSelected"];
        self.isMain = [aDecoder decodeObjectForKey:@"isMain"];
    }
    return self;
}
@end
