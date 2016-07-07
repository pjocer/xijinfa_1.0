//
//  SelectedCollectionView.m
//  xjf
//
//  Created by Hunter_wang on 16/7/2.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "SelectedCollectionView.h"
#import "UIGestureRecognizer+Block.h"
#import "SelectedCollectionViewCell.h"
#import "SelectedCollectionViewFooter.h"
#import "HomePageConfigure.h"

@interface SelectedCollectionView ()<UICollectionViewDataSource,
                                    UICollectionViewDelegate,
                                    UICollectionViewDelegateFlowLayout>

@property (nonatomic, retain) UICollectionViewFlowLayout *layout;
@end

@implementation SelectedCollectionView
static NSString *SelectedCollectionView_CellID = @"SelectedCollectionView_CellID";
static NSString *SelectedCollectionView_FooterID = @"SelectedCollectionView_FooterID";

static CGFloat CellHeight = 25;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.backGroudView];
        [self addSubview:self.collectionView];
        [self makeSubViewsConstraints];
        
        @weakify(self)
        [RACObserve(self, frame) subscribeNext:^(id x) {
            @strongify(self)
            CGRect rect = [x CGRectValue];
            self.backGroudView.frame = rect;
            self.collectionView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height * 0.4);
        }];
    }
    return self;
}

- (void)makeSubViewsConstraints
{
    _backGroudView.frame = self.frame;
    
    _collectionView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 0.4);
}

#pragma mark - setter

- (void)setDataSource:(NSMutableArray<NSString *> *)dataSource
{
    if (dataSource) {
        _dataSource = dataSource;
    }
    [_collectionView reloadData];
}


#pragma mark - getter

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        self.layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 10);
        _layout.minimumLineSpacing = 10.0;
        _layout.minimumInteritemSpacing = 10.0;
        self.collectionView = [[UICollectionView alloc]
                               initWithFrame:CGRectNull
                               collectionViewLayout:_layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = YES;
        _collectionView.bounces = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.allowsMultipleSelection = YES;
    
        [_collectionView registerClass:[SelectedCollectionViewCell class] forCellWithReuseIdentifier:SelectedCollectionView_CellID];
        [_collectionView registerClass:[SelectedCollectionViewFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:SelectedCollectionView_FooterID];
        [_collectionView registerClass:[HomePageCollectionSectionHeaderView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HomePageSelectViewControllerSeccontionHeader_identfail];
    }
    return _collectionView;
}

- (UIView *)backGroudView
{
    if (!_backGroudView) {
        self.backGroudView = [[UIView alloc] init];
        _backGroudView.backgroundColor = [UIColor blackColor];
        _backGroudView.alpha = 0.35;
        __unsafe_unretained __typeof(self) weakSelf = self;
        [_backGroudView addGestureRecognizer:[UITapGestureRecognizer ht_gestureRecognizerWithActionBlock:^(id gestureRecognizer) {
            weakSelf.selectedTableViewFrameUnShow();
        }]];
    }
    return _backGroudView;
}


#pragma mark CollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SelectedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:
                                                          SelectedCollectionView_CellID
                                                          forIndexPath:indexPath];
    cell.dataStr = _dataSource[indexPath.row];

    if (cell.isSelected) {
        cell.title.backgroundColor = BlueColor;
    }else{
        cell.title.backgroundColor = [UIColor whiteColor];
    }
    
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        HomePageCollectionSectionHeaderView *sectionHeaderView =
        [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:
         HomePageSelectViewControllerSeccontionHeader_identfail forIndexPath:indexPath];
        sectionHeaderView.sectionMore.text = @"";
        return sectionHeaderView;
    } else {
        if (indexPath.section == 2) {
            SelectedCollectionViewFooter *rooterView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:SelectedCollectionView_FooterID forIndexPath:indexPath];
            [rooterView.removeSelected addTarget:self action:@selector(removeSelected:) forControlEvents:UIControlEventTouchUpInside];
            [rooterView.determine addTarget:self action:@selector(determine:) forControlEvents:UIControlEventTouchUpInside];
            return rooterView;
        }
    }

    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SCREENWITH, KHomePageSeccontionHeader_Height);
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == 2) {
      return CGSizeMake(SCREENWITH, 50);
    }
    return CGSizeZero;
}

#pragma mark FlowLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *tempStr = _dataSource[indexPath.row];
    return [self boundingRectWithSize:CGSizeMake(MAXFLOAT, CellHeight) Font:FONT12 STR:tempStr];
}

- (CGSize)boundingRectWithSize:(CGSize)size Font:(UIFont*)font STR:(NSString *)str {
    NSDictionary *attribute = @{NSFontAttributeName : font};
    
    CGSize retSize = [str boundingRectWithSize:size
                                             options:NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    
    return retSize;
}

#pragma mark didSelectItemAtIndexPath

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SelectedCollectionViewCell *cell = (SelectedCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.title.backgroundColor = BlueColor;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SelectedCollectionViewCell *cell = (SelectedCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.title.backgroundColor = [UIColor whiteColor];
}


-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    return YES;
}

#pragma mark removeSelected

- (void)removeSelected:(UIButton *)sender
{
    [self.collectionView reloadData];
}

#pragma mark determine

- (void)determine:(UIButton *)sender
{
//    if (_delegate && [_delegate respondsToSelector:@selector(selectedCollectionView:didSelectItemAtIndexPath:DataSource:)]) {
//        [_delegate selectedCollectionView:self didSelectItemAtIndexPath:indexPath DataSource:_dataSource];
//    }
}


@end


