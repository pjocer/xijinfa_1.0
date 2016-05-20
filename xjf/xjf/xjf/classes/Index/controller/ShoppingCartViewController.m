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
@interface ShoppingCartViewController ()<UITableViewDelegate,UITableViewDataSource>
///提交订单视图
@property (nonatomic, strong) SubmitOrdersView *submitOrdersView;
@property (nonatomic, strong) UITableView *tableView;
///析金学堂数据数组
@property (nonatomic, strong) NSMutableArray *dataSourceLesson;
///从业培训数据数组
@property (nonatomic, strong) NSMutableArray *dataSourceTraining;
@end

@implementation ShoppingCartViewController
static NSString *ShoppingCarlessonListCell_id = @"ShoppingCarlessonListCell_id";
static CGFloat submitOrdersViewHeight = 50;


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationItem.title = @"购物车";
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(rightAction:)];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainUI];
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
//    @property (nonatomic, strong) UILabel *selectedLabel;
//    @property (nonatomic, strong) UIButton *selectedButton;
//    @property (nonatomic, strong) UIButton *submitOrdersButton;
//    @property (nonatomic, strong) UILabel *price;
}
#pragma mark 全选
- (void)selectedButtonAction:(UIButton *)sender
{
    
}
#pragma mark 提交订单
- (void)submitOrdersButtonAction:(UIButton *)sender
{
    
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.model = self.dataSource[indexPath.row];
    cell.teacherName.hidden = NO;
    cell.lessonCount.hidden = NO;
    cell.price.hidden = NO;
    cell.oldPrice.hidden = NO;
    cell.selectedLabel.hidden = NO;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    IndexSectionView *tableHeaderView = [[IndexSectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, 35)];
    tableHeaderView.titleLabel.text = @"xxx";
    tableHeaderView.moreLabel.text = @"";
    tableHeaderView.bottomView.hidden = NO;
    return tableHeaderView;
}
#pragma mark CellDelete
#pragma mark rightAction事件
- (void)rightAction:(UIBarButtonItem *)sender
{
    if ([sender.title isEqualToString:@"编辑"]) {
        sender.title = @"完成";
        [_tableView setEditing:YES animated:YES];
    }else{
        sender.title = @"编辑";
        [_tableView setEditing:NO animated:YES];
    }
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        //删除
//        
//        if (self.dataSourceTraining.count == 1 || self.dataSourceLesson.count == 1) {
//            //删除数据
//            if (self.dataSourceTraining.count == 1) {
//                [self.dataSourceTraining removeObject:self.dataSourceTraining[indexPath.row]];
//            }
//            if (self.dataSourceLesson.count == 1) {
//                [self.dataSourceLesson removeObject:self.dataSourceLesson[indexPath.row]];
//            }
//            
//            //删除UI
//            [_tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationTop];
//            
//            
//        }else{
//            
//            //删除数据
//            [array removeObjectAtIndex:indexPath.row];
//            
//            //删除UI
//            [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
//        } 
//    }
}
#pragma mark Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
