//
//  UIOneRotationGestureRecognizer.h
//  RotationButton
//
//  Created by CSX on 2017/3/7.
//  Copyright © 2017年 宗盛商业. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIOneRotationGestureRecognizer : UIGestureRecognizer

// 记录手势最后一个改变是旋转的弧度
@property (nonatomic, assign) CGFloat rotation;

@end
