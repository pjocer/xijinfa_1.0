//
//  VideolistViewController.h
//  xjf
//
//  Created by Hunter_wang on 16/5/13.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "IndexBaseViewController.h"
#import "TalkGridModel.h"

@interface VideolistViewController : IndexBaseViewController
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *videoListTitle;
@property (nonatomic, strong) TablkListModel *tablkListModel;
@end
