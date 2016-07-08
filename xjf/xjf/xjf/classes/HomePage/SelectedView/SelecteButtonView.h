//
//  SelecteButtonView.h
//  xjf
//
//  Created by Hunter_wang on 16/7/1.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, SelecteButtonType) {
    LeftButton,
    RightButton
};

@class SelecteButtonView;

@protocol SelecteButtonViewDelegate <NSObject>
- (void)selecteButtonView:( SelecteButtonView * _Nonnull )selecteButtonView didButtonByButtonType:( SelecteButtonType )type;
@end


@interface SelecteButtonView : UIView
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (nonatomic, weak, nullable) id <SelecteButtonViewDelegate> delegate;
@property (weak, nonatomic, nullable) IBOutlet UILabel *leftButtonLabelName;
@property (weak, nonatomic, nullable) IBOutlet UIImageView *leftShowIcon;
@property (weak, nonatomic, nullable) IBOutlet UILabel *rightButtonLabelName;
@property (weak, nonatomic, nullable) IBOutlet UIImageView *rightShowIcon;
@end
NS_ASSUME_NONNULL_END