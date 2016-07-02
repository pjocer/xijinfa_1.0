//
//  SelecteButtonView.h
//  xjf
//
//  Created by Hunter_wang on 16/7/1.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SelecteButtonType) {
    LeftButton,
    RightButton
};

@class SelecteButtonView;

@protocol SelecteButtonViewDelegate <NSObject>
- (void)selecteButtonView:( SelecteButtonView * _Nonnull )selecteButtonView didButtonByButtonType:( SelecteButtonType )type;
@end


@interface SelecteButtonView : UIView
@property (nonatomic, weak, nullable) id <SelecteButtonViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *leftButtonLabelName;
@property (weak, nonatomic) IBOutlet UIImageView *leftShowIcon;
@property (weak, nonatomic) IBOutlet UILabel *rightButtonLabelName;
@property (weak, nonatomic) IBOutlet UIImageView *rightShowIcon;
@end
