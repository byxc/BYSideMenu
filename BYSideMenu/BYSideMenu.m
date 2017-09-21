//
//  BYSideMenuVC.m
//  BYSideMenuVC
//
//  Created by 白云 on 2017/4/26.
//  Copyright © 2017年 白云. All rights reserved.
//

#import "BYSideMenu.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenScale [UIScreen mainScreen].scale
#define kScreenBounds [UIScreen mainScreen].bounds

@interface BYSideMenu ()<UIGestureRecognizerDelegate>

// sideView show flag
@property(nonatomic,assign)BOOL isSideViewShow;
// UIPanGestureRecognizer
@property(nonatomic,weak)UIPanGestureRecognizer *pan;
// UIScreenEdgePanGestureRecognizer
@property(nonatomic,weak)UIScreenEdgePanGestureRecognizer *edgePan;
// ContentViewButton
@property(nonatomic,strong)UIButton *contentButton;

@end

@implementation BYSideMenu

- (instancetype)initWithContentController:(UIViewController *)contentViewController sideViewController:(UIViewController *)sideViewController {
    NSAssert(contentViewController != nil, @"ContentViewController cannot be nil!");
    NSAssert(sideViewController != nil, @"SideViewController cannot be nil!");
    if (self = [super init]) {
        _contentViewController      = contentViewController;
        _sideViewController         = sideViewController;
        _isSideViewShow             = NO;
        _animationTime              = 0.3;
        _sideViewWidth              = kScreenWidth * 0.8;
        _allowPan                   = YES;
        _allowTransition            = NO;
        _sideType                   = BYSideTypeFollowLeft;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSideMenuViews];
    [self setContentButtonOfContentView];
    [self setGestureRecognizerOfContentView];
}

- (void)configSideMenuViews {
    self.view.backgroundColor   = [UIColor whiteColor];
    [self setContentView];
    [self setSideView];
}

- (void)setContentView {
    [self addChildViewController:_contentViewController];
    _contentViewController.view.frame = self.view.bounds;
    [self.view addSubview:_contentViewController.view];
    [_contentViewController didMoveToParentViewController:self];
}

- (void)setSideView {
    [self addChildViewController:_sideViewController];
    _sideViewController.view.alpha = 0;
    CGRect sideFrame = _sideViewController.view.frame;
    sideFrame.origin.x = (_sideType&1) == 0 ? -_sideViewWidth:_contentViewController.view.frame.size.width;
    sideFrame.size.width = _sideViewWidth;
    _sideViewController.view.frame = sideFrame;
    [self.view addSubview:_sideViewController.view];
    [_sideViewController didMoveToParentViewController:self];
}

- (void)setGestureRecognizerOfContentView {
    UIScreenEdgePanGestureRecognizer *edgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanOfContentView:)];
    UIRectEdge rectEdge = (_sideType&1) == 0 ? UIRectEdgeLeft:UIRectEdgeRight;
    edgePan.edges = rectEdge;
    edgePan.delegate = self;
    [self.view addGestureRecognizer:edgePan];
    self.edgePan = edgePan;
}

- (void)setContentButtonOfContentView {
    _contentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _contentButton.frame = _contentViewController.view.bounds;
    [_contentButton addTarget:self action:@selector(contentButtonTouchAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panOfContentView:)];
    [_contentButton addGestureRecognizer:pan];
    self.pan = pan;
}

- (void)showSideMenuCompleted:(void(^)())completedHandle {
    [self showSideMenuWithAnimation:YES completed:completedHandle];
}

- (void)showSideMenuWithAnimation:(BOOL)animation completed:(void(^)())completedHandle {
    CGRect contentFrame = _contentViewController.view.frame;
    contentFrame.origin.x = [self contentOffsetX];
    CGRect sideFrame = _sideViewController.view.frame;
    sideFrame.origin.x = (_sideType&1) == 0 ? contentFrame.origin.x-_sideViewWidth:contentFrame.origin.x+contentFrame.size.width;
    if (animation) {
        if (!_allowTransition) {
            _sideViewController.view.alpha = 1;
        }
        [UIView animateWithDuration:_animationTime animations:^{
            _sideViewController.view.frame = sideFrame;
            if (_allowTransition) {
                _sideViewController.view.alpha = 1;
            }
            if (_sideType < BYSideTypeLeft) {
                _contentViewController.view.frame = contentFrame;
            }
        } completion:^(BOOL finished) {
            _isSideViewShow = YES;
            [_contentViewController.view addSubview:_contentButton];
            _edgePan.enabled = NO;
            if (completedHandle != nil) {
                completedHandle();
            }
        }];
    }
    else {
        _sideViewController.view.frame = sideFrame;
        _sideViewController.view.alpha = 1;
        _contentViewController.view.frame = contentFrame;
        _isSideViewShow = YES;
        [_contentViewController.view addSubview:_contentButton];
        _edgePan.enabled = NO;
        if (completedHandle != nil) {
            completedHandle();
        }
    }
}

- (void)hiddenSideMenuCompleted:(void(^)())completedHandle {
    [self hiddenSideMenuWithAnimation:YES completed:completedHandle];
}

- (void)hiddenSideMenuWithAnimation:(BOOL)animation completed:(void(^)())completedHandle {
    CGRect contentFrame = _contentViewController.view.frame;
    contentFrame.origin.x = 0;
    CGRect sideFrame = _sideViewController.view.frame;
    sideFrame.origin.x = (_sideType&1) == 0 ? contentFrame.origin.x-_sideViewWidth:contentFrame.origin.x+contentFrame.size.width;
    if (animation) {
        [UIView animateWithDuration:_animationTime animations:^{
            _sideViewController.view.frame = sideFrame;
            if (_allowTransition) {
                _sideViewController.view.alpha = 0;
            }
            if (_sideType < BYSideTypeLeft) {
                _contentViewController.view.frame = contentFrame;
            }
        } completion:^(BOOL finished) {
            _isSideViewShow = NO;
            _sideViewController.view.alpha = 0;
            [_contentButton removeFromSuperview];
            _edgePan.enabled = YES;
            if (completedHandle != nil) {
                completedHandle();
            }
        }];
    }
    else {
        _sideViewController.view.frame = sideFrame;
        _sideViewController.view.alpha = 0;
        if (_sideType < BYSideTypeLeft) {
            _contentViewController.view.frame = contentFrame;
        }
        _isSideViewShow = NO;
        [_contentButton removeFromSuperview];
        _edgePan.enabled = YES;
        if (completedHandle != nil) {
            completedHandle();
        }
    }
}

- (void)contentButtonTouchAction:(UIButton *)button {
    [self hiddenSideMenuCompleted:nil];
}

#pragma mark - Gesture
- (void)edgePanOfContentView:(UIScreenEdgePanGestureRecognizer *)edgePan {
    if (!_allowPan) {
        return;
    }
    CGPoint offset = [edgePan translationInView:self.view];
    CGRect contentFrame = _contentViewController.view.frame;
    contentFrame.origin.x = offset.x;
    if ((_sideType&1) == 0) {
        if (contentFrame.origin.x > _sideViewWidth) {
            contentFrame.origin.x = _sideViewWidth;
        }
        else if (contentFrame.origin.x < 0) {
            contentFrame.origin.x = 0;
        }
    }
    else if ((_sideType&1) == 1) {
        if (contentFrame.origin.x < -_sideViewWidth) {
            contentFrame.origin.x = -_sideViewWidth;
        }
        else if (contentFrame.origin.x > 0) {
            contentFrame.origin.x = 0;
        }
    }
    CGRect sideFrame = _sideViewController.view.frame;
    sideFrame.origin.x = (_sideType&1) == 0 ? contentFrame.origin.x-_sideViewWidth:contentFrame.origin.x+contentFrame.size.width;
    CGFloat alpha = _allowTransition ? ABS(offset.x)/_sideViewWidth:1;
    switch (edgePan.state) {
            case UIGestureRecognizerStateBegan:
            case UIGestureRecognizerStateChanged:
                _sideViewController.view.frame = sideFrame;
                if (_sideType < BYSideTypeLeft) {
                    _contentViewController.view.frame = contentFrame;
                }
                _sideViewController.view.alpha = alpha;
            break;
            case UIGestureRecognizerStateFailed:
            case UIGestureRecognizerStateCancelled:
            case UIGestureRecognizerStateEnded:
                if (ABS(offset.x) < _sideViewWidth*0.5) {
                    [self hiddenSideMenuCompleted:nil];
                }
                else {
                    [self showSideMenuCompleted:nil];
                }
            break;
        default:
            break;
    }
}

- (void)panOfContentView:(UIPanGestureRecognizer *)pan {
    if (!_isSideViewShow || !_allowPan) {
        return;
    }
    CGPoint offset = [pan translationInView:_contentButton];
    CGRect contentFrame = _contentViewController.view.frame;
    
    contentFrame.origin.x = [self contentOffsetX] + offset.x;
    if ((_sideType&1) == 0) {
        if (contentFrame.origin.x > _sideViewWidth) {
            contentFrame.origin.x = _sideViewWidth;
        }
        else if (contentFrame.origin.x < 0) {
            contentFrame.origin.x = 0;
        }
    }
    else if ((_sideType&1) == 1) {
        if (contentFrame.origin.x < -_sideViewWidth) {
            contentFrame.origin.x = -_sideViewWidth;
        }
        else if (contentFrame.origin.x > 0) {
            contentFrame.origin.x = 0;
        }
    }
    CGRect sideFrame = _sideViewController.view.frame;
    sideFrame.origin.x =  (_sideType&1) == 0 ? contentFrame.origin.x-_sideViewWidth:contentFrame.origin.x+contentFrame.size.width;
    
    CGFloat alpha = _allowTransition ? 1-ABS(offset.x)/_sideViewWidth:1;
    if (_isSideViewShow && (((_sideType&1) == 0 && offset.x > 0) || ((_sideType&1) == 1 && offset.x < 0))) {
        alpha = 1;
    }
    switch (pan.state) {
            case UIGestureRecognizerStateBegan:
            case UIGestureRecognizerStateChanged:
                _sideViewController.view.frame = sideFrame;
                if (_sideType < BYSideTypeLeft) {
                    _contentViewController.view.frame = contentFrame;
                }
                _sideViewController.view.alpha = alpha;
            break;
            case UIGestureRecognizerStateFailed:
            case UIGestureRecognizerStateCancelled:
            case UIGestureRecognizerStateEnded:
                if (((_sideType&1) == 0 && offset.x < 0) || ((_sideType&1) == 1 && offset.x > 0)) {
                    [self hiddenSideMenuCompleted:nil];
                }
                else {
                    [self showSideMenuCompleted:nil];
                }
            break;
            
        default:
            break;
    }
}

- (CGFloat)contentOffsetX {
    return (_sideType&1) == 0 ? _sideViewWidth:-_sideViewWidth;
}

#pragma mark - setter
- (void)setSideViewWidth:(CGFloat)sideViewWidth {
    CGRect sideFrame = _sideViewController.view.frame;
    CGFloat offsetX = sideFrame.size.width - sideViewWidth;
    _sideViewWidth = sideViewWidth;
    sideFrame.size.width = sideViewWidth;
    sideFrame.origin.x = sideFrame.origin.x + offsetX;
    _sideViewController.view.frame = sideFrame;
}

- (void)setSideType:(BYSideType)sideType {
    if (_sideType != sideType) {
        _sideType = sideType;
        [self.view removeGestureRecognizer:_edgePan];
        [self setGestureRecognizerOfContentView];
        CGRect sideFrame = _sideViewController.view.frame;
        sideFrame.origin.x = (_sideType&1) == 0 ? -_sideViewWidth:_contentViewController.view.frame.size.width;
        _sideViewController.view.frame = sideFrame;
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        return YES;
    }
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        return YES;
    }
    return NO;
}

@end

@implementation UIViewController (BYSideMenuVC)

- (BYSideMenu *)sideMenuViewController {
    UIViewController *controller = self.parentViewController;
    if (controller && [controller isKindOfClass:[BYSideMenu class]]) {
        return (BYSideMenu *)controller;
    }
    else if (controller.parentViewController && [controller.parentViewController isKindOfClass:[BYSideMenu class]]) {
        return (BYSideMenu *)controller.parentViewController;
    }
    return nil;
}

@end

