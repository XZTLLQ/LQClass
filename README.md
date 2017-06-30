# LQ系列 -- APP 项目模板 V1.0（高阶）

#### 项目开发模板-按需登录型应用 - https://github.com/XZTLLQ/LQProject-NoLogin
#### 项目开发模板-强制登录型应用 - https://github.com/XZTLLQ/LQProject-MustLogin

注意：此模板是自己的设计，虽然称不上是神作，但是有很多地方有非常好的设计点能帮助开发者快速构建项目，用过的都表示赞👍 ！！！

# LQ系列--UI
#### LQPhotoPickerDemo - https://github.com/XZTLLQ/LQClass （可节约项目大量细节调控时间，体验好！）
#### LQPhotoPickerDemo - https://github.com/XZTLLQ/LQPhotoPickerDemo （选择图片上传）
#### LQIMInputView - https://github.com/XZTLLQ/LQIMInputView （聊天页面工具栏）
# LQClass
### 支持:
#### LQViewController  （父类UIViewController）
#### LQTableViewController  （父类UITableViewController）
#### LQCollectionViewController  （父类UICollectionViewController）
#### LQWebView  （父类UIView）使用了（WKWebView）

### 功能简介：
页面常用体验功能：输入框键盘自动补位，点击页面或滑动页面隐藏键盘，加载中背景动画，点击背景刷新，显示无数据背景提示（自定义强度高，支持之定义view，或替换gif），加载失败背景提示。快速集成调用下拉刷新，上拉加载更多（pod 集成MJRefresh）等等常用页面细节处理。能帮助开发人员快速开发页面功能，节约大量细节调控时间！
## 效果图：
![](https://github.com/XZTLLQ/LQClass/blob/master/%E6%95%88%E6%9E%9C%E5%9B%BE.gif?raw=true)
## 集成代码：
因为源码制作本意是快速帮助APP全局配置页面体验效果，所以推荐**继承**方式集成.项目中集成下拉刷新与上拉加载更多使用的是：MJRefresh（pod方式集成），请自行添加。
## 几行代码实现功能（demo源码有示例）：

```
#import "LQTableViewController.h"

@interface testTableViewController : LQTableViewController

@end
```

```
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加载数据
    [self noDataBeginRefresh];
    
    //（避免循环引用）
    __weak typeof(self) weakSelf = self;
    //下拉刷新
    [self addPullRefreshWithBlock:^{
        [weakSelf noDataBeginRefresh];
    }];
    
    //上拉加载更多
    [self addMoreLoadingWithBlock:^{
        [weakSelf noDataBeginRefresh];
    }];
}

#pragma mark - 点击背景刷新时执行
- (void)noDataBeginRefresh {
    [self getDataFromServer];
}

#pragma mark - 从服务器获得数据（异步）
- (void)getDataFromServer {
    
    //显示背景加载
    [self lq_showLoading];//（使用1）
    
    //发出网络请求（异步）
    //推迟两纳秒执行（模拟网络请求）
    dispatch_queue_t concurrentQueue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), concurrentQueue, ^(void){
        //网络请求回调结果：(回到主线程)
        dispatch_async(dispatch_get_main_queue(), ^{
        
            //更新UI操作
            [self lq_endLoading];//（使用2）
            
            if (@"服务器请求成功") {
                
                if (@"服务器返回无数据") {
                    [self lq_showFailLoadWithType:LQTableViewFailLoadViewTypeNoData tipsString:@"暂无数据，点击屏幕刷新"];//（使用3）
                } else {
                    //成功有数据业务逻辑
                }
            } else {
                [self lq_showFailLoadWithType:LQTableViewFailLoadViewTypeDefault tipsString:@"加载失败，点击屏幕重新加载"];//（使用4）
            }
        });
    });
    
}

```
## 自定义修改源码（大部分都在.h文件说明，此处简要介绍其他）：
#### 列：LQTableViewController：（其他类相同使用方法，类似设计）

```
- (void)viewDidLoad {
    [super viewDidLoad];
    /**
     *  添加footView,去除多余分割线
     */
    if (!self.tableView.tableFooterView) {
        [self setExtraCellLineHidden];
    }
    
    //收起键盘设置
    [self setHideKeyBoardTap];
    
    _lq_loadingGifName = @"lq_loading.gif";
    _lq_loadingViewType  = LQTableViewLoadingViewTypeGif;
    //    _lq_loadingViewType  = LQTableViewLoadingViewTypeDefault;
    
    _lq_failLoadViewType = LQTableViewFailLoadViewTypeDefault;
    
    self.tableView.backgroundColor = [UIColor colorWithRed: 248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0];
    
    self.tableView.separatorColor = [UIColor colorWithRed: 231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0];
}
```
_lq_loadingViewType（加载中）对应枚举值：

```
LQTableViewLoadingViewTypeDefault = 0,//默认菊花加载动画
LQTableViewLoadingViewTypeGif,//gif加载动画，想要替换自己的gif直接在LQResource目录下替换同名文件即可
LQTableViewLoadingViewTypeCustom,//加载过程显示自定义view
```
_lq_failLoadViewType(加载失败或空数据)对应枚举值：

```
    LQTableViewFailLoadViewTypeDefault = 0,//默认数据加载失败（感叹号图）
    LQTableViewFailLoadViewTypeNoData,//显示空数据背景（直接在LQResource目录下替换同名文件即可）
    LQTableViewFailLoadViewTypeGif,//gif加载动画，想要替换自己的gif直接在LQResource目录下替换同名文件即可
    LQTableViewFailLoadViewTypeCustom//加载结束显示自定义view
```
## 三方源码来源声明：
CLKeyboardOffsetView（键盘补位），MJRefresh（下拉刷新），YLGIFImage（gif图片加载）




