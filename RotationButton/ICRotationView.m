//
//  ICRotationView.m
//  RotationButton
//
//  Created by CSX on 2017/3/9.
//  Copyright © 2017年 宗盛商业. All rights reserved.
//

#import "ICRotationView.h"
#import "UIOneRotationGestureRecognizer.h"

@interface ICRotationView ()<UIGestureRecognizerDelegate>
//按钮数组
@property (nonatomic , strong) NSMutableArray *btnArray;
//旋转的弧度
@property (nonatomic , assign)CGFloat rotationAngleInRadians;
//按钮的名字
@property (nonatomic , strong) NSMutableArray *nameArray;

@end

@implementation ICRotationView

static ICRotationView *shareInatance;

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.frame = frame;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = self.frame.size.width/2;
        self.With = self.frame.size.width;
        self.backgroundColor = [UIColor clearColor];
        //按钮和按钮标题数组
        _btnArray = [NSMutableArray new];
        _nameArray = [NSMutableArray new];
        UIOneRotationGestureRecognizer *rotation = [[UIOneRotationGestureRecognizer alloc]initWithTarget:self action:@selector(changeMove:)];
        rotation.delegate = self;
        [self addGestureRecognizer:rotation];
    }
    return self;
}

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
- (void)BtnType:(CL_RoundviewType)type BtnWith:(CGFloat)BtnWith adjustFontSizesTowith:(BOOL)sizeWith masksToBounds:(BOOL)mask corenrRadius:(CGFloat)radius image:(NSMutableArray *)image TitleArray:(NSMutableArray *)titleArray titleColor:(UIColor *)titleColor{
    CGFloat corner = -M_PI * 2.0 / titleArray.count;
    // 半径为 （转盘半径➖按钮半径）的一半
    CGFloat r = (self.With  - BtnWith) / 2 ;
    CGFloat x = self.With  / 2 ;
    CGFloat y = self.With  / 2 ;
    _nameArray = titleArray;
    
    for (int i = 0 ; i < titleArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, BtnWith, BtnWith);
        btn.layer.masksToBounds = mask;
        btn.layer.cornerRadius = radius;
        CGFloat  num = (i + 0.5) * 1.0;
        btn.center = CGPointMake(x + r * cos(corner * num), y + r *sin(corner * num));
        btn.backgroundColor = self.BtnBackgroundColor;
        self.BtnWith = BtnWith;
        
        // 自定义按钮的样式
        if (type == CL_RoundviewTypeCustom) {
            UIImageView *imageview = [[UIImageView alloc]init];
            imageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",image[i]]];
            imageview.contentMode = UIViewContentModeScaleAspectFit ;
            imageview.userInteractionEnabled = NO;
            // 设置的按钮的图片的大小
            imageview.frame = CGRectMake(20, 10, 50, 50);
            [btn addSubview:imageview];
            
            UILabel *label = [[UILabel alloc]init ];
            label.frame = CGRectMake(  imageview.center.x - (BtnWith - 20)*0.5, CGRectGetMaxY(imageview.frame), BtnWith - 20 , 20);
            
            label.text = titleArray[i];
            // 设置字体颜色为白色
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            
            label.font = [UIFont systemFontOfSize:11];
            // label根据字体自适应label大小，居中对齐
            label.adjustsFontSizeToFitWidth = sizeWith;
            label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
            
            label.tag = i;
            [btn addSubview:label];
            
        }else {
            [btn setTitle:titleArray[i] forState:UIControlStateNormal];
            [btn setTitleColor:titleColor forState:UIControlStateNormal];
        }
        btn.tag = i;
        [btn addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [_btnArray addObject:btn];

    }
}
    
#pragma mark - 点击按钮时跳转控制器
- (void)btn: (UIButton *)btn {
        
    NSInteger num1 = btn.tag;
    NSString *name = _nameArray[num1];
    self.back(num1,name);
    
}
//手势的代理方法
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 过滤掉UIButton，也可以是其他类型
    if ( [touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    return YES;
}
#pragma mark -通过旋转手势转动转盘
- (void)changeMove:(UIOneRotationGestureRecognizer *)retation {
        
    switch (retation.state) {
        case UIGestureRecognizerStateBegan:
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            self.rotationAngleInRadians += retation.rotation;
            [UIView animateWithDuration:.25 animations:^{
                
                self.transform = CGAffineTransformMakeRotation(self.rotationAngleInRadians+retation.rotation);
                for (UIButton *btn in _btnArray) {
                    //让所有的button逆方向旋转对应角度就能够保证方向正直
                    btn.transform = CGAffineTransformMakeRotation(-(self.rotationAngleInRadians+retation.rotation));
                }
            }];
            break;
        }
            
            //        case UIGestureRecognizerStateFailed:
            //        case UIGestureRecognizerStateCancelled:
            
            //不需要加惯性手势的话这里方法内部所有代码可以省去
        case UIGestureRecognizerStateEnded:
        {
            //每个区域的角度
            CGFloat cellAngle = (M_PI*2)/(_nameArray.count);
            int angleCell = (int)(cellAngle*(180/M_PI));
            int num = self.rotationAngleInRadians/cellAngle;
            int last = ((int)(self.rotationAngleInRadians*(180/M_PI)))%angleCell;
            
            
            if (abs(last)>=angleCell/2) {
                
                [UIView animateWithDuration:.25 animations:^{
                    
                    self.transform = CGAffineTransformMakeRotation(cellAngle*(last>0?(num+1):(num-1)));
                    //                        tempAngle = M_PI/3*(last>0?(num+1):(num-1));
                    for (UIButton *btn in _btnArray) {
                        btn.transform = CGAffineTransformMakeRotation(-(cellAngle*(last>0?(num+1):(num-1))));
                    }
                }];
                //偏转角度保存。
                self.rotationAngleInRadians = cellAngle*(last>0?(num+1):(num-1));
                NSLog(@"偏转角度 = %lf ", self.rotationAngleInRadians*(180/M_PI));
                
            }
            else{
                
                [UIView animateWithDuration:.25 animations:^{
                    
                    self.transform = CGAffineTransformMakeRotation(cellAngle*num);
                    for (UIButton *btn in _btnArray) {
                        btn.transform = CGAffineTransformMakeRotation(-(cellAngle*num));
                    }
                }];
                //偏转角度保存。
                self.rotationAngleInRadians = cellAngle*num;
                
            }
            
            break;
        }
        default:
            break;
    }
}
    
    
    
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
