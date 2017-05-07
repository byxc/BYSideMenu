# BYSideMenu
一个简单好用的侧边栏
# 使用方法
1.将文件加入到工程中，在需要使用的文件中导入头文件
2.使用如下构造方法创建侧边栏控制器
 ' BYSideMenu *sideMenu = [[BYSideMenu alloc] initWithContentController:nav sideViewController:menuVC]; '
3.可设属性
 ' 
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
 '
4.展开与隐藏
 '
/**
显示侧边栏视图

@param completedHandle 完成回调
*/
- (void)showSideMenuCompleted:(void(^)())completedHandle;

/**
显示侧边栏视图

@param animation 是否使用动画
@param completedHandle 完成回调
*/
- (void)showSideMenuWithAnimation:(BOOL)animation completed:(void(^)())completedHandle;

/**
隐藏侧边栏视图

@param completedHandle 完成回调
*/
- (void)hiddenSideMenuCompleted:(void(^)())completedHandle;

/**
隐藏侧边栏视图

@param animation 是否使用动画
@param completedHandle 完成回调
*/
- (void)hiddenSideMenuWithAnimation:(BOOL)animation completed:(void(^)())completedHandle;
 '
