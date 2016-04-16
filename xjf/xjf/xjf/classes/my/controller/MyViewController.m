//
//  MyViewController.m
//  xjf
//
//  Created by yiban on 16/3/21.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "MyViewController.h"
#import "SettingViewController.h"
#import "myConfigure.h"
@interface MyViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    
}
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *sectionsArray;
@end

@implementation MyViewController
@synthesize tableview=_tableview;
@synthesize sectionsArray=_sectionsArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.isIndex = YES;
    self.navTitle =@"我的";
    //
    if (!_sectionsArray) {
        _sectionsArray =[[NSMutableArray alloc] init];
    }
    _sectionsArray=[NSMutableArray arrayWithObjects:@"userinfo",@"checkinfo",@"menuinfo", nil];
    [self extendheadView];
        [self initMainUI];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    self.sectionsArray=nil;
}
//head UI
-(void)extendheadView
{
    //
    UIButton *downButton = [UIButton buttonWithType:UIButtonTypeCustom];
    downButton.frame = CGRectMake(SCREENWITH -110, 20+(HEADHEIGHT-20-25)/2, 50, 25);
    downButton.tag =10;
    downButton.hidden=NO;
    downButton.titleLabel.font =FONT(14);
    [downButton setTitleColor:UIColorFromRGB(0x285790) forState:UIControlStateNormal];
    [downButton setTitle:@"通知" forState:UIControlStateNormal];
    [downButton addTarget:self action:@selector(headerClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.headView  addSubview:downButton];
    //
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(SCREENWITH -50, 20+(HEADHEIGHT-20-25)/2, 50, 25);
    searchButton.tag =11;
    searchButton.hidden=NO;
    searchButton.titleLabel.font =FONT(14);
    [searchButton setTitleColor:UIColorFromRGB(0x285790) forState:UIControlStateNormal];
    [searchButton setTitle:@"设置" forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(headerClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.headView  addSubview:searchButton];
}


-(void)headerClickEvent:(id)sender
{
    UIButton *btn =(UIButton *)sender;
    switch (btn.tag) {
        case 0:
        {
            if (self.navigationController) {
                if (self.navigationController.viewControllers.count == 1) {
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                } else {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } else {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
            break;
        case 10://通知
        {
        }
            break;
        case 11://设置
        {
            SettingViewController *download =[[SettingViewController alloc] init];
            [self.navigationController pushViewController:download animated:YES];
        }
            break;
        default:
            break;
    }
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
   
    _tableview.tableFooterView = [self footerView:@""];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionsArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *sectionTitle =[self.sectionsArray objectAtIndex:section];
    if ([sectionTitle isEqualToString:@"userinfo"])
    {
        return 1;
    }else if ([sectionTitle isEqualToString:@"checkinfo"])
    {
        return 1;
    }else if ([sectionTitle isEqualToString:@"menuinfo"])
    {
        return 5;
    }
    
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sectionTitle =[self.sectionsArray objectAtIndex:indexPath.section];
    if ([sectionTitle isEqualToString:@"userinfo"])
    {
        return [UserHeaderCell returnCellHeight:nil];

    }else if ([sectionTitle isEqualToString:@"checkinfo"])
    {
        return [UserCheckInCell returnCellHeight:nil];
    }else if ([sectionTitle isEqualToString:@"menuinfo"])
    {
        return 50;
    }
    
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle =[self.sectionsArray objectAtIndex:section];
    if ([sectionTitle isEqualToString:@"userinfo"])
    {
    }else if ([sectionTitle isEqualToString:@"checkinfo"])
    {
    }else if ([sectionTitle isEqualToString:@"menuinfo"])
    {
    }
    
    return 0.01;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sectionTitle =[self.sectionsArray objectAtIndex:indexPath.section];
    if ([sectionTitle isEqualToString:@"userinfo"])
    {
        UserHeaderCell *cell = (UserHeaderCell*)[tableView  dequeueReusableCellWithIdentifier:@"UserHeaderCell"];
        if(cell == nil)
        {
            cell = [[UserHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserHeaderCell"];
            cell.backgroundColor=[UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            __weak typeof (self) wSelf = self;
            [cell setCallBack:^(BEventType t, UIView *v,id obj,id key,NSIndexPath *indexPath) {
                [wSelf cellAction:t views:v obj:obj key:key indexPath:indexPath];
            }];
        }
        [cell showInfo:nil other:nil key:sectionTitle indexPath:indexPath];
        return cell;
    }else if ([sectionTitle isEqualToString:@"checkinfo"])
    {
        UserCheckInCell *cell = (UserCheckInCell*)[tableView  dequeueReusableCellWithIdentifier:@"UserCheckInCell"];
        if(cell == nil)
        {
            cell = [[UserCheckInCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserCheckInCell"];
            cell.backgroundColor=[UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            __weak typeof (self) wSelf = self;
            [cell setCallBack:^(BEventType t, UIView *v,id obj,id key,NSIndexPath *indexPath) {
                [wSelf cellAction:t views:v obj:obj key:key indexPath:indexPath];
            }];
        }
        [cell showInfo:nil other:nil key:sectionTitle indexPath:indexPath];
        return cell;
    }else if ([sectionTitle isEqualToString:@"menuinfo"])
    {
        static NSString *identifier = @"menuinfo";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"播放记录";
                break;
            case 1:
                cell.textLabel.text = @"我的缓存";
                break;
            case 2:
                cell.textLabel.text = @"我的收藏";
                break;
            case 3:
                cell.textLabel.text = @"会员中心";
                break;
            case 4:
                cell.textLabel.text = @"反馈意见";
                break;
            default:
                break;
        }
        return cell;
    }
    
    static NSString *identifier = @"statusCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
    
}
-(void)cellAction:(BEventType)type views:(UIView *)v obj:(id)obj key:(id)key indexPath:(NSIndexPath *)indexPath
{
    switch (type)
    {
        case BEventType_Unknow:
            break;
    }
}
@end
