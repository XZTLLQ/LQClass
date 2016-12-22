//
//  LQViewController.m
//  PublicLawyerChat
//
//  Created by lawchat on 16/5/9.
//  Copyright © 2016年 就问律师. All rights reserved.
//

#import "LQViewController.h"
#import "UIView+CLKeyboardOffsetView.h"

@interface LQViewController ()

@end

@implementation LQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //收起键盘
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    tapGr.cancelsTouchesInView    = NO;
    [self.view addGestureRecognizer:tapGr];
    
    self.view.backgroundColor =  [UIColor colorWithRed: 248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0];
    
    _lq_loadingGifName = @"lq_loading.gif";
    _lq_loadingViewType  = LQViewLoadingViewTypeGif;
//    _lq_loadingViewType  = LQViewLoadingViewTypeDefault;
    _lq_failLoadViewType = LQViewFailLoadViewTypeDefault;
}
- (void)viewTapped {
    [self.view endEditing:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //开启友盟统计
//    [MobClick beginLogPageView:NSStringFromClass(self.class)];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //关闭友盟统计
//    [MobClick endLogPageView:NSStringFromClass(self.class)];
    
//    [SVProgressHUD dismiss];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    // 打开键盘补偿视图
    [self.view openKeyboardOffsetView];
    self.view.keyboardGap = 10; // 如果需要自定义键盘与第一响应者之间的间隙，则设置此属性，默认为5
    [super viewDidAppear:animated];
}
- (void)viewDidDisappear:(BOOL)animated
{
    // 关闭键盘补偿视图
    [self.view closeKeyboardOffsetView];
    [super viewDidDisappear:animated];
}

#pragma mark - NoDataTipsDelegate - 刷新点击
- (void)tipsRefreshBtnClicked{
    [self noDataBeginRefresh];
}

#pragma mark - 刷新界面数据
- (void)noDataBeginRefresh {
    
}

/************************ 加载中  ************************/
#pragma mark - 显示加载中的动画
- (void)lq_showLoading {
    [self lq_hideFailLoad];
    
    switch (_lq_loadingViewType) {
        case LQViewLoadingViewTypeDefault: {
            [self lq_showLoadingDefault];
            break;
        }
        case LQViewLoadingViewTypeGif: {
            [self lq_showLoadingGif];
            break;
        }
        case LQViewLoadingViewTypeCustom: {
            [self lq_showLoadingCustomView];
            break;
        }
    }
}
#pragma mark - 隐藏加载中的动画
- (void)lq_hideLoading {
    [self lq_hideLoadingDefault];
    [self lq_hideLoadingGif];
    [self lq_hideLoadingCustomView];
}

#pragma mark - 初始化菊花加载动画
- (void)lq_initLoadingDefault {
    _lq_activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_lq_activityIndicator setCenter:self.view.center];
    
}
#pragma mark - 加载菊花加载动画
- (void)lq_showLoadingDefault {
    if (!_lq_activityIndicator) {
        [self lq_initLoadingDefault];
    }
    [self.view insertSubview:_lq_activityIndicator atIndex:0];
    _lq_activityIndicator.hidden = NO;
    [_lq_activityIndicator startAnimating];
}
#pragma mark - 隐藏菊花加载动画
- (void)lq_hideLoadingDefault {
    if (_lq_activityIndicator) {
        [_lq_activityIndicator removeFromSuperview];
        [_lq_activityIndicator stopAnimating];
    }
}
#pragma mark - 初始化加载中GIF动画
- (void)lq_initLoadingGif {
    // 设定位置和大小
    CGRect frame;
    CGSize size = [UIImage imageNamed:_lq_loadingGifName].size;
    size.width /= 2;
    size.height /= 2;
    frame.size = size;
    // 读取gif图片数据
    
    _lq_loadingGifView = [[YLImageView alloc] initWithFrame:frame];
    _lq_loadingGifView.center = self.view.center;
    _lq_loadingGifView.image = [YLGIFImage imageNamed:_lq_loadingGifName];
}
#pragma mark - 显示加载中GIF动画
- (void)lq_showLoadingGif {
    if (!_lq_loadingGifView) {
        [self lq_initLoadingGif];
    }
    [self.view insertSubview:_lq_loadingGifView atIndex:0];
    _lq_loadingGifView.hidden = NO;
}
#pragma mark - 隐藏加载中GIF动画
- (void)lq_hideLoadingGif {
    if (_lq_loadingGifView) {
        [_lq_loadingGifView removeFromSuperview];
        _lq_loadingGifView = nil;
    }
}
#pragma mark - 显示加载中自定义的View
- (void)lq_showLoadingCustomView {
    if (_lq_loadingView) {
        if (_lq_loadingView.frame.size.width <= 0 && _lq_loadingView.frame.size.height <=0) {
             [self.view layoutIfNeeded];
            CGSize size = self.view.bounds.size;
            _lq_loadingView.frame = CGRectMake(0, 0, size.width, size.height);
        }
        [self.view insertSubview:_lq_loadingView atIndex:0];
        _lq_loadingView.hidden = NO;
    }
}
#pragma mark - 隐藏加载中自定义的View
- (void)lq_hideLoadingCustomView {
    if (_lq_loadingView) {
        [_lq_loadingView removeFromSuperview];
    }
}

/************************ 加载失败  ************************/
- (void)lq_showFailLoadWithType:(LQViewFailLoadViewType)type {
    [self lq_hideLoading];
    self.view.userInteractionEnabled = YES;
    _lq_failLoadViewType = type;
    switch (_lq_failLoadViewType) {
        case LQViewFailLoadViewTypeDefault: {
            if (self.lq_faildLoadDefaultTipsStr.length == 0) {
                self.lq_faildLoadDefaultTipsStr = @"加载失败，点击屏幕刷新";
            }
            self.lq_faildLoadDefaultTipsIamgeName = @"页面加载失败";
            [self lq_showFaildLoadDefault];
            self.lq_faildLoadDefaultTipsStr = nil;
            self.lq_faildLoadDefaultTipsIamgeName = nil;
            break;
        }
        case LQViewFailLoadViewTypeGif: {
            [self lq_showFaildLoadGif];
            break;
        }
        case LQViewFailLoadViewTypeCustom: {
            [self lq_showFaildLoadCustomView];
            break;
        }
        case LQViewFailLoadViewTypeNoData: {
            if (self.lq_faildLoadDefaultTipsStr.length == 0) {
                self.lq_faildLoadDefaultTipsStr = @"空空如也";
            }
            self.lq_faildLoadDefaultTipsIamgeName = @"页面空数据";
            [self lq_showFaildLoadDefault];
            self.lq_faildLoadDefaultTipsStr = nil;
            self.lq_faildLoadDefaultTipsIamgeName = nil;
            break;
        }
    }
}

#pragma mark - 隐藏加载失败提示背景
- (void)lq_hideFailLoad {
    [self lq_hideFaildLoadDefault];
    [self lq_hideFaildLoadGif];
    [self lq_hideFaildLoadCustomView];
}

#pragma mark - 初始化加载失败默认视图
- (void)lq_initFaildLoadDefault {
    [self.view layoutIfNeeded];
    CGSize size = self.view.bounds.size;
    _lq_failLoadDefaultView = [NoDataTipsView setTipsBackGroupWithframe:CGRectMake(0, 0, size.width, size.height) tipsIamgeName:_lq_faildLoadDefaultTipsIamgeName tipsStr:_lq_faildLoadDefaultTipsStr];
    _lq_failLoadDefaultView.delegate = self;
}
#pragma mark - 显示加载失败默认视图
- (void)lq_showFaildLoadDefault {
    if (!_lq_failLoadDefaultView) {
        [self lq_initFaildLoadDefault];
    } else {
        [_lq_failLoadDefaultView setTipsString:_lq_faildLoadDefaultTipsStr];
        [_lq_failLoadDefaultView setImageName:_lq_faildLoadDefaultTipsIamgeName];
    }
    [self.view insertSubview:_lq_failLoadDefaultView atIndex:0];
    _lq_failLoadDefaultView.hidden = NO;
}
#pragma mark - 隐藏加载失败默认视图
- (void)lq_hideFaildLoadDefault {
    if (_lq_failLoadDefaultView) {
        [_lq_failLoadDefaultView removeFromSuperview];
    }
}
#pragma mark - 初始化加载失败GIF动画
- (void)lq_initFaildLoadGif {
    // 设定位置和大小
    CGRect frame;
    frame.size = [UIImage imageNamed:_lq_faildLoadGifName].size;
    [self.view layoutIfNeeded];
    CGPoint origin = CGPointMake(self.view.bounds.size.width/2.0 - frame.size.width / 2.0, self.view.bounds.size.height/2.0 - frame.size.height / 2.0) ;
    frame.origin = origin;
    // 读取gif图片数据
    _lq_faildLoadGifView = [[YLImageView alloc] initWithFrame:frame];
    _lq_faildLoadGifView.image = [YLGIFImage imageNamed:_lq_faildLoadGifName];
}
#pragma mark - 显示加载失败GIF动画
- (void)lq_showFaildLoadGif {
    if (!_lq_faildLoadGifView) {
        [self lq_faildLoadGifView];
    }
    [self.view insertSubview:_lq_faildLoadGifView atIndex:0];
    _lq_faildLoadGifView.hidden = NO;
}
#pragma mark - 隐藏加载失败GIF动画
- (void)lq_hideFaildLoadGif {
    if (_lq_faildLoadGifView) {
        [_lq_faildLoadGifView removeFromSuperview];
    }
}
#pragma mark - 显示加载中自定义的View
- (void)lq_showFaildLoadCustomView {
    if (_lq_failLoadView) {
        if (_lq_failLoadView.frame.size.width <= 0 || _lq_failLoadView.frame.size.height <=0) {
            [self.view layoutIfNeeded];
            CGSize size = self.view.bounds.size;
            _lq_failLoadView.frame = CGRectMake(0, 0, size.width, size.height);
        }
        [self.view insertSubview:_lq_failLoadView atIndex:0];
        _lq_failLoadView.hidden = NO;
    }
}
#pragma mark - 隐藏加载中自定义的View
- (void)lq_hideFaildLoadCustomView {
    if (_lq_failLoadView) {
        [_lq_failLoadView removeFromSuperview];
    }
}
#pragma mark - 清除背景
- (void)lq_cleanBackgroud {
    [self lq_hideLoading];
    [self lq_hideFailLoad];
    self.view.userInteractionEnabled = YES;
}
#pragma mark - 停止loading
- (void)lq_endLoading {
    [self lq_cleanBackgroud];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
