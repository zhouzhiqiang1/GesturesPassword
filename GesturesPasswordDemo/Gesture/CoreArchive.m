//
//  CoreArchive.m
//  GesturesPasswordDemo
//
//  Created by R_zhou on 2018/9/28.
//  Copyright © 2018年 R_zhou. All rights reserved.
//

#import "CoreArchive.h"

@implementation CoreArchive
+(void)setStr:(NSString *)str key:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:str forKey:key];
    [defaults synchronize];
}

+(NSString *)strForKey:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *str = (NSString *)[defaults objectForKey:key];
    return str;
}

+(void)removeStrForKey:(NSString *)key{
    [self setStr:nil key:key];
}
@end
