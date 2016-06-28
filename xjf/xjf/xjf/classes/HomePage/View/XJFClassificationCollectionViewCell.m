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
@property (weak, nonatomic) IBOutlet UILabel *describe;

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
//    [self.titleImage sd_setImageWithURL:[NSURL URLWithString:model.thumbnail]];
    self.title.text = model.title;
    self.describe.text = model.summary;
}

- (void)setWikiPediaCategoriesDataModel:(WikiPediaCategoriesDataModel *)wikiPediaCategoriesDataModel
{
    if (wikiPediaCategoriesDataModel) {
        _wikiPediaCategoriesDataModel = wikiPediaCategoriesDataModel;
    }
    //    [self.titleImage sd_setImageWithURL:[NSURL URLWithString:model.thumbnail]];
    self.title.text = wikiPediaCategoriesDataModel.title;
}

@end
