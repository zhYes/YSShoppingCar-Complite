//
//  MKHeaderFooterView.m
//  发大财
//
//  Created by FDC-iOS on 17/2/21.
//  Copyright © 2017年 meilun. All rights reserved.
//

#import "MKHeaderFooterView.h"

@implementation MKHeaderFooterView

- (instancetype)init
{
    self = [super init];
    if (self) {
        CGRect btnFrame = CGRectMake(20, 12, 20, 20);
        _headerBtn = [[UIButton alloc] initWithFrame:btnFrame];
        [_headerBtn setImage:[UIImage imageNamed:@"gouxuan"] forState:UIControlStateNormal];
        [_headerBtn setImage:[UIImage imageNamed:@"gouxuan1"] forState:UIControlStateSelected];
        [_headerBtn addTarget:self action:@selector(headerBtnClick::) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_headerBtn];
        UIButton * bigSelectedBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        bigSelectedBtn.center = _headerBtn.center;
        [self addSubview:bigSelectedBtn];
        [bigSelectedBtn addTarget:self action:@selector(headerBtnClick::) forControlEvents:UIControlEventTouchUpInside];
        
        
        _sectionLabel = [[UILabel alloc] init];
        _sectionLabel.frame = CGRectMake(50, 12, 300, 20);
        [self addSubview:_sectionLabel];
//        NSArray * salerName = @[@"FDC韩国面料",@"FDC日本面料",@"FDC朝鲜面料",@"FDC法国面料"];
//        _sectionLabel.text = [NSString stringWithFormat:@"    %@",salerName[arc4random()%4]];
        self.contentView.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

// 组头的点击事件
- (void)headerBtnClick: (UIButton*)HeaderBtn :(NSInteger)section{
    HeaderBtn.selected = !HeaderBtn.selected;
    if ([self.headerDelegate respondsToSelector:@selector(headerSelectedBtnClick:)]) {
        [self.headerDelegate headerSelectedBtnClick:self.tag];
    }
}

- (void)setOrderListModel:(MKOrderListModel *)orderListModel {
    _orderListModel = orderListModel;
    _sectionLabel.text = _orderListModel.vend_name;
    _headerBtn.selected = orderListModel.groupSelected;
}

@end
