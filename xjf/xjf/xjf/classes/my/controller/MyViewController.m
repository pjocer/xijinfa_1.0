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
#import "ShoppingCartViewController.h"
#import "MyTeacherViewController.h"
#import "MyTopicViewController.h"
#import "MyLessonsViewController.h"
#import "MyFavoredsViewController.h"
#import "MyPlayerHistoryViewController.h"
#import "MyCommentViewController.h"
#import "XJAccountManager.h"
#import "VipPayListViewController.h"
#import "RegistViewController.h"
#import "XjfRequest.h"
#import "ZToastManager.h"
#import "FeedbackViewController.h"

@interface MyViewController () <UITableViewDataSource, UITableViewDelegate, UserDelegate, UserComponentCellDelegate> {

}
@property (nonatomic, strong) UserProfileModel *model;
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UIButton *footer;
@property (nonatomic, strong) UIView *foot_background;
@property (nonatomic, strong) UserInfoViewController *userinfo;
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
    self.model = [[UserProfileModel alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO] error:nil];
    [self extendheadViewFor:My];
    [self initMainUI];
    [self resetTableViewFooter];
    @weakify(self)
    ReceivedNotification(self, UserInfoDidChangedNotification, ^(NSNotification *notification) {
        @strongify(self)
        self.model = notification.object;
        [self resetTableViewFooter];
        [self.tableview reloadData];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//main UI
- (void)initMainUI {
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, SCREENHEIGHT - kTabBarH - HEADHEIGHT) style:UITableViewStylePlain];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.showsVerticalScrollIndicator = NO;
    _tableview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableview];
    [_tableview registerNib:[UINib nibWithNibName:@"UserUnLoadCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"UserUnLoadCell"];
    [_tableview registerNib:[UINib nibWithNibName:@"UserLoadCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"UserLoadCell"];
    [_tableview registerClass:[UserComponentCell class] forCellReuseIdentifier:@"UserComponentCell"];
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)resetTableViewFooter {
    if (self.model.result.membership) {
        _tableview.tableFooterView = self.foot_background;
    }
}

- (UIView *)foot_background {
    if (!_foot_background) {
        _foot_background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, 60)];
        _foot_background.backgroundColor = [UIColor clearColor];
        _footer = [UIButton buttonWithType:UIButtonTypeCustom];
        _footer.frame = CGRectMake(10, 10, SCREENWITH - 20, 50);
        _footer.layer.cornerRadius = 5;
        _footer.layer.masksToBounds = YES;
        _footer.backgroundColor = [UIColor xjfStringToColor:@"#e60012"];
        [_footer setTitle:@"开通会员" forState:UIControlStateNormal];
        [_footer setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_footer addTarget:self action:@selector(dredgeVIP:) forControlEvents:UIControlEventTouchUpInside];
        [_foot_background addSubview:_footer];
        //是否是会员
        if (self.model.result.membership.count != 0) {
            [_footer setTitle:@"续费会员" forState:UIControlStateNormal];
        }
    }
    return _foot_background;
}

- (void)dredgeVIP:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"开通会员"]) {
        VipPayListViewController *vipPayListViewController = [VipPayListViewController new];
        [self.navigationController pushViewController:vipPayListViewController animated:YES];
    } else if ([sender.titleLabel.text isEqualToString:@"续费会员"]) {
        VipPayListViewController *vipPayListViewController = [VipPayListViewController new];
        [self.navigationController pushViewController:vipPayListViewController animated:YES];
    }
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
            self.userinfo = [[UserInfoViewController alloc] init];
            [self.navigationController pushViewController:self.userinfo animated:YES];
        } else {
            LoginViewController *login = [LoginViewController new];
            login.delegate = self;
            [self.navigationController pushViewController:login animated:YES];
        }
    }
}

#pragma UserComponentDelegate

- (void)componentDidSelected:(NSUInteger)index {

    if ([[XJAccountManager defaultManager] accessToken] == nil ||
            [[[XJAccountManager defaultManager] accessToken] length] == 0) {
        [self LoginPrompt];
    }
    {
        [self pushAction:index];
    }

}

- (void)pushAction:(NSUInteger)index {
    switch (index) {
        case 0: {
            MyLessonsViewController *myLessonsViewController = [MyLessonsViewController new];
            [self.navigationController pushViewController:myLessonsViewController animated:YES];
        }
            break;
        case 1: {
            MyTeacherViewController *myTeacherViewController = [MyTeacherViewController new];
            [self.navigationController pushViewController:myTeacherViewController animated:YES];
        }
            break;
        case 2: {
            MyTopicViewController *controller = [[MyTopicViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 3: {
            MyCommentViewController *controller = [[MyCommentViewController alloc] initWith:(UserInfoModel *) [[XJAccountManager defaultManager] user_model].result];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 4: {
            MyPlayerHistoryViewController *myPlayerHistoryViewController = [[MyPlayerHistoryViewController alloc] init];
            [self.navigationController pushViewController:myPlayerHistoryViewController animated:YES];
        }
            break;
        case 5: {
            MyFavoredsViewController *myFavoredsViewController = [[MyFavoredsViewController alloc] init];
            [self.navigationController pushViewController:myFavoredsViewController animated:YES];
        }
            break;
        case 6: {
            MyMoneyViewController *myMoneyPage = [MyMoneyViewController new];
            [self.navigationController pushViewController:myMoneyPage animated:YES];
        }
            break;
        case 7: {
            ShoppingCartViewController *shoppingCartPage = [ShoppingCartViewController new];
            [self.navigationController pushViewController:shoppingCartPage animated:YES];
        }
            break;
        case 8: {
            [self PostCheckinMessageToSever:checkin Method:POST];
        }
            break;
        case 9: {
            FeedbackViewController *feedbackViewController = [FeedbackViewController new];\
            [self.navigationController pushViewController:feedbackViewController animated:YES];
        }
            break;
        default:
            break;
    }
}

///发送签到请求
- (void)PostCheckinMessageToSever:(APIName *)api
                           Method:(RequestMethod)method {
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];
    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {

        id result = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
        NSString *errMsgStr = result[@"errMsg"];

        if (![errMsgStr isEqualToString:@"重复签到"]) {
            [[ZToastManager ShardInstance] showtoast:@"今日已签到 金币 + 1 "];
        } else {
            [[ZToastManager ShardInstance] showtoast:result[@"errMsg"]];
        }

    }                  failedBlock:^(NSError *_Nullable error) {

    }];
}

@end
