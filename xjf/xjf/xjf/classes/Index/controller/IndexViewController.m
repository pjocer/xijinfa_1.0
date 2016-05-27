//
//  IndexViewController.m
//  xjf
//
//  Created by yiban on 16/3/21.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "IndexViewController.h"
#import "IndexConfigure.h"
#import "VideolistViewController.h"
#import "PlayerViewController.h"
@interface IndexViewController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *sectionsArray;

@end

@implementation IndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!_sectionsArray) {
        _sectionsArray =[[NSMutableArray alloc] init];
    }
    _sectionsArray=[NSMutableArray arrayWithObjects:@"bannercell",@"appcell",@"talkcell",@"baikecell",@"teachercell",@"coursecell", nil];
    //
    [self extendheadViewFor:Index];
    [self initMainUI];
 
}

-(void)initMainUI
{
    _tableview =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, SCREENHEIGHT-45) style:UITableViewStyleGrouped];
    _tableview.dataSource=self;
    _tableview.delegate=self;
    _tableview.showsVerticalScrollIndicator = NO;
    _tableview.backgroundColor = [UIColor clearColor];
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableview];
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

-(void)cellAction:(BEventType)type views:(UIView *)v obj:(id)obj key:(id)key indexPath:(NSIndexPath *)indexPath
{
    switch (type)
    {
        case BEventType_Unknow:
            
            if (indexPath.section == 0) {
                XRCarouselView *carouselView = obj;
                carouselView.imageClickBlock = ^(NSInteger index) {
                    NSLog(@"第%ld张图片被点击", index);
                };
            }
            else if (indexPath.section == 1) {
                
                if ([key isEqualToString:@"0"]) {
                    [self.navigationController pushViewController:[WikipediaViewController new] animated:YES];
                }else if ([key isEqualToString:@"1"]){
                    [self.navigationController pushViewController:[LessonViewController new] animated:YES];
                }else if ([key isEqualToString:@"2"]){
                        NSLog(@"%@",obj[2]);
                }else if ([key isEqualToString:@"3"]){
                        NSLog(@"%@",obj[3]);
                }
                
            }
            else if (indexPath.section == 2){
                //金融百科
                [self.navigationController pushViewController:[PlayerViewController new] animated:YES];
            }
            else if (indexPath.section == 3){
                //析金学堂
            }
            else if (indexPath.section == 4){
                //人气讲师
            }
            else if (indexPath.section == 5){
                //从业培训
            }

            break;
        case BEventType_More:
        {
            if (indexPath.section == 2) {
                //金融百科更多
                [self.navigationController pushViewController:[VideolistViewController new] animated:YES];
            }
            else if (indexPath.section == 3){
                //析金学堂更多
            }
//            
//            IndexMoreViewController *more = [[IndexMoreViewController alloc] init];
//            [self.navigationController pushViewController:more animated:YES];
        }
            break;
    }
    
    
}
@end
