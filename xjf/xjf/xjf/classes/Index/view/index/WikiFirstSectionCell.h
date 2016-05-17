//
//  WikiFirstSectionCell.h
//  xjf
//
//  Created by Hunter_wang on 16/5/11.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WikiFirstSectionCell;

@protocol WikiFirstSectionCellDelegate <NSObject>

- (void)wikiFirstSectionCell:(WikiFirstSectionCell *)cell
      DidSelectedItemAtIndex:(NSInteger)index WithOtherObject:(id)object;

@end


@interface WikiFirstSectionCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *tempArray;
@property (nonatomic, assign) id<WikiFirstSectionCellDelegate>delegate;

@end
