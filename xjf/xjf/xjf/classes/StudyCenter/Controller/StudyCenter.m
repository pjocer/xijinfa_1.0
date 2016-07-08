//
//  StudyCenter.m
//  xjf
//
//  Created by PerryJ on 16/7/6.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "StudyCenter.h"
#import "XJFSchoolCollectionViewCell.h"
#import "HomePageConfigure.h"
#import "XjfRequest.h"
#import "TalkGridModel.h"
#import "FansFocus.h"
#import "XJAccountManager.h"
#import "StudyCenterWikiCell.h"
#import "ZToastManager.h"
#import "HomePageMainViewController.h"
#import "MyLessonsViewController.h"
#import "MyTeacherViewController.h"

@interface StudyCenter () <UICollectionViewDelegateFlowLayout,UICollectionViewDataSource> {
    TablkListModel *_list;
    BOOL _course;
    NSArray *_images;
    NSArray *_titles;
    NSMutableArray *_schoolCourses;
    NSMutableArray *_employedCourses;
}
@property (weak, nonatomic) IBOutlet UILabel *courseCount;
@property (weak, nonatomic) IBOutlet UILabel *teacherCount;
@property (weak, nonatomic) IBOutlet UICollectionView *colloctionView;
@property (weak, nonatomic) IBOutlet UIView *myLessons;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (weak, nonatomic) IBOutlet UIView *myTeachers;
@end

@implementation StudyCenter

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserInfo:[[XJAccountManager defaultManager] user_model]];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UserInfoDidChangedNotification object:nil] subscribeNext:^(NSNotification *x) {
        [self initUserInfo:x.object];
        [_colloctionView reloadData];
    }];
    [self extendheadViewFor:Study];
    [self initCollectionView];
    if (_course) [self initData];
}
- (void)initUserInfo:(UserProfileModel *)model {
    _course = model.result.course_count>0;
    _courseCount.text = [NSString stringWithFormat:@"%ld",model.result.course_count];
    _teacherCount.text = [NSString stringWithFormat:@"%ld",model.result.guru_count];
    _images = @[@"study_wiki",@"study_school",@"study_employee"];
    _titles = @[@"金融小白，我想了解金融知识",@"金融爱好者，我想提高金融知识水平",@"金融从业，我想考取从业资格证书"];
}
- (void)initData {
    [self requestData:myLessonsApi requestMethod:GET];
}
- (void)requestData:(APIName *)api requestMethod:(RequestMethod)method {
    if (!api) {
        return;
    }
    XjfRequest *request = [[XjfRequest alloc] initWithAPIName:api RequestMethod:method];
    [request startWithSuccessBlock:^(NSData * _Nullable responseData) {
        _list = [[TablkListModel alloc] initWithData:responseData error:nil];
        if (_list.errCode==0) {
            _courseCount.text = [NSString stringWithFormat:@"%ld",_list.result.data.count>0?_list.result.data.count:0];
            NSMutableArray *schoolCourses = [NSMutableArray array];
            NSMutableArray *employeeCourses = [NSMutableArray array];
            for (TalkGridModel *tempmodel in _list.result.data) {
                if ([tempmodel.department isEqualToString:@"dept3"]) {
                    if (schoolCourses.count<=2) [schoolCourses addObject:tempmodel];
                }
                if ([tempmodel.department isEqualToString:@"dept4"]) {
                    if (employeeCourses.count<=2) [employeeCourses addObject:tempmodel];
                }
            }
            _employedCourses = employeeCourses;
            _schoolCourses = schoolCourses;
            [_colloctionView reloadData];
        }else {
            [[ZToastManager ShardInstance] showtoast:_list.errMsg];
        }
    } failedBlock:^(NSError * _Nullable error) {
        [[ZToastManager ShardInstance] showtoast:@"网络连接异常"];
    }];
}
- (void)initCollectionView {
    if (_course) {
        [_colloctionView registerNib:[UINib nibWithNibName:@"XJFSchoolCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:HomePageCollectionBySchool_CellID];
        [_colloctionView registerClass:[HomePageCollectionSectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HomePageSelectViewControllerSeccontionHeader_identfail];
    } else {
        [_colloctionView registerNib:[UINib nibWithNibName:@"StudyCenterWikiCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"StudyCenterWikiCell_ID"];
    }
}
- (IBAction)myLessons:(UITapGestureRecognizer *)sender {
    if ([[XJAccountManager defaultManager] accessToken]) {
        MyLessonsViewController *controller = [MyLessonsViewController new];
        [self.navigationController pushViewController:controller animated:YES];
    }else {
        [self LoginPrompt];
    }
}
- (IBAction)myTeachers:(UITapGestureRecognizer *)sender {
    if ([[XJAccountManager defaultManager] accessToken]) {
        MyTeacherViewController *controller = [MyTeacherViewController new];
        [self.navigationController pushViewController:controller animated:YES];
    }else {
        [self LoginPrompt];
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _course?(section==0?_schoolCourses.count:_employedCourses.count):3;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _course?2:1;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (_course) {
        HomePageCollectionSectionHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HomePageSelectViewControllerSeccontionHeader_identfail forIndexPath:indexPath];
        [header setTitle:indexPath.section==0?@"我的学堂":@"我的从业" moreTitle:@"查看全部" moreCallback:^(id gestureRecognizer) {
            NSLog(@"查看更多");
        }];
        return header;
    }else {
        return nil;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_course) {
        XJFSchoolCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomePageCollectionBySchool_CellID forIndexPath:indexPath];
        cell.model = [indexPath.section==0?_schoolCourses:_employedCourses objectAtIndex:indexPath.item];
        
        return cell;
    }else {
        StudyCenterWikiCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StudyCenterWikiCell_ID" forIndexPath:indexPath];
        cell.cover.image = [UIImage imageNamed:_images[indexPath.item]];
        cell.title.text = _titles[indexPath.item];
        return cell;
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_course) {
        if (indexPath.section == 0) {
            NSLog(@"学堂:%ld",indexPath.item);
        }else {
            NSLog(@"从业:%ld",indexPath.item);
        }
    }else {
        UITabBarController *tab = self.tabBarController;
        UINavigationController *nav = [tab.viewControllers objectAtIndex:0];
        HomePageMainViewController *controller = [nav.viewControllers objectAtIndex:0];
        [controller changCurrunViewLocation:indexPath.item+1];
        [tab setSelectedIndex:0];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return _course?CGSizeMake((SCREENWITH-35)/2.0f, (SCREENWITH-35)/2.0f):CGSizeMake(SCREENWITH-20, 150);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return _course?UIEdgeInsetsMake(0, 10, 0, 10):UIEdgeInsetsMake(10, 10, 0, 10);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return _course?0:10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return _course?15:0;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return _course?CGSizeMake(SCREENWITH, 38):CGSizeZero;
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
