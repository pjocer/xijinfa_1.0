//
//  NewTopicViewController.h
//  xjf
//
//  Created by PerryJ on 16/6/1.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "TopicBaseViewController.h"
/**
 勿删，留着备用
 */
typedef enum : NSUInteger {
    NewTopicDiscussStyle,
    NewTopicQAStyle,
    NewTopicDefaultStyle,
} NewTopicStyle;

@interface NewTopicViewController : TopicBaseViewController

@property (nonatomic, assign) NewTopicStyle style;

- (instancetype)initWithStyle:(NewTopicStyle)style;
@end
