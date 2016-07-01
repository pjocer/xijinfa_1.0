//
//  EmployedClassificationCollectionViewCell.h
//  xjf
//
//  Created by Hunter_wang on 16/7/1.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>


@class EmployedClassificationCollectionViewCell;

@protocol EmployedClassificationCellDelegate <NSObject>

/**
 *  didSelectButton
 *
 *  @param employedClassificationCollectionViewCell
 *  @param button
 */
- (void)employedClassificationCollectionViewCell:(EmployedClassificationCollectionViewCell *)Cell
  didSelectButton:(UIButton *)button;
@end


@interface EmployedClassificationCollectionViewCell : UICollectionViewCell

typedef NS_OPTIONS(NSInteger, EmployedClassificationButtonType) {
    DeiveFromButton = 1001,
    DeiveFileButton,
    BookButton,
    TodayButton
};

///Delegate
@property (nonatomic, assign) id<EmployedClassificationCellDelegate>delegate;
@end
