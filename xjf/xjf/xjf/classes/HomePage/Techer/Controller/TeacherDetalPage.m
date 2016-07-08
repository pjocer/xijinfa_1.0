//
//  TeacherDetalPage.m
//  xjf
//
//  Created by Hunter_wang on 16/7/5.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "TeacherDetalPage.h"
#import "HomePageConfigure.h"
#import "TeacherCoverCollectionViewCell.h"
#import "TeacherDetailModel.h"
#import "XJAccountManager.h"
#import "LessonPlayerViewController.h"

@interface TeacherDetalPage ()<UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout>

typedef NS_OPTIONS(NSInteger, WikipediaControllerSectionType) {
    TeacherCover_Cell = 0,
    School_Cell,
    Employed_Cell
};
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, retain) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) TeacherDetailModel *teacherDetailModel;
@property (nonatomic, strong) NSMutableArray *dataSourcerDep3_School;
@property (nonatomic, strong) NSMutableArray *dataSourcerDep4_Employed;
@end

@implementation TeacherDetalPage
static NSString *TeacherDetalPageTeacherCover_CellID = @"TeacherDetalPageTeacherCover_CellID";

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    ;
    self.navigationItem.title = @"讲师详情";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCollectionView];
    [self requestLessonListData:[NSString stringWithFormat:@"%@%@", teacherApi, self.teacherListDataModel.id] method:GET];

}

#pragma mark -- CollectionView

- (void)initCollectionView {
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.sectionInset = UIEdgeInsetsMake(0, KMargin, 0, KMargin);
    _layout.minimumLineSpacing = 0.0;
    _layout.minimumInteritemSpacing = 0.0;
    
    self.collectionView = [[UICollectionView alloc]
                           initWithFrame:CGRectMake(0, 0, SCREENWITH, SCREENHEIGHT - 20)
                           collectionViewLayout:_layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    

    [_collectionView registerNib:[UINib nibWithNibName:@"TeacherCoverCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:TeacherDetalPageTeacherCover_CellID];
    [_collectionView registerNib:[UINib nibWithNibName:@"XJFSchoolCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:HomePageCollectionBySchool_CellID];
    
    [_collectionView registerClass:[HomePageCollectionSectionHeaderView class]
        forSupplementaryViewOfKind:
     UICollectionElementKindSectionHeader withReuseIdentifier:HomePageSelectViewControllerSeccontionHeader_identfail];
}

#pragma mark CollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == TeacherCover_Cell) {
        return 1;
    }else if (section == School_Cell){
        return self.dataSourcerDep3_School.count > 4 ? 4 : self.dataSourcerDep3_School.count;
    }else if (section == Employed_Cell){
        return self.dataSourcerDep4_Employed.count > 4 ? 4 : self.dataSourcerDep4_Employed.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == TeacherCover_Cell) {
        TeacherCoverCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TeacherDetalPageTeacherCover_CellID forIndexPath:indexPath];
        cell.model = self.teacherDetailModel.result;
        [cell.focus addTarget:self action:@selector(focusAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
  
    }
        XJFSchoolCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomePageCollectionBySchool_CellID forIndexPath:indexPath];
        if (indexPath.section == School_Cell) {
            cell.model = self.dataSourcerDep3_School[indexPath.row];
        }else if (indexPath.section == Employed_Cell){
            cell.model = self.dataSourcerDep4_Employed[indexPath.row];
        }
        return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    HomePageCollectionSectionHeaderView *sectionHeaderView =
    [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:
     HomePageSelectViewControllerSeccontionHeader_identfail forIndexPath:indexPath];
    sectionHeaderView.sectionTitle.text = @[@"",@"析金学堂",@"析金从业"][indexPath.section];
    sectionHeaderView.sectionMore.text = @"更多";
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderViewTapPUSHMorePage:)];
    [sectionHeaderView addGestureRecognizer:tap];
    return sectionHeaderView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    
        if (section == TeacherCover_Cell) {
            return CGSizeZero;
        }else if (section == School_Cell && self.dataSourcerDep3_School.count > 0){
            return CGSizeMake(SCREENWITH, KHomePageSeccontionHeader_Height);
        }else if (section == Employed_Cell && self.dataSourcerDep4_Employed.count > 0){
            return CGSizeMake(SCREENWITH, KHomePageSeccontionHeader_Height);
        }
        return CGSizeZero;
}

#pragma mark FlowLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == TeacherCover_Cell) {
        _layout.sectionInset = UIEdgeInsetsMake(KMargin, KMargin, 0, KMargin);
    return CGSizeMake(SCREENWITH - KMargin * 2, 260);
    }
     _layout.sectionInset = UIEdgeInsetsMake(0, KMargin, 0, KMargin);
    _layout.minimumLineSpacing = KlayoutMinimumLineSpacing;
    return KHomePageCollectionByLessons;
}

#pragma mark - sectionHeaderViewTapPUSHMorePage

- (void)sectionHeaderViewTapPUSHMorePage:(UITapGestureRecognizer *)sender
{
    HomePageCollectionSectionHeaderView *sectionHeaderView = (HomePageCollectionSectionHeaderView *)sender.view;
    if ([sectionHeaderView.sectionTitle.text isEqualToString:@"析金学堂"]) {
        
    }else if ([sectionHeaderView.sectionTitle.text isEqualToString:@"析金从业"]){
        
    }
}

#pragma mark - delegate

#pragma mark CollectionView DidSelected

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == School_Cell) {
        TalkGridModel *model = self.dataSourcerDep3_School[indexPath.row]; 
        LessonPlayerViewController *lessonPlayerViewController = [LessonPlayerViewController new];
        lessonPlayerViewController.lesssonID = model.id_;
        lessonPlayerViewController.playTalkGridModel = model;
        lessonPlayerViewController.originalTalkGridModel = model;
        [self.navigationController pushViewController:lessonPlayerViewController animated:YES];
    }else if (indexPath.section == Employed_Cell){
        TalkGridModel *model = self.dataSourcerDep4_Employed[indexPath.row];
        LessonPlayerViewController *lessonPlayerViewController = [LessonPlayerViewController new];
        lessonPlayerViewController.lesssonID = model.id_;
        lessonPlayerViewController.playTalkGridModel = model;
        lessonPlayerViewController.originalTalkGridModel = model;
        [self.navigationController pushViewController:lessonPlayerViewController animated:YES];
    }

}

#pragma mark focusAction

- (void)focusAction:(UIButton *)sender {
    if ([[XJAccountManager defaultManager] accessToken] == nil ||
        [[[XJAccountManager defaultManager] accessToken] length] == 0) {
        [self LoginPrompt];
    } else {
        if (!self.teacherDetailModel.result.user_favored) {
            [self requestLessonListData:favorite method:POST];
        } else if (self.teacherDetailModel.result.user_favored) {
            [self requestLessonListData:favorite method:DELETE];
        }
        [[XJAccountManager defaultManager] updateUserInfoCompeletionBlock:nil];
    }
    
}

#pragma mark - handle Data

- (void)requestLessonListData:(APIName *)api method:(RequestMethod)method {
    
    if (method == GET) {
        self.dataSourcerDep4_Employed = [NSMutableArray array];
        self.dataSourcerDep3_School = [NSMutableArray array];
        @weakify(self);
        XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];
        [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
            @strongify(self);
            self.teacherDetailModel = [[TeacherDetailModel alloc] initWithData:responseData error:nil];

            for (TalkGridModel *model in self.teacherDetailModel.result.guru_courses) {
                if ([model.department isEqualToString:@"dept3"]) {
                    [self.dataSourcerDep3_School addObject:model];
                } else if ([model.department isEqualToString:@"dept4"]) {
                    [self.dataSourcerDep4_Employed addObject:model];
                }
            }
            [self.collectionView reloadData];
        }failedBlock:^(NSError *_Nullable error) {

        }];
    }
    if (method == POST) {
        [self PostOrDeleteRequestData:api Method:POST];
    }
    if (method == DELETE) {
        [self PostOrDeleteRequestData:api Method:DELETE];
    }
    
}

- (void)PostOrDeleteRequestData:(APIName *)api Method:(RequestMethod)method {
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];
    request.requestParams = [NSMutableDictionary dictionaryWithDictionary:
                             @{@"id" : [NSString stringWithFormat:@"%d", self.teacherDetailModel.result.id],
                               @"type" : [NSString stringWithFormat:@"%@", self.teacherDetailModel.result.type],
                               @"department" : [NSString stringWithFormat:@"%@", self.teacherDetailModel.result.department]}];
    [request startWithSuccessBlock:^(NSData *_Nullable responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"result"][@"success"] boolValue]) {
            [self requestLessonListData:[NSString stringWithFormat:@"%@%@", teacherApi, self.teacherListDataModel.id]
                                 method:GET];
        }else {
            [[ZToastManager ShardInstance] showtoast:dic[@"errMsg"]];
        }
    }failedBlock:^(NSError *_Nullable error) {
        
    }];
}



@end
