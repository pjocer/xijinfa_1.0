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
@property(nonatomic,strong)UITableView *tableview;
@end

@implementation MyViewController
@synthesize tableview=_tableview;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self extendheadViewFor:My];
    [self initMainUI];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
////head UI
//-(void)extendheadView
//{
//    //
////    [self initHeaderView];
//     =@"我的";
//    self.isIndex = YES;
//    UIButton *downButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    downButton.frame = CGRectMake(SCREENWITH -110, 20+(HEADHEIGHT-20-25)/2, 50, 25);
//    downButton.tag =10;
//    downButton.titleLabel.font =FONT(14);
//    [downButton setTitleColor:UIColorFromRGB(0x285790) forState:UIControlStateNormal];
//    [downButton setTitle:@"通知" forState:UIControlStateNormal];
//    [downButton addTarget:self action:@selector(headerClickEvent:) forControlEvents:UIControlEventTouchUpInside];
//    [self.headView  addSubview:downButton];
//    //
//    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    searchButton.frame = CGRectMake(SCREENWITH -50, 20+(HEADHEIGHT-20-25)/2, 50, 25);
//    searchButton.tag =11;
//    searchButton.hidden=NO;
//    searchButton.titleLabel.font =FONT(14);
//    [searchButton setTitleColor:UIColorFromRGB(0x285790) forState:UIControlStateNormal];
//    [searchButton setTitle:@"设置" forState:UIControlStateNormal];
//    [searchButton addTarget:self action:@selector(headerClickEvent:) forControlEvents:UIControlEventTouchUpInside];
//    [self.headView  addSubview:searchButton];
//}
//
//
//-(void)headerClickEvent:(id)sender
//{
//    UIButton *btn =(UIButton *)sender;
//    switch (btn.tag) {
//        case 0:
//        {
//            if (self.navigationController) {
//                if (self.navigationController.viewControllers.count == 1) {
//                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//                } else {
//                    [self.navigationController popViewControllerAnimated:YES];
//                }
//            } else {
//                [self dismissViewControllerAnimated:YES completion:nil];
//            }
//        }
//            break;
//        case 10://通知
//        {
//        }
//            break;
//        case 11://设置
//        {
//            SettingViewController *download =[[SettingViewController alloc] init];
//            [self.navigationController pushViewController:download animated:YES];
//        }
//            break;
//        default:
//            break;
//    }
//}
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
