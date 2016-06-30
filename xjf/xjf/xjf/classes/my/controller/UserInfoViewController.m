//
//  UserInfoViewController.m
//  xjf
//
//  Created by PerryJ on 16/5/19.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserInfoCell.h"
#import "UserProfileModel.h"
#import "XJAccountManager.h"
#import "UserInfoSection1.h"
#import "UserInfoSection2.h"
#import "UserInfoSection3.h"
#import "XjfRequest.h"
#import "ZToastManager.h"

@interface UserInfoViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UserProfileModel *model;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSURL *imageURL;
@end

@implementation UserInfoViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.nav_title = @"修改个人信息";
    if (!self.params) {
        self.params = [NSMutableDictionary dictionaryWithDictionary:@{@"nickname" : @"", @"sex" : @"", @"quote" : @"", @"city" : @"", @"age" : @"", @"invest_category" : @"", @"invest_age" : @"", @"invest_type" : @""}];
    }
    self.model = [[XJAccountManager defaultManager] user_model];
    self.view.backgroundColor = BackgroundColor;
    [self initTableView];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(commitUserInfo)];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)commitUserInfo {
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    __block int count = 0;
    //upload user info
    dispatch_group_async(group, global, ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        XjfRequest *reuest = [[XjfRequest alloc] initWithAPIName:update_user_info RequestMethod:POST];
        reuest.requestParams = self.params;
        [reuest startWithSuccessBlock:^(NSData *_Nullable responseData) {
            self.model = [[UserProfileModel alloc] initWithData:responseData error:nil];
            if (self.model.errCode == 0) {
                count++;
                dispatch_semaphore_signal(semaphore);
            }
        }                 failedBlock:^(NSError *_Nullable error) {
            dispatch_semaphore_signal(semaphore);
            [[ZToastManager ShardInstance] showtoast:@"更新用户信息失败"];
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    //upload user avatar
    if (self.imageURL) {
        dispatch_group_async(group, global, ^{
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            XjfRequest *request = [[XjfRequest alloc] initWithAPIName:upload_avatar fileURL:self.imageURL];
            [request startWithSuccessBlock:^(NSData * _Nullable responseData) {
                self.model = [[UserProfileModel alloc] initWithData:responseData error:nil];
                if (self.model.errCode == 0) {
                    count++;
                }
                dispatch_semaphore_signal(semaphore);
            } failedBlock:^(NSError * _Nullable error) {
                dispatch_semaphore_signal(semaphore);
                [[ZToastManager ShardInstance] showtoast:@"上传头像失败"];
            }];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        });
    }
    //handle request result
    dispatch_group_notify(group, global, ^{
        if (self.imageURL || self.image) {
            if (count == 2) {
                [self handleResult];
            }
        }else {
            if (count == 1) {
                [self handleResult];
            }
        }
    });
    
}

- (void)handleResult {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[XJAccountManager defaultManager] setUser_model:self.model];
        [[ZToastManager ShardInstance] showtoast:@"更新用户信息成功"];
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)initTableView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGRect frame = CGRectMake(0, 0, SCREENWITH, SCREENHEIGHT - kTabBarH - HEADHEIGHT);
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    self.tableView.backgroundColor = BackgroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"UserInfoSection1" bundle:nil] forCellReuseIdentifier:@"UserInfoSection1"];
    [self.tableView registerNib:[UINib nibWithNibName:@"UserInfoSection2" bundle:nil] forCellReuseIdentifier:@"UserInfoSection2"];
    [self.tableView registerNib:[UINib nibWithNibName:@"UserInfoSection3" bundle:nil] forCellReuseIdentifier:@"UserInfoSection3"];
    [self.tableView registerNib:[UINib nibWithNibName:@"UserInfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"UserInfoCell"];
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 110;
    } else if (indexPath.row == 1) {
        return 152;
    } else if (indexPath.row == 2) {
        return 60;
    } else if (indexPath.row == 3) {
        return 162;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.AvatarBlock = ^(UIImage *image,NSURL *imageURL) {
            self.image = image;
            self.imageURL = imageURL;
            return YES;
        };
        cell.NicknameBlock = ^(NSString *nickname) {
            [self.params setObject:nickname forKey:@"nickname"];
        };
        cell.SummaryBlock = ^(NSString *summary) {
            [self.params setObject:summary forKey:@"quote"];
        };
        cell.model = self.model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.row == 1) {
        UserInfoSection1 *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoSection1"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.CityBlock = ^(NSString *city) {
            [self.params setObject:city forKey:@"city"];
        };
        cell.AgeBlock = ^(NSString *age) {
            [self.params setObject:age forKey:@"age"];
        };
        cell.SexBlock = ^(NSString *sex) {
            [self.params setObject:[sex isEqualToString:@"男"] ? @"1" : @"2" forKey:@"sex"];
        };
        cell.model = self.model;
        return cell;
    } else if (indexPath.row == 2) {
        UserInfoSection2 *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoSection2"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.model;
        return cell;
    } else if (indexPath.row == 3) {
        UserInfoSection3 *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoSection3"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.InterestedBlock = ^(NSString *interested_invest) {
            [self.params setObject:interested_invest forKey:@"invest_type"];
        };
        cell.PreferenceBlock = ^(NSString *preference_invest) {
            [self.params setObject:preference_invest forKey:@"invest_category"];
        };
        cell.ExperienceBlock = ^(NSString *experience_invest) {
            [self.params setObject:experience_invest forKey:@"invest_age"];
        };
        cell.model = self.model;
        return cell;
    }
    return nil;
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
