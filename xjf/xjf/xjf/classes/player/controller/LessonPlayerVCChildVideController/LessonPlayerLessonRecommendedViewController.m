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
#import "LessonPlayerViewController.h"
@interface LessonPlayerLessonRecommendedViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, retain) UIView *keyBoardView; /**< 键盘背景图 */
@property (nonatomic, retain) UIView *keyBoardAppearView; /**< 键盘出现，屏幕背景图 */
@property (nonatomic, retain) UITextField *textField; /**< 键盘 */

@property (nonatomic, strong) LessonRecommendedHeaderView *tableHeaderView;
@end


@implementation LessonPlayerLessonRecommendedViewController
static NSString *LessonRecommendedCell_id = @"LessonRecommendedCell_id";
static NSString *LessonRecommendedHeader_id = @"LessonRecommendedHeader_id";
static NSString *LessonRecommendedFooter_id = @"LessonRecommendedFooter_id";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor
    [self initTabelView];
    [self initTextField];
  
    
}



#pragma mark- initTabelView
- (void)initTabelView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
        
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
    [self.tableView registerClass:[CommentsPageCommentsCell class] forCellReuseIdentifier:LessonRecommendedCell_id];
}
#pragma mark TabelViewDataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentsPageCommentsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:LessonRecommendedCell_id];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //tableHeaderView
    self.tableHeaderView = [[LessonRecommendedHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, 50)];
    [self.tableHeaderView.commentsButton addTarget:self action:@selector(comments:) forControlEvents:UIControlEventTouchUpInside];
    return self.tableHeaderView;
} 

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

#pragma mark Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击CommentsPageCommentsCell : %ld",indexPath.row);
    
}

#pragma mark 键盘
/**键盘 */
- (void)initTextField
{
    
    self.keyBoardAppearView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.keyBoardAppearView.backgroundColor = [UIColor blackColor];
    self.keyBoardAppearView.alpha = 0.2;
    [[UIApplication sharedApplication].keyWindow addSubview:self.keyBoardAppearView];
    self.keyBoardAppearView.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardresignFirstResponder:)];
    [self.keyBoardAppearView addGestureRecognizer:tap];

    
    self.keyBoardView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 40)];
    self.keyBoardView.backgroundColor = [UIColor lightGrayColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self.keyBoardView];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 250) / 2,5,250,30)];
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.placeholder = @"请输入";
    [self.keyBoardView addSubview:self.textField];
    self.textField.delegate = self;
    
    
    //UIKeyboardWillShow
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardwillAppear:) name:UIKeyboardWillShowNotification object:nil];
    //UIKeyboardWillHide
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark 评论
- (void)comments:(UIButton *)sender
{
    NSLog(@"评论");
    [self.textField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    [self requestCommentsData:self.api method:POST];
    [self.textField resignFirstResponder];
    return YES;
}


#pragma mark- KeyboardAction
/** UIKeyboardWillHide */
- (void)UIKeyboardWillHide:(NSNotification *)notifation
{
    [UIView animateWithDuration:0.25 animations:^{
        self.keyBoardView.frame = CGRectMake(0, SCREENHEIGHT, self.view.frame.size.width, 40);
    }];
    self.keyBoardAppearView.hidden = YES;
}


/** keyBoardwillAppear */
- (void)keyBoardwillAppear:(NSNotification *)notifation
{
    NSLog(@"%@",notifation);
    CGRect KeyboardFrame = [[notifation.userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    NSLog(@"%@",NSStringFromCGRect(KeyboardFrame));
    self.keyBoardAppearView.hidden = NO;
    //UIView动画
    [UIView animateWithDuration:0.25 animations:^{
        self.keyBoardView.frame = CGRectMake(0 , SCREENHEIGHT - KeyboardFrame.size.height -50, self.view.frame.size.width, 50);
    }];
}

- (void)keyBoardresignFirstResponder:(UITapGestureRecognizer *)sender{
    [self.textField resignFirstResponder];
}


@end
