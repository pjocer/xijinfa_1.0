//
//  UserInfoInterestedCell.h
//  xjf
//
//  Created by PerryJ on 16/6/15.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoInterestedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *selectMark;
@property (weak, nonatomic) IBOutlet UILabel *content;

- (void)resetMarkSelected:(void (^)(NSString *txt))selected cancelSelected:(void (^)(NSString *txt))deSelected;

- (void)makeSelected;

- (void)makeDeSelected;
@end
