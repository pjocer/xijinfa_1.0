//
//  NewSharpViewController.h
//  xjf
//
//  Created by PerryJ on 16/6/2.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "TopicBaseViewController.h"

@protocol NewSharpAddSuccessed <NSObject>

- (void)newSharpAddSuccessed:(NSString *)label;

@end

@interface NewSharpViewController : TopicBaseViewController
@property (nonatomic, strong) id <NewSharpAddSuccessed> delegate;
@end
