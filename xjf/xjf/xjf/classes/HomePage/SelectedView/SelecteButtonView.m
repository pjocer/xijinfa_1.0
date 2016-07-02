//
//  SelecteButtonView.m
//  xjf
//
//  Created by Hunter_wang on 16/7/1.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "SelecteButtonView.h"

@interface SelecteButtonView ()


@end

@implementation SelecteButtonView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)LeftbuttonAction:(UIButton *)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(selecteButtonView:didButtonByButtonType:)]) [_delegate selecteButtonView:self didButtonByButtonType:LeftButton];
}
- (IBAction)RightbuttonAction:(UIButton *)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(selecteButtonView:didButtonByButtonType:)]) [_delegate selecteButtonView:self didButtonByButtonType:RightButton];
}

@end
