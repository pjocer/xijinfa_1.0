//
//  EmployedClassificationCollectionViewCell.m
//  xjf
//
//  Created by Hunter_wang on 16/7/1.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "EmployedClassificationCollectionViewCell.h"

@interface EmployedClassificationCollectionViewCell ()

@end

@implementation EmployedClassificationCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewRadius(self, 5.0);
}
- (IBAction)ItemAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(employedClassificationCollectionViewCell:didSelectButton:)]) {
        [self.delegate employedClassificationCollectionViewCell:self didSelectButton:sender];
    }
}

@end
