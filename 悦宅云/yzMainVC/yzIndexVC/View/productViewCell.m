
//
//  productViewCell.m
//  yzProduct
//
//  Created by 尚广杰 on 2019/4/11.
//  Copyright © 2019 CC. All rights reserved.
//

#import "productViewCell.h"

@implementation productViewCell
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backView = [[UIView alloc]initWithFrame:self.bounds];
        
        self.backView.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.backView];
        self.showImage = [[UIImageView alloc]init];
        [self.backView addSubview:self.showImage];
        
        
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.numberOfLines = 1;
        self.titleLabel.font = YSize(13.0);
        
        [self.backView addSubview:self.titleLabel];
        
        
        self.oldPrice = [[UILabel alloc]init];
        self.oldPrice.textAlignment = NSTextAlignmentLeft;
        self.oldPrice.textColor = [UIColor lightGrayColor];
        self.oldPrice.numberOfLines = 1;
        self.oldPrice.font = YSize(13.0);
        [self.backView addSubview:self.oldPrice];
        
        self.nowPrice = [[UILabel alloc]init];
        self.nowPrice.textAlignment = NSTextAlignmentRight;
        self.nowPrice.textColor = [UIColor redColor];
        self.nowPrice.numberOfLines = 1;
        self.nowPrice.font = YSize(13.0);
        [self.backView addSubview:self.nowPrice];
        
//        self.addBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 40, self.frame.size.height - 40, 30, 30)];
//        [self.addBtn setImage:[UIImage imageNamed:@"购物车"] forState:UIControlStateNormal];
//        [self.backView addSubview:self.addBtn];
        
        
    }
    
    return self;
}

-(void)getMessageByModel:(yzIndexShopGoodsModel *)model{
    

        //    NSString* ids = [NSString stringWithFormat:@"%@",[dic objectForKey:@"biku_goods_id"]];
        self.model = model;
        
        if (![model.goodsId isEqualToString:@"<null>"]) {
            self.titleLabel.hidden = NO;
            self.oldPrice.hidden = NO;
            self.nowPrice.hidden = NO;
            //        self.addBtn.hidden = NO;
            self.showImage.frame = CGRectMake(mDeviceWidth/8 - 10, 15, mDeviceWidth/4 + 20, mDeviceWidth/4 + 20);
            //        [self.showImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageUrl,[dic objectForKey:@"biku_goods_img1"]]] placeholderImage:[UIImage imageNamed:@""]];
            //        self.titleLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"biku_goods_name"]];
            //        self.oldPrice.text = [NSString stringWithFormat:@"￥%@",[dic objectForKey:@"biku_goods_market_price"]];
            //        self.nowPrice.text = [NSString stringWithFormat:@"￥%@",[dic objectForKey:@"biku_goods_shop_price"]];
            
            
            [self.showImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageUrl,model.goodsUrl]] placeholderImage:[UIImage imageNamed:@""]];
            self.titleLabel.text = [NSString stringWithFormat:@"%@",model.goodsName];
            
            NSString* oldMoney = [NSString stringWithFormat:@"￥%.2f",model.goodsMarketPrice/100];
            
            
            
            //中划线
            NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
            NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:oldMoney attributes:attribtDic];
            
            
            self.oldPrice.attributedText = attribtStr;
            self.nowPrice.text = [NSString stringWithFormat:@"￥%.2f",model.goodsPrice/100];
            
            
            CGRect titleRect = [self.titleLabel.text boundingRectWithSize:CGSizeMake(self.frame.size.width - 20, 20) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:YSize(13.0)} context:nil];
            
            self.titleLabel.frame = CGRectMake(10, CGRectGetMaxY(self.showImage.frame) + 5, titleRect.size.width, titleRect.size.height);
            
            self.oldPrice.frame = CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame), titleRect.size.width, titleRect.size.height);
            
            self.nowPrice.frame = CGRectMake(self.frame.size.width - titleRect.size.width - 10, CGRectGetMaxY(self.titleLabel.frame), titleRect.size.width, titleRect.size.height);
        }else{
            self.showImage.frame = self.bounds;
            self.showImage.image = [UIImage imageNamed:@"敬请期待"];
            
            
            self.titleLabel.hidden = YES;
            self.oldPrice.hidden = YES;
            self.nowPrice.hidden = YES;
            //        self.addBtn.hidden = YES;
            
        }
   

}

- (BOOL) isNullObject:(id)object{
    if (object == nil || [object isEqual:[NSNull class]])
    {
                return YES;
        
           }else if ([object isKindOfClass:[NSNull class]])
        {
                  if ([object isEqualToString:@""]) {
                
                return YES;
                
                  }else
                          {
                        return NO;
                        
                    }
            
        }else if ([object isKindOfClass:[NSNumber class]])
        {
                if ([object isEqualToNumber:@0])
            {
                           return YES;
                
            }
            else
                  {
                    return NO;
                    
                      }
            
              }
    return NO;
    
}


@end
