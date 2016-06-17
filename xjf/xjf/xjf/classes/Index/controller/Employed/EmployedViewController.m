//
//  EmployedViewController.m
//  xjf
//
//  Created by Hunter_wang on 16/6/7.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "EmployedViewController.h"
#import "EmployedbannerHeaderView.h"
#import "EmployedMainTableViewCell.h"
#import "IndexSectionView.h"
#import "EmployedViewInformationCell.h"
#import "EmployedLessonListViewController.h"
#import "SearchViewController.h"

@interface EmployedViewController () <UITableViewDelegate, UITableViewDataSource, XRCarouselViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSorce;
@property (nonatomic, strong) BannerModel *bannermodel;
@property (nonatomic, strong) NSMutableArray *dataArrayByBanner;
@property (nonatomic, strong) ProjectListByModel *projectListByModel;
@property (nonatomic, strong) TablkListModel *tablkListModel;
@end

@implementation EmployedViewController
static NSString *EmployedViewMainCell_id = @"EmployedViewMainCell_id";
static NSString *EmployedViewInformationCell_id = @"EmployedViewInformationCell_id";
static CGFloat tableNormulHeaderH = 35;
static CGFloat bannerHeaderViewH = 175;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self setNavigation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTabelView];
    [self requestBannerData:appDeptCarousel3 method:GET];
    [self requesProjectListDat:Employed method:GET];
    [self requestTeacherData:Articles method:GET];
}

#pragma mark requestData

//bannermodel
- (void)requestBannerData:(APIName *)api method:(RequestMethod)method {
    __weak typeof(self) wSelf = self;
    self.dataArrayByBanner = [NSMutableArray array];
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];
    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
        __strong typeof(self) sSelf = wSelf;
        sSelf.bannermodel = [[BannerModel alloc] initWithData:responseData error:nil];
        for (BannerResultModel *model in sSelf.bannermodel.result.data) {
            [sSelf.dataArrayByBanner addObject:model.thumbnail];
        }
        [sSelf.tableView reloadData];
    }                  failedBlock:^(NSError *_Nullable error) {

    }];
}

//ProjectListByModel
- (void)requesProjectListDat:(APIName *)api method:(RequestMethod)method {
    __weak typeof(self) wSelf = self;
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];
    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
        __strong typeof(self) sSelf = wSelf;
        sSelf.projectListByModel = [[ProjectListByModel alloc] initWithData:responseData error:nil];
        [sSelf.tableView reloadData];
    }                  failedBlock:^(NSError *_Nullable error) {
    }];
}

//TablkListModel
- (void)requestTeacherData:(APIName *)api method:(RequestMethod)method {
    __weak typeof(self) wSelf = self;
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];
    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
        __strong typeof(self) sSelf = wSelf;
        sSelf.tablkListModel = [[TablkListModel alloc] initWithData:responseData error:nil];
        [sSelf.tableView reloadData];

    }                  failedBlock:^(NSError *_Nullable error) {

    }];
}

#pragma mark -- Navigation

- (void)setNavigation {
    self.navigationItem.title = @"析金从业";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
            initWithImage:[UIImage imageNamed:@"search"]
                    style:UIBarButtonItemStylePlain
                   target:self
                   action:@selector(rightBarButtonItemAction:)];

}

- (void)rightBarButtonItemAction:(UIBarButtonItem *)sender {
    //导航栏右按钮 搜索
    SearchViewController *searchViewController = [SearchViewController new];
    [self.navigationController pushViewController:searchViewController animated:YES];
}

#pragma mark -- initTabelView

- (void)initTabelView {
    self.tableView = [[UITableView alloc]
            initWithFrame:CGRectMake(0, 0, SCREENWITH, SCREENHEIGHT - 10) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    if (iPhone5 || iPhone4) {
        self.tableView.rowHeight = 100;
    } else {
        self.tableView.rowHeight = 120;
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;

    [self.tableView registerClass:[EmployedMainTableViewCell class] forCellReuseIdentifier:EmployedViewMainCell_id];
    [self.tableView registerClass:[EmployedViewInformationCell class] forCellReuseIdentifier:EmployedViewInformationCell_id];
}

#pragma mark TabelViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.projectListByModel.result.data.count;
    }
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        EmployedMainTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:EmployedViewMainCell_id];
        cell.model = self.projectListByModel.result.data[indexPath.row];
        return cell;
    } else if (indexPath.section == 1) {
        EmployedViewInformationCell *cell = [self.tableView dequeueReusableCellWithIdentifier:EmployedViewInformationCell_id];
        cell.model = self.tablkListModel.result.data[indexPath.row];
        return cell;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        EmployedbannerHeaderView *bannerHeaderView = [[EmployedbannerHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, bannerHeaderViewH)];
        bannerHeaderView.carouselView.delegate = self;
        bannerHeaderView.carouselView.imageArray = self.dataArrayByBanner;
        return bannerHeaderView;
    }

    IndexSectionView *sectionView = [[IndexSectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, tableNormulHeaderH)];
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 34, SCREENWITH, 1)];
    [sectionView addSubview:bottomView];
    bottomView.backgroundColor = BackgroundColor;
    sectionView.moreLabel.hidden = YES;
    sectionView.titleLabel.text = @"资讯动态";
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return bannerHeaderViewH;
    }
    return tableNormulHeaderH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

#pragma mark Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        EmployedLessonListViewController *employedLessonListViewController = [[EmployedLessonListViewController alloc] init];
        ProjectList *tempModel = self.projectListByModel.result.data[indexPath.row];

        for (ProjectList *model in tempModel.children) {
            if ([model.title isEqualToString:@"基础知识"]) {
                employedLessonListViewController.employedBasisID = model.id;
            }
            else if ([model.title isEqualToString:@"法律法规"]) {
                employedLessonListViewController.employedLawsID = model.id;
            }
            else if ([model.title isEqualToString:@"全科"]) {
                employedLessonListViewController.employedGeneralID = model.id;
            }
        }

        employedLessonListViewController.employedLessonList = tempModel.title;
        [self.navigationController pushViewController:employedLessonListViewController animated:YES];
    }

}

#pragma mark - carouselView DidClickImage

- (void)carouselView:(XRCarouselView *)carouselView didClickImage:(NSInteger)index {
    NSLog(@"点击..... %ld", index);
}


@end
