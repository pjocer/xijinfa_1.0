//
//  TeacherScrollCollectionViewCell.m
//  xjf
//
//  Created by Hunter_wang on 16/6/28.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "TeacherScrollCollectionViewCell.h"
#import "HomePageConfigure.h"

@interface TeacherScrollCollectionViewCell ()<UICollectionViewDataSource,
                                                    UICollectionViewDelegate,
                                                    UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, retain) UICollectionViewFlowLayout *layout;
@end

@implementation TeacherScrollCollectionViewCell
static NSString *HomePageScrollCellText_CellID = @"HomePageScrollCellText_CellID";

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initCollectionView];
    }
    return self;
}

#pragma mark -- setter

- (void)setTeacherListHostModel:(TeacherListHostModel *)teacherListHostModel
{
    if (teacherListHostModel && !_teacherListHostModel) {
        _teacherListHostModel = teacherListHostModel;
        [self.collectionView reloadData];
    }
}


#pragma mark -- CollectionView

- (void)initCollectionView {
    
    if (!self.collectionView) {
        self.layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 0);
        _layout.itemSize = CGSizeMake(100, 140);
        
        _layout.minimumLineSpacing = 10.0;
        _layout.minimumInteritemSpacing = 0.0;
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        self.collectionView = [[UICollectionView alloc]
                               initWithFrame:self.contentView.bounds
                               collectionViewLayout:_layout];
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self.contentView addSubview:self.collectionView];

        [_collectionView registerNib:[UINib nibWithNibName:@"XJFTeacherCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:HomePageCollectionByTeacher_CellID];
    }
}

#pragma mark -- CollectionViewDataSourse

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.teacherListHostModel.result.data.count > 0 ? self.teacherListHostModel.result.data.count : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XJFTeacherCollectionViewCell *cell = [collectionView
                                                 dequeueReusableCellWithReuseIdentifier:HomePageCollectionByTeacher_CellID forIndexPath:indexPath];
    cell.model = self.teacherListHostModel.result.data[indexPath.row];
    return cell;
}

#pragma mark CollectionView DidSelected
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_delegate && [_delegate respondsToSelector:@selector(teacherScrollCollectionViewCell:didSelectItemAtIndexPath:)]) {
        [_delegate teacherScrollCollectionViewCell:self didSelectItemAtIndexPath:indexPath];
    }
}

@end
