//
//  RequestAPI.h
//  xjf
//
//  Created by PerryJ on 16/5/12.
//  Copyright © 2016年 lcb. All rights reserved.
//
#pragma mark- PerryJi

//找回密码页面获取短信验证码
static APIName *reset_message_code = @"/api/auth/generate-reset-security-code";

//注册页面获取短信验证码
static APIName *regist_message_code = @"/api/auth/generate-register-security-code";

//获取图片验证码
static APIName *get_image_code = @"/api/auth/captcha";

//重置密码
static APIName *reset_password = @"/api/auth/reset-password";

//验证短信验证码是否有效
static APIName *check_code_message = @"/api/auth/verify-security-code";

//本地登录API
static APIName *local_login = @"/api/auth/login";

//第三方登录API
static APIName *third_login = @"/api/auth/third";

//提交注册API
static APIName *commit_register = @"/api/auth/register";

//获取用户信息API
static APIName *user_info = @"/api/user/profile";

//验证用户有效性
static APIName *verify_user = @"/api/auth/verify-bearer";

//购买API
static APIName *buy_trade = @"/api/order";

//话题
static APIName *topic_all = @"/api/topic/";
static APIName *topic_qa = @"/api/topic/?type=QA";
static APIName *topic_discuss = @"/api/topic/?type=discuss";

//点赞 (取消点赞)
static APIName *praise = @"/api/like";

//关注
static APIName *focus_on = @"/api/friendship/follow";
//取消关注
static APIName *focus_off = @"/api/friendship/unfollow";
//是否已经关注
static APIName *focusOrNot = @"/api/friendship/check";

//搜索百科
static APIName *search_baike = @"/api/search/wikis?s=";
//搜索课程
static APIName *search_lesson = @"/api/search/courses?s=";
//搜索话题
static APIName *search_topic = @"/api/search/topics?s=";
//搜索用户
static APIName *search_person = @"/api/search/users?s=";

//用户的评论
static APIName *user_comment_list = @"/api/user/%@/reply";
#pragma mark- Hunter_Wang


#pragma mark-- 轮显Banner广告 -----------------------------
#pragma mark 首页
static APIName *appHomeCarousel = @"/api/banner/app-home-carousel";

#pragma mark 边看边谈
static APIName *appDeptCarousel1 = @"/api/banner/app-dept1-carousel";

#pragma mark 金融百科
static APIName *appDeptCarousel2 = @"/api/banner/app-dept2-carousel";

#pragma mark 析金学堂
static APIName *appDeptCarousel3 = @"/api/banner/app-dept3-carousel";

#pragma mark 从业培训
static APIName *appDeptCarousel4 = @"/api/banner/app-dept4-carousel";


#pragma mark-- 内容-金融百科页面 -----------------------------
#pragma mark 内容-金融百科页面-视频
static APIName *talkGrid = @"/api/courses2";

#pragma mark 内容-金融百科-分类列表
static APIName *talkGridCategories = @"/api/categories2";

#pragma mark 内容-金融百科-具体内容
static APIName *talkGridDetailContent = @"/api/courses2/ID";

#pragma mark 内容-金融百科-获取评论
static APIName *talkGridcomments = @"/api/courses2/";

#pragma mark 内容-金融百科-发表评论   POST
static APIName *talkGridSendComments = @"/api/courses2/ID/comments";

#pragma mark 金融百科分类- 视频列表
static APIName *categoriesVideoList = @"/api/courses2/?category_id=";

#pragma mark-- 内容-析金学堂页面 -----------------------------
#pragma mark 析金学堂-专题列表
static APIName *projectList = @"/api/categories3";
#pragma mark 析金学堂-视频列表--按专题筛选
static APIName *coursesProject = @"/api/courses3/?category_id=";

#pragma mark 析金学堂-视频详情--视频列表
static APIName *coursesProjectLessonDetailList = @"/api/courses3";

#pragma mark-- 订单 -----------------------------
#pragma mark 查询所有订单
static APIName *queryAllOrder = @"/api/order";
#pragma mark 取消订单
static APIName *cancelOrder = @"/api/order/";

#pragma mark-- 老师 -----------------------------
#pragma mark 老师列表-热门
static APIName *teacherApi = @"/api/gurus3/";
static APIName *teacherListHot = @"/api/gurus3/hot";

#pragma mark-- 收藏 -----------------------------
static APIName *favorite = @"/api/favorite";

#pragma mark-- 用户已学习 ------------------------
static APIName *user_learnedApi = @"/api/learn";

#pragma mark-- My
#pragma mark 我的课程
static APIName *myLessonsApi = @"/api/user/courses";
