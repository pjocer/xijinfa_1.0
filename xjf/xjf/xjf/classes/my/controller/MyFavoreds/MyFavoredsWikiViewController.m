//
//  MyFavoredsWikiViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/6/4.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "MyFavoredsWikiViewController.h"
#import "TalkGridModel.h"
#import "VideoListCell.h"
#import "PlayerViewController.h"
@interface MyFavoredsWikiViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation MyFavoredsWikiViewController
static NSString *MyFavoredsWikiCell_id = @"MyFavoredsWikiCell_id";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTabelView];
}

#pragma mark- initTabelView

- (void)initTabelView {
    
    self.tableView = [[UITableView alloc]
                      initWithFrame:CGRectMake(0, 0, SCREENWITH, self.view.frame.size.height - 100)];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if (iPhone5 || iPhone4) {
        self.tableView.rowHeight = 100;
    } else {
        self.tableView.rowHeight = 120;
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self.tableView registerClass:[VideoListCell class] forCellReuseIdentifier:MyFavoredsWikiCell_id];
}

#pragma mark TabelViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:MyFavoredsWikiCell_id];
    cell.model = self.dataSource[indexPath.row];
    cell.viedoDetail.hidden = NO;
    return cell;
}

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
    if (editingStyle == UITableViewCellEditingStyleDelete){
        [self PostOrDeleteRequestData:favorite Method:DELETE IndexPath:indexPath];
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        }
}

#pragma mark Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        PlayerViewController *player = [[PlayerViewController alloc] init];
        TalkGridModel *model = self.dataSource[indexPath.row];
        player.talkGridModel = model;
//        player.talkGridListModel = self.tablkListModel;
        [self.navigationController pushViewController:player animated:YES];
}

- (void)PostOrDeleteRequestData:(APIName *)api Method:(RequestMethod)method IndexPath:(NSIndexPath *)index
{
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];
    TalkGridModel *model = self.dataSource[index.row];
    request.requestParams = [NSMutableDictionary dictionaryWithDictionary:@{@"id":[NSString stringWithFormat:@"%@",model.id_],@"type":[NSString stringWithFormat:@"%@",model.type],@"department":[NSString stringWithFormat:@"%@",model.department]}];
   
    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
    }failedBlock:^(NSError *_Nullable error) {
    }];
}


@end
