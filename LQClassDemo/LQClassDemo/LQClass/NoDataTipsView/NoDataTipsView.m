//
//  NoDataTipsView.m
//  jackliForLawyer
//
//  Created by jacli on 15/7/31.
//  Copyright (c) 2015年 jacli. All rights reserved.
//

#import "NoDataTipsView.h"

@implementation NoDataTipsView

- (void)setImageName:(NSString *)imageName{
    if (imageName) {
        [_tipsIamgeBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    else{
        [_tipsIamgeBtn setImage:[UIImage imageNamed:@"页面加载失败"] forState:UIControlStateNormal];
    }
}

-(void)setTipsString:(NSString *)tipsString
{
    if (tipsString) {
        _tipsStringLabel.text = tipsString;
    }
}

//设置指示按钮背景色
- (void)setNoDataBtnBackgroudColor:(UIColor*)color{
    if (color) {
        [_noDataBtn setBackgroundColor:color];
    }
}

//设置指示按钮文字
- (void)setNoDataBtnTitle:(NSString*)title{
    if (title) {
        [_noDataBtn setTitle:title forState:UIControlStateNormal];
    }
}

-(void)needBtnWithName:(NSString*)btnName
{
    _noDataBtn.hidden = !@(btnName.length).boolValue;
    _noDataBtn.layer.cornerRadius = 3;
    if (btnName) {
        [_noDataBtn setTitle:btnName forState:UIControlStateNormal];
    }
}

- (IBAction)NoDataBtnClicked:(id)sender {
    if(_delegate != nil && [_delegate respondsToSelector:@selector(tipsNoDataBtnDid)])
    {
        [_delegate tipsNoDataBtnDid];
    }
}

- (IBAction)refreshBtnClicked:(id)sender {
//    self.hidden = YES;
    if(_delegate && [_delegate respondsToSelector:@selector(tipsRefreshBtnClicked)])
    {
        [_delegate tipsRefreshBtnClicked];
    }
}

#pragma mark - 设置提示背景
+(NoDataTipsView *)setTipsBackGroupWithframe:(CGRect)frame tipsIamgeName:(NSString*)tipsIamgeName tipsStr:(NSString *)tipsStr
{
    NoDataTipsView *tipsView = [[[NSBundle mainBundle] loadNibNamed:@"NoDataTipsView" owner:nil options:nil] firstObject];
    [tipsView setImageName:tipsIamgeName];
    [tipsView setTipsString:tipsStr];
    tipsView.frame = frame;
    return tipsView;
}

@end
