//
//  TopicViewController.m
//  xjf
//
//  Created by yiban on 16/3/21.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "TopicViewController.h"
#import "TopicConfigure.h"
#import <MJRefresh/MJRefresh.h>
#import "XjfRequest.h"
#import "TopicModel.h"
#import "TopicBaseCellTableViewCell.h"
#import "StringUtil.h"
#import "ZToastManager.h"
#import "TopicDetailViewController.h"

@interface TopicViewController () <UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *bottom;
@property (nonatomic, strong) UIButton *q_a;
@property (nonatomic, strong) UIButton *all;
@property (nonatomic, strong) UIButton *diss;
@property (nonatomic, assign) NSInteger offSet;
@property (nonatomic, strong) TopicModel *model_all;
@property (nonatomic, strong) TopicModel *model_qa;
@property (nonatomic, strong) TopicModel *model_discuss;
@property (nonatomic, strong) NSMutableArray *allDataSource;
@property (nonatomic, strong) NSMutableArray *disscussDataSource;
@property (nonatomic, strong) NSMutableArray *qaDataSource;
@property (nonatomic, strong) UITableView *tableView_all;
@property (nonatomic, strong) UITableView *tableview_qa;
@property (nonatomic, strong) UITableView *tableView_discuss;
@end

@implementation TopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self extendheadViewFor:Topic];
    [self initMainUI];
    [self initData];
}

- (void)initData {
    [self reqeustData:topic_all method:GET tableView:_tableView_all];
    [self reqeustData:topic_qa method:GET tableView:_tableview_qa];
    [self reqeustData:topic_discuss method:GET tableView:_tableView_discuss];
}

- (void)reqeustData:(APIName *)api method:(RequestMethod)method tableView:(UITableView *)tableView{
    if (api == nil) {
        [self hiddenMJRefresh:tableView];
        return ;
    }
    [[ZToastManager ShardInstance] showprogress];
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];
    [request startWithSuccessBlock:^(NSData * _Nullable responseData) {
        [[ZToastManager ShardInstance] hideprogress];
        TopicModel *model = [[TopicModel alloc] initWithData:responseData error:nil];
        if (tableView == self.tableview_qa) {
            _model_qa = model;
            [_qaDataSource addObjectsFromArray:_model_qa.result.data];
            [_tableview_qa reloadData];
        }else if (tableView == self.tableView_discuss) {
            _model_discuss = model;
            [_disscussDataSource addObjectsFromArray:_model_discuss.result.data];
            [_tableView_discuss reloadData];
        }else {
            _model_all = model;
            [_allDataSource addObjectsFromArray:_model_all.result.data];
            [_tableView_all reloadData];
        }
        [self hiddenMJRefresh:tableView];
        
    } failedBlock:^(NSError * _Nullable error) {
        [self hiddenMJRefresh:tableView];
        [[ZToastManager ShardInstance] hideprogress];
        [[ZToastManager ShardInstance] showtoast:@"请求数据失败"];
    }];
}

- (void)hiddenMJRefresh:(UITableView *)tableView {
    [tableView.mj_footer isRefreshing]?[tableView.mj_footer endRefreshing]:nil;
    [tableView.mj_header isRefreshing]?[tableView.mj_header endRefreshing]:nil;
}

- (void)initMainUI {
    self.nav_title = @"话题";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.header];
    [self.scrollView addSubview:self.tableView_all];
    [self.scrollView addSubview:self.tableview_qa];
    [self.scrollView addSubview:self.tableView_discuss];
    [self.view addSubview:self.scrollView];
}

- (UITableView *)tableView_all {
    if (!_tableView_all) {
        _allDataSource = [NSMutableArray array];
        _tableView_all = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, CGRectGetHeight(_scrollView.bounds)) style:UITableViewStylePlain];
        [_tableView_all registerNib:[UINib nibWithNibName:@"TopicBaseCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"TopicBaseCellTableViewCell"];
        _tableView_all.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [_allDataSource removeAllObjects];
            [self reqeustData:topic_all method:GET tableView:_tableView_all];
        }];
        _tableView_all.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self reqeustData:_model_all.result.next_page_url method:GET tableView:_tableView_all];
        }];
        _tableView_all.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView_all.delegate = self;
        _tableView_all.dataSource = self;
    }
    return _tableView_all;
}

-(UITableView *)tableview_qa {
    if (!_tableview_qa) {
        _qaDataSource = [NSMutableArray array];
        _tableview_qa = [[UITableView alloc] initWithFrame:CGRectMake(SCREENWITH, 0, SCREENWITH, CGRectGetHeight(_scrollView.bounds)) style:UITableViewStylePlain];
        [_tableview_qa registerNib:[UINib nibWithNibName:@"TopicBaseCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"TopicBaseCellTableViewCell"];
        _tableview_qa.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [_qaDataSource removeAllObjects];
            [self reqeustData:topic_qa method:GET tableView:_tableview_qa];
        }];
        _tableview_qa.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self reqeustData:_model_qa.result.next_page_url method:GET tableView:_tableview_qa];
        }];
        _tableview_qa.delegate = self;
        _tableview_qa.dataSource = self;
        _tableview_qa.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableview_qa;
}

-(UITableView *)tableView_discuss {
    if (!_tableView_discuss) {
        _disscussDataSource = [NSMutableArray array];
        _tableView_discuss = [[UITableView alloc] initWithFrame:CGRectMake(2*SCREENWITH, 0, SCREENWITH, CGRectGetHeight(_scrollView.bounds)) style:UITableViewStylePlain];
        [_tableView_discuss registerNib:[UINib nibWithNibName:@"TopicBaseCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"TopicBaseCellTableViewCell"];
        _tableView_discuss.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [_disscussDataSource removeAllObjects];
            [self reqeustData:topic_discuss method:GET tableView:_tableView_discuss];
        }];
        _tableView_discuss.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self reqeustData:_model_discuss.result.next_page_url method:GET tableView:_tableView_discuss];
        }];
        _tableView_discuss.delegate = self;
        _tableView_discuss.dataSource = self;
        _tableView_discuss.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView_discuss;
}

-(UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.header.frame), SCREENWITH, SCREENHEIGHT-35-HEADHEIGHT-kTabBarH)];
        _scrollView.contentSize = CGSizeMake(3*SCREENWITH, CGRectGetHeight(_scrollView.bounds));
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

-(UIView *)header {
    if (!_header) {
        _header = [[UIView alloc] initWithFrame:CGRectMake(0, 1, SCREENWITH, 35)];
        _header.backgroundColor = [UIColor whiteColor];
        _q_a = [UIButton buttonWithType:UIButtonTypeCustom];
        _q_a.frame = CGRectMake(0, 0, 30, 18);
        _q_a.center = _header.center;
        UIColor *color = NormalColor;
        _q_a.titleLabel.font = FONT15;
        [_q_a setTitleColor:color forState:UIControlStateNormal];
        [_q_a setTitle:@"问答" forState:UIControlStateNormal];
        _q_a.tag = 201;
        [_q_a addTarget:self action:@selector(headerClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_header addSubview:_q_a];
        
        _all = [UIButton buttonWithType:UIButtonTypeCustom];
        _all.frame = CGRectMake(CGRectGetMinX(_q_a.frame)-70, CGRectGetMinY(_q_a.frame), 30, 18);
        _all.titleLabel.font = FONT15;
        [_all setTitleColor:color forState:UIControlStateNormal];
        [_all setTitle:@"全部" forState:UIControlStateNormal];
        _all.tag = 200;
        [_all addTarget:self action:@selector(headerClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_header addSubview:_all];
        
        _diss = [UIButton buttonWithType:UIButtonTypeCustom];
        _diss.frame = CGRectMake(CGRectGetMaxX(_q_a.frame)+40, CGRectGetMinY(_q_a.frame), 30, 18);
        _diss.titleLabel.font = FONT15;
        [_diss setTitle:@"讨论" forState:UIControlStateNormal];
        [_diss setTitleColor:color forState:UIControlStateNormal];
        _diss.tag = 202;
        [_diss addTarget:self action:@selector(headerClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_header addSubview:_diss];
        
        UILabel *bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 34, CGRectGetWidth(_header.frame), 1)];
        bottomLine.backgroundColor = BackgroundColor;
        [_header addSubview:bottomLine];
        
        _bottom = [[UILabel alloc] initWithFrame:CGRectMake(_all.center.x-25, CGRectGetMaxY(_q_a.frame)+4, 50, 3)];
        _bottom.backgroundColor = PrimaryColor;
        [_header addSubview:_bottom];
    }
    return _header;
}
- (void)headerClicked:(UIButton *)button {
    [_scrollView setContentOffset:CGPointMake(SCREENWITH*(button.tag-200), 0) animated:YES];
}
- (CGFloat)cellHeightByModel:(TopicDataModel *)model {
    CGFloat contentHeight = [StringUtil calculateLabelHeight:model.content width:SCREENWITH-20 fontsize:15];
    CGFloat height = 10+40+10+contentHeight;
    CGFloat cellHeight = 0.0;
    if (model.categories.count > 0) {
        float length = 10;
        for (int i = 0; i < model.categories.count; i++) {
            TopicCategoryLabel *label = model.categories[i];
            NSString *buttonTitle = [NSString stringWithFormat:@"#%@#",label.name];
            CGRect frame = [StringUtil calculateLabelRect:buttonTitle height:14 fontSize:12];
            CGFloat width = frame.size.width;
            if (length+10+width <= SCREENWITH) {
                cellHeight = height + 34 + 36;
            }else {
                length = 10;
                cellHeight = height + 30 + 28 + 36;
            }
            length = 10*(i+1)+width+length;
        }
    }else {
        cellHeight = height+10+36;
    }
    return cellHeight+10;
}
#pragma TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _tableView_all) {
        return _allDataSource.count;
    }else if (tableView == _tableview_qa) {
        return _qaDataSource.count;
    }else if (tableView == _tableView_discuss) {
        return _disscussDataSource.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TopicBaseCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopicBaseCellTableViewCell" forIndexPath:indexPath];
    TopicDataModel *model = nil;
    if (tableView == _tableView_all) {
        model = _allDataSource[indexPath.row];
    }else if (tableView == _tableview_qa) {
        model = _qaDataSource[indexPath.row];
    }else if (tableView == _tableView_discuss) {
        model = _disscussDataSource[indexPath.row];
    }
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TopicDataModel *model = nil;
    if (tableView == _tableView_all) {
        model = _allDataSource[indexPath.row];
    }else if (tableView == _tableview_qa) {
        model = _qaDataSource[indexPath.row];
    }else if (tableView == _tableView_discuss) {
        model = _disscussDataSource[indexPath.row];
    }
    return [self cellHeightByModel:model];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TopicDataModel *model = nil;
    if (tableView == self.tableView_all) {
        model = self.model_all.result.data[indexPath.row];
    }else if (tableView == self.tableview_qa) {
        model = self.model_qa.result.data[indexPath.row];
    }else if (tableView == self.tableView_discuss) {
        model = self.model_discuss.result.data[indexPath.row];
    }
    TopicDetailViewController *controller = [[TopicDetailViewController alloc] init];
    controller.topic_id = model.id;
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma ScrollView Delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        NSInteger offSet = scrollView.contentOffset.x/SCREENWITH*70;
        [UIView animateWithDuration:0.3 animations:^{
            _bottom.frame = CGRectMake(_all.center.x-25+offSet, CGRectGetMaxY(_q_a.frame)+4, 50, 3);
        } completion:^(BOOL finished) {
            
        } ];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        CGFloat offSet = scrollView.contentOffset.x;
        CGFloat percent = offSet/SCREENWITH;
        UIButton *button = nil;
        if (percent>0.5 && percent<=1.5) {
            button = _q_a;
            percent-=1;
        }else if (percent<=0.5) {
            button = _all;
        }else if (percent>1.5 && percent<=2.5){
            button = _diss;
            percent-=2;
        }
        _bottom.frame = CGRectMake(button.center.x-25+70*percent, CGRectGetMaxY(_q_a.frame)+4, 50, 3);
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
