//
//  CitySelecter.h
//  xjf
//
//  Created by PerryJ on 16/6/16.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "MyBaseViewController.h"

@protocol CityDidChoosedDelegate <NSObject>
- (void)cityDidChoosed:(NSString *)city;
@end

@interface CitySelector : MyBaseViewController
@property (nonatomic, copy) NSString *cityChoosed;
@property (nonatomic, weak) id <CityDidChoosedDelegate> delegate;

- (instancetype)initWithDataSource:(NSMutableArray *)dataSource navTitle:(NSString *)title;
@end
