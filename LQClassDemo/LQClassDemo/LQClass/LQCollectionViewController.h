//
//  LQCollectionViewController.h
//  PublicLawyerChat
//
//  Created by lawchat on 16/5/9.
//  Copyright © 2016年 就问律师. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoDataTipsView.h"
#import "YLGIFImage.h"
#import "YLImageView.h"
typedef NS_ENUM(NSInteger, LQCollectionViewLoadingViewType) {
    LQCollectionViewLoadingViewTypeDefault = 0,//默认菊花加载动画
    LQCollectionViewLoadingViewTypeGif,
    LQCollectionViewLoadingViewTypeCustom
};
typedef NS_ENUM(NSInteger, LQCollectionViewFailLoadViewType) {
    LQCollectionViewFailLoadViewTypeDefault = 0,//默认
    LQCollectionViewFailLoadViewTypeNoData,
    LQCollectionViewFailLoadViewTypeGif,
    LQCollectionViewFailLoadViewTypeCustom
};
@interface LQCollectionViewController : UICollectionViewController<NoDataTipsDelegate>

/**
 *  加载中动画类型，默认菊花加载动画
 */
@property(nonatomic,assign) LQCollectionViewLoadingViewType lq_loadingViewType;
/**
 *  加载中动画类型，默认菊花加载动画
 */
@property(nonatomic,assign) LQCollectionViewFailLoadViewType lq_failLoadViewType;
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
 *  菊花加载视图
 */
@property(nullable, nonatomic,strong) UIActivityIndicatorView *lq_activityIndicator;

/**
 *  加载中gif
 */
@property(nullable, nonatomic,strong) YLImageView *lq_loadingGifView;

/**
 *  加载失败gif
 */
@property(nullable, nonatomic,strong) YLImageView *lq_faildLoadGifView;
/**
 *  显示加载ing背景
 */
- (void)lq_showLoading;
/**
 *  停止loading
 */
- (void)lq_endLoading;
/**
 *  显示加载空数据
 */
- (void)lq_showFailLoadWithType:(LQCollectionViewFailLoadViewType)type tipsString:(nullable NSString *)tipsString;
/**
 *  清除背景
 */
- (void)lq_cleanBackgroud;
/**
 *  无数据点击界面刷新
 */
- (void)noDataBeginRefresh;


/**
 *  下拉刷新
 */
- (void)addPullRefreshWithBlock:(nullable void(^)(void))block;

/**
 添加上拉加载更多
 
 @param block 上拉加载回调
 */
- (void)addMoreLoadingWithBlock:(nullable void(^)(void))block;

- (void)endRefreshWithFooterHidden;
@end
