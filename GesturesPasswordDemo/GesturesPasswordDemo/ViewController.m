//
//  ViewController.m
//  GesturesPasswordDemo
//
//  Created by R_zhou on 2018/9/27.
//  Copyright © 2018年 R_zhou. All rights reserved.
//

#import "ViewController.h"
#import "SetGestureViewController.h"
#import "ModifyGesturesViewController.h"
#import "CoreArchive.h"

@interface ViewController ()

@property (strong, nonatomic) UILabel *passwordLabel;
@property (strong, nonatomic) UILabel *password;

@property (strong, nonatomic) UIButton *btn3;
@property (strong, nonatomic) UIButton *btn4;


@property (strong, nonatomic) ModifyGesturesViewController *modifyGesturesVC;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //导航栏覆盖问题
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(30, 50, 300, 90)];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"手势密码" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClickAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(30, 160, 300, 50)];
    btn2.backgroundColor = [UIColor redColor];
    [btn2 setTitle:@"设置/修改手势密码后点击显示密码" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btn2ClickAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    //密码
    self.passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 220, 300, 50)];
    self.passwordLabel.hidden = YES;
    self.passwordLabel.text = @"MD5加密 密码：";
    [self.view addSubview:self.passwordLabel];
    
    self.password = [[UILabel alloc] initWithFrame:CGRectMake(30, 250, 300, 70)];
    self.password.numberOfLines = 2;
    [self.view addSubview:self.password];
    
    
    self.btn3 = [[UIButton alloc] initWithFrame:CGRectMake(30, 350, 300, 90)];
    self.btn3.hidden = YES;
    self.btn3.backgroundColor = [UIColor redColor];
    [self.btn3 setTitle:@"修改手势密码" forState:UIControlStateNormal];
    [self.btn3 addTarget:self action:@selector(btn3ClickAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn3];
    
    
    self.btn4 = [[UIButton alloc] initWithFrame:CGRectMake(30, 460, 300, 50)];
    self.btn4.hidden = YES;
    self.btn4.backgroundColor = [UIColor redColor];
    [self.btn4 setTitle:@"清空密码" forState:UIControlStateNormal];
    [self.btn4 addTarget:self action:@selector(btn4ClickAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn4];
}

/**
 * btn 点击事件
 */
- (void)btnClickAction
{
    SetGestureViewController *setGestureVC = [[SetGestureViewController alloc] init];
    [self.navigationController pushViewController:setGestureVC animated:YES];
}

- (void)btn2ClickAction
{
    NSString *password = [CoreArchive strForKey:@"password"];
    if (password.length > 0) {
        self.passwordLabel.hidden = NO;
        self.btn3.hidden = NO;
        self.btn4.hidden = NO;
        self.password.text = password;
    } else {

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请先设置手势密码" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消Cancel");
        }];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"默认Default" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"默认Default");
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:defaultAction];
        
        //弹出视图 使用UIViewController的方法
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}

- (void)btn3ClickAction
{
    self.modifyGesturesVC = [[ModifyGesturesViewController alloc] init];
    self.modifyGesturesVC.password = self.password.text;
    
    [self.navigationController pushViewController:self.modifyGesturesVC animated:YES];
}

- (void)btn4ClickAction
{
    self.passwordLabel.hidden = YES;
    self.password.hidden = YES;
    self.btn3.hidden = YES;
    self.btn4.hidden = YES;
    [CoreArchive removeStrForKey:@"password"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
