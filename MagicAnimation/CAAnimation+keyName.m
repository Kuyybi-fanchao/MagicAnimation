//
//  CAAnimation+keyName.m
//  MagicAnimation
//
//  Created by 九尾 on 2018/6/16.
//  Copyright © 2018年 九尾. All rights reserved.
//

#import "CAAnimation+keyName.h"
#import <objc/runtime.h>

static const void *layerKey1 = &layerKey1;
static const void *nameKey1 = &nameKey1;

@implementation CAAnimation (keyName)

- (void)setAnimationKey:(NSString *)animationKey {
    objc_setAssociatedObject(self, nameKey1, animationKey, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)animationKey {
    return objc_getAssociatedObject(self, nameKey1);
}

- (void)setCurrentLayer:(CALayer *)currentLayer {
    objc_setAssociatedObject(self, layerKey1, currentLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CALayer *)currentLayer {
    return objc_getAssociatedObject(self, layerKey1);
}

@end
