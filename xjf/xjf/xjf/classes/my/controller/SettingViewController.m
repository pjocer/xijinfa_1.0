//
//  SettingViewController.m
//  xjf
//
//  Created by PerryJ on 16/5/24.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "SettingViewController.h"
#import "XJAccountManager.h"
#import "AlertUtils.h"
#import "XJFCacheHandler.h"
#import "RegistViewController.h"
@interface SettingViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UIView *footer;
@property (nonatomic, strong) NSString *cacheSizeStr;
@end

@implementation SettingViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"设置";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
}

- (void)initTableView {
    _dataSource = @[@"允许3G/4G网络时自动播放", @"更改密码", @"清除缓存", @"清除搜索记录", @"软件许可及服务协议", @"关于我们"];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, SCREENHEIGHT - HEADHEIGHT - kTabBarH) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = self.footer;
    _tableView.tableHeaderView = [UIView new];
    [self.view addSubview:_tableView];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    UIColor *color = NormalColor;
    cell.textLabel.text = _dataSource[indexPath.row];
    if (indexPath.row == 0) {
        UISwitch *switchB = [[UISwitch alloc] init];
        if ([UserDefaultObjectForKey(USER_SETTING_WIFI) isEqualToString:@"YES"]) {
            switchB.on = YES;
        } else {
            switchB.on = NO;
        }
        [switchB addTarget:self action:@selector(switchClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = switchB;
    } else if (indexPath.row == 2) {
        NSAttributedString *string = [[NSAttributedString alloc] initWithString:[[XJFCacheHandler sharedInstance] getSize] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15], NSForegroundColorAttributeName : color}];
        [cell.detailTextLabel setAttributedText:string];
    }
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:_dataSource[indexPath.row] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15], NSForegroundColorAttributeName : color}];
    [cell.textLabel setAttributedText:string];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        [AlertUtils alertWithTarget:self title:@"提示" content:@"确定清除当前缓存?" confirmBlock:^{
            [[XJFCacheHandler sharedInstance] clearDiskOnCompeletion:^{
                [[ZToastManager ShardInstance] showtoast:@"清除缓存成功"];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
        }];
    }
    if (indexPath.row == 1) {
        RegistViewController *controller = [RegistViewController new];
        controller.title_item = @"重设密码";
        [self.navigationController pushViewController:controller animated:YES];
    }
    if (indexPath.row == 3) {
        [AlertUtils alertWithTarget:self title:@"提示" content:@"确定清除搜索记录?" confirmBlock:^{
            [[XJFCacheHandler sharedInstance] clearRecentlySearched];
        }];
        
    }
}
- (void)switchClicked:(UISwitch *)switchButton {
    if (switchButton.isOn == YES) {
        [[ZToastManager ShardInstance] showtoast:@"已允许3G/4G播放"];
        UserDefaultSetObjectForKey(@"YES", USER_SETTING_WIFI);
    } else {
        [[ZToastManager ShardInstance] showtoast:@"不允许3G/4G播放"];
        UserDefaultSetObjectForKey(@"NO", USER_SETTING_WIFI);
    }
}

- (UIView *)footer {
    if (!_footer) {
        _footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, 70)];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10, 10, CGRectGetWidth(_footer.frame) - 20, 50);
        button.backgroundColor = [UIColor xjfStringToColor:@"#e60012"];
        button.layer.cornerRadius = 5;
        [button setTitle:@"退出登录" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
        [_footer addSubview:button];
    }
    return _footer;
}

- (void)logout {
    [[XJAccountManager defaultManager] logout];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
