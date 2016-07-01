//
//  UserInfoController.m
//  xjf
//
//  Created by PerryJ on 16/6/30.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "UserInfoController.h"
#import "UserProfileModel.h"
#import "UIImageView+WebCache.h"
#import "SettingViewController.h"
#import "MyTopicViewController.h"
#import "CommentViewController.h"
#import "XJAccountManager.h"
#import "UserInfoViewController.h"
#import "Fans_FocusViewController.h"
#import "LoginViewController.h"
#import "RegistViewController.h"
#import "UserInfoListCell.h"
#import "MyPlayerHistoryViewController.h"
#import "MyFavoredsViewController.h"
#import "MyMoneyViewController.h"
#import "MyOrderViewController.h"
#import "ShoppingCartViewController.h"
#import "FeedbackViewController.h"
#import "TopicBaseCellTableViewCell.h"
#import "XjfRequest.h"
#import "StringUtil.h"
#import "TaTopicViewController.h"
#import "UITableViewCell+AvatarEnabled.h"
#import "TopicDetailViewController.h"

@interface UserInfoController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *focusButton;
@property (weak, nonatomic) IBOutlet UIButton *back;
@property (assign, nonatomic) BOOL hasLogined;
@property (weak, nonatomic) IBOutlet UIButton *setting;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UIView *topic;
@property (weak, nonatomic) IBOutlet UIView *comment;
@property (weak, nonatomic) IBOutlet UILabel *topic_count;
@property (weak, nonatomic) IBOutlet UILabel *comment_count;
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UILabel *summary;
@property (weak, nonatomic) IBOutlet UILabel *fans;
@property (weak, nonatomic) IBOutlet UILabel *focus;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UserProfileModel *model;
@property (strong, nonatomic) NSMutableArray *dataSource;
@end

@implementation UserInfoController

-(instancetype)initWithUserType:(UserType)type userInfo:(UserInfoModel *)model {
    if (self = [super init]) {
        _userType = type;
        _model = [[UserProfileModel alloc] init];
        _model.result = model;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self setNeedsStatusBarAppearanceUpdate];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super  viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self setNeedsStatusBarAppearanceUpdate];
}
- (void)viewDidLoad {
    [self initProperties];
    [self initUI];
    [self initControl];
    [self initData];
}
- (void)initProperties {
    self.hasLogined = [[XJAccountManager defaultManager] accessToken]!=nil;
    if (self.userType == Myself) {
        self.dataSource = [NSMutableArray arrayWithArray:@[@"播放历史",@"我的收藏",@"我的钱包",@"我的订单",@"购物车",@"我的反馈"]];
        self.model = [[XJAccountManager defaultManager] user_model];
    }else {
        self.dataSource = [NSMutableArray array];
    }
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UserInfoDidChangedNotification object:nil] subscribeNext:^(NSNotification *x) {
        @strongify(self);
        if (self.userType == Myself) {
            if (x.object){
                self.model = x.object;
                self.hasLogined = YES;
            }else {
                self.model = nil;
                self.hasLogined = NO;
            }
            [self initData];
        }
    }];
}
- (void)initUI {
    if (self.userType == Myself) {
        [_tableView registerNib:[UINib nibWithNibName:@"UserInfoListCell" bundle:nil] forCellReuseIdentifier:@"UserInfoListCell"];
        _setting.hidden = NO;
        _focusButton.hidden = YES;
        _back.hidden = YES;
    }else {
        [_tableView registerNib:[UINib nibWithNibName:@"TopicBaseCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"TopicBaseCellTableViewCell"];
        _setting.hidden = YES;
        _focusButton.hidden = NO;
        _back.hidden = NO;
        [self requestData];
    }
    [_userAvatar.layer setCornerRadius:35];
    [_userAvatar.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [_userAvatar.layer setBorderWidth:5.f];
    [_userAvatar.layer setMasksToBounds:YES];
}
- (void)initControl {
    NSArray *views = @[_fans,_focus,_topic,_comment,_userAvatar];
    for (int i = 0; i < views.count; i++) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidClicked:)];
        UIView *view = views[i];
        view.tag = 770+i;
        [view addGestureRecognizer:tap];
    }
}
- (void)initData {
    if (self.userType == Myself) {
        if (self.hasLogined) {
            [self initUserInfo];
        }else {
            [_userAvatar setImage:[UIImage imageNamed:@"user_unload"]];
            [_nickname setText:@"登录"];
            [_summary setText:@""];
            [_fans setText:@"粉丝"];
            [_focus setText:@"关注"];
            [_topic_count setText:[NSString stringWithFormat:@"%ld",self.model.result.topic_count]];
            [_comment_count setText:[NSString stringWithFormat:@"%ld",self.model.result.reply_count]];
        }
    }else {
        [self initUserInfo];
        [self requestData];
        [self requestDataWithApi:focusOrNot method:POST];
    }
}
- (void)initUserInfo {
    [_userAvatar sd_setImageWithURL:[NSURL URLWithString:self.model.result.avatar]];
    [_nickname setText:self.model.result.nickname];
    [_summary setText:self.model.result.quote?:@"这个家伙很懒，没有简介信息~"];
    [_fans setText:[NSString stringWithFormat:@"粉丝   %@",self.model.result.follower?:@"0"]];
    [_focus setText:[NSString stringWithFormat:@"关注   %@",self.model.result.following?:@"0"]];
    [_topic_count setText:[NSString stringWithFormat:@"%ld",self.model.result.topic_count]];
    [_comment_count setText:[NSString stringWithFormat:@"%ld",self.model.result.reply_count]];
}

- (void)requestData {
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:[NSString stringWithFormat:@"/api/user/%@/topic",self.model.result.id] RequestMethod:GET];
    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
        TopicModel *model = [[TopicModel alloc] initWithData:responseData error:nil];
        if (model.errCode == 0) {
            [self.dataSource addObjectsFromArray:model.result.data];
            [self.tableView reloadData];
        } else {
            [[ZToastManager ShardInstance] showtoast:_model.errMsg];
        }
    }                  failedBlock:^(NSError *_Nullable error) {
        [[ZToastManager ShardInstance] showtoast:@"网络连接失败"];
    }];
}
- (IBAction)focusButtonClicked:(UIButton *)sender {
    APIName *api = nil;
    if (sender.selected) {
        api = focus_off;
    }else {
        api = focus_on;
    }
    [self requestDataWithApi:api method:POST];
}
- (void)requestDataWithApi:(APIName *)api method:(RequestMethod)method {
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:POST];
    request.requestParams = [NSMutableDictionary dictionaryWithDictionary:@{@"ref_user_id":self.model.result.id}];
    [request startWithSuccessBlock:^(NSData * _Nullable responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
        if ([api isEqualToString:focusOrNot]) {
            if ([dic[@"errCode"] integerValue] == 0) {
                _focusButton.selected = [dic[@"result"][@"success"] boolValue];
            }else {
                NSLog(@"检查是否关注失败");
            }
        }else {
            if ([dic[@"errCode"] integerValue] == 0) {
                [[ZToastManager ShardInstance] showtoast:_focusButton.selected?@"取消关注成功":@"关注成功"];
                _focusButton.selected = !_focusButton.isSelected;
                [[XJAccountManager defaultManager] updateUserInfo];
            }else {
                [[ZToastManager ShardInstance] showtoast:@"请求失败"];
            }
        }
    } failedBlock:^(NSError * _Nullable error) {
        [[ZToastManager ShardInstance] showtoast:@"请求失败"];
    }];
}
- (IBAction)backButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)settingButtonClicked:(UIButton *)sender {
    SettingViewController *setting = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:setting animated:YES];
}
- (void)viewDidClicked:(UITapGestureRecognizer *)tap {
    NSInteger tag = tap.view.tag;
        if (!self.hasLogined) {
            if (tag != 774) {
                [self loginPrompt];
            }else {
                LoginViewController *login = [[LoginViewController alloc] init];
                [self.navigationController pushViewController:login animated:YES];
            }
            return;
        }
        switch (tag) {
            case 770:
            {
                Fans_FocusViewController *fans_focus = [[Fans_FocusViewController alloc] initWithID:self.model.result.id type:0 nickname:self.model.result.nickname];
                [self.navigationController pushViewController:fans_focus animated:YES];
            }
                break;
            case 771:
            {
                Fans_FocusViewController *fans_focus = [[Fans_FocusViewController alloc] initWithID:self.model.result.id type:1 nickname:self.model.result.nickname];
                [self.navigationController pushViewController:fans_focus animated:YES];
            }
                break;
            case 772:
            {
                if (self.userType == Myself) {
                    MyTopicViewController *controller = [[MyTopicViewController alloc] init];
                    [self.navigationController pushViewController:controller animated:YES];
                }else {
                    TaTopicViewController *controller = [[TaTopicViewController alloc] initWithID:self.model.result.id nickname:self.model.result.nickname];
                    [self.navigationController pushViewController:controller animated:YES];
                }
            }
                break;
            case 773:
            {
                CommentViewController *controller = [[CommentViewController alloc] initWith:(UserInfoModel *)self.model.result];
                [self.navigationController pushViewController:controller animated:YES];
            }
                break;
            case 774:
            {
                if (self.userType == Myself) {
                    UserInfoViewController *userInfo = [[UserInfoViewController alloc] init];
                    [self.navigationController pushViewController:userInfo animated:YES];
                }
            }
                break;
            default:
                break;
        }
}

- (void)loginPrompt {
    [AlertUtils alertWithTarget:self title:@"登录您将获得更多功能"
                        okTitle:@"登录"
                     otherTitle:@"注册"
              cancelButtonTitle:@"取消"
                        message:@"参与话题讨论\n\n播放记录云同步\n\n更多金融专业课程"
                    cancelBlock:^{
                    } okBlock:^{
                        LoginViewController *loginPage = [LoginViewController new];
                        [self.navigationController pushViewController:loginPage animated:YES];
                    }        otherBlock:^{
                        RegistViewController *registPage = [RegistViewController new];
                        registPage.title_item = @"注册";
                        [self.navigationController pushViewController:registPage animated:YES];
                    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.userType == Myself) {
        UserInfoListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoListCell"];
        cell.titleLabel.text = self.dataSource[indexPath.row];
        return cell;
    }else {
        TopicBaseCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopicBaseCellTableViewCell"];
        cell.avatarEnabled = NO;
        cell.model = self.dataSource&&self.dataSource.count>0?self.dataSource[indexPath.row]:nil;
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.userType == Myself) {
        return 60;
    }else {
        TopicDataModel *model = self.dataSource&&self.dataSource.count>0?self.dataSource[indexPath.row]:nil;
        CGFloat height = [StringUtil calculateLabelHeight:model.content width:SCREENWITH-40 fontsize:15]+81+42;
        height = height>210?202:height;
        return height;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.userType == Myself) {
        UIViewController *controller = nil;
        switch (indexPath.row) {
            case 0:
            {
                controller = [[MyPlayerHistoryViewController alloc] init];
            }
                break;
            case 1:
            {
                controller = [[MyFavoredsViewController alloc] init];
            }
                break;
            case 2:
            {
                controller = [[MyMoneyViewController alloc] init];
            }
                break;
            case 3:
            {
                controller = [[MyOrderViewController alloc] init];
            }
                break;
            case 4:
            {
                controller = [[ShoppingCartViewController alloc] init];
            }
                break;
            case 5:
            {
                controller = [[FeedbackViewController alloc] init];
            }
                break;
            default:
                break;
        }
        [self.navigationController pushViewController:controller animated:YES];
    }else {
        TopicDataModel *model = self.dataSource&&self.dataSource.count>0?[self.dataSource objectAtIndex:indexPath.row]:nil;
        if (model) {
            TopicDetailViewController *controller = [[TopicDetailViewController alloc] init];
            controller.topic_id = model.id;
            [self.navigationController pushViewController:controller animated:YES];
        }
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
