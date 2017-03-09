//
//  ViewController.m
//  RotationButton
//
//  Created by CSX on 2017/3/7.
//  Copyright © 2017年 宗盛商业. All rights reserved.
//

#import "ViewController.h"
#import "buttonModel.h"
#import "ICRotationView.h"
#import "UIOneRotationGestureRecognizer.h"
#import "SecondViewController.h"

@interface ViewController ()
@property(nonatomic , strong) UIButton *button;
@property(nonatomic , strong) ICRotationView *romate;
@property(nonatomic , strong) NSMutableArray *datasource;
@end

@implementation ViewController
//设置状态栏颜色为白色
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.navigationController.navigationBar.hidden = YES;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timg.jpeg"]];
    
    //旋转视图控制区域
    self.romate = [[ICRotationView alloc]initWithFrame:CGRectMake(0, 0, 270, 270)];
    self.romate.center = self.view.center;
    //添加背景图层layer层
    self.romate.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"home_center_bg"].CGImage);
    
    // 获取按钮模型数据
    _datasource = [NSMutableArray new];
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"ButtonList.plist" ofType:nil];
    NSArray *contentArray = [NSArray arrayWithContentsOfFile:filePath];
    for (NSDictionary *item  in contentArray) {
        buttonModel *model = [[buttonModel alloc]init];
        [model setValuesForKeysWithDictionary:item];
        [_datasource addObject:model];
    }
    NSMutableArray *titleArray = [NSMutableArray new];
    NSMutableArray *imageArray = [NSMutableArray new];
    for (buttonModel *model  in _datasource) {
        
        [titleArray addObject:model.title];
        [imageArray addObject:model.Image];
        
    }
    [self.romate BtnType:CL_RoundviewTypeCustom BtnWith:80 adjustFontSizesTowith:YES masksToBounds:YES corenrRadius:40 image:imageArray TitleArray:titleArray titleColor:[UIColor blackColor]];
    
#pragma mark - 使用block逆向传值，用途为点击旋转view上的按钮时弹出控制器
    __weak  typeof(self) weakself = self;
    self.romate.back = ^(NSInteger num ,NSString *name ) {
        [weakself pushView:num name:name];
    };
    [self.view addSubview:self.romate];
    
#pragma mark-------------------中间按钮自定义显示--------
    // 自定义的中间按钮
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake(0, 0, 80, 80);
    UIImageView *imageview = [[UIImageView alloc]init];
    imageview.image = [[UIImage imageNamed:@"home_center_img"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    imageview.contentMode = UIViewContentModeScaleAspectFit ;
    imageview.userInteractionEnabled = NO;
    // 设置的按钮的图片的大小
    imageview.frame = CGRectMake(_button.center.x - 15, _button.center.y - 20, 30, 30);
    
    [_button addSubview:imageview];
    UILabel *lable = [[UILabel alloc]init ];
    
    CGFloat BtnWidth = _button.frame.size.width;
    
    lable.frame = CGRectMake(  imageview.center.x - (BtnWidth - 20)*0.5, CGRectGetMaxY(imageview.frame), BtnWidth - 20 , 20);
    
    lable.text = @"拍照搜题";
    // 设置字体颜色为应用程序的主题色 通过取色笔获取的 RGB颜色
    lable.textColor = [UIColor colorWithRed:102.0/ 255.0 green:190/ 255.0 blue:48/ 255.0 alpha:1.0];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.font = [UIFont systemFontOfSize:11];
    [_button addSubview:lable];
    
    _button.backgroundColor = [UIColor whiteColor];
    _button.center = self.view.center;
    
    _button.layer.cornerRadius = 40;
    [_button addTarget:self action:@selector(showItems:) forControlEvents:UIControlEventTouchUpInside];
    
    // 按钮是添加到控制器的view上，所以转盘转动的时候不会跟着转盘一同旋转
    [self.view addSubview:_button];
    
}

- (void)showItems:(UIButton *)sender{
    
    
    SecondViewController *vc = [[SecondViewController alloc]init];
    
    for (UILabel *label in sender.subviews) {
        
        if ( [label isKindOfClass:[UILabel class]]  &&  label.text  ) {
            
            // 根据按钮的标题给控制器的title赋值
            vc.title = label.text;
            NSLog(@"----%@",label.text);
        }
        else {
            vc.title =  @"拍照搜题";
        }
        
    }
    
    //    [self.navigationController pushViewController:vc animated:YES];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}
// 跳转界面
- (void)pushView:(NSInteger)num name:(NSString *)name {
    
    NSMutableArray *classArray = [NSMutableArray new];
    for (buttonModel *model  in _datasource) {
        [classArray addObject:model.className];
    }
    SecondViewController *vc = [[SecondViewController alloc]init];
    vc.title = name;
    [self.navigationController pushViewController:vc animated:YES];
    
}


-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
