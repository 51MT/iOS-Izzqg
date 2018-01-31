#import <UIKit/UIKit.h>

//类别和扩展（Categories和Extensions）
//分类能够做到的事情主要是：即使在你不知道一个类的源码情况下，向这个类添加扩展的方法。

/**
 *  @author wangjian, 16-11-23 13:11:41
 *
 *  @brief UIButton类别和扩展
 */
@interface UIButton (wrapper)

/**
 *  @brief 设置按钮最小点击区域
 *
 *  @param point default value
 *  @param event default value
 *
 *  @return BOOL value
 */
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event;

@end
