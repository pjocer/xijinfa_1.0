//
//  LessonPlayerLessonCommentsViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/5/18.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "LessonPlayerLessonCommentsViewController.h"
#import "VideoListCell.h"
@interface LessonPlayerLessonCommentsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation LessonPlayerLessonCommentsViewController
static NSString *LessonCommentsCel_id = @"LessonCommentsCel_id";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor
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
    
    if (iPhone5) {
        self.tableView.rowHeight = 100;
    }else{
        self.tableView.rowHeight = 120;
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self.tableView registerClass:[VideoListCell class] forCellReuseIdentifier:LessonCommentsCel_id];
}
#pragma mark TabelViewDataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:LessonCommentsCel_id];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.teacherName.hidden = NO;
    cell.lessonCount.hidden = NO;
    cell.price.hidden = NO;
    cell.oldPrice.hidden = NO;
    return cell;
}
#pragma mark Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击VideoListCell : %ld",indexPath.row);

}



@end
