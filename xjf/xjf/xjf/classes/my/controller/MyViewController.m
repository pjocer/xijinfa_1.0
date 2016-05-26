//
//  MyViewController.m
//  xjf
//
//  Created by yiban on 16/3/21.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "MyViewController.h"
#import "myConfigure.h"
#import "UserInfoViewController.h"
#import "MyMoneyViewController.h"
@interface MyViewController () <UITableViewDataSource, UITableViewDelegate, UserDelegate, UserComponentCellDelegate> {

}
@property(nonatomic, strong) UserProfileModel *model;
@property(nonatomic, strong) UITableView *tableview;
@end

@implementation MyViewController
@synthesize tableview = _tableview;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.model = [[UserProfileModel alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO] error:nil];
    [self.tableview reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor
    self.model = [[UserProfileModel alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO] error:nil];
    [self extendheadViewFor:My];
    [self initMainUI];
    @weakify(self)
    ReceivedNotification(self, UserInfoDidChangedNotification, ^(NSNotification *notification) {
        @strongify(self)
        self.model = notification.object;
        [self.tableview reloadData];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//main UI
- (void)initMainUI {
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, HEADHEIGHT, SCREENWITH, SCREENHEIGHT - HEADHEIGHT - 40) style:UITableViewStylePlain];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.showsVerticalScrollIndicator = NO;
    _tableview.backgroundColor = [UIColor clearColor];
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, 1)];
    self.tableview.tableHeaderView = header;
    [self.view addSubview:_tableview];
    [_tableview registerNib:[UINib nibWithNibName:@"UserUnLoadCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"UserUnLoadCell"];
    [_tableview registerNib:[UINib nibWithNibName:@"UserLoadCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"UserLoadCell"];
    [_tableview registerClass:[UserComponentCell class] forCellReuseIdentifier:@"UserComponentCell"];
//    _tableview.tableFooterView = [self footerView:@""];
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 110;
    }
    return 320;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if (self.model == nil) {
            UserUnLoadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserUnLoadCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else {
            UserLoadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserLoadCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = self.model;
            return cell;
        }

    } else {
        UserComponentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserComponentCell" forIndexPath:indexPath];
        cell.backgroundColor = BackgroundColor;
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        if (self.model != nil) {
            UserInfoViewController *userinfo = [[UserInfoViewController alloc]init];
            [self.navigationController pushViewController:userinfo animated:YES];
        } else {
            LoginViewController *login = [LoginViewController new];
            login.delegate = self;
            [self.navigationController pushViewController:login animated:YES];
        }
    }
}

#pragma UserDelegate

- (void)userLoginOK:(id)userinfo {

}

- (void)userLoginFail {

}

- (void)userDidCancel {

}

#pragma UserComponentDelegate

- (void)componentDidSelected:(NSUInteger)index {
    NSLog(@"%lu", index);
    
    if (index == 6) {
        MyMoneyViewController *myMoneyPage = [MyMoneyViewController new];
        [self.navigationController pushViewController:myMoneyPage animated:YES];
    }
    
    
    
    switch (index) {
        case 0:

            break;
        case 1:

            break;
        case 2:

            break;
        case 3:

            break;
        case 4:

            break;
        case 5:

            break;
        case 6:

            break;
        case 7:

            break;
        case 8:

            break;
        case 9:

            break;
        case 10:

            break;
        default:
            break;
    }
}
@end
