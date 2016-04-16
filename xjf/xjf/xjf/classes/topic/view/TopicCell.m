//
//  TopicCell.m
//  xjf
//
//  Created by liuchengbin on 16/4/10.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "TopicCell.h"

@interface TopicCell()
{
    
}
@property (nonatomic, strong) UIView *bgView;
@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)UILabel *userLable;
@property(nonatomic,strong)UILabel *timeLable;


@property (nonatomic, strong) UIScrollView* imgBackView ;
@property (nonatomic, strong) UIImageView *pimageView;
@property(nonatomic,strong)UILabel *skuNameLabel;
@property(nonatomic,strong)UIView *skuNameLine;
@property(nonatomic,strong)RTLabel *skuNameContent;
@property(nonatomic,strong)RTLabel *cateLabel;
@property(nonatomic,strong)RTLabel *brandLabel;
@property (nonatomic, strong) UIButton *btnLikeV;
@property (nonatomic, strong) UIButton *btnReplyV;
@property (nonatomic, strong) UIView *commentView;
@property(nonatomic,strong)UILabel *priceLabel;
@property(nonatomic,strong)UILabel *photoLabel;
@property(nonatomic,strong)UILabel *levelLabel;
@property(nonatomic,strong)UIButton *followBtn;
@property(nonatomic,strong)UIButton *moreBtn;
@property(nonatomic,strong)UIImageView *shaidanView;
@property(nonatomic,strong)UIImageView *brandView;
@property(nonatomic,strong)UIImageView *lineView;
@end


@implementation TopicCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgView.backgroundColor =[UIColor clearColor];
        [self.contentView addSubview:_bgView];
        //
        UITapGestureRecognizer* singleRecognizer4= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFromUser)];
        _iconView =[[UIImageView alloc] initWithFrame:CGRectZero];
        _iconView.layer.cornerRadius=10*1.5;
        _iconView.layer.masksToBounds = YES;
        _iconView.userInteractionEnabled=YES;
        [_iconView addGestureRecognizer:singleRecognizer4];
        [_bgView addSubview:_iconView];
        singleRecognizer4=nil;
        
        UITapGestureRecognizer* singleRecognizer5= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFromUser)];
        _userLable =[[UILabel alloc] initWithFrame:CGRectZero];
        _userLable.backgroundColor = [UIColor clearColor];
        _userLable.textColor = [UIColor darkGrayColor];
        _userLable.textAlignment = NSTextAlignmentLeft;
        _userLable.font =FONT(14);
        _userLable.numberOfLines=0;
        _userLable.userInteractionEnabled=YES;
        [_userLable addGestureRecognizer:singleRecognizer5];
        [_bgView addSubview:_userLable];
        singleRecognizer5=nil;
        
        _timeLable =[[UILabel alloc] initWithFrame:CGRectZero];
        _timeLable.backgroundColor = [UIColor clearColor];
        _timeLable.textColor = UIColorFromRGB(0x999999);
        _timeLable.textAlignment = NSTextAlignmentLeft;
        _timeLable.font = FONT(10);
        _timeLable.numberOfLines=0;
        [_bgView addSubview:_timeLable];
        
        _levelLabel =[[UILabel alloc] initWithFrame:CGRectZero];
        _levelLabel.backgroundColor = [UIColor blackColor];
        _levelLabel.textColor = [UIColor whiteColor];
        _levelLabel.textAlignment = NSTextAlignmentCenter;
        _levelLabel.font = FONT(9);
        [_bgView addSubview:_levelLabel];
        //
        _followBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _followBtn.backgroundColor =[UIColor clearColor];
        _followBtn.layer.borderColor=UIColorFromRGB(0xcccccc).CGColor;
        _followBtn.layer.borderWidth =0.5;
        _followBtn.layer.cornerRadius = 2.5;
        _followBtn.titleLabel.font = FONT(12);
        [_followBtn addTarget:self action:@selector(followAction) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_followBtn];
        
        
        _imgBackView = [[UIScrollView alloc]initWithFrame:CGRectZero];
        _imgBackView.scrollEnabled = NO;
        _imgBackView.backgroundColor = [UIColor clearColor];
        [_bgView addSubview:_imgBackView];
        
        UITapGestureRecognizer* singleRecognizer= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom)];
        _pimageView =[[UIImageView alloc] initWithFrame:CGRectZero];
        _pimageView.backgroundColor =UIColorFromRGB(0xffffff);
        _pimageView.userInteractionEnabled =YES;
        _pimageView.contentMode = UIViewContentModeScaleAspectFit;
        [_pimageView addGestureRecognizer:singleRecognizer];
        [_imgBackView addSubview:_pimageView];
        singleRecognizer=nil;
        

        
        //
        _commentView = [[UIView alloc] initWithFrame:CGRectZero];
        _commentView.backgroundColor =[UIColor clearColor];
        [_bgView addSubview:_commentView];
        //
        _btnLikeV = [[UIButton alloc] initWithFrame:CGRectZero];
        _btnLikeV.backgroundColor =  [UIColor clearColor];
        [_bgView addSubview:_btnLikeV];
        
        _btnReplyV = [[UIButton alloc] initWithFrame:CGRectZero];
        _btnReplyV.backgroundColor =  [UIColor clearColor];

        [_bgView addSubview:_btnReplyV];
        
        
        _priceLabel =[[UILabel alloc] initWithFrame:CGRectZero];
        _priceLabel.backgroundColor = [UIColor clearColor];
        _priceLabel.textColor = [UIColor grayColor];
        _priceLabel.textAlignment = NSTextAlignmentLeft;
        _priceLabel.font = FONT(12);
        [_bgView addSubview:_priceLabel];
        
        _photoLabel =[[UILabel alloc] initWithFrame:CGRectZero];
        _photoLabel.backgroundColor = [UIColor grayColor];
        _photoLabel.alpha=0.5;
        _photoLabel.textColor = [UIColor whiteColor];
        _photoLabel.textAlignment = NSTextAlignmentCenter;
        _photoLabel.font = FONT(14);
        _photoLabel.layer.cornerRadius = 3;//(值越大，角就越圆)
        _photoLabel.layer.masksToBounds = YES;
        [_bgView addSubview:_photoLabel];
        
        
        _shaidanView =[[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_shaidanView];
        
        
        _lineView =[[UIImageView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor=UIColorFromRGB(0xe5e5e5);
        [self.contentView addSubview:_lineView];
    }
    return self;
}
-(void)dealloc
{
    self.actionBlock=nil;
    self.data=nil;
    self.other=nil;
    self.indexPath=nil;
    
    [self.pimageView removeFromSuperview];
    self.pimageView=nil;
    [self.skuNameLabel removeFromSuperview];
    self.skuNameLabel=nil;
    
    [self.skuNameLine removeFromSuperview];
    self.skuNameLine=nil;
    
    [self.skuNameContent removeFromSuperview];
    self.skuNameContent=nil;
    
    [self.cateLabel removeFromSuperview];
    self.cateLabel=nil;
    
    [self.brandLabel removeFromSuperview];
    self.brandLabel=nil;
    
    [self.btnLikeV removeFromSuperview];
    self.btnLikeV=nil;
    
    [self.btnReplyV removeFromSuperview];
    self.btnReplyV=nil;
    
    [self.commentView removeFromSuperview];
    self.commentView=nil;
    [self.priceLabel removeFromSuperview];
    self.priceLabel=nil;
    [self.photoLabel removeFromSuperview];
    self.photoLabel=nil;
    
    [self.userLable removeFromSuperview];
    self.userLable=nil;
    
    [self.timeLable removeFromSuperview];
    self.timeLable=nil;
    
    [self.levelLabel removeFromSuperview];
    self.levelLabel=nil;
    
    [self.brandView removeFromSuperview];
    self.brandView=nil;
    
    [self.shaidanView removeFromSuperview];
    self.shaidanView=nil;
    
    [self.lineView removeFromSuperview];
    self.lineView=nil;
    
    //    DLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    _bgView.frame =CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    
}
- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    _lineView.frame =CGRectMake(0,self.bounds.size.height-0.5, SCREENWITH, 0.5);
}
/// 根据数据模型来显示内容
- (void)showInfo:(id)model other:(id)other key:(id)key indexPath:(NSIndexPath *)indexPath
{
    self.other =other;
    self.key =key;
    self.data =model;
    [self showInfo:model indexPath:indexPath];
}
- (void)showInfo:(id)model key:(id)key indexPath:(NSIndexPath *)indexPath
{
    self.key = key;
    self.data =model;
    [self showInfo:model indexPath:indexPath];
}
- (void)showInfo:(id)model indexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict =(NSDictionary*)model;
    self.data =model;
    self.indexPath=indexPath;
    float fTop = PHOTO_FRAME_WIDTH+PHOTO_TIME_PADDING;
    NSString * iconURL =[[NSString stringWithFormat:@"%@", [[dict objectForKey:@"user"] objectForKey:@"largeFace"]] replaceNullString];
    if (iconURL.length>0) {
        _iconView.frame =CGRectMake(PHOTO_FRAME_WIDTH,fTop, PHOTO_FRAME_WIDTH*3, PHOTO_FRAME_WIDTH*3);
        [_iconView sd_setImageWithURL:[NSURL URLWithString:iconURL] placeholderImage:[UIImage imageNamed:@"user_face.png"]];
        fTop += PHOTO_FRAME_WIDTH*4+PHOTO_TIME_PADDING;
    }
    //
    NSString *nick = [[NSString stringWithFormat:@"%@",[[dict objectForKey:@"user"] objectForKey:@"nick_name"]] replaceNullString];
    if (nick.length>0)
    {
        self.userLable.text =nick;
        CGSize uw =[self.userLable boundingRectWithSize:CGSizeMake(SCREENWITH-PHOTO_FRAME_WIDTH*6, 0)];
        self.userLable.frame =CGRectMake(PHOTO_FRAME_WIDTH*5,PHOTO_FRAME_WIDTH+PHOTO_TIME_PADDING, uw.width, PHOTO_FRAME_WIDTH*2);
        
    }
    NSString *level = [[NSString stringWithFormat:@"%@",[[dict objectForKey:@"user"] objectForKey:@"user_level"]] replaceNullString];
    if (level.length>0) {
        _levelLabel.text =[NSString stringWithFormat:@"%@级",level];
        CGSize uw =[_levelLabel boundingRectWithSize:CGSizeMake(SCREENWITH-PHOTO_FRAME_WIDTH*6, 0)];
        _levelLabel.frame=CGRectMake(self.userLable.frame.origin.x+self.userLable.frame.size.width+PHOTO_TIME_PADDING,PHOTO_FRAME_WIDTH*2,uw.width+PHOTO_TIME_PADDING, uw.height);
        _levelLabel.layer.cornerRadius =PHOTO_FRAME_WIDTH/2;
        _levelLabel.layer.masksToBounds=YES;
        
    }
    NSString *followed = [[NSString stringWithFormat:@"%@",[[dict objectForKey:@"user"] objectForKey:@"followed"]] replaceNullString];
    _followBtn.frame=CGRectMake(SCREENWITH -PHOTO_FRAME_WIDTH*7.5,PHOTO_FRAME_WIDTH+PHOTO_TIME_PADDING, PHOTO_FRAME_WIDTH*6.5, PHOTO_FRAME_WIDTH*3);
    if([followed intValue]==0)
    {
        [_followBtn setTitleColor:UIColorFromRGB(0x3DBB2B) forState:UIControlStateNormal];
        [_followBtn setTitle:@"关注" forState:UIControlStateNormal];
    }else  if([followed intValue]==1)
    {
        [_followBtn setTitleColor:UIColorFromRGB(0xBFBFBF) forState:UIControlStateNormal];
        [_followBtn setTitle:@"已关注" forState:UIControlStateNormal];
    }else{
        [_followBtn setTitleColor:UIColorFromRGB(0xBFBFBF) forState:UIControlStateNormal];
        [_followBtn setTitle:@"互相关注" forState:UIControlStateNormal];
    }
    //
    NSString *upload_dateinfo = [[NSString stringWithFormat:@"%@",[dict objectForKey:@"upload_dateinfo"]] replaceNullString];
    if (upload_dateinfo.length>0) {
        self.timeLable.frame =CGRectMake(PHOTO_FRAME_WIDTH*5,PHOTO_FRAME_WIDTH*3, SCREENWITH-PHOTO_FRAME_WIDTH*6, PHOTO_FRAME_WIDTH*2);
        self.timeLable.text =upload_dateinfo;
    }
    
       fTop = fTop+PHOTO_FRAME_WIDTH;
    //
    NSString *text =[[NSString stringWithFormat:@"%@", [dict objectForKey:@"text"]] replaceNullString];
    if (text.length>0) {
        text =[NSString stringWithFormat:@"%@",text];
        [_skuNameContent setText:text];
        CGSize optimumSize1 = [_skuNameContent optimumSize];
        _skuNameContent.frame = CGRectMake(PHOTO_FRAME_WIDTH,fTop, SCREENWITH-PHOTO_FRAME_WIDTH*2, optimumSize1.height);
        fTop = fTop+optimumSize1.height+PHOTO_FRAME_WIDTH;
    }
    
//    NSString *like_cnt =[NSString stringWithFormat:@"%@",[dict objectForKey:@"like_cnt"]];
//    if (like_cnt.length>0&&![like_cnt isEqualToString:@"0"]) {
//        [_btnLikeV setImage:[UIImage imageNamed:@"like_icon.png"] name:like_cnt];
//    }else
//    {
//        like_cnt =@"喜欢";
//        [_btnLikeV setImage:[UIImage imageNamed:@"like_icon.png"] name:@"喜欢"];
//    }
//    CGSize size2=[like_cnt sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0]}];
//    //    [_btnLikeV setFrame:CGRectMake(DEVICE_WIDTH-PHOTO_FRAME_WIDTH - (size2.width+25) ,fTop, size2.width+25, MORE_BUTTON_HEIGHT)];
//    
//    
//    int isLike=[[dict objectForKey:@"like"] intValue];
//    if (isLike) {
//        [_btnLikeV setImage:[UIImage imageNamed:@"like_icon_selected.png"] name:like_cnt];
//    }
//    //
//    NSString *reply_cnt =[NSString stringWithFormat:@"%@",[dict objectForKey:@"reply_cnt"]];
//    if (reply_cnt.length>0&&![reply_cnt isEqualToString:@"0"]) {
//        [_btnReplyV setImage:[UIImage imageNamed:@"pinglun_icon.png"] name:reply_cnt];
//        
//    }else{
//        reply_cnt =@"点评";
//        [_btnReplyV setImage:[UIImage imageNamed:@"pinglun_icon.png"] name:@"点评"];
//        
//    }
//    CGSize size1=[reply_cnt sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0]}];
//    //    [_btnReplyV setFrame:CGRectMake(_btnLikeV.frame.origin.x -(size1.width+25)- PHOTO_FRAME_WIDTH ,fTop, size1.width+25, MORE_BUTTON_HEIGHT)];
//    [_btnReplyV setFrame:CGRectMake(PHOTO_FRAME_WIDTH ,fTop, size1.width+25, MORE_BUTTON_HEIGHT)];
//    [_btnLikeV setFrame:CGRectMake(_btnReplyV.frame.origin.x +_btnReplyV.frame.size.width+PHOTO_FRAME_WIDTH ,fTop, size2.width+25, MORE_BUTTON_HEIGHT)];
//    //    [_moreBtn setFrame:CGRectMake(DEVICE_WIDTH-PHOTO_FRAME_WIDTH - MORE_BUTTON_HEIGHT ,fTop, MORE_BUTTON_HEIGHT, MORE_BUTTON_HEIGHT)];
//    
    
    
    [self layoutSubviews];
}
/// 返回Cell高度
+ (CGFloat)returnCellHeight:(id)model
{
    NSDictionary *dict =(NSDictionary*)model;
    float fTop = PHOTO_FRAME_WIDTH;
    

    
    //
    NSString *text =[[NSString stringWithFormat:@"%@", [dict objectForKey:@"text"]] replaceNullString];
    if (text.length>0) {
        text =[NSString stringWithFormat:@"%@",text];
        RTLabel *textLabel =[[RTLabel alloc] initWithFrame:CGRectMake(PHOTO_FRAME_WIDTH,0, SCREENWITH-PHOTO_FRAME_WIDTH*2,0)];
        textLabel.font = FONT(14);
        textLabel.lineSpacing = LSpacing;
        [textLabel setText:text];
        CGSize optimumSize1 = [textLabel optimumSize];
        textLabel=nil;
        CGFloat hh1 =optimumSize1.height;
        fTop =fTop + hh1+PHOTO_FRAME_WIDTH;
    }
    
    fTop = fTop +PHOTO_FRAME_WIDTH;
    return fTop;
    
}
-(void)setCallBack:(void(^)(BEventType,UIView*,id,id,NSIndexPath *))callback
{
    self.actionBlock=callback;
}

@end
