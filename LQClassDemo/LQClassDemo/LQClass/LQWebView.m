//
//  LQWebView.m
//  demo
//
//  Created by jackli on 16/5/3.
//  Copyright © 2016年 jackli. All rights reserved.
//

#import "LQWebView.h"
#import "YLGIFImage.h"
#import "YLImageView.h"
#import <MJRefresh/MJRefresh.h>

@interface LQWebView () <NoDataTipsDelegate, WKNavigationDelegate>


@property (nonatomic , strong) NSArray *pullLoadingImages;

/**
 *  菊花加载视图
 */
@property(nonatomic,strong) UIActivityIndicatorView *lq_activityIndicator;

/**
 *  加载中gif
 */
@property(nonatomic,strong) YLImageView *lq_loadingGifView;

/**
 *  加载失败gif
 */
@property(nonatomic,strong) YLImageView *lq_faildLoadGifView;

/**
 *  请求地址
 */
@property(nonatomic,strong) NSURLRequest *lq_request;

@end

@implementation LQWebView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (!_lq_loadingViewType) {
            _lq_loadingGifName = @"lq_loading.gif";
//            _lq_loadingViewType  = LQWebViewLoadingViewTypeGif;
            _lq_loadingViewType  = LQWebViewLoadingViewTypeDefault;
        }
        if (!_lq_failLoadViewType) {
            _lq_failLoadViewType = LQWebViewFailLoadViewTypeDefault;
        }
        _lq_webView = [[WKWebView alloc] initWithFrame:self.bounds];
        _lq_webView.navigationDelegate = self;
        [self addSubview:_lq_webView];
        self.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
        _lq_webView.backgroundColor = self.backgroundColor;
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    _lq_webView.frame = self.bounds;
}

/************************ 加载中  ************************/

#pragma mark - 下拉刷新图
- (NSArray *)pullLoadingImages {
    if (!_pullLoadingImages) {
        _pullLoadingImages = @[[UIImage imageNamed:@"pullLoading-1"],
                               [UIImage imageNamed:@"pullLoading-2"],
                               [UIImage imageNamed:@"pullLoading-3"],
                               [UIImage imageNamed:@"pullLoading-4"]];
    }
    return _pullLoadingImages;
}

- (void)addPullRefreshWithBlock:(void(^)(void))block {
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        if (block) {
            block();
        }
    }];
    
    [header setImages:self.pullLoadingImages forState:MJRefreshStateIdle];
    
    [header setImages:self.pullLoadingImages forState:MJRefreshStatePulling];
    
    [header setImages:self.pullLoadingImages forState:MJRefreshStateRefreshing];
    
    self.lq_webView.scrollView.mj_header = header;
    
    header.lastUpdatedTimeLabel.hidden = YES;
    
    header.stateLabel.hidden = YES;
    
    header.lastUpdatedTimeLabel.hidden = YES;
}


#pragma mark - 显示加载中的动画
- (void)lq_showLoading {
    _lq_webView.hidden = YES;
    switch (_lq_loadingViewType) {
        case LQWebViewLoadingViewTypeDefault: {
            [self lq_showLoadingDefault];
            break;
        }
        case LQWebViewLoadingViewTypeGif: {
            [self lq_showLoadingGif];
            break;
        }
        case LQWebViewLoadingViewTypeCustom: {
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
    _lq_webView.hidden = NO;
}

#pragma mark - 初始化菊花加载动画
- (void)lq_initLoadingDefault {
    _lq_activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_lq_activityIndicator setCenter:self.center];
    
}
#pragma mark - 加载菊花加载动画
- (void)lq_showLoadingDefault {
    if (!_lq_activityIndicator) {
        [self lq_initLoadingDefault];
    }
    
    [self insertSubview:_lq_activityIndicator atIndex:0];
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
    frame.size = CGSizeMake(200, 200);
    // 读取gif图片数据
    
    _lq_loadingGifView = [[YLImageView alloc] initWithFrame:frame];
    _lq_loadingGifView.center = self.lq_webView.center;
    _lq_loadingGifView.image = [YLGIFImage imageNamed:_lq_loadingGifName];
}
#pragma mark - 显示加载中GIF动画
- (void)lq_showLoadingGif {
    if (!_lq_loadingGifView) {
        [self lq_initLoadingGif];
    }
    [self insertSubview:_lq_loadingGifView atIndex:0];
    _lq_loadingGifView.hidden = NO;
}
#pragma mark - 隐藏加载中GIF动画
- (void)lq_hideLoadingGif {
    if (_lq_loadingGifView) {
        [_lq_loadingGifView removeFromSuperview];
        _lq_faildLoadGifView = nil;
    }
}
#pragma mark - 显示加载中自定义的View
- (void)lq_showLoadingCustomView {
    if (_lq_loadingView) {
        if (_lq_loadingView.frame.size.width <= 0 && _lq_loadingView.frame.size.height <=0) {
            _lq_loadingView.frame = self.bounds;
        }
        [self insertSubview:_lq_loadingView atIndex:0];
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
#pragma mark - 显示加载失败提示背景
- (void)lq_showFailLoad {
    _lq_webView.hidden = YES;
    switch (_lq_failLoadViewType) {
        case LQWebViewFailLoadViewTypeDefault: {
            [self lq_showFaildLoadDefault];
            break;
        }
        case LQWebViewFailLoadViewTypeGif: {
            [self lq_showFaildLoadGif];
            break;
        }
        case LQWebViewFailLoadViewTypeCustom: {
            [self lq_showFaildLoadCustomView];
            break;
        }
    }
}
#pragma mark - 隐藏加载失败提示背景
- (void)lq_hideFailLoad {
    [self lq_hideFaildLoadDefault];
    [self lq_hideFaildLoadGif];
    [self lq_hideFaildLoadCustomView];
    _lq_webView.hidden = NO;
}

#pragma mark - 初始化加载失败默认视图
- (void)lq_initFaildLoadDefault {
    _lq_failLoadDefaultView = [NoDataTipsView setTipsBackGroupWithframe:self.bounds tipsIamgeName:_lq_faildLoadDefaultTipsIamgeName tipsStr:_lq_faildLoadDefaultTipsStr];
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
    
    [self insertSubview:_lq_failLoadDefaultView atIndex:0];
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
    CGPoint origin = CGPointMake(self.bounds.size.width/2.0 - frame.size.width / 2.0, self.bounds.size.height/2.0 - frame.size.height / 2.0) ;
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
    [self insertSubview:_lq_faildLoadGifView atIndex:0];
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
            _lq_failLoadView.frame = self.bounds;
        }
        [self insertSubview:_lq_failLoadView atIndex:0];
        _lq_failLoadView.hidden = NO;
    }
}
#pragma mark - 隐藏加载中自定义的View
- (void)lq_hideFaildLoadCustomView {
    if (_lq_failLoadView) {
        [_lq_failLoadView removeFromSuperview];
    }
}

/************************ webViewDelegate  ************************/
#pragma mark - <WKNavigationDelegate> (替代UIWebView)
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    if (self.delegate && [self.delegate respondsToSelector:@selector(webView:didStartProvisionalNavigation:)]) {
        [self.delegate webView:webView didStartProvisionalNavigation:navigation];
    }
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    /**
     *  隐藏加载失败提示背景
     */
    
    [self lq_hideFailLoad];
    /**
     *  显示加载中动画
     */
    [self lq_showLoading];
    
    if (_delegate && [self.delegate respondsToSelector:@selector(webView:didCommitNavigation:)]) {
        [self.delegate webView:webView didCommitNavigation:navigation];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    /**
     *  隐藏加载中动画
     */
    [self lq_hideLoading];
    
    if (_delegate && [self.delegate respondsToSelector:@selector(webView:didFinishNavigation:)]) {
        [_delegate webView:webView didFinishNavigation:navigation];
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    /**
     *  隐藏加载中动画
     */
    [self lq_hideLoading];
    
    /**
     *  显示加载失败提示背景
     */
    [self lq_showFailLoad];
    
    if (_delegate && [self.delegate respondsToSelector:@selector(webView:didFailNavigation:withError:)]) {
        return [_delegate webView:webView didFailNavigation:navigation withError:error];
    }
}

#pragma mark - NoDataTipsDelegate - 刷新点击
- (void)tipsRefreshBtnClicked {
    [_lq_webView loadRequest:_lq_request];
}

#pragma mark - 根据地址请求
- (void)loadRequestWithUrlString:(NSString *) urlString {
    _lq_request =  [[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:urlString]];
    [self beginLoad];
}

#pragma mark - 开始加载
- (void)beginLoad {
    [_lq_webView loadRequest:_lq_request];
}
#pragma mark - 开始加载，gif动画加载中
- (void)beginLoadWithGifImageName:(nullable NSString *) gifImageName {
    _lq_loadingViewType = LQWebViewLoadingViewTypeGif;
    _lq_loadingGifName = @"1.gif";
    [self beginLoad];
}
#pragma mark - 开始加载，自定义视图
- (void)beginLoadWithCustomView:(nullable UIView *) customView {
    _lq_loadingView = customView;
    _lq_loadingViewType = LQWebViewLoadingViewTypeCustom;
    [self beginLoad];
}
#pragma mark - 加载webView到自定superView
+ (nullable instancetype)initWithShowWebViewInSuperView:(nullable UIView *)superView delegate:(nullable id)delegate urlString:(nullable NSString *)urlString {
    LQWebView *webView = [[LQWebView alloc] initWithFrame:superView.bounds];
    [superView addSubview:webView];
    webView.delegate = delegate;
    webView.lq_request =  [[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:urlString]];
    return webView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
