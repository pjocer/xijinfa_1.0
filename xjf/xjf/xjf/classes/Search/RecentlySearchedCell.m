//
//  RecentlySearchedCell.m
//  xjf
//
//  Created by PerryJ on 16/7/11.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "RecentlySearchedCell.h"
#import "XJFCacheHandler.h"
#import "StringUtil.h"
#import "XjfRequest.h"
#import "ZToastManager.h"
#import "RecentlySearchedCollectionCell.h"

@interface RecentlySearchedCell () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation RecentlySearchedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.dataSource = [NSMutableArray array];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"RecentlySearchedCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"RecentlySearchedCollectionCell"];
    [self.dataSource addObjectsFromArray:[[XJFCacheHandler sharedInstance] recentlySearched]];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource!=nil && self.dataSource.count>0?self.dataSource.count:0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RecentlySearchedCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RecentlySearchedCollectionCell" forIndexPath:indexPath];
    if (self.dataSource!=nil && self.dataSource.count>0 ) {
        NSString *temp = [self.dataSource objectAtIndex:indexPath.item];
        [cell setTitle:temp];
    } 
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource!=nil && self.dataSource.count>0 ) {
        NSString *temp = [self.dataSource objectAtIndex:indexPath.item];
        CGRect frame = [StringUtil calculateLabelRect:temp height:25 fontSize:15];
        CGSize itemSize = CGSizeMake(frame.size.width+10, 25);
        return itemSize;
    }
    return CGSizeZero;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchHandler) self.searchHandler (self.dataSource[indexPath.row]);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
