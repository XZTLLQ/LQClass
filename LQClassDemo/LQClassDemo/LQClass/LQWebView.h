//
//  LQWebView.h
//  demo
//
//  Created by jackli on 16/5/3.
//  Copyright © 2016年 jackli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "NoDataTipsView.h"
typedef NS_ENUM(NSInteger, LQWebViewLoadingViewType) {
    LQWebViewLoadingViewTypeDefault = 0,//默认菊花加载动画
    LQWebViewLoadingViewTypeGif,
    LQWebViewLoadingViewTypeCustom
};
typedef NS_ENUM(NSInteger, LQWebViewFailLoadViewType) {
    LQWebViewFailLoadViewTypeDefault = 0,//默认菊花加载动画
    LQWebViewFailLoadViewTypeGif,
    LQWebViewFailLoadViewTypeCustom
};

@class LQWebView;

@protocol LQWebViewDelegate <NSObject>

@optional

#pragma mark - <WKNavigationDelegate>

//- (BOOL)webView:(nullable LQWebView *)webView shouldStartLoadWithRequest:(nullable NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;  --UIWebViewDelegate
- (void)webView:(nullable WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation;

//- (void)webViewDidStartLoad:(nullable LQWebView *)webView;
- (void)webView:(nullable WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation;

//- (void)webViewDidFinishLoad:(nullable LQWebView *)webView;
- (void)webView:(nullable WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation;

//- (void)webView:(nullable LQWebView *)webView didFailLoadWithError:(nullable NSError *)error;
- (void)webView:(nullable WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(nullable NSError *)error;

@end

@interface LQWebView : UIView

@property (nullable, nonatomic, assign) id <LQWebViewDelegate> delegate;

/**
 *  webView
 */
//@property(nullable, nonatomic,strong) UIWebView *lq_webView;
@property(nullable, nonatomic,strong) WKWebView *lq_webView;

/**
 *  加载中动画类型，默认菊花加载动画
 */
@property(nonatomic,assign) LQWebViewLoadingViewType lq_loadingViewType;
/**
 *  加载中动画类型，默认菊花加载动画
 */
@property(nonatomic,assign) LQWebViewFailLoadViewType lq_failLoadViewType;
/**
 *  加载中动画自定义的View
 */
@property(nullable, nonatomic,strong) UIView *lq_loadingView;
/**
 *  加载中动画gif文件名称
 */
@property(nullable, nonatomic,strong) NSString *lq_loadingGifName;
/**
 *  加载失败自定义的View
 */
@property(nullable, nonatomic,strong) UIView *lq_failLoadView;
/**
 *  加载失败动画gif文件名称
 */
@property(nullable, nonatomic,strong) NSString *lq_faildLoadGifName;
/**
 *  加载失败默认背景View
 */
@property(nullable, nonatomic,strong) NoDataTipsView *lq_failLoadDefaultView;
/**
 *  加载失败默认显示的图片名称
 */
@property(nullable, nonatomic,strong) NSString *lq_faildLoadDefaultTipsIamgeName;
/**
 *  加载失败默认显示的说明文字
 */
@property(nullable, nonatomic,strong) NSString *lq_faildLoadDefaultTipsStr;

/**
 *  根据地址请求
 *
 *  @param urlString 网络请求地址string
 */
- (void)loadRequestWithUrlString:(nullable NSString *) urlString;

/**
 *  开始加载
 */
- (void)beginLoad;

/**
 *  开始加载（gif加载动画）
 */
- (void)beginLoadWithGifImageName:(nullable NSString *) gifImageName;

/**
 *  开始加载（自定义视图）
 */
- (void)beginLoadWithCustomView:(nullable UIView *) customView;

/**
 *  加载webView到自定superView
 *
 *  @param superView 父视图
 *  @param delegate  代理对象
 */
+ (nullable instancetype)initWithShowWebViewInSuperView:(nullable UIView *)superView delegate:(nullable id)delegate urlString:(nullable NSString *)urlString;

/**
 添加下拉刷新
 */
- (void)addPullRefreshWithBlock:(nullable void(^)(void))block;
@end

