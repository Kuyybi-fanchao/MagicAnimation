//
//  ListItem.h
//  CollectionViews
//
//  Created by 九尾 on 2017/7/3.
//  Copyright © 2017年 九尾. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListItem : NSObject

@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *subTitle;
@property(nonatomic,strong)Class itemClass;

+ (instancetype)itemWithName:(NSString *)name object:(Class)object;

@end
