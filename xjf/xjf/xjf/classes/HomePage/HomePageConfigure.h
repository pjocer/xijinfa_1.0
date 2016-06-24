//
//  HomePageConfigure.h
//  xjf
//
//  Created by Hunter_wang on 16/6/24.
//  Copyright © 2016年 lcb. All rights reserved.
//

#ifndef HomePageConfigure_h
#define HomePageConfigure_h


#pragma mark -- SizeAboutItem

#define KlayoutMinimumInteritemSpacing 7.5
#define KlayoutMinimumLineSpacing 10
#define KHomePageCollectionByBannerSize CGSizeMake(SCREENWITH - KlayoutMinimumLineSpacing * 2, 110)
#define KHomePageCollectionByClassificationAndTeacher CGSizeMake((SCREENWITH - KlayoutMinimumInteritemSpacing * 2 - KlayoutMinimumLineSpacing * 2) / 2, 150)
#define KHomePageCollectionByLessons CGSizeMake(SCREENWITH, 150)
#define KHomePageSeccontionHeader_Height 45


#pragma mark -- .h

#import "HomePageCollectionSectionHeaderView.h"
#import "BannerModel.h"
#import "HomePageBanderCell.h"
#import "HomePageScrollCell.h"

#endif /* HomePageConfigure_h */
