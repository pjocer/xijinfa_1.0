//
//  SelectedCollectionView.h
//  xjf
//
//  Created by Hunter_wang on 16/7/2.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^SelectedTableViewFrameUnShow)();

@class SelectedCollectionView;

@protocol SelectedCollectionViewDelegate <NSObject>
- (void)selectedCollectionView:(SelectedCollectionView * _Nonnull)selectedCollectionView didSelectItemAtIndexPath:(NSIndexPath * _Nonnull)indexPath DataSource:(NSMutableArray *)dataSource;
@end

@interface SelectedCollectionView : UIView
@property (nonatomic, strong) NSMutableArray <NSString *>*dataSource;
@property(nullable, nonatomic, copy) SelectedTableViewFrameUnShow selectedTableViewFrameUnShow;
@property (nonatomic, weak, nullable) id <SelectedCollectionViewDelegate> delegate;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *backGroudView;

@end

NS_ASSUME_NONNULL_END