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
#define KHomePageCollectionByWikipediaSize CGSizeMake(SCREENWITH - KlayoutMinimumLineSpacing * 2, 245)
#define KHomePageCollectionByLessons CGSizeMake(SCREENWITH, 150)
#define KHomePageSeccontionHeader_Height 45


#pragma mark -- CellIdentifier

static NSString *HomePageSelectViewControllerText_Cell = @"HomePageSelectViewControllerText_Cell";
static NSString *HomePageSelectViewControllerBander_CellID = @"HomePageSelectViewControllerBander_CellID";
static NSString *HomePageCollectionByClassification_CellID = @"HomePageCollectionByClassification_CellID";
static NSString *HomePageCollectionByTeacher_CellID = @"HomePageCollectionByTeacher_CellID";
static NSString *HomePageCollectionByWikipedia_CellID = @"HomePageCollectionByWikipedia_CellID";
static NSString *HomePageCollectionByWikipediaBig_CellID = @"HomePageCollectionByWikipediaBig_CellID";
static NSString *HomePageCollectionBySchool_CellID = @"HomePageCollectionBySchool_CellID";
static NSString *XJFEmploymentInformationCollectionViewCell_ID = @"XJFEmploymentInformationCollectionViewCell_ID";
static NSString *HomePageSelectViewControllerHomePageScrollCell_CellID = @"HomePageSelectViewControllerHomePageScrollCell_CellID";

static NSString *HomePageSelectViewControllerSeccontionHeader_identfail = @"HomePageSelectViewControllerSeccontionHeader_identfail";


#pragma mark -- .h

#import "HomePageCollectionSectionHeaderView.h"
#import "BannerModel.h"
#import "HomePageBanderCell.h"
#import "HomePageScrollCell.h"
#import "XJFClassificationCollectionViewCell.h"
#import "XJFTeacherCollectionViewCell.h"
#import "XJFWikipediaCollectionViewCell.h"
#import "XJFSchoolCollectionViewCell.h"
#import "XJFBigWikipediaCollectionViewCell.h"
#import "XJFEmploymentInformationCollectionViewCell.h"
#endif /* HomePageConfigure_h */
