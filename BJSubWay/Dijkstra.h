//
//  Dijkstra.h
//  BJSubWay
//
//  Created by xwmedia01 on 2017/3/27.
//  Copyright © 2017年 xwmedia01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dijkstra : NSObject


/**
 *    1  2  3  4
 *    ￣￣￣￣￣￣
 *  1| 0 0  ∞ 0
 *  2| 0 0  0 0
 *  3| 0 ∞  0 0
 *  4| 0 0  0 0
 */
- (void)configEdagesData:(NSArray *)edagesData;

- (float)shortestPath:(NSString *)source target:(NSString *)target;

- (NSString *)searchPath:(NSString *)source target:(NSString *)target;

@end
