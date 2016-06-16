//
//  ShoppingCartViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/5/19.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "SubmitOrdersView.h"
#import "VideoListCell.h"
#import "IndexSectionView.h"
#import "OrderDetaiViewController.h"
#import "XJMarket.h"

@interface ShoppingCartViewController () <UITableViewDelegate, UITableViewDataSource>
///提交订单视图
@property(nonatomic, strong) SubmitOrdersView *submitOrdersView;
@property(nonatomic, strong) UITableView *tableView;
///析金学堂数据数组
@property(nonatomic, strong) NSMutableArray *dataSourceLesson;
///从业培训数据数组
@property(nonatomic, strong) NSMutableArray *dataSourceTraining;
@property(nonatomic, strong) VideoListCell *videoListCell;
@end

@implementation ShoppingCartViewController
static NSString *ShoppingCarlessonListCell_id = @"ShoppingCarlessonListCell_id";
static CGFloat submitOrdersViewHeight = 50;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationItem.title = @"购物车";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainUI];

    self.dataSourceTraining = [NSMutableArray array];
    self.dataSourceLesson = [[[XJMarket sharedMarket] shoppingCartFor:XJ_XUETANG_SHOP] mutableCopy];
}


#pragma mark- initMainUI

- (void)initMainUI {
    [self setSubmitOrdersView];
    [self setTableView];
}

#pragma mark --setSubmitOrdersView--

- (void)setSubmitOrdersView {
    self.submitOrdersView = [[SubmitOrdersView alloc] initWithFrame:CGRectNull];
    [self.view addSubview:self.submitOrdersView];
    [self.submitOrdersView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.mas_equalTo(submitOrdersViewHeight);
    }];
    [self.submitOrdersView.selectedButton addTarget:self action:@selector(selectedButtonAction:)
                                   forControlEvents:UIControlEventTouchUpInside];
    [self.submitOrdersView.submitOrdersButton addTarget:self action:@selector(submitOrdersButtonAction:)
                                       forControlEvents:UIControlEventTouchUpInside];
    if ([[[[XJMarket sharedMarket] shoppingCartFor:XJ_XUETANG_SHOP] mutableCopy] count] == 0 && [[[XJMarket sharedMarket]
            shoppingCartFor:XJ_CONGYE_PEIXUN_SHOP] count] == 0) {
        self.submitOrdersView.hidden = YES;
    }
}

#pragma mark 全选

- (void)selectedButtonAction:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"全选"]) {
        [sender setTitle:@"取消" forState:UIControlStateNormal];
        self.submitOrdersView.selectedLabel.backgroundColor = [UIColor redColor];
        self.submitOrdersView.selectedLabel.layer.borderColor = [UIColor redColor].CGColor;
        tempPrcie = 0;
        if (self.dataSourceLesson.count != 0) {
            for (TalkGridModel *model in self.dataSourceLesson) {
                model.isSelected = YES;
                tempPrcie += model.price.floatValue;
            }
            [self.tableView reloadData];
        }
        if (self.dataSourceTraining.count != 0) {
            for (TalkGridModel *model in self.dataSourceTraining) {
                model.isSelected = YES;
                tempPrcie += model.price.floatValue;
            }
            [self.tableView reloadData];
        }

        self.submitOrdersView.price.text = [NSString stringWithFormat:@"%.2lf", tempPrcie / 100];
    }
    else if ([sender.titleLabel.text isEqualToString:@"取消"]) {
        [sender setTitle:@"全选" forState:UIControlStateNormal];
        self.submitOrdersView.selectedLabel.backgroundColor = [UIColor whiteColor];
        self.submitOrdersView.selectedLabel.layer.borderColor = [UIColor xjfStringToColor:@"#9a9a9a"].CGColor;

        if (self.dataSourceLesson.count != 0) {
            for (TalkGridModel *model in self.dataSourceLesson) {
                model.isSelected = NO;
            }
            [self.tableView reloadData];
        }

        if (self.dataSourceTraining.count != 0) {
            for (TalkGridModel *model in self.dataSourceTraining) {
                model.isSelected = NO;
            }
            [self.tableView reloadData];
        }

        tempPrcie = 0;
        self.submitOrdersView.price.text = [NSString stringWithFormat:@"%.2lf", tempPrcie / 100];
    }


}

#pragma mark 提交订单

- (void)submitOrdersButtonAction:(UIButton *)sender {
    NSMutableArray *tempArray = [NSMutableArray array];
    if (self.dataSourceLesson.count != 0) {
        for (TalkGridModel *model in self.dataSourceLesson) {
            if (model.isSelected) {
                [tempArray addObject:model];
            }
        }
    }

    if (self.dataSourceTraining.count != 0) {
        for (TalkGridModel *model in self.dataSourceTraining) {
            if (model.isSelected) {
                [tempArray addObject:model];
            }
        }
    }
    if (tempArray.count == 0 || tempArray == nil) {
        [[ZToastManager ShardInstance] showtoast:@"请选择商品"];
    } else {
        OrderDetaiViewController *oderDetaiPage = [OrderDetaiViewController new];
        oderDetaiPage.dataSource = tempArray;
        [self.navigationController pushViewController:oderDetaiPage animated:YES];
    }

}

#pragma mark --setTableView--

- (void)setTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-submitOrdersViewHeight);
    }];

    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if (iPhone5) {
        self.tableView.rowHeight = 100;
    } else {
        self.tableView.rowHeight = 120;
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;

    [self.tableView registerClass:[VideoListCell class] forCellReuseIdentifier:ShoppingCarlessonListCell_id];
}

#pragma mark TabelViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.dataSourceLesson.count;
    }
    return self.dataSourceTraining.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.videoListCell = [self.tableView dequeueReusableCellWithIdentifier:ShoppingCarlessonListCell_id];
    self.videoListCell.teacherName.hidden = NO;
    self.videoListCell.lessonCount.hidden = NO;
    self.videoListCell.price.hidden = NO;
    self.videoListCell.oldPrice.hidden = YES;
    self.videoListCell.selectedLabel.hidden = NO;
    self.videoListCell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (indexPath.section == 0) {
        self.videoListCell.model = self.dataSourceLesson[indexPath.row];
    } else if (indexPath.section == 1) {
        self.videoListCell.model = self.dataSourceTraining[indexPath.row];
    }

    if (!self.videoListCell.model.isSelected) {
        self.videoListCell.selectedLabel.backgroundColor = [UIColor whiteColor];
        self.videoListCell.selectedLabel.layer.borderColor = [UIColor xjfStringToColor:@"#9a9a9a"].CGColor;
    } else {
        self.videoListCell.selectedLabel.backgroundColor = [UIColor redColor];
        self.videoListCell.selectedLabel.layer.borderColor = [UIColor redColor].CGColor;
    }

    return self.videoListCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.dataSourceTraining.count == 0 && section == 1) {
        return 0;
    }
    if (self.dataSourceLesson.count == 0 && section == 0) {
        return 0;
    }
    if (self.dataSourceLesson.count == 0 && self.dataSourceTraining.count == 0) {
        return 0;
    }
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    IndexSectionView *tableHeaderView = [[IndexSectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, 35)];
    if (section == 0) {
        tableHeaderView.titleLabel.text = @"析金学堂";
    }
    else if (section == 1) {
        tableHeaderView.titleLabel.text = @"从业培训";
    }

    tableHeaderView.moreLabel.text = @"";
    tableHeaderView.bottomView.hidden = NO;

    return tableHeaderView;
}

#pragma mark CellDelete
#pragma mark rightAction事件

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (nullable NSString *)tableView:(UITableView *)tableView
        titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        if (indexPath.section == 0) {
            TalkGridModel *model = self.dataSourceLesson[indexPath.row];
            if (model.isSelected) {
                tempPrcie -= model.price.floatValue;
                self.submitOrdersView.price.text = [NSString stringWithFormat:@"%.2lf", tempPrcie / 100];
            }

            [[XJMarket sharedMarket] deleteGoodsFrom:XJ_XUETANG_SHOP goods:@[model]];

            [self.dataSourceLesson removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        }
        if (indexPath.section == 1) {
            [self.dataSourceTraining removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        }
    }
}

static CGFloat tempPrcie = 0;
#pragma mark Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoListCell *cell = (VideoListCell *) [tableView cellForRowAtIndexPath:indexPath];
    TalkGridModel *model = self.dataSourceLesson[indexPath.row];
    if (model.isSelected) {
        cell.selectedLabel.backgroundColor = [UIColor whiteColor];
        cell.selectedLabel.layer.borderColor = [UIColor xjfStringToColor:@"#9a9a9a"].CGColor;
        model.isSelected = !model.isSelected;
        tempPrcie -= model.price.floatValue;
    } else {
        cell.selectedLabel.backgroundColor = [UIColor redColor];
        cell.selectedLabel.layer.borderColor = [UIColor redColor].CGColor;
        model.isSelected = !model.isSelected;
        tempPrcie += model.price.floatValue;
    }
    self.submitOrdersView.price.text = [NSString stringWithFormat:@"%.2lf", tempPrcie / 100];
}

@end
