//
//  HomePageScrollCell.h
//  xjf
//
//  Created by Hunter_wang on 16/6/24.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "XJFBaseCollectionViewCell.h"
#import "ProjectListByModel.h"
#import "WikiPediaCategoriesModel.h"

typedef NS_OPTIONS(short, HomePageClassificationType) {
    HomePageWikiClassification = 0,
    HomePageSchoolClassification,
    HomePageEmployedassification
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
///HomePageClassificationType
@property (nonatomic, assign) HomePageClassificationType ClassificationType;
///Delegate
@property (nonatomic, assign) id<HomePageScrollCellDelegate>delegate;
///projectListByModel
@property (nonatomic, strong) ProjectListByModel *projectListByModel;
///wikiPediaCategoriesModel
@property (nonatomic, strong) WikiPediaCategoriesModel *wikiPediaCategoriesModel;

@end
