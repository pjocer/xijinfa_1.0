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

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       [self initCollectionView];
    }
    return self;
}

#pragma mark -- setter

- (void)setProjectListByModel:(ProjectListByModel *)projectListByModel
{
    if (projectListByModel && !_projectListByModel) {
         _projectListByModel = projectListByModel;
        [self.collectionView reloadData];
    }
}

- (void)setWikiPediaCategoriesModel:(WikiPediaCategoriesModel *)wikiPediaCategoriesModel
{
    if (wikiPediaCategoriesModel && !_wikiPediaCategoriesModel) {
        _wikiPediaCategoriesModel = wikiPediaCategoriesModel;
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
        
        [_collectionView registerNib:[UINib nibWithNibName:@"XJFClassificationCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:HomePageCollectionByClassification_CellID];
    }
}

#pragma mark -- CollectionViewDataSourse

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

            switch (self.ClassificationType) {
                case HomePageWikiClassification: {
                     return self.wikiPediaCategoriesModel.result.data.count > 0 ? self.wikiPediaCategoriesModel.result.data.count : 0;
                }
                    break;
                case HomePageSchoolClassification: {
                    return self.projectListByModel.result.data.count > 0 ? self.projectListByModel.result.data.count : 0;
                }
                    break;
                case HomePageEmployedassification: {
                    return self.projectListByModel.result.data.count > 0 ? self.projectListByModel.result.data.count : 0;
                }
                    break;
                default:
                    break;
            }

    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XJFClassificationCollectionViewCell *cell = [collectionView
                                                 dequeueReusableCellWithReuseIdentifier:HomePageCollectionByClassification_CellID forIndexPath:indexPath];
    switch (self.ClassificationType) {
        case HomePageWikiClassification: {
            cell.wikiPediaCategoriesDataModel = self.wikiPediaCategoriesModel.result.data[indexPath.row];
        }
            break;
        case HomePageSchoolClassification: {
            cell.model = self.projectListByModel.result.data[indexPath.row];
        }
            break;
        case HomePageEmployedassification: {
            cell.model = self.projectListByModel.result.data[indexPath.row];
        }
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark CollectionView DidSelected
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.ClassificationType == HomePageWikiClassification) {
        WikiPediaCategoriesDataModel *model = self.wikiPediaCategoriesModel.result.data[indexPath.row];
        if (_delegate && [_delegate respondsToSelector:@selector(homePageScrollCell:didSelectItemAtIndexPath:ClassificationTitle:)]) {
            [_delegate homePageScrollCell:self didSelectItemAtIndexPath:indexPath ClassificationTitle:model.title];
        }
    }else{
       ProjectList *model = self.projectListByModel.result.data[indexPath.row];
       if (_delegate && [_delegate respondsToSelector:@selector(homePageScrollCell:didSelectItemAtIndexPath:ClassificationTitle:)]) {
            [_delegate homePageScrollCell:self didSelectItemAtIndexPath:indexPath ClassificationTitle:model.title];
        }
    }
    
    
  
}


@end
