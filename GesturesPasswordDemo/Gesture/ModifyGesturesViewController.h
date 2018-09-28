//
//  ModifyGesturesViewController.h
//  GesturesPasswordDemo
//
//  Created by R_zhou on 2018/9/28.
//  Copyright © 2018年 R_zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyGesturesViewController : UIViewController

/** 页面传值 **/
@property (strong, nonatomic) NSString *password;

/**<#Description#>*/
@property (nonatomic, assign)int selectedIndex;

@property (nonatomic, assign) CGPoint lineStartPoint;
@property (nonatomic, assign) CGPoint lineEndPoint;

@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) NSMutableArray *selectedButtons;

@property (nonatomic, assign) BOOL drawFlag;
@property (nonatomic, strong) UIImage *pointImage;
@property (nonatomic, strong) UIImage *selectedImage;
/**
 *绘制结果显示label
 */

@property (weak, nonatomic) IBOutlet UILabel *showlbl;
/**
 *下面的手势image
 */

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/**
 *用户头像
 */

@property IBOutlet UIImageView *iconImageV;
/**
 *名字
 */

@property IBOutlet UILabel *nameLabel;

/**
 *忘记密码按钮
 */
@property IBOutlet UIButton *forgetBtn;
/**
 *展示提示信息
 */
@property (weak, nonatomic) IBOutlet UIView *showView;
/**感叹号*/
@property (weak, nonatomic) IBOutlet UIImageView *gantaohaoImageView;

@property (assign, nonatomic) BOOL isPopMyVc;






/**来源控制器  控制器*/
@property (nonatomic, weak)UIViewController * sourceVC;
@end
