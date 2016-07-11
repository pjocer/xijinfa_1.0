//
//  XJFSchoolCollectionViewCell.h
//  xjf
//
//  Created by Hunter_wang on 16/6/27.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TalkGridModel.h"
@interface XJFSchoolCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) TalkGridModel *model;
@property (weak, nonatomic) IBOutlet UIView *priceBackGroudView;
@property (weak, nonatomic) IBOutlet UILabel *lessonLogoLabel;
@property (weak, nonatomic) IBOutlet UILabel *price;

@end
