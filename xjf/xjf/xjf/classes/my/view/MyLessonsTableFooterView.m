//
//  MyLessonsTableFooterView.m
//  xjf
//
//  Created by Hunter_wang on 16/6/4.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "MyLessonsTableFooterView.h"

@interface MyLessonsTableFooterView ()
@property (nonatomic, strong) UIImageView *studyImage;
@property (nonatomic, strong) UILabel *studyLogoLabel;
@end

@implementation MyLessonsTableFooterView
static CGFloat StudyImageH = 20;
static CGFloat StudyLabelW = 40;
static CGFloat StudyLabelH = 14;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.studyImage = [[UIImageView alloc] init];
        [self addSubview:self.studyImage];
        self.studyImage.layer.masksToBounds = YES;
        self.studyImage.layer.cornerRadius = StudyImageH / 2;
        self.studyImage.image = [UIImage imageNamed:@"study"];
        [self.studyImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(10);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(StudyImageH, StudyImageH));
        }];
        
        self.studyLogoLabel = [[UILabel alloc] init];
        [self addSubview:self.studyLogoLabel];
        self.studyLogoLabel.font = FONT15;
        self.studyLogoLabel.textAlignment = NSTextAlignmentLeft;
        [self.studyLogoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.studyImage.mas_right).with.offset(10);
            make.right.equalTo(self).with.offset(-10);
            make.height.equalTo(self.studyImage);
        }];
        
    }
    return self;
}

@end
