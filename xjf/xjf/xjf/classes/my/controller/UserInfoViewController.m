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

@interface UserInfoViewController () <UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UserProfileModel *model;
@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nav_title = @"修改个人信息";
    self.model = [[XJAccountManager defaultManager] user_model];
    self.view.backgroundColor = BackgroundColor;
    [self initTableView];
}

- (void)initTableView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGRect frame = CGRectMake(0, 0, SCREENWITH, SCREENHEIGHT-kTabBarH-HEADHEIGHT);
    self.tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
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
    }else if (indexPath.row == 1){
        return 152;
    }else if (indexPath.row == 2) {
        return 60;
    }else if (indexPath.row == 3) {
        return 162;
    }
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.NicknameBlock = ^(NSString *nickname) {
            NSLog(@"%@",nickname);
        };
        cell.SummaryBlock = ^(NSString *summary) {
            NSLog(@"%@",summary);
        };
        cell.model = self.model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 1){
        UserInfoSection1 *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoSection1"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.CityBlock = ^(NSString *city) {
            NSLog(@"%@",city);
        };
        cell.AgeBlock = ^(NSString *age) {
            NSLog(@"%@",age);
        };
        cell.SexBlock = ^(NSString *sex) {
            NSLog(@"%@",sex);
        };
        cell.model = self.model;
        return cell;
    }else if (indexPath.row == 2) {
        UserInfoSection2 *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoSection2"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.model;
        return cell;
    }else if (indexPath.row == 3) {
        UserInfoSection3 *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoSection3"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.InterestedBlock = ^(NSString *interested_invest) {
            NSLog(@"%@",interested_invest);
        };
        cell.PreferenceBlock = ^(NSString *preference_invest) {
            NSLog(@"%@",preference_invest);
        };
        cell.ExperienceBlock = ^(NSString *experience_invest) {
            NSLog(@"%@",experience_invest);
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
