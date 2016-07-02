//
//  SelectedTableView.h
//  xjf
//
//  Created by Hunter_wang on 16/7/2.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "XJFBaseView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^SelectedTableViewFrameUnShow)();

@class SelectedTableView;

@protocol SelectedTableViewDelegate <NSObject>
- (void)selectedTableView:(SelectedTableView * _Nonnull)selectedTableView didSelectRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath DataSource:(NSMutableArray *)dataSource;
@end


@interface SelectedTableView : UIView
@property (nonatomic, strong) NSMutableArray <NSString *>*dataSource;
@property(nullable, nonatomic, copy) SelectedTableViewFrameUnShow selectedTableViewFrameUnShow;
@property (nonatomic, weak, nullable) id <SelectedTableViewDelegate> delegate;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *backGroudView;
@end

NS_ASSUME_NONNULL_END