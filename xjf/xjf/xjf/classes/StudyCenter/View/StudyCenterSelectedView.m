//
//  StudyCenterSelectedView.m
//  xjf
//
//  Created by Hunter_wang on 16/7/5.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "StudyCenterSelectedView.h"

@interface StudyCenterSelectedView ()
@property (weak, nonatomic) IBOutlet UILabel *myLessonCount;
@property (weak, nonatomic) IBOutlet UILabel *myTeacherCount;

@end

@implementation StudyCenterSelectedView

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (IBAction)MyLessonAction:(UIButton *)sender {
}
- (IBAction)MyTeacherAction:(UIButton *)sender {
}

@end
