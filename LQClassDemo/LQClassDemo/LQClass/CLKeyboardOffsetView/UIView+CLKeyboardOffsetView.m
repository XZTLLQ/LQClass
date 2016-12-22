//
//  UIView+CLKeyboardOffsetView.m
//  CLKeyboardOffsetView
//
//  Created by 李辉 on 15/12/23.
//  Copyright © 2015年 李辉. All rights reserved.
//  https://github.com/changelee82/CLKeyboardOffsetView
//

#import "UIView+CLKeyboardOffsetView.h"
#import "objc/runtime.h"



@implementation UIView (CLKeyboardOffsetView)

static char kKeyboardGap;
static char kKeyboardOffsetViewDelegate;


#pragma mark - 属性

/** 键盘与第一响应者的间隙 */
- (void)setKeyboardGap:(CGFloat)keyboardGap
{
    objc_setAssociatedObject(self, &kKeyboardGap, [NSNumber numberWithFloat:keyboardGap], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)keyboardGap
{
    // 未设置该属性，则返回默认值
    if (objc_getAssociatedObject(self, &kKeyboardGap) == nil)
        return 5.0;
        
    return [objc_getAssociatedObject(self, &kKeyboardGap) floatValue];
}

/** 委托，用于设置视图偏移的高度 */
- (void)setKeyboardOffsetViewDelegate:(id <CLKeyboardOffsetViewDelegate>)keyboardOffsetViewDelegate
{
    objc_setAssociatedObject(self, &kKeyboardOffsetViewDelegate, keyboardOffsetViewDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id <CLKeyboardOffsetViewDelegate>)keyboardOffsetViewDelegate
{
    return objc_getAssociatedObject(self, &kKeyboardOffsetViewDelegate);
}

#pragma mark - 方法

/** 打开键盘补偿视图 */
- (void)openKeyboardOffsetView
{
    // 监视键盘出现和键盘消失的消息
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardWillAppear:)
                                                name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardWillDisappear:)
                                                name:UIKeyboardWillHideNotification object:nil];
}

/** 关闭键盘补偿视图 */
- (void)closeKeyboardOffsetView
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

/**
 *  获取视图的第一响应者，采用递归的方式
 *
 *  @return 视图的第一响应者，不存在第一响应者则返回nil
 */
- (UIView *)firstResponder
{
    if([self isKindOfClass:[UITextField class]] || [self isKindOfClass:[UITextView class]])
    {
        if(self.isFirstResponder)
        {
            return self;
        }
        else
        {
            return nil;
        }
    }
    
    NSArray *subViews = [self subviews];
    
    if(subViews.count == 0)
    {
        return nil;
    }
    
    for(UIView *control in subViews)
    {
        UIView *firstResponder = [control firstResponder];
        if(firstResponder)
        {
            return firstResponder;
        }
    }
    
    return nil;
}

/** 获取键盘的高度 */
- (CGFloat)keyboardFrameHeight:(NSDictionary *)userInfo
{
    CGRect keyboardUncorrectedFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect keyboardFrame = [self convertRect:keyboardUncorrectedFrame fromView:nil];
    return keyboardFrame.size.height;
}

/** 键盘出现，向上移动视图 */
- (void)keyboardWillAppear:(NSNotification *)notification
{
    CGFloat keyboardHeight = [self keyboardFrameHeight:[notification userInfo]];  // 键盘高度
    CGFloat duration = [[notification userInfo][UIKeyboardAnimationDurationUserInfoKey] floatValue];    // 键盘弹出动画的持续时间
    UIViewAnimationOptions options = [[notification userInfo][UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16; // 键盘弹出动画的时间曲线
    
    // 获取第一响应者的位置
    UIView *firstResponder = [self firstResponder];
    CGRect rect = [firstResponder.superview convertRect:firstResponder.frame toView:self];
    
    // 计算向上偏移的高度，根据当前的第一响应者计算视图偏移高度，当键盘没有遮挡输入框时，弹出键盘时不需要移动视图
    CGFloat offsetViewHeight = self.frame.size.height - rect.origin.y - rect.size.height - self.keyboardGap;
    if (keyboardHeight < offsetViewHeight)
        offsetViewHeight = 0;
    else
        offsetViewHeight = keyboardHeight - offsetViewHeight;
    
    // 通过代理获取视图偏移的高度
    if([self.keyboardOffsetViewDelegate respondsToSelector:@selector(offsetViewHeightWithFirstResponder:keyboardHeight:offsetHeight:)])
    {
        offsetViewHeight  = [self.keyboardOffsetViewDelegate offsetViewHeightWithFirstResponder:firstResponder
                                                                                 keyboardHeight:keyboardHeight
                                                                                   offsetHeight:offsetViewHeight];
    }
    
    // 避免循环引用
    __weak typeof(self) weakSelf = self;
    
    // 执行向上移动视图的动画
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:options
                     animations:^{
                         // 动画执行代码
                         weakSelf.transform = CGAffineTransformMakeTranslation(0, -offsetViewHeight);
                     }
                     completion:^(BOOL completed) {
                         // 动画结束后执行的代码
                     }];
}

/** 键盘消失，还原视图 */
-(void)keyboardWillDisappear:(NSNotification *)notification
{
    CGFloat duration = [[notification userInfo][UIKeyboardAnimationDurationUserInfoKey] floatValue];    // 动画持续时间
    UIViewAnimationOptions options = [[notification userInfo][UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16; // 动画时间曲线
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:options
                     animations:^{
                         // 动画执行代码
                         self.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL completed) {
                         // 动画结束后执行的代码
                     }];
}

@end
