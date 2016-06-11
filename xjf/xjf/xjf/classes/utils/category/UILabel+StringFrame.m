//
//  UILabel+StringFrame.m
//  danpin
//
//  Created by chuangjia on 1/9/15.
//  Copyright (c) 2015 chuangjia. All rights reserved.
//

#import "UILabel+StringFrame.h"

@implementation UILabel (StringFrame)

- (CGSize)boundingRectWithSize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    
    CGSize retSize = [self.text boundingRectWithSize:size
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    
    return retSize;
}

- (NSMutableAttributedString *)changeColorWithString:(NSString *)string
                                               light:(NSString *)light
                                                Font:(CGFloat)font
                                               Color:(UIColor*)color
{
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:string];
    
    for (int i = 0; i < attString.length - light.length + 1; i++) {
        
        NSRange range =NSMakeRange(i, light.length);
        
        if ([[string substringWithRange:range] isEqualToString:light]) {
            
            // 添加关键字的特征
            [attString addAttribute:NSForegroundColorAttributeName value:color range:range];
            [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:range];
            
        }
    }
    return attString;
}

@end
