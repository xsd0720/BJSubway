//
//  NSDictionary+Category.m
//  BJSubWay
//
//  Created by xwmedia01 on 2017/3/27.
//  Copyright © 2017年 xwmedia01. All rights reserved.
//

#import "NSDictionary+Category.h"

@implementation NSDictionary (Category)

- (void)f:(NSString *)f s:(NSString *)s r:(NSString *)r
{
    if (s && r) {
        NSMutableDictionary *mubDic = [NSMutableDictionary dictionaryWithDictionary:[self valueForKey:f]];
        [mubDic setValue:r forKey:s];
        [self setValue:mubDic forKey:f];
        
       
    }else
    {
       [self setValue:@{} forKey:f]; 
    }
    
}

@end
