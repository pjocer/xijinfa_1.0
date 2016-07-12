//
//  XJFClassificationCollectionViewCell.m
//  xjf
//
//  Created by Hunter_wang on 16/6/27.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "XJFClassificationCollectionViewCell.h"

@interface XJFClassificationCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UIImageView *backGroudImage;

@end

@implementation XJFClassificationCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewRadius(self, 5.0);
}

- (void)setModel:(ProjectList *)model {
    if (model) {
        _model = model;
    }
    self.title.text = model.title;
//    self.describe.text = model.summary;
    
    for (ProjectListCover *cover in model.cover) {
        if ([cover.size isEqualToString:@"default"]) {
            [_backGroudImage sd_setImageWithURL:[NSURL URLWithString:cover.url]];
        }
    }
}

- (void)setWikiPediaCategoriesDataModel:(WikiPediaCategoriesDataModel *)wikiPediaCategoriesDataModel
{
    if (wikiPediaCategoriesDataModel) {
        _wikiPediaCategoriesDataModel = wikiPediaCategoriesDataModel;
    }
    self.title.text = wikiPediaCategoriesDataModel.title;
    
    for (ProjectListCover *cover in wikiPediaCategoriesDataModel.cover) {
        if ([cover.size isEqualToString:@"default"]) {
            [_backGroudImage sd_setImageWithURL:[NSURL URLWithString:cover.url]];
        }
    }
}

@end
