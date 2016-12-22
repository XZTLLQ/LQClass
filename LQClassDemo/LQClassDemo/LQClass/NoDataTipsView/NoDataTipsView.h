//
//  NoDataTipsView.h
//  jackliForLawyer
//
//  Created by jacli on 15/7/31.
//  Copyright (c) 2015年 jacli. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NoDataTipsDelegate <NSObject>

@optional
//指示按钮点击
- (void)tipsNoDataBtnDid;
//刷新按钮点击
- (void)tipsRefreshBtnClicked;

@end

@interface NoDataTipsView : UIView

@property (nonatomic, weak) id<NoDataTipsDelegate> delegate;


//显示的提示信息
@property (weak, nonatomic) IBOutlet UILabel *tipsStringLabel;
//指示按钮
@property (strong, nonatomic) IBOutlet UIButton *noDataBtn;
//图片按钮
@property (weak, nonatomic) IBOutlet UIButton *tipsIamgeBtn;
//刷新按钮
@property (weak, nonatomic) IBOutlet UIButton *refDataBtn;

//提示图片名称
@property(nonatomic,strong) NSString *imageName;

- (void)setImageName:(NSString *)imageName;
//设置提示信息
-(void)setTipsString:(NSString *)tipsString;

//设置指示按钮背景色
- (void)setNoDataBtnBackgroudColor:(UIColor*)color;
//设置指示按钮文字
- (void)setNoDataBtnTitle:(NSString*)title;


//是否需要指示按钮
-(void)needBtnWithName:(NSString*)btnName;

+(NoDataTipsView*)setTipsBackGroupWithframe:(CGRect)frame tipsIamgeName:(NSString*)tipsIamgeName tipsStr:(NSString *)tipsStr;
@end
