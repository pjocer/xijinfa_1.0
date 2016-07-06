//
//  LessonPlayerLessonRecommendedViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/5/18.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "LessonPlayerLessonRecommendedViewController.h"
#import "CommentsPageCommentsCell.h"
#import "LessonRecommendedHeaderView.h"
#import "XJAccountManager.h"
#import <MJRefresh.h>
#import "CustomTextField.h"

@interface LessonPlayerLessonRecommendedViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, retain) UIView *keyBoardView;
/**< 键盘背景图 */
@property (nonatomic, retain) UIView *keyBoardAppearView;
/**< 键盘出现，屏幕背景图 */
@property (nonatomic, retain) CustomTextField *textField;
/**< 键盘 */
@property (nonatomic, strong) LessonRecommendedHeaderView *tableHeaderView;
@property (nonatomic, strong) UIButton *sendMsgButton;
@property (nonatomic, strong) CommentsAllDataList *commentsModel;
@end


@implementation LessonPlayerLessonRecommendedViewController
static NSString *LessonRecommendedCell_id = @"LessonRecommendedCell_id";
static NSString *LessonRecommendedHeader_id = @"LessonRecommendedHeader_id";
static NSString *LessonRecommendedFooter_id = @"LessonRecommendedFooter_id";

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dataSource = [NSMutableArray array];
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.keyBoardAppearView removeFromSuperview];
    [self.keyBoardView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor
    [self initTabelView];
    [self initTextField];
    [self requestCommentsData:[NSString stringWithFormat:@"%@/%@/comments",
                                                         coursesProjectLessonDetailList, self.ID] method:GET];

}

#pragma mark requestData

- (void)requestCommentsData:(APIName *)api method:(RequestMethod)method {

    [[ZToastManager ShardInstance] showprogress];
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];
    //GET
    if (method == GET) {
        @weakify(self)
        [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
            @strongify(self)
            self.commentsModel = [[CommentsAllDataList alloc] initWithData:responseData error:nil];
            [self.dataSource addObjectsFromArray:self.commentsModel.result.data];
            [self.tableView reloadData];
            [self.tableView.mj_footer isRefreshing] ? [self.tableView.mj_footer endRefreshing] : nil;
            [[ZToastManager ShardInstance] hideprogress];
        }                  failedBlock:^(NSError *_Nullable error) {
            [[ZToastManager ShardInstance] hideprogress];
            [[ZToastManager ShardInstance] showtoast:@"网络连接失败"];
            [self.tableView.mj_footer isRefreshing] ? [self.tableView.mj_footer endRefreshing] : nil;
        }];
    }
        //POST
    else if (method == POST) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:self.textField.text forKey:@"content"];
        [dic setValue:self.ID forKey:@"ID"];
        request.requestParams = dic;

        @weakify(self)
        [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
            @strongify(self)
            self.dataSource = [NSMutableArray array];
            [self requestCommentsData:[NSString stringWithFormat:@"%@/%@/comments",
                                                                 coursesProjectLessonDetailList, self.ID] method:GET];
        }                  failedBlock:^(NSError *_Nullable error) {
            [[ZToastManager ShardInstance] showtoast:@"网络连接失败"];
        }];
    }
}

- (void)loadMoreData {
    if (self.commentsModel.result.next_page_url != nil) {
        [self requestCommentsData:self.commentsModel.result.next_page_url method:GET];
    } else if (self.commentsModel.result.current_page == self.commentsModel.result.last_page) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [[ZToastManager ShardInstance] showtoast:@"没有更多数据"];
        [self.tableView.mj_footer removeFromSuperview];
    }
}

#pragma mark- initTabelView

- (void)initTabelView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(10);
        make.left.right.bottom.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-10);

    }];
    self.tableHeaderView = [[LessonRecommendedHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, 50)];
    [self.tableHeaderView.commentsButton addTarget:self action:@selector(comments:)
                                  forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableHeaderView = self.tableHeaderView;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[CommentsPageCommentsCell class] forCellReuseIdentifier:LessonRecommendedCell_id];

    if (!self.tableView.mj_footer) {
        //mj_footer
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter
                footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    }
}

#pragma mark TabelViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentsPageCommentsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:LessonRecommendedCell_id];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.commentsModel = self.dataSource[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentsModel *model = self.dataSource[indexPath.section];
    CGRect tempRect = [StringUtil calculateLabelRect:model.content width:SCREENWITH - 70 fontsize:15];
    return tempRect.size.height + 60;
}


#pragma mark Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击CommentsPageCommentsCell : %ld", (long)indexPath.section);

}

#pragma mark 键盘

/**键盘 */
- (void)initTextField {
    self.keyBoardAppearView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.keyBoardAppearView.backgroundColor = [UIColor blackColor];
    self.keyBoardAppearView.alpha = 0.2;
    [[UIApplication sharedApplication].keyWindow addSubview:self.keyBoardAppearView];
    self.keyBoardAppearView.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
            initWithTarget:self action:@selector(keyBoardresignFirstResponder:)];
    [self.keyBoardAppearView addGestureRecognizer:tap];

    self.keyBoardView = [[UIView alloc]
            initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 50)];
    self.keyBoardView.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self.keyBoardView];

    self.textField = [[CustomTextField alloc] initWithFrame:CGRectMake(10, 10, SCREENWITH - 70, 30)];
    self.textField.backgroundColor = BackgroundColor
    self.textField.layer.masksToBounds = YES;
    self.textField.layer.cornerRadius = 4;
    self.textField.placeholder = @"回复新内容";

    [self.textField setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    [self.keyBoardView addSubview:self.textField];
    self.textField.delegate = self;

    self.sendMsgButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.keyBoardView addSubview:self.sendMsgButton];
    [self.sendMsgButton setTitle:@"发送" forState:UIControlStateNormal];
    self.sendMsgButton.titleLabel.font = FONT15;
    self.sendMsgButton.frame = CGRectMake(0, 0, 30, 19);
    self.sendMsgButton.center = CGPointMake(CGRectGetMaxX(self.textField.frame) + 30, self.textField.center.y);
    self.sendMsgButton.tintColor = [UIColor blackColor];
    [[self.sendMsgButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self requestCommentsData:[NSString stringWithFormat:@"%@/%@/comments", coursesProjectLessonDetailList, self.ID] method:POST];
        [self.textField resignFirstResponder];
    }];

    //UIKeyboardWillShow
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardwillAppear:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    //UIKeyboardWillHide
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark 评论

- (void)comments:(UIButton *)sender {
    if ([[XJAccountManager defaultManager] accessToken] == nil ||
            [[[XJAccountManager defaultManager] accessToken] length] == 0) {
        [self LoginPrompt];
    } else {
        [self.textField becomeFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //    [self requestCommentsData:self.api method:POST];
    [self.textField resignFirstResponder];
    return YES;
}

#pragma mark- KeyboardAction

/** UIKeyboardWillHide */
- (void)UIKeyboardWillHide:(NSNotification *)notifation {
    [UIView animateWithDuration:0.25 animations:^{
        self.keyBoardView.frame = CGRectMake(0, SCREENHEIGHT, self.view.frame.size.width, 40);
    }];
    self.keyBoardAppearView.hidden = YES;
}


/** keyBoardwillAppear */
- (void)keyBoardwillAppear:(NSNotification *)notifation {
    NSLog(@"%@", notifation);
    CGRect KeyboardFrame = [[notifation.userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    NSLog(@"%@", NSStringFromCGRect(KeyboardFrame));
    self.keyBoardAppearView.hidden = NO;
    //UIView动画
    [UIView animateWithDuration:0.25 animations:^{
        self.keyBoardView.frame = CGRectMake(0, SCREENHEIGHT - KeyboardFrame.size.height - 50,
                self.view.frame.size.width, 50);
    }];
}

- (void)keyBoardresignFirstResponder:(UITapGestureRecognizer *)sender {
    [self.textField resignFirstResponder];
}


@end
