//
//  yzKeyListController.m
//  悦宅云
//
//  Created by 尚广杰 on 2019/4/24.
//  Copyright © 2019 尚广杰. All rights reserved.
//

#import "yzKeyListController.h"
#import "yzKeyHeadViewCell.h"
#import "yzKeyFirstCell.h"
#import "yzKeySecondCell.h"
@interface yzKeyListController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView*collectionView;
@end

@implementation yzKeyListController
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        //自动网格布局
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
          [flowLayout setHeaderReferenceSize:CGSizeMake(_collectionView.frame.size.width,50)];
         [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);
        //网格布局
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, mDeviceWidth, mDeviceHeight - kNavBarHeight - KSAFEBAR_HEIGHT) collectionViewLayout:flowLayout];
        //设置数据源代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = RGB(240, 240, 240);
     
        [self.view addSubview:_collectionView];
        //注册cell
        [_collectionView registerClass:[yzKeyFirstCell class] forCellWithReuseIdentifier:@"first"];
         [_collectionView registerClass:[yzKeySecondCell class] forCellWithReuseIdentifier:@"second"];
        [_collectionView registerClass:[yzKeyHeadViewCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
        
    }
    return _collectionView;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self collectionView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    [self setStatusBarBackgroundColor:RGBA(255, 255, 255, 1)];
    [self.navigationController.navigationBar setBackgroundColor:RGBA(255, 255, 255, 1)];
    [self.navigationController.visibleViewController.navigationItem setLeftBarButtonItem:nil];
    
    //左侧返回
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"blackBack"] forState:UIControlStateNormal];
    [backBtn setBackgroundColor:[UIColor clearColor]];
    
    [backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn.titleLabel setFont:[UIFont fontWithName:@"HYJinChangTiJ" size:16]];
    [backBtn setTitleColor:AppBackTitleColor forState:UIControlStateNormal];
    [backBtn setFrame:CGRectMake(0, 0, AutoWitdh(32), AutoWitdh(32))];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationController.visibleViewController.navigationItem setLeftBarButtonItem:backItem];
    //顶部信息
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setText:@"钥匙管理"];
    [titleLabel setFrame:CGRectMake(0, 0, mDeviceWidth/2, NavTopHeight)];
    [titleLabel setFont:[UIFont fontWithName:@"HYJinChangTiJ" size:18]];
    [titleLabel setTextColor:RGB(22, 22, 22)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.navigationController.visibleViewController.navigationItem setTitleView:titleLabel];
    
    [self.navigationController.visibleViewController.navigationItem setRightBarButtonItem:nil];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
}
//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}
-(void)backClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        yzKeyFirstCell* cell = (yzKeyFirstCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"first" forIndexPath:indexPath];
        [cell setBackgroundColor:[UIColor whiteColor]];
        cell.layer.cornerRadius = 5;
    
        return cell;
    }else{
    yzKeySecondCell* cell = (yzKeySecondCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"second" forIndexPath:indexPath];
    
    return cell;
    }
    return nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return CGSizeMake(mDeviceWidth - 20, 50);
    }else
        return CGSizeMake((mDeviceWidth - 30)/2 , 80);
   
}

// 设置区头尺寸高度
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size = CGSizeMake(mDeviceWidth, 50);
    return size;
}
// 设置区尾尺寸高度
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    CGSize size = CGSizeMake(mDeviceWidth, 1);
    return size;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    yzKeyHeadViewCell *reusableHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head" forIndexPath:indexPath];
    NSArray* arr = @[@{@"image":@"业主钥匙",@"title":@"您在自己家的钥匙"},@{@"image":@"子业主钥匙",@"title":@"您在别人家的钥匙"}];
    [reusableHeaderView setMessageByDic:arr[indexPath.section]];
    return  reusableHeaderView;
}

@end
