//
//  PlayerPageDescribeCell.m
//  xjf
//
//  Created by Hunter_wang on 16/5/12.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "PlayerPageDescribeCell.h"

@implementation PlayerPageDescribeCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        ViewRadius(self, 5.0);
        
        self.title = [[UILabel alloc] init];
        [self addSubview:self.title];
        self.title.font = FONT15;
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.contentView).with.offset(10);
            make.right.equalTo(self).with.offset(-30);
            make.height.mas_equalTo(18);
        }];
        
        self.rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self addSubview:self.rightButton];
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.title);
            make.right.equalTo(self).with.offset(-10);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];

        self.titleDetail = [[UILabel alloc] init];
        [self addSubview:self.titleDetail];
        self.titleDetail.font = FONT12;
        self.titleDetail.textColor = AssistColor;
        [self.titleDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.title.mas_bottom).with.offset(10);
            make.left.equalTo(self.title);
            make.right.equalTo(self.contentView).with.offset(-10);
            make.height.mas_equalTo(18);
        }];
        
        self.videoDescribe = [[UILabel alloc] init];
        [self addSubview:self.videoDescribe];
        self.videoDescribe.font = FONT12;
        self.videoDescribe.numberOfLines = 0;
        self.videoDescribe.textColor = AssistColor;
    }
    return self;
}

- (void)setIsShowVideDescrible:(BOOL)isShowVideDescrible
{
    if (isShowVideDescrible == YES) {
        [self.rightButton setImage:[[UIImage imageNamed:@"iconLess"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }else{
        [self.rightButton setImage:[[UIImage imageNamed:@"iconMore"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
    _isShowVideDescrible = isShowVideDescrible;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect tempRect = [StringUtil calculateLabelRect:self.model.content width:SCREENWITH - 20 fontsize:12];
//    self.videoDescribe.frame = CGRectMake(10, 10, self.bounds.size.width - 20, tempRect.size.height);
    
    if (_isShowVideDescrible) {
        [self.videoDescribe mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(10);
            make.top.equalTo(self.titleDetail.mas_bottom);
            make.right.equalTo(self.contentView).with.offset(-10);
            make.height.mas_equalTo(tempRect.size.height);
        }];
    } else {
        [self.videoDescribe mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(10);
            make.top.equalTo(self.titleDetail.mas_bottom);
            make.right.equalTo(self.contentView).with.offset(-10);
            make.height.mas_equalTo(0);
        }];
    }


}

- (void)setModel:(TalkGridModel *)model {
    if (model) {
        _model = model;
    }
    self.videoDescribe.text = model.content;
}

- (void)setLessonDetailListResultModel:(LessonDetailListResultModel *)lessonDetailListResultModel
{
    if (lessonDetailListResultModel) {
        _lessonDetailListResultModel = lessonDetailListResultModel;
    }
    self.title.text = _lessonDetailListResultModel.title;
    
    NSString *tempStr;
    if (_lessonDetailListResultModel.taxonomy_categories.count != 0) {
        Taxonomy_categories *taxonomy_categories = _lessonDetailListResultModel.taxonomy_categories.firstObject;
        tempStr = taxonomy_categories.title;
    }
    if (tempStr != nil || tempStr.length > 0) {
        self.titleDetail.text = [NSString stringWithFormat:@"播放: %@次  类型: %@", _lessonDetailListResultModel.view_count, tempStr];
    } else {
        self.titleDetail.text = [NSString stringWithFormat:@"播放: %@次 ", _lessonDetailListResultModel.view_count];
    }
}


@end
