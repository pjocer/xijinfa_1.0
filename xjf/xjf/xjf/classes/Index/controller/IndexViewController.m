//
//  IndexViewController.m
//  xjf
//
//  Created by yiban on 16/3/21.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "IndexViewController.h"
#import "IndexConfigure.h"
#import "playerConfigure.h"
@interface IndexViewController () <UITableViewDataSource, UITableViewDelegate>
{
    
}
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *sectionsArray;
@end

@implementation IndexViewController
@synthesize tableview=_tableview;
@synthesize sectionsArray=_sectionsArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isIndex = YES;
    self.navTitle =@"首页";
    // Do any additional setup after loading the view.
    //
    if (!_sectionsArray) {
        _sectionsArray =[[NSMutableArray alloc] init];
    }
    _sectionsArray=[NSMutableArray arrayWithObjects:@"bannercell",@"appcell",@"talkcell",@"baikecell",@"teachercell",@"coursecell", nil];
    //
    [self extendheadView];
    [self initMainUI];
   
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    self.sectionsArray=nil;
}
//head UI
-(void)extendheadView
{
    //
    UIButton *hisButton = [UIButton buttonWithType:UIButtonTypeCustom];
    hisButton.frame = CGRectMake(SCREENWITH -160, 20+(HEADHEIGHT-20-25)/2, 30, 25);
    hisButton.tag =10;
    hisButton.hidden = NO;
    hisButton.titleLabel.font =FONT(14);
    [hisButton setTitleColor:UIColorFromRGB(0x285790) forState:UIControlStateNormal];
    [hisButton setTitle:@"历史" forState:UIControlStateNormal];
    [hisButton addTarget:self action:@selector(headerClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:hisButton];
    //
    UIButton *downButton = [UIButton buttonWithType:UIButtonTypeCustom];
    downButton.frame = CGRectMake(SCREENWITH -110, 20+(HEADHEIGHT-20-25)/2, 50, 25);
    downButton.tag =11;
    downButton.hidden=NO;
    downButton.titleLabel.font =FONT(14);
    [downButton setTitleColor:UIColorFromRGB(0x285790) forState:UIControlStateNormal];
    [downButton setTitle:@"下载" forState:UIControlStateNormal];
    [downButton addTarget:self action:@selector(headerClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.headView  addSubview:downButton];
    //
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(SCREENWITH -50, 20+(HEADHEIGHT-20-25)/2, 50, 25);
    searchButton.tag =12;
    searchButton.hidden=NO;
    searchButton.titleLabel.font =FONT(14);
    [searchButton setTitleColor:UIColorFromRGB(0x285790) forState:UIControlStateNormal];
    [searchButton setTitle:@"搜索" forState:UIControlStateNormal];
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
        case 10://历史
        {
            PlayerHistoryViewController *history =[[PlayerHistoryViewController alloc] init];
            [self.navigationController pushViewController:history animated:YES];
        }
            break;
        case 11://下载
        {
            PlayerDownLoadViewController *download =[[PlayerDownLoadViewController alloc] init];
            [self.navigationController pushViewController:download animated:YES];
        }
            break;
        case 12://搜索 #import "SearchViewController.h"
        {
            SearchViewController *download =[[SearchViewController alloc] init];
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
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableview];
    _tableview.tableFooterView = [self footerView:@""];
}
//tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionsArray.count;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sectionTitle =[self.sectionsArray objectAtIndex:indexPath.section];
    if ([sectionTitle isEqualToString:@"bannercell"])
    {
        return [IndexBannerCell returnCellHeight:nil];
    }else if ([sectionTitle isEqualToString:@"appcell"])
    {
        return [IndexAppCell returnCellHeight:nil];
    }else if ([sectionTitle isEqualToString:@"talkcell"])
    {
        return [IndexTalkCell returnCellHeight:nil];
    }
    else if ([sectionTitle isEqualToString:@"baikecell"])
    {
        return [IndexBaikeCell returnCellHeight:nil];
    }
    else if ([sectionTitle isEqualToString:@"teachercell"])
    {
        return [IndexTeacherCell returnCellHeight:nil];
    }
    else if ([sectionTitle isEqualToString:@"coursecell"])
    {
        return [IndexCourseCell returnCellHeight:nil];
    }
 
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle =[self.sectionsArray objectAtIndex:section];
    if ([sectionTitle isEqualToString:@"bannercell"] || [sectionTitle isEqualToString:@"appcell"])
    {
           return 0.01;
    }
    return 10;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *sectionTitle =[self.sectionsArray objectAtIndex:indexPath.section];
    if ([sectionTitle isEqualToString:@"bannercell"])
    {
        IndexBannerCell *cell = (IndexBannerCell*)[tableView  dequeueReusableCellWithIdentifier:@"IndexBannerCell"];
        if(cell == nil)
        {
            cell = [[IndexBannerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IndexBannerCell"];
            cell.backgroundColor=[UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            __weak typeof (self) wSelf = self;
            [cell setCallBack:^(BEventType t, UIView *v,id obj,id key,NSIndexPath *indexPath) {
                [wSelf cellAction:t views:v obj:obj key:key indexPath:indexPath];
            }];
        }
        [cell showInfo:nil key:sectionTitle indexPath:indexPath];
        return cell;
    }else if ([sectionTitle isEqualToString:@"appcell"])
    {
        IndexAppCell *cell = (IndexAppCell*)[tableView  dequeueReusableCellWithIdentifier:@"IndexAppCell"];
        if(cell == nil)
        {
            cell = [[IndexAppCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IndexAppCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            __weak typeof (self) wSelf = self;
            [cell setCallBack:^(BEventType t, UIView *v,id obj,id key,NSIndexPath *indexPath) {
                [wSelf cellAction:t views:v obj:obj key:key indexPath:indexPath];
            }];
        }
        [cell showInfo:nil key:sectionTitle indexPath:indexPath];
        return cell;
        
    }else if ([sectionTitle isEqualToString:@"talkcell"])
    {
        IndexTalkCell *cell = (IndexTalkCell*)[tableView  dequeueReusableCellWithIdentifier:@"IndexTalkCell"];
        if(cell == nil)
        {
            cell = [[IndexTalkCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IndexTalkCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            __weak typeof (self) wSelf = self;
            [cell setCallBack:^(BEventType t, UIView *v,id obj,id key,NSIndexPath *indexPath) {
                [wSelf cellAction:t views:v obj:obj key:key indexPath:indexPath];
            }];
        }
        [cell showInfo:nil key:sectionTitle indexPath:indexPath];
        return cell;
    }
    else if ([sectionTitle isEqualToString:@"baikecell"])
    {
        IndexBaikeCell *cell = (IndexBaikeCell*)[tableView  dequeueReusableCellWithIdentifier:@"IndexBaikeCell"];
        if(cell == nil)
        {
            cell = [[IndexBaikeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IndexBaikeCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            __weak typeof (self) wSelf = self;
            [cell setCallBack:^(BEventType t, UIView *v,id obj,id key,NSIndexPath *indexPath) {
                [wSelf cellAction:t views:v obj:obj key:key indexPath:indexPath];
            }];
        }
        [cell showInfo:nil key:sectionTitle indexPath:indexPath];
        return cell;
    }
    else if ([sectionTitle isEqualToString:@"teachercell"])
    {
        IndexTeacherCell *cell = (IndexTeacherCell*)[tableView  dequeueReusableCellWithIdentifier:@"IndexTeacherCell"];
        if(cell == nil)
        {
            cell = [[IndexTeacherCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IndexTeacherCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            __weak typeof (self) wSelf = self;
            [cell setCallBack:^(BEventType t, UIView *v,id obj,id key,NSIndexPath *indexPath) {
                [wSelf cellAction:t views:v obj:obj key:key indexPath:indexPath];
            }];
        }
        [cell showInfo:nil key:sectionTitle indexPath:indexPath];
        return cell;
    }
    else if ([sectionTitle isEqualToString:@"coursecell"])
    {
        IndexCourseCell *cell = (IndexCourseCell*)[tableView  dequeueReusableCellWithIdentifier:@"IndexCourseCell"];
        if(cell == nil)
        {
            cell = [[IndexCourseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IndexCourseCell"];
            cell.backgroundColor=[UIColor redColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            __weak typeof (self) wSelf = self;
            [cell setCallBack:^(BEventType t, UIView *v,id obj,id key,NSIndexPath *indexPath) {
                [wSelf cellAction:t views:v obj:obj key:key indexPath:indexPath];
            }];
        }
        [cell showInfo:nil key:sectionTitle indexPath:indexPath];
        return cell;
    }
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *sectionTitle =[self.sectionsArray objectAtIndex:indexPath.section];
    if ([sectionTitle isEqualToString:@"bannercell"])
    {
        
    }else if ([sectionTitle isEqualToString:@"appcell"])
    {
        
    }else if ([sectionTitle isEqualToString:@"talkcell"])
    {
        
    }
    else if ([sectionTitle isEqualToString:@"baikecell"])
    {
        
    }
    else if ([sectionTitle isEqualToString:@"teachercell"])
    {
        
    }
    else if ([sectionTitle isEqualToString:@"coursecell"])
    {
        
    }
}
-(void)cellAction:(BEventType)type views:(UIView *)v obj:(id)obj key:(id)key indexPath:(NSIndexPath *)indexPath
{
    switch (type)
    {
        case BEventType_Unknow:
            break;
        case BEventType_More:
        {
            IndexMoreViewController *more = [[IndexMoreViewController alloc] init];
            [self.navigationController pushViewController:more animated:YES];
        }
            break;
    }
}
@end
