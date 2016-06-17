//
//  FeedbackView.h
//  xjf
//
//  Created by Hunter_wang on 16/6/15.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextField.h"
#import "CloverText.h"

@class FeedbackView;

@protocol FeedbackViewDelegate <NSObject>
- (void)FeedbackView:(FeedbackView *)feedbackViewsub
          FeedAction:(UIButton *)sender;
@end

@interface FeedbackView : UIView
@property (strong, nonatomic) CloverText *feedbackTextView;
@property (strong, nonatomic) CustomTextField *qqTextField;
@property (strong, nonatomic) UIButton *submit;
@property (strong, nonatomic) UIScrollView *scrolleView;
@property (assign, nonatomic) id <FeedbackViewDelegate> delegate;
@end
