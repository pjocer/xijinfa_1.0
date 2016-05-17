//
//  MyViewController.m
//  xjf
//
//  Created by yiban on 16/3/21.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "MyViewController.h"
#import "myConfigure.h"

@interface MyViewController ()<UITableViewDataSource, UITableViewDelegate,UserDelegate,UserComponentCellDelegate>
{
    
}
@property (nonatomic, strong) AccountInfoModel *model;
@property (nonatomic, strong) UITableView *tableview;
@end

@implementation MyViewController
@synthesize tableview=_tableview;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
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
-(void)initMainUI
{
    _tableview =[[UITableView alloc] initWithFrame:CGRectMake(0, HEADHEIGHT, SCREENWITH, SCREENHEIGHT-HEADHEIGHT-45) style:UITableViewStylePlain];
    _tableview.dataSource=self;
    _tableview.delegate=self;
    _tableview.showsVerticalScrollIndicator = NO;
    _tableview.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_tableview];
    [_tableview registerNib:[UINib nibWithNibName:@"UserUnLoadCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"UserUnLoadCell"];
    [_tableview registerClass:[UserComponentCell class] forCellReuseIdentifier:@"UserComponentCell"];
    _tableview.tableFooterView = [self footerView:@""];
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - TableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 120;
    }
    return 320;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UserUnLoadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserUnLoadCell" forIndexPath:indexPath];
//        cell.type = (self.model = nil)?:
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
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
        LoginViewController *login = [LoginViewController new];
        login.delegate = self;
        [self.navigationController pushViewController:login animated:YES];
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
-(void)componentDidSelected:(NSUInteger)index {
    NSLog(@"%lu",index);
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
