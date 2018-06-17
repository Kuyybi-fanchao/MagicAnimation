//
//  CAAnimation+keyName.h
//  MagicAnimation
//
//  Created by 九尾 on 2018/6/16.
//  Copyright © 2018年 九尾. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CAAnimation (keyName)

@property(nonatomic,copy)NSString *animationKey;
@property(nonatomic,strong)CALayer *currentLayer;

@end
