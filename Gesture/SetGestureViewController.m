//
//  SetGestureViewController.m
//  GesturesPasswordDemo
//
//  Created by R_zhou on 2018/9/27.
//  Copyright © 2018年 R_zhou. All rights reserved.
//

#import "SetGestureViewController.h"
#import "NSString+MD5.h"
#import "CoreArchive.h"
#import "ViewController.h"


#define ScreenWidth  [UIScreen mainScreen].bounds.size.width

@interface SetGestureViewController ()
{
    NSString *gesturePwd;
    
    BOOL errorMessage;
}

/** 头部视图 **/
@property (weak, nonatomic) IBOutlet UIView *smallGestureView;

/** 没选中时图片 **/
@property (nonatomic, strong) UIImage *pointImage;
/** 选中时图片 **/
@property (nonatomic, strong) UIImage *selectedImage;

/** 下方 button 个数 **/
@property (nonatomic, strong) NSMutableArray *buttonArray;
/** 下方 button 选中个数 **/
@property (nonatomic, strong) NSMutableArray *selectedButtons;

/** 下方 button 是否选中 **/
@property (nonatomic, assign) BOOL drawFlag;

/** 起点线 **/
@property (nonatomic, assign) CGPoint lineStartPoint;
/** 终点线 **/
@property (nonatomic, assign) CGPoint lineEndPoint;

@end

@implementation SetGestureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //导航栏覆盖view问题
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //在小手势视图的布局
    [self addSmallGestureViewButton];
    
    //布局大的解锁视图
    [self createLockPoints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    //单页面
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];

    UIButton *navItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [navItem setTitle:@"返回" forState:UIControlStateNormal];
    [navItem addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
 
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navItem];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"beijing_back.png"]forBarMetrics:UIBarMetricsDefault];
}

- (void)back
{
    [self popbackview];
}

-(void)popbackview
{
    for (UIViewController * vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[ViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 添加UI
//在小手势视图的布局
-(void)addSmallGestureViewButton{
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat btnWH = 30;
    int cloumn = 3;
    CGFloat margin = (self.smallGestureView.bounds.size.width - (cloumn * btnWH)) / (cloumn + 1);
    int curCloumn = 0;
    int curRow = 0;
    
    for(int i = 0; i < 9; i++){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.userInteractionEnabled = NO;
        btn.tag = i + 1;
        //正常状态图片
        [btn setBackgroundImage:[UIImage imageNamed:@"shangfang_icon.png"] forState:UIControlStateNormal];
        
        [self.smallGestureView addSubview:btn];
        curCloumn = i % cloumn;
        curRow =  i / cloumn;
        
        x = margin + (btnWH + margin) *curCloumn;
        y = (btnWH + margin) * curRow;
        
        //设置每一个按钮的尺寸
        btn.frame = CGRectMake(x, y, btnWH, btnWH);
    }
}

//布局大的解锁视图
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
    [self smallGestureViewButtonHightLight];
    self.drawFlag = NO;
    self.selectedButtons = nil;
    
    //    [self smallGestureViewButtonHightLight];
}


#pragma mark - 自定义方法
//绘出手势路线
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

/**
 * 绘制完手势后的小视图高亮按钮
 */
-(void)smallGestureViewButtonHightLight{
    for (UIButton *smallGestureViewBtn in self.smallGestureView.subviews) {
        [smallGestureViewBtn setBackgroundImage:[UIImage imageNamed:@"shangfang_point.png"] forState:UIControlStateNormal];
    }
    
    for (int i = 0; i < self.selectedButtons.count; i++) {
        UIButton *selectBtn = self.selectedButtons[i];
        UIButton *smallGestureViewBtn = [self.smallGestureView viewWithTag:selectBtn.tag];
        //选中状态图片
        [smallGestureViewBtn setBackgroundImage:[UIImage imageNamed:@"shangfang_selected.png"] forState:UIControlStateNormal];
    }
    
}

#pragma mark - 业务逻辑的处理
- (void)outputSelectedButtons
{
    NSMutableString *pwd = [NSMutableString string];
    for (UIButton *btn in self.selectedButtons) {
        [btn setBackgroundImage:self.pointImage forState:UIControlStateNormal];
        [pwd appendFormat:@"%ld",(long)btn.tag];
    }
    
    
    if (pwd.length) {
        if (pwd.length<4) {
            if (!gesturePwd) {
                self.notifyLabel.text = @"至少连接4个点，请重新绘制";
                [self resetBtnImageWithError];
            }else{
                self.notifyLabel.text = @"与上次绘制不一致，请重新绘制";
                [self resetBtnImageWithError];
            }
            self.notifyLabel.textColor = [UIColor redColor];
            self.tanHaoImageView.image = [UIImage imageNamed:@"warning.png"];
            [self shakeView:self.notifyView duration:1];
            
            
        }else{
            if (!gesturePwd) {
                gesturePwd = pwd;
                self.notifyLabel.textColor = [UIColor whiteColor];
                self.tanHaoImageView.image = [UIImage imageNamed:@"gantanhao.png"];
                self.notifyLabel.text = @"再次绘制解锁图案";
                self.imageView.image = nil;
            }else{
                if (![pwd isEqualToString:gesturePwd]) {
                    self.notifyLabel.textColor = [UIColor redColor];
                    self.notifyLabel.text = @"与上次绘制不一致，请重新绘制";
                    self.tanHaoImageView.image = [UIImage imageNamed:@"warning.png"];
                    
                    [self shakeView:self.notifyView duration:1];
                    
                    [self resetBtnImageWithError];
                    
                }else{

                    //密码储存
                    [CoreArchive setStr:[gesturePwd md5] key:@"password"];
                    
                    [self performSelector:@selector(popbackview) withObject:nil afterDelay:0.3];
                    
                    self.imageView.image = nil;
                }
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)afterShowError{
    for (UIButton *btn in self.buttonArray) {
        [btn setBackgroundImage:self.pointImage forState:UIControlStateNormal];
    }
    self.imageView.image = nil;
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
