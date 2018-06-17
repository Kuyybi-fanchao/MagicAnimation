//
//  ListItem.m
//  CollectionViews
//
//  Created by 九尾 on 2017/7/3.
//  Copyright © 2017年 九尾. All rights reserved.
//

#import "ListItem.h"

@implementation ListItem
+ (instancetype)itemWithName:(NSString *)name object:(Class)object{
    ListItem *item = [[self alloc] init];
    item.title = name;
    item.subTitle = [NSString stringWithFormat:@"%@",object];
    item.itemClass = object;
    return item;
}

@end
