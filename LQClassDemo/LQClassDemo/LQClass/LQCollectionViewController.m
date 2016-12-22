//
//  LQCollectionViewController.m
//  PublicLawyerChat
//
//  Created by lawchat on 16/5/9.
//  Copyright © 2016年 就问律师. All rights reserved.
//

#import "LQCollectionViewController.h"
#import <MJRefresh/MJRefresh.h>

@interface LQCollectionViewController ()

@property (nonatomic , strong) NSArray *pullLoadingImages;
@property (nonatomic , strong) NSArray *moreLoadingImages;
@end

@implementation LQCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _lq_loadingGifName = @"lq_loading.gif";
    _lq_loadingViewType  = LQCollectionViewLoadingViewTypeGif;
    //    _lq_loadingViewType  = LQCollectionViewLoadingViewTypeDefault;
    _lq_failLoadViewType = LQCollectionViewFailLoadViewTypeDefault;
    
    self.collectionView.backgroundColor =  [UIColor colorWithRed: 248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0];
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
#pragma mark - 开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - 点击某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

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
- (NSArray *)moreLoadingImages {
    if (!_moreLoadingImages) {
        _moreLoadingImages = @[[UIImage imageNamed:@"pullLoading-1"],
                               [UIImage imageNamed:@"pullLoading-2"],
                               [UIImage imageNamed:@"pullLoading-3"],
                               [UIImage imageNamed:@"pullLoading-4"]];
    }
    return _moreLoadingImages;
}
#pragma mark - 添加下拉刷新
- (void)addPullRefreshWithBlock:(void(^)(void))block {
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        self.collectionView.mj_footer.hidden = NO;
        if (block) {
            block();
        }
    }];
    
    [header setImages:self.pullLoadingImages forState:MJRefreshStateIdle];
    
    [header setImages:self.pullLoadingImages forState:MJRefreshStatePulling];
    
    [header setImages:self.pullLoadingImages forState:MJRefreshStateRefreshing];
    
    self.collectionView.mj_header = header;
    
    header.lastUpdatedTimeLabel.hidden = YES;
    
    header.stateLabel.hidden = YES;
    
    header.lastUpdatedTimeLabel.hidden = YES;
}
#pragma mark - 上拉加载更多
- (void)addMoreLoadingWithBlock:(void(^)(void))block {
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        if (block) {
            block();
        }
    }];
    
    
    [footer setImages:self.moreLoadingImages forState:MJRefreshStateIdle];
    
    [footer setImages:self.moreLoadingImages forState:MJRefreshStatePulling];
    
    [footer setImages:self.moreLoadingImages forState:MJRefreshStateRefreshing];
    
    // Set footer
    self.collectionView.mj_footer = footer;
    
    footer.stateLabel.hidden = YES;
    
    self.collectionView.mj_footer.automaticallyHidden = YES;
}

- (void)endRefreshWithFooterHidden {
    [self.collectionView.mj_footer endRefreshing];
    self.collectionView.mj_footer.hidden = YES;
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
    if (self.collectionView.mj_header.isRefreshing || self.collectionView.mj_footer.isRefreshing) {
        return;
    }
    [self lq_hideFailLoad];
    
    switch (_lq_loadingViewType) {
        case LQCollectionViewLoadingViewTypeDefault: {
            [self lq_showLoadingDefault];
            break;
        }
        case LQCollectionViewLoadingViewTypeGif: {
            [self lq_showLoadingGif];
            break;
        }
        case LQCollectionViewLoadingViewTypeCustom: {
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
    [_lq_activityIndicator setCenter:self.collectionView.backgroundView.center];
    
}
#pragma mark - 加载菊花加载动画
- (void)lq_showLoadingDefault {
    if (!_lq_activityIndicator) {
        [self lq_initLoadingDefault];
    }
    
    self.collectionView.backgroundView = nil;
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
    
    _lq_loadingGifView.image = [YLGIFImage imageNamed:_lq_loadingGifName];
}
#pragma mark - 显示加载中GIF动画
- (void)lq_showLoadingGif {
    if (!_lq_loadingGifView) {
        [self lq_initLoadingGif];
    }
    [self.collectionView layoutIfNeeded];
    CGSize size = self.collectionView.bounds.size;
    UIView *backgroudView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    backgroudView.backgroundColor = [UIColor clearColor];
    [backgroudView addSubview:_lq_loadingGifView];
    _lq_loadingGifView.center = backgroudView.center;
    self.collectionView.backgroundView = backgroudView;
    _lq_loadingGifView.hidden = NO;
}
#pragma mark - 隐藏加载中GIF动画
- (void)lq_hideLoadingGif {
    if (_lq_loadingGifView) {
        self.collectionView.backgroundView = nil;
        _lq_loadingGifView = nil;
    }
}
#pragma mark - 显示加载中自定义的View
- (void)lq_showLoadingCustomView {
    if (_lq_loadingView) {
        if (_lq_loadingView.frame.size.width <= 0 && _lq_loadingView.frame.size.height <=0) {
            [self.collectionView layoutIfNeeded];
            CGSize size = self.collectionView.bounds.size;
            _lq_loadingView.frame = CGRectMake(0, 0, size.width, size.height);
        }
        self.collectionView.backgroundView = _lq_loadingView;
        _lq_loadingView.hidden = NO;
    }
}
#pragma mark - 隐藏加载中自定义的View
- (void)lq_hideLoadingCustomView {
    if (_lq_loadingView) {
        self.collectionView.backgroundView = nil;
    }
}

/************************ 加载失败  ************************/
#pragma mark - 显示加载失败提示背景

- (void)lq_showFailLoadWithType:(LQCollectionViewFailLoadViewType)type tipsString:(NSString *)tipsString{
    [self lq_hideLoading];
    self.view.userInteractionEnabled = YES;
    _lq_failLoadViewType = type;
    self.lq_faildLoadDefaultTipsStr = tipsString;
    switch (_lq_failLoadViewType) {
        case LQCollectionViewFailLoadViewTypeDefault: {
            if (self.lq_faildLoadDefaultTipsStr.length == 0) {
                self.lq_faildLoadDefaultTipsStr = @"加载失败，点击屏幕刷新";
            }
            self.lq_faildLoadDefaultTipsIamgeName = @"页面加载失败";
            [self lq_showFaildLoadDefault];
            self.lq_faildLoadDefaultTipsStr = nil;
            self.lq_faildLoadDefaultTipsIamgeName = nil;
            break;
        }
        case LQCollectionViewFailLoadViewTypeGif: {
            [self lq_showFaildLoadGif];
            break;
        }
        case LQCollectionViewFailLoadViewTypeCustom: {
            
            [self lq_showFaildLoadCustomView];
            break;
        }
        case LQCollectionViewFailLoadViewTypeNoData: {
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
    [self.collectionView layoutIfNeeded];
    CGSize size = self.collectionView.bounds.size;
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
    
    self.collectionView.backgroundView = _lq_failLoadDefaultView;
    _lq_failLoadDefaultView.hidden = NO;
}
#pragma mark - 隐藏加载失败默认视图
- (void)lq_hideFaildLoadDefault {
    if (_lq_failLoadDefaultView) {
        self.collectionView.backgroundView = nil;
    }
}
#pragma mark - 初始化加载失败GIF动画
- (void)lq_initFaildLoadGif {
    // 设定位置和大小
    CGRect frame;
    frame.size = [UIImage imageNamed:_lq_faildLoadGifName].size;
    [self.collectionView layoutIfNeeded];
    CGPoint origin = CGPointMake(self.collectionView.bounds.size.width/2.0 - frame.size.width / 2.0, self.collectionView.bounds.size.height/2.0 - frame.size.height / 2.0) ;
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
    self.collectionView.backgroundView = _lq_faildLoadGifView;
    _lq_faildLoadGifView.hidden = NO;
}
#pragma mark - 隐藏加载失败GIF动画
- (void)lq_hideFaildLoadGif {
    if (_lq_faildLoadGifView) {
        self.collectionView.backgroundView = nil;
        _lq_faildLoadGifView = nil;
    }
}
#pragma mark - 显示加载中自定义的View
- (void)lq_showFaildLoadCustomView {
    if (_lq_failLoadView) {
        if (_lq_failLoadView.frame.size.width <= 0 || _lq_failLoadView.frame.size.height <=0) {
            [self.collectionView layoutIfNeeded];
            CGSize size = self.collectionView.bounds.size;
            _lq_failLoadView.frame = CGRectMake(0, 0, size.width, size.height);
        }
        self.collectionView.backgroundView = _lq_failLoadView;
        _lq_failLoadView.hidden = NO;
    }
}
#pragma mark - 隐藏加载中自定义的View
- (void)lq_hideFaildLoadCustomView {
    if (_lq_failLoadView) {
        self.collectionView.backgroundView = nil;
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
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
