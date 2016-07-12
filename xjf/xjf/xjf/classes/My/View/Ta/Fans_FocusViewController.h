//
//  Fans_FocusViewController.h
//  xjf
//
//  Created by PerryJ on 16/6/6.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "BaseViewController.h"

@interface Fans_FocusViewController : BaseViewController
/**
 *  Fans_Focus VC
 *
 *  @param userId   Who
 *  @param type     0 Fans 1 Focus
 *  @param nickname Whose name
 *
 *  @return instance
 */
- (instancetype)initWithID:(NSString *)userId type:(NSInteger)type nickname:(NSString *)nickname;
@end
