//
//  LessonPlayerLessonListViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/5/18.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "LessonPlayerLessonListViewController.h"
#import "LessonListCell.h"
@interface LessonPlayerLessonListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation LessonPlayerLessonListViewController
static NSString *LessonListCell_id = @"LessonListCell_id";


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor;
    [self initTabelView];
}



#pragma mark- initTabelView
- (void)initTabelView
{
//    static const CGFloat  videoBottomViewH = 49;
//    static const CGFloat  playViewH = 231;
//    static const CGFloat  titleH = 35;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, SCREENHEIGHT - 49 - 231 - 36) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.tableView.rowHeight = 50;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self.tableView registerClass:[LessonListCell class] forCellReuseIdentifier:LessonListCell_id];
}
#pragma mark TabelViewDataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LessonListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:LessonListCell_id];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row % 2) {
        cell.backgroundColor = BackgroundColor;
    }
    else {
        cell.backgroundColor = [UIColor whiteColor];
    }
        
    return cell;
}
#pragma mark Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击LessonListCell : %ld",indexPath.row);
}


@end
