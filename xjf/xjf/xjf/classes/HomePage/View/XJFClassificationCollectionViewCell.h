//
//  XJFClassificationCollectionViewCell.h
//  xjf
//
//  Created by Hunter_wang on 16/6/27.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectListByModel.h"
#import "WikiPediaCategoriesModel.h"

@interface XJFClassificationCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) ProjectList *model;
@property (nonatomic, strong) WikiPediaCategoriesDataModel *wikiPediaCategoriesDataModel;
@end
