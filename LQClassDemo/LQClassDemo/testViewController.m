//
//  ViewController.m
//  LQClassDemo
//
//  Created by JW on 2016/12/20.
//  Copyright © 2016年 JL674297026@qq.com. All rights reserved.
//

#import "testViewController.h"

@interface testViewController ()

@end

@implementation testViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //加载数据
    [self noDataBeginRefresh];
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
                    [self lq_showFailLoadWithType:LQViewFailLoadViewTypeNoData];//（使用3）
                } else {
                    //成功有数据业务逻辑
                    
                }
                
            } else {
                
                [self lq_showFailLoadWithType:LQViewFailLoadViewTypeDefault];//（使用4）
                
            }
        });
        
        
        
        
        
    });
   
}


@end
