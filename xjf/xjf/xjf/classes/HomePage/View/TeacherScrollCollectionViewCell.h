//
//  TeacherScrollCollectionViewCell.h
//  xjf
//
//  Created by Hunter_wang on 16/6/28.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "XJFBaseCollectionViewCell.h"
#import "TeacherListHostModel.h"

@class TeacherScrollCollectionViewCell;

@protocol TeacherScrollCollectionViewCellDelegate <NSObject>

/**
 *  DidSelected
 *
 *  @param homePageScrollCell teacherScrollCollectionViewCell
 *  @param indexPath          indexPath
 */
- (void)teacherScrollCollectionViewCell:(TeacherScrollCollectionViewCell *)teacherScrollCollectionViewCell
  didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface TeacherScrollCollectionViewCell : XJFBaseCollectionViewCell
///TeacherListHostModel
@property (nonatomic, strong) TeacherListHostModel *teacherListHostModel;
///Delegate
@property (nonatomic, assign) id<TeacherScrollCollectionViewCellDelegate>delegate;
@end
