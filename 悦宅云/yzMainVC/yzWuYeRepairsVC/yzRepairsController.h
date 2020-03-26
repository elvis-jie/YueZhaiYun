//
//  yzRepairsController.h
//  悦宅云
//
//  Created by 尚广杰 on 2019/4/22.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import "yzBaseUIViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface yzRepairsController : yzBaseUIViewController
@property(nonatomic,strong)UIScrollView* scrollV;
@property(nonatomic,strong)UILabel* quLabel;        //小区
@property(nonatomic,strong)UILabel* typeLabel;      //报修类型
@property(nonatomic,strong)UILabel* nameLabel;      //姓名
@property(nonatomic,strong)UILabel* telLabel;       //电话
@property(nonatomic,strong)UILabel* questionLabel;  //问题描述
@property(nonatomic,strong)UILabel* imageLabel;     //图片上传


@property(nonatomic,strong)UILabel* quNameLabel;
@property(nonatomic,strong)UITextField* nameFiled;
@property(nonatomic,strong)UITextField* telFiled;
@property(nonatomic,strong)UITextView* textView;
@property(nonatomic,strong)UILabel* countLabel;

@property(nonatomic,strong)UIButton* submitBtn;

@property(nonatomic,strong)NSString* name;
@end

NS_ASSUME_NONNULL_END
