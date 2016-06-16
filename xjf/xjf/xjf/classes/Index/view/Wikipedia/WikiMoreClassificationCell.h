//
//  WikiMoreClassificationCell.h
//  xjf
//
//  Created by Hunter_wang on 16/5/20.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WikiPediaCategoriesModel.h"

@interface WikiMoreClassificationCell : UICollectionViewCell
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) WikiPediaCategoriesDataModel *model;
@end
