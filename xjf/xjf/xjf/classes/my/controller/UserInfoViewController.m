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
#import "UserInfoListCell.h"

@interface UserInfoViewController () <UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *array;
@property (strong, nonatomic) NSArray *array_detail;
@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.array = [NSMutableArray arrayWithObjects:@"性别",@"地区",@"年龄",@"手机号",@"邮箱",@"感兴趣的金融知识",@"投资理财资历",@"投资偏好", nil];
    UserProfileModel *model = [[XJAccountManager defaultManager] user_model];
    NSString *sex = ([model.result.sex integerValue]==1)?@"男":(([model.result.sex integerValue]==0)?@"女":@"未知");
    self.array_detail = @[sex,model.result.city,model.result.age,model.result.phone,model.result.email,model.result.invest_category,model.result.invest_age,model.result.invest_type];
    self.view.backgroundColor = BackgroundColor;
    [self initTableView];
}

- (void)initTableView {
    self.automaticallyAdjustsScrollViewInsets = YES;
    CGRect frame = CGRectMake(0, 0, SCREENWITH, SCREENHEIGHT-40);
    self.tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = BackgroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"UserInfoListCell" bundle:nil] forCellReuseIdentifier:@"UserInfoListCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"UserInfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"UserInfoCell"];
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 3;
    }else if (section == 2) {
        return 2;
    }else if (section == 3) {
        return 3;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 110;
    }else {
        return 44;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserProfileModel *model = [[XJAccountManager defaultManager] user_model];
    if (indexPath.section == 0) {
        UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoCell"];
        cell.model = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        UserInfoListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoListCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section == 1) {
            cell.title.text = self.array[indexPath.row];
            cell.detail.text = self.array_detail[indexPath.row];
        }else if (indexPath.section == 2) {
            cell.title.text = self.array[indexPath.row+3];
            cell.detail.text = self.array_detail[indexPath.row+3];
        }else if (indexPath.section ==3) {
            cell.title.text = self.array[indexPath.row+5];
            cell.detail.text = self.array_detail[indexPath.row+5];
        }
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
