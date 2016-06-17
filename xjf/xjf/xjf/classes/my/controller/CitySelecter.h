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

@interface CitySelecter : MyBaseViewController
@property (nonatomic, copy) NSString *cityChoosed;
@property (nonatomic, weak) id <CityDidChoosedDelegate> delegate;

- (instancetype)initWithDataSource:(NSMutableArray *)dataSource;
@end
