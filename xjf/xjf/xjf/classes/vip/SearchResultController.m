//
//  SearchResultController.m
//  xjf
//
//  Created by PerryJ on 16/6/7.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "SearchResultController.h"
#import "SearchSectionTwo.h"
#import "BaikeCell.h"
#import "UIImageView+WebCache.h"
#import "CommentDetailHeader.h"
#import "FansCell.h"

@interface SearchResultController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) NSMutableArray *tableViews;
@property (nonatomic, strong) UITableView *encyclopedia;
@property (nonatomic, strong) UITableView *lessons;
@property (nonatomic, strong) UITableView *topics;
@property (nonatomic, strong) UITableView *persons;
@end

@implementation SearchResultController
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
}
-(void)loadView {
    [super loadView];
    [self handleDopant];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.header];
    [self.scrollView addSubview:self.encyclopedia];
    [self.scrollView addSubview:self.lessons];
    [self.scrollView addSubview:self.topics];
    [self.scrollView addSubview:self.persons];
    [self handleRACResult];
}
- (void)handleDopant {
    self.tableViews = [NSMutableArray arrayWithCapacity:4];
    [self.tableViews addObject:self.encyclopedia];
    [self.tableViews addObject:self.lessons];
    [self.tableViews addObject:self.topics];
    [self.tableViews addObject:self.persons];
    self.encyDataSource = [NSMutableArray array];
    self.topicsDataSource = [NSMutableArray array];
    self.lessonsDataSource = [NSMutableArray array];
    self.personsDataSource = [NSMutableArray array];
}
- (void)requestData:(APIName *)api method:(RequestMethod)method {
    
}
- (void)handleRACResult {
    @weakify(self);
    RAC(self.segmentline,frame) = [RACObserve(self.scrollView, contentOffset) map:^id(id x) {
        @strongify(self);
        CGPoint point = [x CGPointValue];
        CGFloat percent = point.x/SCREENWITH;
        self.current = percent;
        CGRect frame = CGRectMake(SCREENWITH/4*percent, 32, SCREENWITH/4, 3);
        return [NSValue valueWithCGRect:frame];
    }];
    for (UIButton *button in self.buttons) {
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
            @strongify(self);
            [self.scrollView setContentOffset:CGPointMake(SCREENWITH*(x.tag-700), 35) animated:YES];
        }];
    }
}
-(UIView *)header {
    if (!_header) {
        _header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, 35)];
        _header.backgroundColor = [UIColor whiteColor];
        [_header addSubview:self.segmentline];
        UILabel *bottom = [[UILabel alloc] initWithFrame:CGRectMake(0, 34, SCREENWITH, 1)];
        bottom.backgroundColor = BackgroundColor;
        [_header addSubview:bottom];
        self.buttons = [NSMutableArray arrayWithCapacity:4];
        NSArray *titles = @[@"百科",@"课程",@"话题",@"找人"];
        for (int i = 0; i < 4; i++) {
            CGFloat width = SCREENWITH/4;
            CGFloat height = 18;
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*width, 8, width, height)];
            [button setTitle:titles[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor xjfStringToColor:@"#444444"] forState:UIControlStateNormal];
            button.titleLabel.font = FONT15;
            button.tag = 700+i;
            [_header addSubview:button];
            [self.buttons addObject:button];
        }
    }
    return _header;
}
-(UILabel *)segmentline {
    if (!_segmentline) {
        _segmentline = [[UILabel alloc] initWithFrame:CGRectMake(0, 32, SCREENWITH/4, 3)];
        _segmentline.backgroundColor = [UIColor xjfStringToColor:@"#0061b0"];
    }
    return _segmentline;
}
-(UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 35, SCREENWITH, SCREENHEIGHT-35-64)];
        _scrollView.contentSize = CGSizeMake(4*SCREENWITH, SCREENHEIGHT-35-64);
        _scrollView.backgroundColor = BackgroundColor;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}
-(UITableView *)encyclopedia {
    if (!_encyclopedia) {
        _encyclopedia = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, SCREENHEIGHT-35-64) style:UITableViewStylePlain];
        _encyclopedia.delegate = self;
        _encyclopedia.dataSource = self;
        [_encyclopedia registerNib:[UINib nibWithNibName:@"BaikeCell" bundle:nil] forCellReuseIdentifier:@"BaikeCell"];
    }
    return _encyclopedia;
}
-(UITableView *)lessons {
    if (!_lessons) {
        _lessons = [[UITableView alloc] initWithFrame:CGRectMake(SCREENWITH, 0, SCREENWITH, SCREENHEIGHT-35-64) style:UITableViewStylePlain];
        _lessons.delegate = self;
        _lessons.dataSource = self;
        [_lessons registerNib:[UINib nibWithNibName:@"SearchSectionTwo" bundle:nil] forCellReuseIdentifier:@"SearchSectionTwo"];
    }
    return _lessons;
}
-(UITableView *)topics {
    if (!_topics) {
        _topics = [[UITableView alloc] initWithFrame:CGRectMake(SCREENWITH*2, 0, SCREENWITH, SCREENHEIGHT-35-64) style:UITableViewStylePlain];
        _topics.delegate = self;
        _topics.dataSource = self;
        [_topics registerNib:[UINib nibWithNibName:@"CommentDetailHeader" bundle:nil] forCellReuseIdentifier:@"CommentDetailHeader"];
    }
    return _topics;
}

-(UITableView *)persons {
    if (!_persons) {
        _persons = [[UITableView alloc] initWithFrame:CGRectMake(SCREENWITH*3, 0, SCREENWITH, SCREENHEIGHT-35-64) style:UITableViewStylePlain];
        _persons.delegate = self;
        _persons.dataSource = self;
        [_persons registerNib:[UINib nibWithNibName:@"FansCell" bundle:nil] forCellReuseIdentifier:@"FansCell"];
    }
    return _persons;
}
-(void)reloadDataFor:(ReloadTableType)type {
    switch (type) {
        case LessonsTable:
        {
            [self.lessons reloadData];
        }
            break;
        case TopicsTable:
        {
            [self.topics reloadData];
        }
            break;
        case EncyclopediaTable:
        {
            [self.encyclopedia reloadData];
        }
            break;
        case PersonsTable:
        {
            [self.persons reloadData];
        }
            break;
        case AllTable:
        {
            for (UITableView *tableView in self.tableViews) {
                [tableView reloadData];
            }
        }
            break;
        default:
            break;
    }
}
#pragma TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.encyclopedia) {
        return self.encyDataSource.count?:0;
    }else if (tableView == self.topics) {
        return self.topicsDataSource.count?:0;
    }else if (tableView == self.lessons) {
        return self.lessonsDataSource.count?:0;
    }else {
        return self.personsDataSource.count?:0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.encyclopedia) {
        BaikeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BaikeCell" forIndexPath:indexPath];
        [cell.avatar sd_setImageWithURL:[NSURL URLWithString:@""]];
        cell.title.text = @"A";
        cell.everWatched.text = @"200人观看过";
        return cell;
    }else if (tableView == self.topics) {
        CommentDetailHeader *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentDetailHeader" forIndexPath:indexPath];
        return cell;
    }else if (tableView == self.lessons) {
        SearchSectionTwo *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchSectionTwo" forIndexPath:indexPath];
        return cell;
    }else {
        FansCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FansCell" forIndexPath:indexPath];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.topics) {
        return 150;
    }else {
        return 101;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.encyclopedia) {
        NSLog(@"encylopedia");
    }else if (tableView == self.topics) {
        NSLog(@"topics");
    }else if (tableView == self.lessons) {
        NSLog(@"lessons");
    }else {
        NSLog(@"persons");
    }
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
