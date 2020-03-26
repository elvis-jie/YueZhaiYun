//
//  indexGoodsProductAttrView.m
//  LemonTree
//
//  Created by LiuHQ on 2018/7/26.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "indexGoodsProductAttrView.h"
#import "GoodsSpecCollectCell.h"
#import "GoodsSpecNameCollectReusableView.h"
#import "yzIndexGoodsAttrModel.h" //规格

@interface indexGoodsProductAttrView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, weak) IBOutlet UICollectionView *sepcCollectionView;
@property (nonatomic, strong) yzIndexShopGoodsModel *goodsModel;
@end

static NSString *GoodsSpecCollectCellId = @"GoodsSpecCollectCell";
static NSString *GoodsSpecNameCollectReusableViewID = @"GoodsSpecNameCollectReusableView";
@implementation indexGoodsProductAttrView
-(NSMutableArray *)jsonArray{
    if (!_jsonArray) {
        _jsonArray = [[NSMutableArray alloc] init];
    }
    return _jsonArray;
}
-(yzIndexGoodsModel *)goodsModel{
    if (!_goodsModel) {
        _goodsModel = [[yzIndexGoodsAttrModel alloc] init];
    }
    return _goodsModel;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"indexGoodsProductAttrView" owner:nil options:nil]firstObject];
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumInteritemSpacing = AutoWitdh(5);//最小列间距
        layout.minimumLineSpacing = AutoHeight(5);// 最小行间距
        // 设置item的内边距
        layout.sectionInset = UIEdgeInsetsMake(0,3,0,3);
        [self.sepcCollectionView setCollectionViewLayout:layout];
        self.sepcCollectionView.delegate = self;
        self.sepcCollectionView.dataSource = self;
        self.sepcCollectionView.showsVerticalScrollIndicator = NO;
        self.sepcCollectionView.showsHorizontalScrollIndicator = NO;
        self.sepcCollectionView.alwaysBounceVertical = YES;
        self.sepcCollectionView.scrollEnabled = NO;
        //注册Cell
        [self.sepcCollectionView registerNib:[UINib nibWithNibName:GoodsSpecCollectCellId bundle:nil] forCellWithReuseIdentifier:GoodsSpecCollectCellId];
        //注册Header
        [self.sepcCollectionView registerNib:[UINib nibWithNibName:GoodsSpecNameCollectReusableViewID bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:GoodsSpecNameCollectReusableViewID];
        
         [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    self.frame = frame;
    return self;
}
#pragma mark - <UITableViewDataSource>
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//实现宽度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    yzIndexGoodsAttrModel *attrModel = (yzIndexGoodsAttrModel *)[self.jsonArray objectAtIndex:indexPath.row];
    float width = [yzProductPubObject widthForString:attrModel.biku_goods_attr_name fontSize:16 andHeight:30];
    
    return CGSizeMake(20+width, 30);
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.jsonArray.count;
}

#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.sepcCollectionView.frame.size.width, 35);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        GoodsSpecNameCollectReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:GoodsSpecNameCollectReusableViewID forIndexPath:indexPath];
//        [headerView setSpecTitleName:(GoodsSpecificationModel *)[self.jsonArray objectAtIndex:indexPath.section]];
        reusableview = headerView;
    }
    return reusableview;
}
#pragma mark - <UICollectionViewDelegate>
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.sepcCollectionView.contentSize.height < mDeviceWidth) {
        self.sepcCollectionView.scrollEnabled = NO;
        float height = self.sepcCollectionView.contentSize.height;
        self.specViewHeight.constant = height;
        self.bgViewHeight.constant = 260 + height;
    }else{
        self.sepcCollectionView.scrollEnabled = YES;
    }
    
    
    GoodsSpecCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodsSpecCollectCellId forIndexPath:indexPath];
    [cell setAttrModel:(yzIndexGoodsAttrModel *)self.jsonArray[indexPath.row]];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    for (int i = 0; i < self.jsonArray.count; i ++) {
        yzIndexGoodsAttrModel *attModel = (yzIndexGoodsAttrModel *)[self.jsonArray objectAtIndex:i];
        if (i == indexPath.row) {
            attModel.isSelected = YES;
            [self.goodsAttrCount setText:[NSString stringWithFormat:@"库存%d件",attModel.biku_goods_attr_count]];
            [self.goodsNumber setText:@"1"];
        }else{
            attModel.isSelected = NO;
        }
    }
    [self.sepcCollectionView reloadData];
    
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//-(void)setProductList:(NSMutableArray *)jsonArray picUrl:(NSString *)picUrl GoodsInfoModel:(ShopListGoodsInfoModel *)infoModel{
//    self.jsonArray = jsonArray;
//    self.infoModel = infoModel;
//    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:DefaultGoodsLogo options:SDWebImageHandleCookies];
//    [self.sepcCollectionView reloadData];
//
//    if (self.jsonArray.count == 0) {
//        self.specViewHeight.constant = 0;
//        self.bgViewHeight.constant = 260-103;
//    }
//    [self.goodsPrice setText:[NSString stringWithFormat:@"￥%@",self.infoModel.retail_price]];
//    //将￥字体缩小
//    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:self.goodsPrice.text];
//    NSRange range = NSMakeRange(0, 1);
//    [attString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:range];
//    [self.goodsPrice setAttributedText:attString];
//}
-(void)setGoodsInfoModel:(yzIndexShopGoodsModel *)model{
    self.goodsModel = model;
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageUrl,model.goodsUrl]] placeholderImage:FaultGoodsImg options:SDWebImageRefreshCached];
    [self.goodsName setText:model.goodsName];
}

- (IBAction)closeClick:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 0.0f;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (IBAction)jianClick:(id)sender {
    if ([self.goodsNumber.text intValue] > 1) {
        self.goodsNumber.text = [NSString stringWithFormat:@"%d",([self.goodsNumber.text intValue] - 1)];
    }
}

- (IBAction)addClick:(id)sender {
    self.goodsNumber.text = [NSString stringWithFormat:@"%d",([self.goodsNumber.text intValue] + 1)];
}

- (IBAction)okClick:(id)sender {
    for (int i = 0; i < self.jsonArray.count; i ++) {
        yzIndexGoodsAttrModel *attModel = (yzIndexGoodsAttrModel *)self.jsonArray[i];
        if (attModel.isSelected) {
            if ([self.goodsNumber.text intValue] > attModel.biku_goods_attr_count) {
                [DDProgressHUD showErrorImageWithInfo:@"库存不足"];
                return;
            }
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;

//            [[ShoppingCartAnimaition shareTool] startAnimationandView:self.goodsImage endView:app.bottomHiddenView finishBlock:^(BOOL isFinished) {
//                if (isFinished) {
//
//                }
//            }];
            //加入购物车
            if (self.addGoodsCartBlock) {
                self.addGoodsCartBlock(self.goodsModel.goodsId, attModel.biku_goods_attr_id, self.goodsNumber.text);
            }
        }
    }
    
}
-(void)getGoodsAttr:(NSString*)goods_id{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
    
    [DDProgressHUD show];
    [CCAFNetWork get:[NSString stringWithFormat:@"%@app/biku/listHomeGoodsAttr",postUrl] version:Token parameters:@{@"bikuGoodsId":goods_id} success:^(id object) {
        [DDProgressHUD dismiss];
        NSDictionary *json = object;
        [self.jsonArray removeAllObjects];
        if ([[json objectForKey:@"code"] intValue] == 200) {
            NSMutableArray *goods = [[json objectForKey:@"data"] JSONValue];
            for (int i = 0; i < goods.count; i ++) {
                yzIndexGoodsAttrModel *attrModel = [[yzIndexGoodsAttrModel alloc] init:goods[i]];
                if ( i == 0) {
                    attrModel.isSelected = YES;
                    [self.goodsAttrCount setText:[NSString stringWithFormat:@"库存%d件",attrModel.biku_goods_attr_count]];
                }
                [self.jsonArray addObject:attrModel];
            }
        }else{
            [DDProgressHUD showErrorImageWithInfo:[json objectForKey:@"message"]];
        }
        [self.sepcCollectionView reloadData];
    } failure:^(NSError *error) {
        [DDProgressHUD showErrorImageWithInfo:error.localizedDescription];
    }];
}
@end
