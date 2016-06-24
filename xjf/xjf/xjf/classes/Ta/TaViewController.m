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
#import "XjfRequest.h"
#import "FansFocus.h"
#import "ZToastManager.h"

@interface TaViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIView *footer;
@property (nonatomic, strong) UIButton *footerAnimate;
@property (nonatomic, strong) UIImageView *focus;
@property (nonatomic, strong) UIButton *focusButton;
@property (nonatomic, strong) UILabel *focusLabel;
@end

@implementation TaViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainUI];
}

- (void)initMainUI {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footer];
    [self requestData:focusOrNot Method:POST];
    if (self.model) {
        UserInfoModel *userInfo = (UserInfoModel *)self.model;
        self.nav_title = [NSString stringWithFormat:@"%@的个人主页",userInfo.nickname];
    }
}

- (UIView *)footer {
    if (!_footer) {
        _footer = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT - 50 - HEADHEIGHT, SCREENWITH, 50)];
        _footer.backgroundColor = [UIColor whiteColor];
        [_footer addSubview:self.focusButton];
    }
    return _footer;
}

- (UIButton *)footerAnimate {
    if (!_footerAnimate) {
        _footerAnimate = [UIButton buttonWithType:UIButtonTypeCustom];
        _footerAnimate.frame = CGRectMake(SCREENWITH / 2 - 50, SCREENHEIGHT - HEADHEIGHT - 50, 100, 50);
        _footerAnimate.backgroundColor = [UIColor whiteColor];
        _footerAnimate.layer.cornerRadius = 5;
        _footerAnimate.layer.masksToBounds = YES;
        _footerAnimate.alpha = 0;
        [_footerAnimate addTarget:self action:@selector(cancelFocus) forControlEvents:UIControlEventTouchUpInside];
        [_footerAnimate setTitle:@"取消关注" forState:UIControlStateNormal];
        _footerAnimate.titleLabel.font = FONT15;
        [_footerAnimate setTitleColor:[UIColor xjfStringToColor:@"#444444"] forState:UIControlStateNormal];
    }
    return _footerAnimate;
}

- (UIButton *)focusButton {
    if (!_focusButton) {
        _focusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _focusButton.frame = CGRectMake(0, 0, SCREENWITH, 50);
        [_focusButton addSubview:self.focus];
        [_focusButton addSubview:self.focusLabel];
        [_focusButton addTarget:self action:@selector(focusAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _focusButton;
}

- (UILabel *)focusLabel {
    if (!_focusLabel) {
        _focusLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWITH / 2 + 5, 14, 50, 18)];
        _focusLabel.font = FONT15;
        _focusLabel.textColor = AssistColor;
        _focusLabel.text = @"加关注";
    }
    return _focusLabel;
}

- (UIImageView *)focus {
    if (!_focus) {
        _focus = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"focus_on"] highlightedImage:[UIImage imageNamed:@"focus_off"]];
        _focus.frame = CGRectMake(SCREENWITH / 2 - 27, 14, 22, 22);
        _focus.userInteractionEnabled = YES;
    }
    return _focus;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, SCREENHEIGHT - kTabBarH) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerNib:[UINib nibWithNibName:@"TaBaseCell" bundle:nil] forCellReuseIdentifier:@"TaBaseCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"TaBaseCellFoot" bundle:nil] forCellReuseIdentifier:@"TaBaseCellFoot"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)cancelFocus {
    [self requestData:focus_off Method:POST];
    [UIView animateWithDuration:0.3 animations:^{
        self.footerAnimate.frame = CGRectMake(SCREENWITH / 2 - 50, SCREENHEIGHT - HEADHEIGHT, 100, 50);
        self.footerAnimate.alpha = 0;
    }                completion:^(BOOL finished) {
        [self.footerAnimate removeFromSuperview];
    }];
}

- (void)focusAction:(UIButton *)button {
    if (_focus.highlighted) {
        [self.view insertSubview:self.footerAnimate belowSubview:self.footer];
        [UIView animateWithDuration:0.3 animations:^{
            self.footerAnimate.frame = CGRectMake(SCREENWITH / 2 - 50, SCREENHEIGHT - HEADHEIGHT - 110, 100, 50);
            self.footerAnimate.alpha = 1.0;
        }];
    } else {
        [self requestData:focus_on Method:POST];
    }
}

- (void)requestData:(APIName *)api Method:(RequestMethod)method {
    UserInfoModel *userinfo = (UserInfoModel *) self.model;
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];
    request.requestParams = [NSMutableDictionary dictionaryWithDictionary:@{@"ref_user_id" : userinfo.id}];
    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"errCode"] integerValue] == 0) {
            [self resetFooter:[api isEqualToString:focus_on] ? YES : NO];
            if ([api isEqualToString:focus_on]) {
                [self resetFooter:YES];
            } else if ([api isEqualToString:focus_off]) {
                [self resetFooter:NO];
            } else if ([api isEqualToString:focusOrNot]) {
                NSDictionary *result = [dic objectForKey:@"result"];
                [self resetFooter:result[@"success"]];
            }
        } else {
            [[ZToastManager ShardInstance] showtoast:dic[@"errMsg"]];
        }
    }                  failedBlock:^(NSError *_Nullable error) {
        [[ZToastManager ShardInstance] showtoast:@"连接服务器失败"];
    }];
}

- (void)resetFooter:(BOOL)isFocusOn {
    _focus.highlighted = isFocusOn;
    _focusLabel.text = isFocusOn ? @"已关注" : @"加关注";
    _focusLabel.textColor = isFocusOn ? [UIColor xjfStringToColor:@"#9a9a9a"] : [UIColor xjfStringToColor:@"#f39700"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 146;
    } else {
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
    } else {
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
