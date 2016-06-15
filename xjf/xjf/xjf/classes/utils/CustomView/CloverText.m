//
//  CloverText.m
//  xjf
//
//  Created by Hunter_wang on 16/6/15.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "CloverText.h"

@implementation CloverText

- (id)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.TV = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.TV.text = placeholder;
        self.TV.font = [UIFont boldSystemFontOfSize:15];
        self.TV.textColor = [UIColor lightGrayColor];
        self.TV.backgroundColor = [UIColor clearColor];
        self.TV.editable = NO;
        [self addSubview:self.TV];
        [self sendSubviewToBack:self.TV];
        self.delegate = self;
    }
    return self;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (self.text.length == 0) {
        self.TV.hidden = NO;
    }
    else {
        self.TV.hidden = YES;
    }
}


@end
