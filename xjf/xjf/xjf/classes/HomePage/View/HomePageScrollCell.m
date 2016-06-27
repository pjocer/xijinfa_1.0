//
//  HomePageScrollCell.m
//  xjf
//
//  Created by Hunter_wang on 16/6/24.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "HomePageScrollCell.h"
#import "HomePageConfigure.h"

@interface HomePageScrollCell ()<UICollectionViewDataSource,
                                    UICollectionViewDelegate,
                                    UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, retain) UICollectionViewFlowLayout *layout;
@end

@implementation HomePageScrollCell
static NSString *HomePageScrollCellText_CellID = @"HomePageScrollCellText_CellID";

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       [self initCollectionView];
    }
    return self;
}

#pragma mark -- CollectionView

- (void)initCollectionView {
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
    
    [_collectionView registerNib:[UINib nibWithNibName:@"XJFClassificationCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:HomePageCollectionByClassification_CellID];
    [_collectionView registerNib:[UINib nibWithNibName:@"XJFTeacherCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:HomePageCollectionByTeacher_CellID];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:HomePageScrollCellText_CellID];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (self.cellType) {
        case ClassificationCell: {
            XJFClassificationCollectionViewCell *cell = [collectionView
                                          dequeueReusableCellWithReuseIdentifier:HomePageCollectionByClassification_CellID forIndexPath:indexPath];
            return cell;
        }
            break;
        case TeacherCell: {
            XJFTeacherCollectionViewCell *cell = [collectionView
                                          dequeueReusableCellWithReuseIdentifier:HomePageCollectionByTeacher_CellID forIndexPath:indexPath];
            return cell;
        }
            break;
        default:
            break;
    }
    
    UICollectionViewCell *cell = [collectionView
                                  dequeueReusableCellWithReuseIdentifier:HomePageScrollCellText_CellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

#pragma mark CollectionView DidSelected
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if (_delegate && [_delegate respondsToSelector:@selector(homePageScrollCell:didSelectItemAtIndexPath:)]) {
        [_delegate homePageScrollCell:self didSelectItemAtIndexPath:indexPath];
    }
}


@end
