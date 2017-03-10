//
//  MKShopCarCell.h
//  发大财
//
//  Created by FDC-iOS on 17/2/18.
//  Copyright © 2017年 meilun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKOrderListModel.h"
@class MKGoodsModel;

@protocol shopCarCellDelegate <NSObject>

- (void)shopCellSelectedClick :(NSInteger)shopCellTag;
- (void)shopCellEndEditerClick :(NSInteger)shopCellTag beforeBuyNum:(float)beforeBuyNum;

@end
@interface MKShopCarCell : UITableViewCell <UITextFieldDelegate>
@property (nonatomic,weak)id <shopCarCellDelegate>shopDelegate;
@property (nonatomic ,strong)MKGoodsModel * goodsModel;

@end
