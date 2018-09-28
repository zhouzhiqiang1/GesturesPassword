//
//  CoreArchive.h
//  GesturesPasswordDemo
//
//  Created by R_zhou on 2018/9/28.
//  Copyright © 2018年 R_zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreArchive : NSObject
/**
 *  保存
 */
+(void)setStr:(NSString *)str key:(NSString *)key;

/**
 *  读取
 */
+(NSString *)strForKey:(NSString *)key;

/**
 *  删除
 */
+(void)removeStrForKey:(NSString *)key;
@end
