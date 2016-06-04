//
//  TaViewController.m
//  xjf
//
//  Created by PerryJ on 16/6/4.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "TaViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "TaBaseCell.h"
#import "TaBaseCellFoot.h"
@interface TaViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIView *footer;
@property (nonatomic, strong) UIImageView *focus;
@end

@implementation TaViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainUI];
}
- (void)initMainUI {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footer];
}
-(UIView *)footer {
    if (!_footer) {
        _footer = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT-50-HEADHEIGHT, SCREENWITH, 50)];
        _footer.backgroundColor = [UIColor whiteColor];
        [_footer addSubview:self.focus];
    }
    return _footer;
}
-(UIImageView *)focus {
    if (!_focus) {
        _focus = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"focus_on"] highlightedImage:[UIImage imageNamed:@"focus_off"]];
        _focus.frame = CGRectMake(SCREENWITH/2 - 27, SCREENHEIGHT-HEADHEIGHT-14, 22, 22);
        _focus.userInteractionEnabled = YES;
    }
    return _focus;
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, SCREENHEIGHT-kTabBarH) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerNib:[UINib nibWithNibName:@"TaBaseCell" bundle:nil] forCellReuseIdentifier:@"TaBaseCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"TaBaseCellFoot" bundle:nil] forCellReuseIdentifier:@"TaBaseCellFoot"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 146;
    }else {
        return 102;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        TaBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaBaseCell" forIndexPath:indexPath];
        cell.model = self.model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        TaBaseCellFoot *cell = [tableView dequeueReusableCellWithIdentifier:@"TaBaseCellFoot" forIndexPath:indexPath];
        cell.model = self.model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
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
