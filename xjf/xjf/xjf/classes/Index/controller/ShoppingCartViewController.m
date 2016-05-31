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

@interface ShoppingCartViewController ()<UITableViewDelegate,UITableViewDataSource>
///提交订单视图
@property (nonatomic, strong) SubmitOrdersView *submitOrdersView;
@property (nonatomic, strong) UITableView *tableView;
///析金学堂数据数组
@property (nonatomic, strong) NSMutableArray *dataSourceLesson;
///从业培训数据数组
@property (nonatomic, strong) NSMutableArray *dataSourceTraining;

//@property (nonatomic, strong) NSMutableArray *selectedIndexArray;

@end

@implementation ShoppingCartViewController
static NSString *ShoppingCarlessonListCell_id = @"ShoppingCarlessonListCell_id";
static CGFloat submitOrdersViewHeight = 50;


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationItem.title = @"购物车";
//    self.selectedIndexArray = [NSMutableArray array];
//    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(rightAction:)];
//    self.navigationItem.rightBarButtonItem = right;
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
- (void)initMainUI
{
    [self setSubmitOrdersView];
    [self setTableView];
}
#pragma mark --setSubmitOrdersView--
- (void)setSubmitOrdersView
{
    self.submitOrdersView = [[SubmitOrdersView alloc] initWithFrame:CGRectNull];
    [self.view addSubview:self.submitOrdersView];
    [self.submitOrdersView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.mas_equalTo(submitOrdersViewHeight);
    }];
    [self.submitOrdersView.selectedButton addTarget:self action:@selector(selectedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
     [self.submitOrdersView.submitOrdersButton addTarget:self action:@selector(submitOrdersButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    if ([[[[XJMarket sharedMarket] shoppingCartFor:XJ_XUETANG_SHOP] mutableCopy]count] == 0 && [[[XJMarket sharedMarket] shoppingCartFor:XJ_CONGYE_PEIXUN_SHOP]count] == 0) {
        self.submitOrdersView.hidden = YES;
    }
    
}
#pragma mark 全选
- (void)selectedButtonAction:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"全选"]) {
        [sender setTitle:@"取消" forState:UIControlStateNormal];
        self.submitOrdersView.selectedLabel.backgroundColor = [UIColor redColor];
        self.submitOrdersView.selectedLabel.layer.borderColor = [UIColor redColor].CGColor;
        
//        [self.selectedIndexArray removeAllObjects];
//        NSIndexPath *indexpath;
//        for (int i = 0; i < self.dataSourceLesson.count; i ++) {
//            indexpath = [NSIndexPath indexPathForRow:i inSection:0];
//            [self.selectedIndexArray addObject:indexpath];
//             VideoListCell *cell = (VideoListCell*)[self.tableView cellForRowAtIndexPath:indexpath];
//            cell.selectedLabel.backgroundColor = [UIColor redColor];
//            cell.selectedLabel.layer.borderColor = [UIColor redColor].CGColor;
//        }
//        
//        for (int i = 0; i < self.dataSourceTraining.count; i ++) {
//            indexpath = [NSIndexPath indexPathForRow:i inSection:1];
//            [self.selectedIndexArray addObject:indexpath];
//            VideoListCell *cell = (VideoListCell*)[self.tableView cellForRowAtIndexPath:indexpath];
//            cell.selectedLabel.backgroundColor = [UIColor redColor];
//            cell.selectedLabel.layer.borderColor = [UIColor redColor].CGColor;
//        }
        if (self.dataSourceLesson.count != 0) {
            for (TalkGridModel *model in self.dataSourceLesson) {
                model.isSelected = YES;
            }
            [self.tableView reloadData];
        }
        if (self.dataSourceTraining.count != 0) {
            for (TalkGridModel *model in self.dataSourceTraining) {
                model.isSelected = YES;
            }
            [self.tableView reloadData];
        }
  
    }
    else if ([sender.titleLabel.text isEqualToString:@"取消"]) {
        [sender setTitle:@"全选" forState:UIControlStateNormal];
        self.submitOrdersView.selectedLabel.backgroundColor = [UIColor whiteColor];
        self.submitOrdersView.selectedLabel.layer.borderColor = [UIColor xjfStringToColor:@"#9a9a9a"].CGColor;

//        [self.selectedIndexArray removeAllObjects];
//        NSIndexPath *indexpath;
//        for (int i = 0; i < self.dataSourceLesson.count; i ++) {
//            indexpath = [NSIndexPath indexPathForRow:i inSection:0];
//            [self.selectedIndexArray removeObject:indexpath];
//            VideoListCell *cell = (VideoListCell*)[self.tableView cellForRowAtIndexPath:indexpath];
//            cell.selectedLabel.backgroundColor = [UIColor whiteColor];
//            cell.selectedLabel.layer.borderColor = [UIColor xjfStringToColor:@"#9a9a9a"].CGColor;
//        }
//        
//        for (int i = 0; i < self.dataSourceTraining.count; i ++) {
//            indexpath = [NSIndexPath indexPathForRow:i inSection:1];
//             [self.selectedIndexArray removeObject:indexpath];
//            VideoListCell *cell = (VideoListCell*)[self.tableView cellForRowAtIndexPath:indexpath];
//            cell.selectedLabel.backgroundColor = [UIColor whiteColor];
//            cell.selectedLabel.layer.borderColor = [UIColor xjfStringToColor:@"#9a9a9a"].CGColor;
//        }
        
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
    }
    

}
#pragma mark 提交订单
- (void)submitOrdersButtonAction:(UIButton *)sender
{
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

    
    OrderDetaiViewController *oderDetaiPage = [OrderDetaiViewController new];
    oderDetaiPage.dataSource = tempArray;
    [self.navigationController pushViewController:oderDetaiPage animated:YES];
}

#pragma mark --setTableView--
- (void)setTableView
{
        self.tableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStylePlain];
        [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view).with.offset(-submitOrdersViewHeight);
        }];
//        self.tableView.allowsMultipleSelection = YES;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        if (iPhone5) {
            self.tableView.rowHeight = 100;
        }else{
            self.tableView.rowHeight = 120;
        }
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.showsVerticalScrollIndicator = NO;
    
        [self.tableView registerClass:[VideoListCell class] forCellReuseIdentifier:ShoppingCarlessonListCell_id];
}
#pragma mark TabelViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
    return self.dataSourceLesson.count;
    }
    return self.dataSourceTraining.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ShoppingCarlessonListCell_id];
    cell.teacherName.hidden = NO;
    cell.lessonCount.hidden = NO;
    cell.price.hidden = NO;
    cell.oldPrice.hidden = NO;
    cell.selectedLabel.hidden = NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (indexPath.section == 0) {
        cell.model = self.dataSourceLesson[indexPath.row];
    }else if (indexPath.section == 1) {
        cell.model = self.dataSourceTraining[indexPath.row];
    }
    
//    if ([self.selectedIndexArray containsObject:indexPath]) {
//        cell.selectedLabel.backgroundColor = [UIColor redColor];
//        cell.selectedLabel.layer.borderColor = [UIColor redColor].CGColor;
//    } else {
//        cell.selectedLabel.backgroundColor = [UIColor whiteColor];
//        cell.selectedLabel.layer.borderColor = [UIColor xjfStringToColor:@"#9a9a9a"].CGColor;
//    }
//    
    if (!cell.model.isSelected) {
        cell.selectedLabel.backgroundColor = [UIColor whiteColor];
        cell.selectedLabel.layer.borderColor = [UIColor xjfStringToColor:@"#9a9a9a"].CGColor;
    } else {
        cell.selectedLabel.backgroundColor = [UIColor redColor];
        cell.selectedLabel.layer.borderColor = [UIColor redColor].CGColor;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
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
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
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
//- (void)rightAction:(UIBarButtonItem *)sender
//{
//    if ([sender.title isEqualToString:@"编辑"]) {
//        sender.title = @"完成";
//        [_tableView setEditing:YES animated:YES];
//    }else{
//        sender.title = @"编辑";
//        [_tableView setEditing:NO animated:YES];
//    }
//}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if (indexPath.section == 0) {
            TalkGridModel *model = self.dataSourceLesson[indexPath.row];
            [[XJMarket sharedMarket] deleteGoodsFrom:XJ_XUETANG_SHOP goods:@[model]];
            
            [self.dataSourceLesson removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        }
        if (indexPath.section == 1) {
            [self.dataSourceTraining removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        }
    }
//    VideoListCell *cell = (VideoListCell*)[tableView cellForRowAtIndexPath:indexPath];
//    if ([self.selectedIndexArray containsObject:indexPath]) {
//        [self.selectedIndexArray removeObject:indexPath];
//        cell.selectedLabel.backgroundColor = [UIColor whiteColor];
//        cell.selectedLabel.layer.borderColor = [UIColor xjfStringToColor:@"#9a9a9a"].CGColor;
//    }
}

#pragma mark Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    VideoListCell *cell = (VideoListCell*)[tableView cellForRowAtIndexPath:indexPath];
//    if ([self.selectedIndexArray containsObject:indexPath]) {
//        [self.selectedIndexArray removeObject:indexPath];
//        cell.selectedLabel.backgroundColor = [UIColor whiteColor];
//        cell.selectedLabel.layer.borderColor = [UIColor xjfStringToColor:@"#9a9a9a"].CGColor;
//    } else {
//        cell.selectedLabel.backgroundColor = [UIColor redColor];
//        cell.selectedLabel.layer.borderColor = [UIColor redColor].CGColor;
//        [self.selectedIndexArray addObject:indexPath];
//    }
        VideoListCell *cell = (VideoListCell*)[tableView cellForRowAtIndexPath:indexPath];
     TalkGridModel *model = self.dataSourceLesson[indexPath.row];
    if (model.isSelected) {
        cell.selectedLabel.backgroundColor = [UIColor whiteColor];
        cell.selectedLabel.layer.borderColor = [UIColor xjfStringToColor:@"#9a9a9a"].CGColor;
        model.isSelected = !model.isSelected;
    } else {
        cell.selectedLabel.backgroundColor = [UIColor redColor];
        cell.selectedLabel.layer.borderColor = [UIColor redColor].CGColor;
        model.isSelected = !model.isSelected;
    }
}

@end
