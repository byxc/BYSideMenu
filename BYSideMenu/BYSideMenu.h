//
//  BYSideMenuVC.h
//  BYSideMenuVC
//
//  Created by 白云 on 2017/4/26.
//  Copyright © 2017年 白云. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BYSideType) {
    BYSideTypeFollowLeft = 0,   // 左侧展示、内容视图跟随效果(默认)
    BYSideTypeFollowRight,      // 右侧展示、内容视图跟随效果
    BYSideTypeLeft,             // 左侧展示
    BYSideTypeRight,            // 右侧展示
};

@interface BYSideMenu : UIViewController

// 动画时间(默认：0.3s)
@property(nonatomic,assign)NSTimeInterval animationTime;
// 侧边栏视图宽度(默认：屏幕宽度*0.8)
@property(nonatomic,assign)CGFloat sideViewWidth;
// 侧边栏位置
@property(nonatomic,assign)BYSideType sideType;
// 是否允许手势拖动(默认：YES)
@property(nonatomic,assign)BOOL allowPan;
// 允许过渡效果
@property(nonatomic,assign)BOOL allowTransition;
// 内容视图控制器
@property(nonatomic,strong,readonly)UIViewController *contentViewController;
// 主视图控制器
@property(nonatomic,strong,readonly)UIViewController *sideViewController;

/**
 构造函数

 @param contentViewController 内容视图控制器
 @param sideViewController 侧边栏视图控制器
 @return 控制器对象
 */
- (instancetype)initWithContentController:(UIViewController *)contentViewController sideViewController:(UIViewController *)sideViewController;

/**
 显示侧边栏视图

 @param completedHandle 完成回调
 */
- (void)showSideMenuCompleted:(void(^)(void))completedHandle;

/**
 显示侧边栏视图

 @param animation 是否使用动画
 @param completedHandle 完成回调
 */
- (void)showSideMenuWithAnimation:(BOOL)animation completed:(void(^)(void))completedHandle;

/**
 隐藏侧边栏视图
 
 @param completedHandle 完成回调
 */
- (void)hiddenSideMenuCompleted:(void(^)(void))completedHandle;

/**
 隐藏侧边栏视图

 @param animation 是否使用动画
 @param completedHandle 完成回调
 */
- (void)hiddenSideMenuWithAnimation:(BOOL)animation completed:(void(^)(void))completedHandle;

@end

@interface UIViewController (BYSideMenuVC)

- (BYSideMenu *)sideMenuViewController;

@end
