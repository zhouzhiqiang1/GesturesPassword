//
//  ModifyGesturesViewController.m
//  GesturesPasswordDemo
//
//  Created by R_zhou on 2018/9/28.
//  Copyright © 2018年 R_zhou. All rights reserved.
//

#import "ModifyGesturesViewController.h"
#import "SetGestureViewController.h"
#import "NSString+MD5.h"



#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth  [UIScreen mainScreen].bounds.size.width

@interface ModifyGesturesViewController ()
{
    BOOL errorMessage;
    NSInteger maxCount;
    
}
@end

@implementation ModifyGesturesViewController

#pragma mark - 控制器生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

    maxCount = 5;
    //设置头像位圆形
    self.iconImageV.layer.cornerRadius=self.iconImageV.bounds.size.height/2;
    self.iconImageV.layer.borderColor=[UIColor whiteColor].CGColor;
    self.iconImageV.layer.borderWidth=1;
    self.iconImageV.layer.masksToBounds=YES;
    
    self.nameLabel.text = @"昵称";
    [self createLockPoints];
    CGRect frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    UIImageView *bgIV = [[UIImageView alloc] initWithFrame:frame];
    [bgIV setImage:[UIImage imageNamed:@"beijing.png"]];
    [self.view insertSubview:bgIV atIndex:0];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIButton *navItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [navItem setTitle:@"返回" forState:UIControlStateNormal];
    [navItem addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    navItem.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    navItem.frame = CGRectMake(0, 0, 14, 27);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navItem];

    //单页面
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"beijing_back.png"]forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - 点击事件
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch) {
        for (UIButton *btn in self.buttonArray) {
            CGPoint touchPoint = [touch locationInView:btn];
            if ([btn pointInside:touchPoint withEvent:nil]) {
                self.lineStartPoint = btn.center;
                self.drawFlag = YES;
                
                if (!self.selectedButtons) {
                    self.selectedButtons = [NSMutableArray arrayWithCapacity:9];
                }
                [self.selectedButtons addObject:btn];
                [btn setBackgroundImage:self.selectedImage forState:UIControlStateNormal];
            }
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch && self.drawFlag) {
        self.lineEndPoint = [touch locationInView:self.imageView];
        
        for (UIButton *btn in self.buttonArray) {
            CGPoint touchPoint = [touch locationInView:btn];
            
            if ([btn pointInside:touchPoint withEvent:nil]) {
                BOOL btnContained = NO;
                
                for (UIButton *selectedBtn in self.selectedButtons) {
                    if (btn == selectedBtn) {
                        btnContained = YES;
                        break;
                    }
                }
                
                if (!btnContained) {
                    [self.selectedButtons addObject:btn];
                    [btn setBackgroundImage:self.selectedImage forState:UIControlStateNormal];
                }
            }
        }
        
        self.imageView.image = [self drawUnlockLine];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self outputSelectedButtons];
    self.drawFlag = NO;
    self.selectedButtons = nil;
    
}

- (void)back
{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - 添加UI
- (void)createLockPoints
{
    self.pointImage = [UIImage imageNamed:@"point.png"];
    self.selectedImage = [UIImage imageNamed:@"selected.png"];
    
    CGFloat width = 65;
    
    CGFloat jiange = (ScreenWidth - width * 3) / 4.0;
    
    float y;
    for (int i = 0; i < 3; ++i) {
        y = i * (ScreenWidth - width) * 1/3.0 + jiange;
        float x = jiange;
        for (int j = 0; j < 3; ++j) {
            //            x = 30 +j * (ScreenWidth-140)* 1/2.0 ;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setBackgroundImage:self.pointImage forState:UIControlStateNormal];
            [btn setBackgroundImage:self.selectedImage forState:UIControlStateHighlighted];
            [btn setFrame:CGRectMake(x, y, width, width)];
            btn.layer.cornerRadius = btn.frame.size.width / 2.0;
            btn.layer.masksToBounds = YES;
            [self.imageView addSubview:btn];
            
            btn.userInteractionEnabled = NO;
            btn.tag = 1 + i * 3 + j;
            
            if (!self.buttonArray) {
                self.buttonArray = [NSMutableArray arrayWithCapacity:9];
            }
            [self.buttonArray addObject:btn];
            x = x + width + jiange;
        }
    }
}


#pragma mark - 业务逻辑(划线)
- (UIImage *)drawUnlockLine
{
    UIImage *image = nil;
    
    UIColor *color = [UIColor whiteColor];
    CGFloat width = 1.5f;
    
    if (errorMessage) {
        color = [UIColor colorWithRed:255 green:54 blue:0 alpha:1];
    }
    
    CGSize imageContextSize = self.imageView.frame.size;
    
    UIGraphicsBeginImageContext(imageContextSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, width);
    CGContextSetStrokeColorWithColor(context, [color CGColor]);
    
    CGContextMoveToPoint(context, self.lineStartPoint.x, self.lineStartPoint.y);
    for (UIButton *selectedBtn in self.selectedButtons) {
        CGPoint btnCenter = selectedBtn.center;
        CGContextAddLineToPoint(context, btnCenter.x, btnCenter.y);
        CGContextMoveToPoint(context, btnCenter.x, btnCenter.y);
    }
    CGContextAddLineToPoint(context, self.lineEndPoint.x, self.lineEndPoint.y);
    
    CGContextStrokePath(context);
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    errorMessage = NO;
    return image;
}

#pragma mark - 验证结果
- (void)outputSelectedButtons
{
    NSMutableString *pwd = [NSMutableString string];
    for (UIButton *btn in self.selectedButtons) {
        [btn setBackgroundImage:self.pointImage forState:UIControlStateNormal];
        [pwd appendFormat:@"%ld",(long)btn.tag];
    }
    
    if (pwd.length) {
        if ([[pwd md5] isEqualToString:self.password]) {
            
            self.imageView.image = nil;
            [self poptoRootVC];
            
        }else{
            maxCount--;
            if (maxCount > 0) {
                self.showlbl.text = [NSString stringWithFormat:@"密码错误，还可以输入%ld次",(long)maxCount];
                self.showlbl.textColor = [UIColor redColor];
                self.gantaohaoImageView.image = [UIImage imageNamed:@"warning.png"];
                [self shakeView:self.showView duration:1];
                
                [self resetBtnImageWithError];
                
            }else{
                self.imageView.image = nil;
                self.showlbl.text = @"密码错误，还可以输入0次";
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"你已连续输错5次" message:@"需要重新登录" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    [self passwordInputErrorTooMuch];
                }];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }
    }
}


#pragma mark - 忘记密码的响应
- (IBAction)forgetGesAction:(UIButton *)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"忘记手势密码" message:@"需要重新登录" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self forgotPassword];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

//绘制错误时按钮的显示状态
- (void)resetBtnImageWithError{
    
    for (int i = 0; i < self.selectedButtons.count; i++) {
        UIButton *btn = self.selectedButtons[i];
        [btn setBackgroundImage:[UIImage imageNamed:@"cuowu_xuanzhong.png"] forState:UIControlStateNormal];
    }
    errorMessage = YES;
    self.imageView.image = [self drawUnlockLine];
    
    
    
    [self performSelector:@selector(afterShowError) withObject:self afterDelay:0.5];
    
}

//错误之后的显示
- (void)afterShowError{
    for (UIButton *btn in self.buttonArray) {
        [btn setBackgroundImage:self.pointImage forState:UIControlStateNormal];
    }
    self.imageView.image = nil;
}


#pragma mark ---- 忘记密码
- (void)forgotPassword
{
    NSLog(@"忘记密码");
}

#pragma mark ---- 密码输入次数过多
- (void)passwordInputErrorTooMuch
{
    NSLog(@"密码输入次数过多");
}

-(void)poptoRootVC
{
    SetGestureViewController * gesVC = [[SetGestureViewController alloc] init];
    [self.navigationController pushViewController:gesVC animated:YES];
}

#pragma mark - 动画效果
- (void)shakeView:(UIView *)viewToShake duration:(CGFloat)fDuration
{
    
    //左右抖动
    CGFloat t =2.0;
    CGAffineTransform translateRight  =CGAffineTransformTranslate(CGAffineTransformIdentity, t,0.0);
    CGAffineTransform translateLeft =CGAffineTransformTranslate(CGAffineTransformIdentity,-t,0.0);
    
    viewToShake.transform = translateLeft;
    
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:2.0];
        viewToShake.transform = translateRight;
    } completion:^(BOOL finished){
        if(finished){
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                viewToShake.transform =CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
}

@end
