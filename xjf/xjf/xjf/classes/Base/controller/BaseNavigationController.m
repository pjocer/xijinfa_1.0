//
//  BaseNavigationController.m
//  xjf
//
//  Created by PerryJ on 16/7/4.
//  Copyright © 2016年 lcb. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()
@property (strong, nonatomic)UIPanGestureRecognizer *panGestureRecognizer;
@property (strong, nonatomic)UIImageView *backView;
@property (strong, nonatomic)NSMutableArray *backImgs;
@property (strong, nonatomic)NSMutableArray *popImgs;
@property (assign) CGPoint panBeginPoint;
@property (assign) CGPoint panEndPoint;
@property (strong, nonatomic) UIViewController *next;
@property (assign) BOOL hadPushed;
@end

@implementation BaseNavigationController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //initlization
    }
    return self;
}

- (void)loadView{
    [super loadView];
    [self initilization];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBaseUI];
}

- (void)initilization{
    self.backImgs = [[NSMutableArray alloc] init];
    self.popImgs = [[NSMutableArray alloc] init];
}

- (void)loadBaseUI{
    self.interactivePopGestureRecognizer.enabled = NO;
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerAction:)];
    [self.view addGestureRecognizer:self.panGestureRecognizer];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [self.backImgs addObject:[self screenShot]];
    self.next = viewController;
    [super pushViewController:viewController animated:NO];
    if (!self.hadPushed && self.childViewControllers.count>1) {
        [self.popImgs addObject:[self screenShot]];
        [self popViewControllerAnimated:NO];
        [self startPushAnimation];
    }
}
- (UIImage *)screenShot {
    UIGraphicsBeginImageContextWithOptions([UIScreen mainScreen].bounds.size, YES, 0);
    [[UIApplication sharedApplication].keyWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    [_backImgs removeLastObject];
    return [super popViewControllerAnimated:animated];
}

- (void)panGestureRecognizerAction:(UIPanGestureRecognizer*)panGestureRecognizer{
    if ([self.viewControllers count] == 1) {
        return ;
    }
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.panBeginPoint = [panGestureRecognizer locationInView:[UIApplication sharedApplication].keyWindow];
        [self insertLastViewFromSuperView:self.view.superview];
    }else if(panGestureRecognizer.state == UIGestureRecognizerStateEnded){
        self.panEndPoint = [panGestureRecognizer locationInView:[UIApplication sharedApplication].keyWindow];
        if ((_panEndPoint.x - _panBeginPoint.x) > 50) {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveNavigationViewWithLenght:[UIScreen mainScreen].bounds.size.width];
            } completion:^(BOOL finished) {
                [self removeLastViewFromSuperView];
                [self popViewControllerAnimated:NO];
                [self moveNavigationViewWithLenght:0];
            }];
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                [self moveNavigationViewWithLenght:0];
            }];
        }
    }else{
        CGFloat panLength = ([panGestureRecognizer locationInView:[UIApplication sharedApplication].keyWindow].x - _panBeginPoint.x);
        if (panLength > 0) {
            [self moveNavigationViewWithLenght:panLength];
        }
    }
}

- (void)startPushAnimation {
    [self insertNextViewFromSuperView:self.view.superview];
    [UIView transitionWithView:_backView duration:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self moveNavigationViewWithLenght:-SCREENWITH];
        _backView.frame = [[UIScreen mainScreen] bounds];
    } completion:^(BOOL finished) {
        [self removeLastViewFromSuperView];
        [self moveNavigationViewWithLenght:0];
        self.hadPushed = YES;
        [self pushViewController:self.next animated:NO];
        self.hadPushed = NO;
    }];
}
- (void)startPopAnimation {
    [self insertLastViewFromSuperView:self.view.superview];
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(SCREENWITH, self.view.frame.origin.y, SCREENWITH, SCREENHEIGHT);
    } completion:^(BOOL finished) {
        [self removeLastViewFromSuperView];
        [self moveNavigationViewWithLenght:0];
        [self popViewControllerAnimated:NO];
    }];
}
- (void)moveNavigationViewWithLenght:(CGFloat)lenght{
    self.view.frame = CGRectMake(lenght, self.view.frame.origin.y, SCREENWITH, SCREENHEIGHT);
}
- (void)insertNextViewFromSuperView:(UIView *)superView {
    if (_backView == nil) {
        _backView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWITH, self.view.frame.origin.y, SCREENWITH, SCREENHEIGHT)];
        _backView.image = [_popImgs lastObject];
    }
    [superView insertSubview:_backView aboveSubview:self.view];
}
- (void)insertLastViewFromSuperView:(UIView *)superView{
    if (_backView == nil) {
        _backView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backView.image = [_backImgs lastObject];;
    }
    [superView insertSubview:_backView belowSubview:self.view];
}
- (void)removeLastViewFromSuperView{
    [_backView removeFromSuperview];
    _backView = nil;
}
- (BOOL)shouldAutorotate {
    return [[self.viewControllers lastObject] shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
