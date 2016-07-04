//
//  RechargeStreamCell.m
//  xjf
//
//  Created by PerryJ on 16/7/4.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "RechargeStreamCell.h"

@interface RechargeStreamCell ()
@property (weak, nonatomic) IBOutlet UILabel *created_at;
@property (weak, nonatomic) IBOutlet UILabel *stream_id;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *detail;
@end

@implementation RechargeStreamCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(RechargeStreamResultData *)model {
    _model = model;
    _created_at.text = _model.created_at;
    _stream_id.text = [NSString stringWithFormat:@"%ld",_model.id];
    _content.text = _model._description;
    _detail.text = [NSString stringWithFormat:@"%ld",_model.amount/100];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
