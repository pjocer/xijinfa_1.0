//
//  CloverText.h
//  xjf
//
//  Created by Hunter_wang on 16/6/15.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CloverText : UITextView <UITextViewDelegate>

@property (nonatomic, strong) UITextView *TV;

- (id)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder;
@end
