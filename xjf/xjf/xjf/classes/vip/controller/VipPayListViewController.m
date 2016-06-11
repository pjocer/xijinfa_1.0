//
//  VipPayListViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/6/11.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "VipPayListViewController.h"
#import "VipModel.h"
#import "VipPayListPageChoiceCell.h"
#import "VipPayListPagePrivilegeCell.h"
#import "IndexSectionView.h"
#import "OrderDetaiViewController.h"
#import "TalkGridModel.h"
@interface VipPayListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) VipListModel *dataSourceModel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *footer;
@property (nonatomic, strong) UIView *foot_background;
@end

@implementation VipPayListViewController
static NSString *VipPayListPageChoiceCell_id = @"VipPayListPageChoiceCell_id";
static NSString *VipPayListPagePrivilegeCell_id = @"VipPayListPagePrivilegeCell_id";
static CGFloat tableSectionHeaderH = 35;


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationItem.title = @"会员支付";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTabelView];
    [self requestVipDataApi:vipPriceList method:GET];
}

- (void)requestVipDataApi:(APIName *)lessonListApi
                      method:(RequestMethod)method
{
    __weak typeof(self) wSelf = self;
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:lessonListApi RequestMethod:method];
    
    //tablkListModel_Lesson
    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
        __strong typeof(self) sSelf = wSelf;
        sSelf.dataSourceModel = [[VipListModel alloc] initWithData:responseData error:nil];
        [sSelf.tableView reloadData];
    }failedBlock:^(NSError *_Nullable error) {
    }];
    
}

#pragma mark - initTabelView
- (void)initTabelView {
    self.tableView = [[UITableView alloc]
                      initWithFrame:CGRectMake(0, 0, SCREENWITH, SCREENHEIGHT - 64) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = 70;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[VipPayListPageChoiceCell class] forCellReuseIdentifier:VipPayListPageChoiceCell_id];
    [self.tableView registerClass:[VipPayListPagePrivilegeCell class] forCellReuseIdentifier:VipPayListPagePrivilegeCell_id];
    self.tableView.tableFooterView = self.foot_background;
}

-(UIView *)foot_background {
    if (!_foot_background) {
        _foot_background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, 60)];
        _foot_background.backgroundColor = [UIColor clearColor];
        _footer = [UIButton buttonWithType:UIButtonTypeCustom];
        _footer.frame = CGRectMake(10, 10, SCREENWITH-20, 50);
        _footer.layer.cornerRadius = 5;
        _footer.layer.masksToBounds = YES;
        _footer.backgroundColor = [UIColor xjfStringToColor:@"#e60012"];
        [_footer setTitle:@"立即支付" forState:UIControlStateNormal];
        [_footer setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_footer addTarget:self action:@selector(dredgeVIP) forControlEvents:UIControlEventTouchUpInside];
        [_foot_background addSubview:_footer];
    }
    return _foot_background;
}

#pragma mark TabelViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }
    
    if (self.dataSourceModel.result.count != 0 && self.dataSourceModel.result) {
        VipResultModel *vipResultModel =  self.dataSourceModel.result.firstObject;
        return vipResultModel.deal.count;
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
    VipPayListPagePrivilegeCell *cell = [self.tableView dequeueReusableCellWithIdentifier:VipPayListPagePrivilegeCell_id];
    return cell;
    }
    VipPayListPageChoiceCell *cell = [self.tableView dequeueReusableCellWithIdentifier:VipPayListPageChoiceCell_id];
    if (self.dataSourceModel.result.count != 0 && self.dataSourceModel.result) {
        VipResultModel *vipResultModel =  self.dataSourceModel.result.firstObject;
        cell.model = vipResultModel.deal[indexPath.row];
        if (cell.model.isSelected) {
            cell.selectedLabel.backgroundColor = [UIColor redColor];
            cell.backGroudView.layer.borderColor = [UIColor redColor].CGColor;
        }
        else{
            cell.selectedLabel.backgroundColor = [UIColor whiteColor];
            cell.selectedLabel.layer.borderColor = [UIColor xjfStringToColor:@"#9a9a9a"].CGColor;
            cell.backGroudView.layer.borderColor = [UIColor xjfStringToColor:@"#9a9a9a"].CGColor;
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return tableSectionHeaderH;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    IndexSectionView *sectionView = [[IndexSectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, 35)];
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 34, SCREENWITH, 1)];
    [sectionView addSubview:bottomView];
    bottomView.backgroundColor = BackgroundColor;
    sectionView.moreLabel.hidden = YES;
    
    if (section == 0) {
        sectionView.titleLabel.text = @"会员特权";
    } else if (section == 1) {
        sectionView.titleLabel.text = @"套餐选择";
    }
    return sectionView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (self.dataSourceModel.result.count != 0 && self.dataSourceModel.result) {
            VipResultModel *vipResultModel =  self.dataSourceModel.result.firstObject;
            VipModel *model = vipResultModel.deal[indexPath.row];
            VipPayListPageChoiceCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.selectedLabel.backgroundColor = [UIColor redColor];
            cell.backGroudView.layer.borderColor = [UIColor redColor].CGColor;
            model.isSelected = YES;
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        VipPayListPageChoiceCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.selectedLabel.backgroundColor = [UIColor whiteColor];
        cell.selectedLabel.layer.borderColor = [UIColor xjfStringToColor:@"#9a9a9a"].CGColor;
        cell.backGroudView.layer.borderColor = [UIColor xjfStringToColor:@"#9a9a9a"].CGColor;
        VipResultModel *vipResultModel =  self.dataSourceModel.result.firstObject;
        VipModel *model = vipResultModel.deal[indexPath.row];
        model.isSelected = NO;
        }
}

#pragma mark 立即支付
- (void)dredgeVIP{
    VipResultModel *vipResultModel =  self.dataSourceModel.result.firstObject;
    VipModel *model = [VipModel new];
    for (VipModel *tempModel in vipResultModel.deal) {
        if (tempModel.isSelected) {
            model = tempModel;
        }
    }
    NSDictionary *dic = [model toDictionary];
    TalkGridModel *talkGridModel = [TalkGridModel new];
    talkGridModel.title = dic[@"title"];
    talkGridModel.price = dic[@"price"];
    OrderDetaiViewController *orderDetaiViewController = [OrderDetaiViewController new];
    orderDetaiViewController.dataSource = [NSMutableArray arrayWithObject:talkGridModel];
    [self.navigationController pushViewController:orderDetaiViewController animated:YES];
}



@end
