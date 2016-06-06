//
//  SearchSectionOne.h
//  xjf
//
//  Created by PerryJ on 16/6/6.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchSectionOne : UITableViewCell
@property (nonatomic, copy) void (^SearchHandler) (NSString *text);
- (void)initSubViews;
@property (nonatomic, assign) NSInteger cellHeight;
@end
