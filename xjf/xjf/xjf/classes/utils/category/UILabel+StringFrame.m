//
//  UILabel+StringFrame.m
//  danpin
//
//  Created by chuangjia on 1/9/15.
//  Copyright (c) 2015 chuangjia. All rights reserved.
//

#import "UILabel+StringFrame.h"

@implementation UILabel (StringFrame)

- (CGSize)boundingRectWithSize:(CGSize)size {
    NSDictionary *attribute = @{NSFontAttributeName : self.font};

    CGSize retSize = [self.text boundingRectWithSize:size
                                             options:NSStringDrawingTruncatesLastVisibleLine |
                                                     NSStringDrawingUsesLineFragmentOrigin |
                                                     NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;

    return retSize;
}

- (void)changeColorWithString:(NSString *)string
                                               light:(NSString *)light
                                                Font:(CGFloat)font
                                               Color:(UIColor *)color {
    NSRange range = [string rangeOfString:light];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:string];
    [attString addAttributes:@{NSForegroundColorAttributeName:color,NSFontAttributeName:FONT(font)} range:range];
    self.attributedText = attString;
}

@end
