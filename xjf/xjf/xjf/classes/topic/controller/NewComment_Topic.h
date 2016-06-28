//
//  NewCommentViewController.h
//  xjf
//
//  Created by PerryJ on 16/6/2.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "TopicBaseViewController.h"

typedef enum : NSUInteger {
    NewTopic,
    NewComment,
} NewStyle;

@interface NewComment_Topic : TopicBaseViewController
@property (nonatomic, copy) NSString *topic_id;
@property (nonatomic, copy) NSString *type;
-(instancetype)initWithType:(NewStyle)aNewStyle;
@end
