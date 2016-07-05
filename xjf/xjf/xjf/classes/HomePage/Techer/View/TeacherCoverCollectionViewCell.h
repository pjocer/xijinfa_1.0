//
//  TeacherCoverCollectionViewCell.h
//  xjf
//
//  Created by Hunter_wang on 16/7/5.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeacherDetailModel.h"

@interface TeacherCoverCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *techerCover;
@property (weak, nonatomic) IBOutlet UILabel *techerDescribe;
@property (weak, nonatomic) IBOutlet UIButton *focus;
@property (nonatomic, strong) TeacherDetailResult *model;
@end
