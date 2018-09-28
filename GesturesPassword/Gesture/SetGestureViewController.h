//
//  SetGestureViewController.h
//  GesturesPasswordDemo
//
//  Created by R_zhou on 2018/9/27.
//  Copyright © 2018年 R_zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetGestureViewController : UIViewController

/** 文本编辑框 **/
@property (weak, nonatomic) IBOutlet UILabel *notifyLabel;
/** 文本编辑框底层View **/
@property (weak, nonatomic) IBOutlet UIView *notifyView;

/** 底部手势密码背景 **/
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

/** 文本编辑框icon **/
@property (weak, nonatomic) IBOutlet UIImageView *tanHaoImageView;

@end
