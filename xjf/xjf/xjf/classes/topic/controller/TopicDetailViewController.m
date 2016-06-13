//
//  TopicDetailViewController.m
//  xjf
//
//  Created by PerryJ on 16/5/30.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "TopicDetailViewController.h"
#import "XjfRequest.h"
#import "TopicDetailModel.h"
#import "TopicCommentList.h"
#import "CommentDetailHeader.h"
#import "ZToastManager.h"
#import <MJRefresh/MJRefresh.h>
#import "CommentListCell.h"
#import "StringUtil.h"
#import "XJAccountManager.h"
#import "NewCommentViewController.h"
@interface TopicDetailViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TopicDetailModel *model;
@property (nonatomic, strong) TopicCommentList *commentList;
@property (nonatomic, strong) CommentDetailHeader *header;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIView *footer;
@property (nonatomic, strong) UIImageView *like_imageView;
@property (nonatomic, strong) UIButton *like_count;
@end

@implementation TopicDetailViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.tabBarController.tabBar.isHidden) {
        self.tabBarController.tabBar.hidden = YES;
        [self.view addSubview:self.footer];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.tabBarController.tabBar.isHidden) {
        self.tabBarController.tabBar.hidden = NO;
        [self.footer removeFromSuperview];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainUI];
    [self initData];
}

- (void)initData {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    [self requestData:[topic_all stringByAppendingString:self.topic_id] method:GET];
    [self requestData:[NSString stringWithFormat:@"%@%@/reply",topic_all,self.topic_id] method:GET];
}

- (void)requestData:(APIName *)api method:(RequestMethod)method {
    if (api == nil) {
        [self hiddenMJRefresh:_tableView];
        return;
    }
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];
    if ([api isEqualToString:praise]) {
        request.requestParams = [NSMutableDictionary dictionaryWithDictionary:@{@"type":@"topic",@"id":_model.result.id}];
    }
    [request startWithSuccessBlock:^(NSData * _Nullable responseData) {
        if ([api isEqualToString:[topic_all stringByAppendingString:self.topic_id]]) {
            _model = [[TopicDetailModel alloc] initWithData:responseData error:nil];
            if ([_model.errCode isEqualToString:@"0"]) {
                [self resetLikeButton:_model.result.user_liked];
                [self.tableView reloadData];
            }else {
                [[ZToastManager ShardInstance] showtoast:_model.errMsg];
            }
        }else if ([api isEqualToString:praise]) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
            if ([dic[@"errCode"] integerValue] == 0) {
                [self resetLikeButton:method==DELETE?NO:YES];
            }else {
                [[ZToastManager ShardInstance] showtoast:dic[@"errMsg"]];
            }
        }else {
            _commentList = [[TopicCommentList alloc] initWithData:responseData error:nil];
            if ([_commentList.errCode isEqualToString:@"0"]) {
                [_dataSource addObjectsFromArray:_commentList.result.data];
                [self.tableView reloadData];
            }else {
                [[ZToastManager ShardInstance] showtoast:_commentList.errMsg];
            }
        }
        [self hiddenMJRefresh:_tableView];
    } failedBlock:^(NSError * _Nullable error) {
        [self hiddenMJRefresh:_tableView];
        [[ZToastManager ShardInstance] showtoast:@"网络请求失败"];
    }];
}

- (void)initMainUI {
    self.nav_title = @"话题详情";
    [self.view addSubview:self.tableView];
}

- (void)commentClicked:(UIButton *)button {
    if ([[XJAccountManager defaultManager] accessToken]) {
        NewCommentViewController *controler = [[NewCommentViewController alloc] init];
        controler.topic_id = self.topic_id;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controler];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }else {
        [[ZToastManager ShardInstance] showtoast:@"请先登录"];
    }
    
}
- (void)lickClicked:(UIButton *)button {
    if ([[XJAccountManager defaultManager] accessToken]) {
        [self requestData:praise method:_like_imageView.highlighted?DELETE:POST];
    }else {
        [[ZToastManager ShardInstance] showtoast:@"请先登录"];
    }
}

- (void)resetLikeButton:(BOOL)like {
    if (_like_imageView.highlighted == like) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        _like_imageView.highlighted = like;
        CGPoint center = _like_imageView.center;
        center.x  = like?(center.x-20):(center.x+20);
        _like_imageView.center = center;
        [_like_count setTitle:like?@"取消点赞":@"点赞" forState:UIControlStateNormal];
        CGPoint labelCenter = _like_count.center;
        labelCenter.x =like?(labelCenter.x-20):(labelCenter.x+20);;
        _like_count.center = labelCenter;
    });
}

- (UIView *)footer {
    if (!_footer) {
        _footer = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT-kTabBarH-HEADHEIGHT, SCREENWITH, kTabBarH)];
        _footer.backgroundColor = [UIColor whiteColor];
        CGFloat halfWidth = (SCREENWITH-1)/2.0;
        UIButton *comment = [UIButton buttonWithType:UIButtonTypeCustom];
        comment.frame = CGRectMake(0, 0, halfWidth, kTabBarH/2.0);
        UIImageView *comment_imageview = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWITH/4-15-2.5, 17, 15, 15)];
        comment_imageview.image = [UIImage imageNamed:@"comment"];
        [comment addSubview:comment_imageview];
        UILabel *comment_count = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWITH/4+2.5, 17, SCREENWITH/4, 14)];
        comment_count.text = @"评论";
        comment_count.font = FONT12;
        comment_count.textColor = AssistColor;
        [comment addSubview:comment_count];
        [comment addTarget:self action:@selector(commentClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_footer addSubview:comment];
        UILabel *segmentLine = [[UILabel alloc] initWithFrame:CGRectMake(halfWidth, 0, 1, kTabBarH)];
        segmentLine.backgroundColor = BackgroundColor;
        [_footer addSubview:segmentLine];
        UIButton *like = [UIButton buttonWithType:UIButtonTypeCustom];
        like.frame = CGRectMake(halfWidth+1, 0, halfWidth, kTabBarH/2.0);
        _like_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWITH/4-15-2.5, 17, 15, 15)];
        _like_imageView.image = [UIImage imageNamed:@"iconLike"];
        _like_imageView.highlightedImage = [UIImage imageNamed:@"iconLikeOn"];
        _like_imageView.userInteractionEnabled =YES;
        [like addSubview:_like_imageView];
        _like_count = [UIButton buttonWithType:UIButtonTypeCustom];
        _like_count.frame = CGRectMake(SCREENWITH/4+2.5, 17, SCREENWITH/4, 14);
        UIColor *color = AssistColor;
        [_like_count setTitleColor:color forState:UIControlStateNormal];
        [_like_count setTitle:@"点赞" forState:UIControlStateNormal];
        _like_count.titleLabel.font = FONT12;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lickClicked:)];
        [_like_count addTarget:self action:@selector(lickClicked:) forControlEvents:UIControlEventTouchUpInside];
        _like_count.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_like_imageView addGestureRecognizer:tap];
        [like addSubview:_like_count];
        [like addTarget:self action:@selector(lickClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_footer addSubview:like];
    }
    return _footer;
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, SCREENHEIGHT-HEADHEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerNib:[UINib nibWithNibName:@"CommentDetailHeader" bundle:nil] forCellReuseIdentifier:@"CommentDetailHeader"];
        [_tableView registerNib:[UINib nibWithNibName:@"CommentListCell" bundle:nil] forCellReuseIdentifier:@"CommentListCell"];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [_dataSource removeAllObjects];
            [self initData];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self requestData:_commentList.result.next_page_url method:GET];
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (void)hiddenMJRefresh:(UITableView *)tableView {
    [tableView.mj_footer isRefreshing]?[tableView.mj_footer endRefreshing]:nil;
    [tableView.mj_header isRefreshing]?[tableView.mj_header endRefreshing]:nil;
}
#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section==0?1:_dataSource.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, 35)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, SCREENWITH-10, 18)];
        label.font = FONT15;
        label.textColor = NormalColor;
        label.text = @"评论";
        [view addSubview:label];
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 34, SCREENWITH, 1)];
        line.backgroundColor = BackgroundColor;
        [view addSubview:line];
        if (_dataSource.count==0) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, SCREENWITH, 200)];
            label.font = FONT12;
            label.textAlignment = 1;
            label.textColor = AssistColor;
            label.text = @"还没有人评论";
            [view addSubview:label];
        }
        return view;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        if (_dataSource.count==0) {
            return 235;
        }else {
            return 35;
        }
    }else {
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        _header = [tableView dequeueReusableCellWithIdentifier:@"CommentDetailHeader" forIndexPath:indexPath];
        _header.model = _model.result;
        _header.selectionStyle = UITableViewCellSelectionStyleNone;
        return _header;
    }else {
        CommentListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentListCell" forIndexPath:indexPath];
        if (_dataSource && _dataSource.count>0) {
            TopicDataModel *data = [_dataSource objectAtIndex:indexPath.row];
            cell.data = data;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return _header.cellHeight;
    }else if (indexPath.section == 1){
        if (self.dataSource && self.dataSource.count>0) {
            TopicDataModel *data = [self.dataSource objectAtIndex:indexPath.row];
            return [StringUtil calculateLabelHeight:data.content width:SCREENWITH-70 fontsize:15]+71;
        }
    }
    return 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
