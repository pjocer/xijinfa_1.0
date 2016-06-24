//
//  HomePageScrollCell.h
//  xjf
//
//  Created by Hunter_wang on 16/6/24.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "XJFBaseCollectionViewCell.h"

typedef NS_OPTIONS(short, HomePageScrollCellType) {
    ClassificationCell = 0,
    TeacherCell
};

@class HomePageScrollCell;

@protocol HomePageScrollCellDelegate <NSObject>

/**
 *  DidSelected
 *
 *  @param homePageScrollCell homePageScrollCell
 *  @param indexPath          indexPath
 */
- (void)homePageScrollCell:(HomePageScrollCell *)homePageScrollCell
  didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface HomePageScrollCell : XJFBaseCollectionViewCell
///CellType
@property (nonatomic, assign) HomePageScrollCellType cellType;
///Delegate
@property (nonatomic, assign) id<HomePageScrollCellDelegate>delegate;
@end
