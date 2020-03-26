//
//  yzAddCarController.h
//  yzProduct
//
//  Created by 尚广杰 on 2019/2/6.
//  Copyright © 2019 CC. All rights reserved.
//

#import "yzBaseUIViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^BlockEditSuccess)(void);
typedef void(^BlockAddSuccess)(void);
@interface yzAddCarController : yzBaseUIViewController
@property(nonatomic,strong)UIScrollView* scrollView;
//label
@property(nonatomic,strong)UILabel* typeLab;                //车辆类型
@property(nonatomic,strong)UILabel* typeSortLab;            //车辆种类
@property(nonatomic,strong)UILabel* cardLab;                //车牌号
@property(nonatomic,strong)UILabel* colorLab;               //颜色
@property(nonatomic,strong)UILabel* timeLab;                //可用时段
@property(nonatomic,strong)UILabel* countLab;               //可用次数
@property(nonatomic,strong)UILabel* remarkLab;              //备注
//uitextfield
@property(nonatomic,strong)UITextField* typeTextField;        //车辆类型
@property(nonatomic,strong)UITextField* typeSortTextField;    //车辆种类
@property(nonatomic,strong)UITextField* cardTextField;        //车牌号
@property(nonatomic,strong)UITextField* colorTextField;       //颜色
@property(nonatomic,strong)UITextField* timeTextField;        //可用时段
@property(nonatomic,strong)UITextField* countTextField;       //可用次数
@property(nonatomic,strong)UITextField* remarkTextField;      //备注


@property(nonatomic,strong)NSString* type;     //1  添加   2  编辑


@property (nonatomic, copy) BlockEditSuccess blockEditSuccess;

@property (nonatomic, copy) BlockAddSuccess blockAddSuccess;

@property (nonatomic, strong) NSDictionary* dic;              //编辑时传的数据
@end

NS_ASSUME_NONNULL_END
