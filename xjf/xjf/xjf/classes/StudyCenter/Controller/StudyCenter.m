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

@interface StudyCenter () <UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *colloctionView;
@property (weak, nonatomic) IBOutlet UIView *myLessons;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (weak, nonatomic) IBOutlet UIView *myTeachers;
@end

@implementation StudyCenter

- (void)viewDidLoad {
    [super viewDidLoad];
    [self extendheadViewFor:Study];
    [self initCollectionView];
    // Do any additional setup after loading the view from its nib.
}
- (void)initCollectionView {
    [_colloctionView registerNib:[UINib nibWithNibName:@"XJFSchoolCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:HomePageCollectionBySchool_CellID];
    [_colloctionView registerClass:[HomePageCollectionSectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HomePageSelectViewControllerSeccontionHeader_identfail];
    _layout.itemSize = CGSizeMake((SCREENWITH-35)/2.0f, (SCREENWITH-35)/2.0f);
}
- (IBAction)myLessons:(UITapGestureRecognizer *)sender {
}
- (IBAction)myTeachers:(UITapGestureRecognizer *)sender {
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    HomePageCollectionSectionHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HomePageSelectViewControllerSeccontionHeader_identfail forIndexPath:indexPath];
    header.sectionTitle.text = indexPath.section==0?@"我的学堂":@"我的老师";
    return header;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XJFSchoolCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomePageCollectionBySchool_CellID forIndexPath:indexPath];
    return cell;
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
