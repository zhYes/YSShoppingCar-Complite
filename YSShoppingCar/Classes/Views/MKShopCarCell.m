//
//  MKShopCarCell.m
//  发大财
//
//  Created by FDC-iOS on 17/2/18.
//  Copyright © 2017年 meilun. All rights reserved.
//

#import "MKShopCarCell.h"
#import "MKGoodsModel.h"



@implementation MKShopCarCell {
    
    __weak IBOutlet UIImageView *iconImageView;
    __weak IBOutlet UILabel *fabricNameLabel;//面料编号: KIUHDO
    __weak IBOutlet UILabel *fabricNumLabel;//面料序号: 4
    __weak IBOutlet UILabel *fabricPriceLabel;//¥9.00
//    __weak IBOutlet UILabel *fabricX1;// x 1.5
    __weak IBOutlet UIButton *fabricSelectedBtn;//布料选中状态按钮
    __weak IBOutlet UITextField *_ex_buynum_texField;
    __weak IBOutlet UILabel *maLabel;//"码"
    __weak IBOutlet NSLayoutConstraint *maConstraint; // "码"约束
    __weak IBOutlet UILabel *_changeMeterLabel;
    UIButton * _coverClickBtn;  // 增大点击效果的按钮
}

- (IBAction)fabricSelectClick:(UIButton*)sender {
    _goodsModel.isSelected = !_goodsModel.isSelected;
    fabricSelectedBtn.selected = !fabricSelectedBtn.selected;
//    NSLog(@"%zd",self.tag);
    if ([self.shopDelegate respondsToSelector:@selector(shopCellSelectedClick:)]) {
        [self.shopDelegate shopCellSelectedClick:self.tag];
    }
}
/// MARK:数量增加按钮
- (IBAction)plusBtnClick {
    if (_ex_buynum_texField.editing) {
        return;
    }
    // 保存之前值
    float beforeBuyNum = _goodsModel.goods_number;
    // 判断不能大于20
    if (_ex_buynum_texField.text.floatValue == 20) {
        return;
    }
    /// 修改模型数据
    _ex_buynum_texField.text = [NSString stringWithFormat:@"%.1f",_ex_buynum_texField.text.floatValue + 0.5];
    _goodsModel.goods_number = _ex_buynum_texField.text.floatValue;
    if ([self.shopDelegate respondsToSelector:@selector(shopCellEndEditerClick:beforeBuyNum:)]) {
        [self.shopDelegate shopCellEndEditerClick:self.tag beforeBuyNum:beforeBuyNum];
    }
    /// 传递给服务器 一会写 $$$$$$$$
}
- (IBAction)reduceBtnClick {
    if (_ex_buynum_texField.editing) {
        return;
    }
    // 保存之前值
    float beforeBuyNum = _goodsModel.goods_number;
    // 判断不能小于0.5
    if (_ex_buynum_texField.text.floatValue == 0.5) {
        return;
    }
    /// 修改模型数据
    _ex_buynum_texField.text = [NSString stringWithFormat:@"%.1f",_ex_buynum_texField.text.floatValue - 0.5];
    _goodsModel.goods_number = _ex_buynum_texField.text.floatValue;
    if ([self.shopDelegate respondsToSelector:@selector(shopCellEndEditerClick:beforeBuyNum:)]) {
        [self.shopDelegate shopCellEndEditerClick:self.tag beforeBuyNum:beforeBuyNum];
    }
    /// 传递给服务器 一会写 $$$$$$$$
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //    NSLog(@"%@",string);
    //    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    int i = 0;
    while (i < string.length) {
        NSString * string1 = [string substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string1 rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            //            res = NO;
            return NO;
            break;
        }
        i++;
    }
    
    NSRange ran = [textField.text rangeOfString:@"."];
    if ([textField.text containsString:@"."]) {//存在小数点
        
        //判断小数点的位数
        if (range.location - ran.location <= 1) {
            if ([string isEqualToString:@""]) {
                _ex_buynum_texField.text = [NSString stringWithFormat:@"%zd",(NSInteger)(_ex_buynum_texField.text.floatValue - 0.5)];
                if (_ex_buynum_texField.text.floatValue < 20) {
                    
                    maConstraint.constant = 43;
                }
                
                if (_ex_buynum_texField.text.floatValue < 10) {
                    
                    maConstraint.constant = 38;
                }
                
                float ma = _ex_buynum_texField.text.floatValue / 1.0936133;
                _changeMeterLabel.text = [NSString stringWithFormat:@"合%.2f米",ma];
                return NO;
            }
            return YES;
        }else{
            return NO;
        }
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        _changeMeterLabel.hidden = NO;
        maLabel.hidden = NO;
        
        float changeMi = _ex_buynum_texField.text.floatValue;
        
        if (changeMi < 10) {
            maConstraint.constant = 38;
        }
        
        if ((changeMi < 10) & ([string containsString:@"."])) { //小于10 有小数点的情况
            
            maConstraint.constant = 43;
            _ex_buynum_texField.text = [NSString stringWithFormat:@"%.1f",changeMi + 0.5];
            
        }
        
        if (changeMi >= 10 & changeMi < 20) {
            maConstraint.constant = 43;
            if ([string containsString:@"."]) {
                _ex_buynum_texField.text = [NSString stringWithFormat:@"%.1f",changeMi + 0.5];
                maConstraint.constant = 47;
            }
        }
        
        
        if (changeMi >= 20) {
            _ex_buynum_texField.text = @"20";
            maConstraint.constant = 43;
        }
        
        if (_ex_buynum_texField.text.floatValue == 0) {
            _changeMeterLabel.hidden = YES;
            maLabel.hidden = YES;
        }
        
        // 计算米
        float ma = _ex_buynum_texField.text.floatValue / 1.0936133;
        _changeMeterLabel.text = [NSString stringWithFormat:@"合%.2f米",ma];
        
    });
    
    return YES;
}

/// MARK: 结束编辑数量
- (void)textFieldDidEndEditing:(UITextField *)textField {
    /// 修改模型数据
    float beforeBuyNum = _goodsModel.goods_number;
    if (_ex_buynum_texField.text.floatValue == 0) { // 如果修改后为0恢复原值
        _ex_buynum_texField.text = [NSString stringWithFormat:@"%.1f",beforeBuyNum];
        _changeMeterLabel.hidden = NO;
        maLabel.hidden = NO;
        
        float changeMi = _ex_buynum_texField.text.floatValue;
        
        if (changeMi <= 20) {
            maConstraint.constant = 47;
        }
        if (changeMi < 10) {
            maConstraint.constant = 43;
        }
        // 计算米
        float ma = _ex_buynum_texField.text.floatValue / 1.0936133;
        _changeMeterLabel.text = [NSString stringWithFormat:@"合%.2f米",ma];
        
        return;
    }

    _goodsModel.goods_number = _ex_buynum_texField.text.floatValue;
    if ([self.shopDelegate respondsToSelector:@selector(shopCellEndEditerClick:beforeBuyNum:)]) {
        [self.shopDelegate shopCellEndEditerClick:self.tag beforeBuyNum:beforeBuyNum];
    }
    /// 传递给服务器 一会写 $$$$$$$$
}

- (void)setGoodsModel:(MKGoodsModel *)goodsModel {
    _goodsModel = goodsModel;
    fabricSelectedBtn.selected = _goodsModel.isSelected;
//    NSString * baseurlStr = @"http://www.fdcfabric.com/"; // 图片地址的前缀
    NSString * urlStr = [NSString stringWithFormat:@"%@",goodsModel.goods_thumb];
//    [iconImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"wait"]];  // 设置图片
    
    fabricNameLabel.text = [NSString stringWithFormat:@"面料编号: %@",goodsModel.goods_name]; // 设置商品名称
    fabricNumLabel.text = [NSString stringWithFormat:@"面料序号: %@",goodsModel.choose_num];
    fabricPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",goodsModel.goods_price];// 设置商品价格
//    fabricX1.text = [NSString stringWithFormat:@"x %.2f",goodsModel.goods_number]; // 这款商品的数量
    _ex_buynum_texField.text = [NSString stringWithFormat:@"%.1f",goodsModel.goods_number];
    float ma = goodsModel.goods_number / 1.0936133;
    _changeMeterLabel.text = [NSString stringWithFormat:@"合%.1f米",ma];
    
    _changeMeterLabel.hidden = NO;
    maLabel.hidden = NO;
    
    float changeMi = goodsModel.goods_number;
    
    if (changeMi < 10) {
        maConstraint.constant = 38;
    }
    
    
    if ((changeMi < 10) & ([_ex_buynum_texField.text containsString:@"."])) { //小于10 有小数点的情况
        
        maConstraint.constant = 43;
//        _ex_buynum_texField.text = [NSString stringWithFormat:@"%.1f",changeMi + 0.5];
        
    }
    
    if (changeMi >= 10 & changeMi < 20) {
        maConstraint.constant = 43;
        if ([_ex_buynum_texField.text containsString:@"."]) {
//            _ex_buynum_texField.text = [NSString stringWithFormat:@"%.1f",changeMi + 0.5];
            maConstraint.constant = 47;
        }
    }
    
    
    if (changeMi >= 20) {
        _ex_buynum_texField.text = @"20";
        maConstraint.constant = 43;
    }
    
    if (_ex_buynum_texField.text.floatValue == 0) {
        _changeMeterLabel.hidden = YES;
        maLabel.hidden = YES;
    }
    
    // 计算米
    ma = _ex_buynum_texField.text.floatValue / 1.0936133;
    _changeMeterLabel.text = [NSString stringWithFormat:@"合%.2f米",ma];
//    maConstraint.constant = 50;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _ex_buynum_texField.delegate = self;
    _coverClickBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 100)];
    _coverClickBtn.center = fabricSelectedBtn.center;
    [self addSubview:_coverClickBtn];
    [_coverClickBtn addTarget:self action:@selector(fabricSelectClick:) forControlEvents:UIControlEventTouchUpInside];
}


@end




