//
//  Dijkstra.m
//  BJSubWay
//
//  Created by ",wmedia01 on 2017/3/27.
//  Copyright © 2017年 ",wmedia01. All rights reserved.
//

#import "Dijkstra.h"
#import "NSDictionary+Category.h"

int maxDistance = 999999;   //定义一个最大的距离数字，大概这么多就可以了

@interface Dijkstra()

@property (nonatomic, strong) NSMutableDictionary *graph;

@property (nonatomic, strong) NSMutableDictionary *dist;
@property (nonatomic, strong) NSMutableDictionary *prev;
@property (nonatomic, strong) NSMutableDictionary *visitied;



@end

@implementation Dijkstra

- (void)configEdagesData:(NSArray *)edagesData
{
    _graph = [NSMutableDictionary dictionary];
    
    [edagesData enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *source = obj[0];
        NSString *target = obj[1];
        NSString *weight = obj[2];
        if (![_graph valueForKey:source]) {
            [_graph setValue:@{} forKey:source];
        }
        if (![_graph valueForKey:target]) {
            [_graph setValue:@{} forKey:target];
        }
        
        [_graph f:source s:target r:weight]; // 字典二维矩阵 graph[source][target] = weight
        [_graph f:target s:source r:weight];
        
    }];
}

- (float)shortestPath:(NSString *)source target:(NSString *)target
{

    
    self.dist = [NSMutableDictionary dictionary];
    self.prev = [NSMutableDictionary dictionary];
    self.visitied = [NSMutableDictionary dictionary];

    
    NSInteger n = [_graph allKeys].count;
    NSArray *keyArray = [_graph allKeys];

    if (![keyArray containsObject:source]) {
        return 0;
    }
    if (![keyArray containsObject:target]) {
        return 0;
    }
    
    
    [keyArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {

        [self.dist setValue:@"999999" forKey:obj];

        _visitied[obj] = 0;
        NSString *distObj = self.dist[obj];
        if (distObj.intValue >= maxDistance) {
            self.prev[obj] = @"0";
        }else
        {
            self.prev[obj] = source;
        }
    }];
    
    self.dist[source] = @"0";

    for (int i=0; i<n; i++) {
        __block int minDist = maxDistance;   //初始化最小距离为最大值
        __block NSString *minV = source;   //
        
        [keyArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *objDist = self.dist[obj]; //起点到obj顶点的距离
            NSString *isObjVisitied = _visitied[obj]; //obj顶点访问状态
       
            if (isObjVisitied.intValue == 0) {  //判断obj顶点是否已经已经访问过
                if (minDist > objDist.intValue) {
                    minDist = objDist.intValue; //minDist 更新为最小数值
                    minV = obj;  //记录最小数值的顶点名称
                }
            }
        }];
        

        //如果最小数值名称等于终点，则循环结束
        if ([minV isEqualToString:target]) {
            
            [self searchPath:source target:target];
            
            NSString *rsMinDis = self.dist[target];
            return rsMinDis.floatValue;
        }
        
        _visitied[minV] = @"1";  //记录minV（当前邻接点）已访问过
        
        //更新
        NSDictionary *minV_Graph = _graph[minV]; //读取minV的所有可直达顶点
        NSArray *minV_Graph_KeyArray = [minV_Graph allKeys]; //读取minV的所有可直达顶点的名称
        
        [minV_Graph_KeyArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *minV_Graph_obj = minV_Graph[obj]; //minV的所有可直达顶点到minV的距离
            NSString *isObjVisitied = _visitied[obj]; //当前顶点是否已经访问过
        
            NSString *graph_obj_dist = _dist[obj]; //读取当前记录
            
            int newDistance = minDist+minV_Graph_obj.intValue;
        
            if (isObjVisitied.intValue == 0) {
                if (newDistance < graph_obj_dist.intValue) {
                    _dist[obj] = [NSString stringWithFormat:@"%i", newDistance];
                    _prev[obj] = minV;
                }
            }
            
        }];

    }

    return maxDistance;

}

- (NSString *)searchPath:(NSString *)source target:(NSString *)target
{
    NSMutableArray *searchPathArray = [[NSMutableArray alloc] init];
    [searchPathArray addObject:target];
    NSString *tmp = self.prev[target];
   
    while (![tmp isEqualToString:source]) {
        [searchPathArray addObject:tmp];
        tmp = self.prev[tmp];
    }
    [searchPathArray addObject:source];

    searchPathArray = [NSMutableArray arrayWithArray:[[searchPathArray reverseObjectEnumerator] allObjects]];
    NSString *searchPathStr = [searchPathArray componentsJoinedByString:@"->"];

    return searchPathStr;
    
}

@end

