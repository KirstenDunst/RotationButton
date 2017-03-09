//
//  ICRotationView.h
//  RotationButton
//
//  Created by CSX on 2017/3/9.
//  Copyright © 2017年 宗盛商业. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , CL_RoundviewType) {
    CL_RoundviewTypeSystem = 0,//设置按钮只有文字显示在button上面
    CL_RoundviewTypeCustom , //自定义的按钮有图有文字
};


typedef void (^JumpBlock)(NSInteger num , NSString *name);

@interface ICRotationView : UIView

//点击按钮时跳转到控制器的逆向传值block 【可以使用代理代替】
@property(nonatomic ,copy) JumpBlock back;

//按钮样式 -- 系统样式或者自定义样式
@property (nonatomic , assign) CL_RoundviewType Type;
//按钮的宽度
@property(nonatomic ,assign) CGFloat BtnWith;
//视图的宽度
@property(nonatomic, assign)CGFloat With;
//按钮的背景颜色
@property (nonatomic , strong) UIColor *BtnBackgroundColor;


/*
 @param type        按钮的风格
 @param BtnWith      按钮的宽度
 @param sizeWith     字体是否自动适应按钮的宽度
 @param mask         是否允许剪切
 @param radius       圆角的大小
 @param image        图片数组
 @param titleArray   名字数组
 @param titleColor   字体的颜色
 */
- (void)BtnType:(CL_RoundviewType)type BtnWith:(CGFloat)BtnWith adjustFontSizesTowith:(BOOL)sizeWith masksToBounds:(BOOL)mask corenrRadius:(CGFloat)radius image:(NSMutableArray *)image TitleArray:(NSMutableArray *)titleArray titleColor:(UIColor *)titleColor;



@end
