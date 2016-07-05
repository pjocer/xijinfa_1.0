//
//  CloverText.m
//  xjf
//
//  Created by Hunter_wang on 16/6/15.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "CloverText.h"
#import "UIGestureRecognizer+Block.h"

@interface CloverText ()
@property (nonatomic, strong) UILabel *placeHolderLabel;
@end

@implementation CloverText

- (id)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder {
    self = [super initWithFrame:frame];
    if (self) {
        self.placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, self.frame.size.width, 18)];
        [self addSubview:_placeHolderLabel];
        _placeHolderLabel.text = placeholder;
        _placeHolderLabel.font = FONT15;
        _placeHolderLabel.textColor = AssistColor;

        self.delegate = self;
    }
    return self;
}

- (void)textViewDidChange:(UITextView *)textView {
    self.placeHolderLabel.hidden = self.text.length != 0;
}

@end
