//
//  IndexMoreViewController.m
//  xjf
//
//  Created by yiban on 16/4/11.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "IndexMoreViewController.h"
#import "IndexConfigure.h"
#import "playerConfigure.h"
@interface IndexMoreViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    
}
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *sectionsArray;

@end

@implementation IndexMoreViewController
@synthesize titleName=_titleName;
@synthesize tableview=_tableview;
@synthesize sectionsArray=_sectionsArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navTitle = self.titleName;
    if (!_sectionsArray) {
        _sectionsArray =[[NSMutableArray alloc] init];
    }
    _sectionsArray=[NSMutableArray arrayWithObjects:@"morebannercell",@"morerecommendcell",@"moresubscribecell", nil];
    //
    [self extendheadView];
    [self initMainUI];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    
}
//head UI
-(void)extendheadView
{
    //
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(SCREENWITH -50, 20+(HEADHEIGHT-20-25)/2, 50, 25);
    searchButton.tag =10;
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
        case 10://搜索 #import "SearchViewController.h"
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
    _tableview =[[UITableView alloc] initWithFrame:CGRectMake(0, HEADHEIGHT, SCREENWITH, SCREENHEIGHT-HEADHEIGHT) style:UITableViewStylePlain];
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
    if ([sectionTitle isEqualToString:@"morebannercell"])
    {
        return [MoreBannerCell returnCellHeight:nil];
    }else if ([sectionTitle isEqualToString:@"morerecommendcell"])
    {
        return [MoreRecommendCell returnCellHeight:nil];
    }else if ([sectionTitle isEqualToString:@"moresubscribecell"])
    {
        return [MoreSubscribeCell returnCellHeight:nil];
    }
    return 50;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *sectionTitle =[self.sectionsArray objectAtIndex:indexPath.section];
    if ([sectionTitle isEqualToString:@"morebannercell"])
    {
        MoreBannerCell *cell = (MoreBannerCell*)[tableView  dequeueReusableCellWithIdentifier:@"MoreBannerCell"];
        if(cell == nil)
        {
            cell = [[MoreBannerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MoreBannerCell"];
            cell.backgroundColor=[UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            __weak typeof (self) wSelf = self;
            [cell setCallBack:^(BEventType t, UIView *v,id obj,id key,NSIndexPath *indexPath) {
                [wSelf cellAction:t views:v obj:obj key:key indexPath:indexPath];
            }];
        }
        [cell showInfo:nil key:sectionTitle indexPath:indexPath];
        return cell;
    }else if ([sectionTitle isEqualToString:@"morerecommendcell"])
    {
        MoreRecommendCell *cell = (MoreRecommendCell*)[tableView  dequeueReusableCellWithIdentifier:@"MoreRecommendCell"];
        if(cell == nil)
        {
            cell = [[MoreRecommendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MoreRecommendCell"];
            cell.backgroundColor=[UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            __weak typeof (self) wSelf = self;
            [cell setCallBack:^(BEventType t, UIView *v,id obj,id key,NSIndexPath *indexPath) {
                [wSelf cellAction:t views:v obj:obj key:key indexPath:indexPath];
            }];
        }
        [cell showInfo:nil key:sectionTitle indexPath:indexPath];
        return cell;
    }else if ([sectionTitle isEqualToString:@"moresubscribecell"])
    {
        MoreSubscribeCell *cell = (MoreSubscribeCell*)[tableView  dequeueReusableCellWithIdentifier:@"MoreSubscribeCell"];
        if(cell == nil)
        {
            cell = [[MoreSubscribeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MoreSubscribeCell"];
            cell.backgroundColor=[UIColor clearColor];
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
    if ([sectionTitle isEqualToString:@"morerecommendcell"])
    {
        
    }
    PlayerViewController *player = [[PlayerViewController alloc] init];
    [self.navigationController pushViewController:player animated:YES];
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
