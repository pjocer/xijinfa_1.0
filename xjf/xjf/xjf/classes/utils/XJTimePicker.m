//
//  XJTimePicker.m
//  xjf
//
//  Created by PerryJ on 16/6/14.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "XJTimePicker.h"

@interface XJTimePicker () {
    NSArray *_dataSource;
}
@property (nonatomic, strong)UIPickerView *picker;
@end

@implementation XJTimePicker
-(instancetype)initWith:(NSArray *)dataSource {
    if (self = [super init]) {
        _dataSource = dataSource;
    }
    return self;
}
- (void)initPicker {
    
}
@end
