//
//  MKShopCarController.m
//  发大财
//
//  Created by FDC-iOS on 17/2/18.
//  Copyright © 2017年 meilun. All rights reserved.
//

#import "MKShopCarController.h"
#import "MKShopCarCell.h"
#import "MKOrderListModel.h" // 用订单列表里的数据作为假数据
#import "MKGoodsModel.h"
#import "MKHeaderFooterView.h"




@interface MKShopCarController () <UITableViewDelegate,UITableViewDataSource,shopCarCellDelegate,headerViewDelegate>

@property (nonatomic,strong)NSMutableDictionary *dic;
//@property(nonatomic,strong)NSArray * modelArray; // 模型数组


@end

@implementation MKShopCarController {
    float _totalNum;  // 合计价格
    MKHeaderFooterView *_headerView; // 组头view
    UITableView * _tableView;
    UILabel *_hejiLabel;
    UIButton * allSelectBtn;
}

//懒加载数据数组
- (NSArray *)modelArray {
    if (_modelArray == nil) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

/// 懒加载indexpath字典
- (NSMutableDictionary *)dic {
    if (_dic == nil) {
        _dic = [NSMutableDictionary dictionary];
    }
    return _dic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBase];
    [self setTableList];
    [self setAllpayView];
    [self getData];
}

// 请求网络数据
- (void)getData {
//    NSDictionary * dic = @{
//                           @"user_id":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"]
//                           };
//    [[NetWorkTools sharedNetWorkTools] post_objectWithURLString:@"/group_user.php?act=group_cart" parmiter:dic completeBlock:^(id object) {
//        //                NSLog(@"%@",object);
//        NSMutableArray * nmArray = [NSMutableArray array];
//        NSArray * array = object[@"group_goods_cart"];
//        for (NSDictionary* list in array) {
//            
//            MKOrderListModel* obj = [MKOrderListModel mj_objectWithKeyValues:list];
//            //            NSLog(@"%@---%@",obj.goods,obj.order_id);
//            [nmArray addObject:obj];
//        }
//        _modelArray = nmArray.copy;
//        [_tableView reloadData];
//        
//        [_tableView.mj_header endRefreshing];
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error);
//        [_tableView.mj_header endRefreshing];
//    }];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [_tableView.mj_header endRefreshing];
//    });
}

// 设置表格
- (void)setTableList {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    UINib * nib = [UINib nibWithNibName:@"MKShopCarCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:@"shop"];
    _tableView.rowHeight = 110;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
}

// 基础设置
- (void)setBase {
    
    self.title = @"购物车";
    
}

/// MARK: 底栏 |  要支付的总价
- (void)setAllpayView {
    CGRect  viewFrame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 49, [UIScreen mainScreen].bounds.size.width, 49);
    UIView * allPayView = [[UIView alloc] initWithFrame:viewFrame];
    allPayView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:allPayView];
    CGRect hejiFrame0 = CGRectMake(108, 15, 0, 0);
    UILabel * hejiLabel0 = [[UILabel alloc] initWithFrame:hejiFrame0];
    hejiLabel0.text = @"合计: ";
    [hejiLabel0 sizeToFit];
    [allPayView addSubview:hejiLabel0];
    CGRect hejiFrame = CGRectMake(155, 15, 200, 20);
    _hejiLabel = [[UILabel alloc] initWithFrame:hejiFrame];
    _hejiLabel.textColor = [UIColor redColor];
    _hejiLabel.text = @"¥0.00";
//    [_hejiLabel sizeToFit];
    [allPayView addSubview:_hejiLabel];
    
    CGRect btnFrame = CGRectMake([UIScreen mainScreen].bounds.size.width - 120, 0, 120, 49);
    UIButton * payBtn = [[UIButton alloc] initWithFrame:btnFrame];
    [payBtn setTitle:@"去结算" forState:UIControlStateNormal];
    [payBtn setBackgroundColor:[UIColor redColor]];
    [allPayView addSubview:payBtn];
    
    //全选
    CGRect allSelectFrame = CGRectMake(15, 15, 20, 20);
    allSelectBtn = [[UIButton alloc] initWithFrame:allSelectFrame];
    [allSelectBtn setImage:[UIImage imageNamed:@"gouxuan"] forState:UIControlStateNormal];
    [allSelectBtn setImage:[UIImage imageNamed:@"gouxuan1"] forState:UIControlStateSelected];
    [allSelectBtn addTarget:self action:@selector(allSelectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [allPayView addSubview:allSelectBtn];
    
    UIButton * allBigSlectedBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    allBigSlectedBtn.center = allSelectBtn.center;
    [allPayView addSubview: allBigSlectedBtn];
    [allBigSlectedBtn addTarget:self action:@selector(allSelectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect quanxuanFrame = CGRectMake(45, 15, 0, 0);
    UILabel * quanxuanLabel = [[UILabel alloc] initWithFrame:quanxuanFrame];
    quanxuanLabel.text = @"全选";
    [quanxuanLabel sizeToFit];
    [allPayView addSubview:quanxuanLabel];
    
}

/// MARK: 全选的点击事件
- (void)allSelectBtnClick: (UIButton*)allSelectedBtn{
    allSelectedBtn.selected = !allSelectedBtn.selected; // 修改全选按钮的状态
    if (allSelectedBtn.selected) { // 如果全选按钮改变了为选中
        
        for (int i = 0; i <_modelArray.count; i ++) {
            MKOrderListModel * listModel = _modelArray[i];
            if (!listModel.groupSelected) {//遍历如果组不是选中状态
                [self headerSelectedBtnClick:i]; //模拟组头点击了一次
                
            }
        }
    }else { // 全选按钮改变为不选中 那么所有商品都不选中!
        for (int i = 0; i < _modelArray.count; i ++) { // 遍历所有的组头点击
            [self headerSelectedBtnClick:i];
        }
    }
}

//左拉抽屉(删除和修改按钮)
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 添加一个删除按钮
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        MKOrderListModel*listModel = _modelArray[indexPath.section];
        
        NSMutableArray*goodsModel = (NSMutableArray*)listModel.goods;
        
        /// 如果删除的是带勾选的则计算一次数值
        MKGoodsModel*goodModel = (MKGoodsModel*)goodsModel[indexPath.row];
        if (goodModel.isSelected) {
            float goods_price = goodModel.goods_price;               //价格
            float goods_number = goodModel.goods_number;   // 数量
            _totalNum -= goods_price * goods_number;
            _hejiLabel.text = [NSString stringWithFormat:@"%.2f",_totalNum];
            if ([_hejiLabel.text containsString:@"-"]) {
                _hejiLabel.text = @"0";
            }
        }
        
        [goodsModel  removeObjectAtIndex:indexPath.row];    // 删除操作放到最后
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if (goodsModel.count == 0) {
            NSMutableArray *temp = [NSMutableArray arrayWithArray:_modelArray];
//            [temp arraywitharray:_modelList];
//            temp = _modelList;
            [temp removeObjectAtIndex:indexPath.section];
            _modelArray = temp;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [tableView reloadData];
        });
    }];
    
    // 修改资料按钮
    UITableViewRowAction *editRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"修改"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
    }];
    
    editRowAction.backgroundColor = [UIColor blueColor];
    // 将设置好的按钮放到数组中返回
    return @[deleteRowAction, editRowAction];
}

// 组头的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
}

/// MARK: header | 组名
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    MKOrderListModel*listModel = _modelArray[section];
    _headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MKShopCarHeader"];
    if (_headerView == nil) {
        
        _headerView = [[MKHeaderFooterView alloc] init];
        _headerView.headerDelegate = self;
    }
    _headerView.orderListModel = listModel;
    
    
    _headerView.tag = section;
    _headerView.headerBtn.selected = listModel.groupSelected;
    if (listModel.goods.count == 0) {
        return nil;
    }
    return _headerView;
}


#pragma mark - 代理方法组头header的选中状态
- (void)headerSelectedBtnClick:(NSInteger)section {
    //    NSLog(@"%zd",section);
    MKOrderListModel*listModel = _modelArray[section];
    listModel.groupSelected = !listModel.groupSelected;

    
    // 判断如果点击 | header选中
    if (listModel.groupSelected) {
        
        //    /// 判断组头的点击改变全选按钮
        NSInteger tempGroupSelectNum = 0;
        for (MKOrderListModel *model in _modelArray) {
            if (model.groupSelected) {
                tempGroupSelectNum ++;
            }
            if (tempGroupSelectNum == _modelArray.count) {
                allSelectBtn.selected = YES;
            }
        }
        
        
        for (MKGoodsModel* goodsModel in listModel.goods) {
            
            if (!goodsModel.isSelected) {                                       //下面不是选中状态的cell 将价格加入到总价当中
                float goods_price = goodsModel.goods_price;               //价格
                float goods_number = goodsModel.goods_number;   // 数量
                _totalNum += goods_price * goods_number;
                goodsModel.isSelected = YES;
            }
            
        }
    } else {  // 取消header选中 所有都取消
        //全选按钮变为不选中
        allSelectBtn.selected = NO;
        for (MKGoodsModel* goodsModel in listModel.goods) {
            goodsModel.isSelected = NO;
            float goods_price = goodsModel.goods_price;               //价格
            float goods_number = goodsModel.goods_number;   // 数量
            _totalNum -= goods_price * goods_number;
        }
    }
//    NSLog(@"总价格为: %.2f",_totalNum);
    _hejiLabel.text = [NSString stringWithFormat:@"¥%.2f",_totalNum - 1 + 1];
    if ([_hejiLabel.text containsString:@"-"]) {
        _hejiLabel.text = @"0";
    }
    [_tableView reloadData];
}

// 数据源 | 几组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _modelArray.count;
}

// 数据源 | 每组几个
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MKOrderListModel * tempModle = (MKOrderListModel*)_modelArray[section];
    return tempModle.goods.count;
}
// cell显示内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     MKShopCarCell*shopCell = [tableView dequeueReusableCellWithIdentifier:@"shop"];
    shopCell.shopDelegate = self;
    //去出对应组的对应商品信息
    shopCell.goodsModel = ((MKOrderListModel*)_modelArray[indexPath.section]).goods[indexPath.row];
    
    // 给cell做标记
    shopCell.tag = (long)indexPath.section *100 + (long)indexPath.row;
//    if (_modelList.count != self.dic.count) {
    
        NSString * cellTag = [NSString stringWithFormat:@"%zd",shopCell.tag];
        NSDictionary* _tempDic = @{
                     cellTag:indexPath
                     };
        [self.dic addEntriesFromDictionary:_tempDic];
//    }


    return shopCell;
}

#pragma mark - cell上的代理方法获 | 取的价格
- (void)shopCellSelectedClick:(NSInteger)shopCellTag {
    
    //判断组的是否选中状态是否修改
    NSString * cellTagStr = [NSString stringWithFormat:@"%zd",shopCellTag];
    NSIndexPath *indexPath = self.dic[cellTagStr];
    MKOrderListModel * listModel = (MKOrderListModel*)_modelArray[indexPath.section];
    //0.便利当前组cell上选中按钮的个数
    NSInteger seletedNum =0;
    for (MKGoodsModel* goodsModel in listModel.goods) {
        if (goodsModel.isSelected) {
            seletedNum += 1;
        }
        // 1.当前组的cell的个数 是否等于 勾选的总数
        if (((MKOrderListModel*)_modelArray[indexPath.section]).goods.count == seletedNum) {
            listModel.groupSelected = YES; //cell改变组头变为选中
            //判断  //cell改变组头 //组头改变全选
            NSInteger selectedNum = 0 ;
            for (MKOrderListModel * tempListModel in _modelArray) {//遍历所有组
                if (tempListModel.groupSelected) {//如果组头是选中的
                    selectedNum += 1;
                }
                if (selectedNum == _modelArray.count) {
                    allSelectBtn.selected = YES;
                }
            }
        } else {
            listModel.groupSelected = NO;
            allSelectBtn.selected = NO;
        }
        [_tableView reloadData];
    }
    
    MKGoodsModel *goodsModel = ((MKOrderListModel*)_modelArray[indexPath.section]).goods[indexPath.row];
    float goods_price = goodsModel.goods_price;
    float goods_number = goodsModel.goods_number;
    if (!goodsModel.isSelected) {
        _totalNum = _totalNum - goods_price*goods_number;
//        NSLog(@"%.2f",_totalNum);
        
    }else {
        
        _totalNum = _totalNum + goods_price*goods_number;
//        NSLog(@"%.2f",_totalNum);
    }
    _hejiLabel.text = [NSString stringWithFormat:@"¥%.2f",_totalNum -1 + 1];
    if ([_hejiLabel.text containsString:@"-"]) {
        _hejiLabel.text = @"¥0.0";
    }
}


/// MARK: - 结束编辑时候的代理方法
- (void)shopCellEndEditerClick:(NSInteger)shopCellTag beforeBuyNum:(float)beforeBuyNum{
    //判断组的是否选中状态是否修改
    NSString * cellTagStr = [NSString stringWithFormat:@"%zd",shopCellTag];
    NSIndexPath *indexPath = self.dic[cellTagStr];
    
    MKGoodsModel *goodsModel = ((MKOrderListModel*)_modelArray[indexPath.section]).goods[indexPath.row];
    float goods_price = goodsModel.goods_price;
    float goods_number = goodsModel.goods_number;
    if (!goodsModel.isSelected) {  // 不作处理
        
    }else {
        
        _totalNum = _totalNum + goods_price*(goods_number - beforeBuyNum);
//        _beforeBuyNum = goods_number;
        //        NSLog(@"%.2f",_totalNum);
    }
    _hejiLabel.text = [NSString stringWithFormat:@"¥%.2f",_totalNum -1 + 1];
    if ([_hejiLabel.text containsString:@"-"]) {
        _hejiLabel.text = @"¥0.0";
    }
}

@end


