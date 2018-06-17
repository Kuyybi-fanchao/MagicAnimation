//
//  MagicOneViewController.m
//  MagicAnimation
//
//  Created by 九尾 on 2018/6/16.
//  Copyright © 2018年 九尾. All rights reserved.
//

#import "MagicOneViewController.h"

#import <Masonry/Masonry.h>
#import <ChameleonFramework/Chameleon.h>

#import "CAAnimation+keyName.h"

#define kBigCircleRadius 150
#define kSmallCircleRadius 130

@interface MagicOneViewController ()<CAAnimationDelegate>

@property(nonatomic,strong)CAShapeLayer *circleOne;
@property(nonatomic,strong)CAShapeLayer *circleTwo;
//正三角形数据
@property(nonatomic,strong)NSMutableArray *upTrigonPointData;
//倒三角形数据
@property(nonatomic,strong)NSMutableArray *downTrigonPointData;

//正三角形线条数组
@property(nonatomic,strong)NSMutableArray *upLineData;
//倒三角形数组
@property(nonatomic,strong)NSMutableArray *downLineData;

//按照执行顺序添加的line数组
@property(nonatomic,strong)NSMutableArray *allArr;

@property(nonatomic,assign)BOOL isSecond;
@property(nonatomic,assign)bool isLast;

@property(nonatomic,strong)CABasicAnimation *normalAnim;

@end

@implementation MagicOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIButton *start = [UIButton buttonWithType:UIButtonTypeCustom];
    [start setTitle:@"开始" forState:UIControlStateNormal];
    [start setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    start.titleLabel.font = [UIFont systemFontOfSize:14.f];
    start.backgroundColor = [UIColor flatGreenColor];
    [start addTarget:self action:@selector(startAnim:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:start];
    [start mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(-50);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(80);
    }];
    
    [self addSubviews];
    [self addPointData];
    [self addSublayers];
    
    // Do any additional setup after loading the view.
}

- (void)addSubviews {
    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
//    view.center = CGPointMake(self.view.center.x, self.view.center.y-20);
//    view.backgroundColor = [UIColor flatRedColor];
//    [self.view addSubview:view];
    
    UIBezierPath *bezier1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.view.center.x, self.view.center.y-20) radius:kBigCircleRadius startAngle:-M_PI_2 endAngle:-M_PI_2-M_PI*2 clockwise:NO];
    
    UIBezierPath *bezier2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.view.center.x, self.view.center.y-20) radius:kSmallCircleRadius startAngle:M_PI_2+M_PI_4 endAngle:M_PI_2+M_PI_4-2*M_PI clockwise:NO];
    
    self.circleOne = [CAShapeLayer layer];
    self.circleOne.path = bezier1.CGPath;
    self.circleOne.strokeColor = [UIColor flatBlueColor].CGColor;
//    self.circleOne.strokeEnd = 1.0;
    self.circleOne.lineWidth = 4.f;
    self.circleOne.lineCap = kCALineCapButt;
    self.circleOne.fillColor = [UIColor clearColor].CGColor;
    [self.view.layer addSublayer:self.circleOne];
    
    self.circleTwo = [CAShapeLayer layer];
    self.circleTwo.path = bezier2.CGPath;
    self.circleTwo.strokeColor = [UIColor flatGreenColor].CGColor;
//    self.circleTwo.strokeEnd = 0.0;
    self.circleTwo.lineWidth = 4.f;
    self.circleTwo.fillColor = [UIColor clearColor].CGColor;
    self.circleTwo.lineCap = kCALineCapRound;
    [self.view.layer addSublayer:self.circleTwo];
    
}

- (void)addPointData {
    CGPoint circleCenter = CGPointMake(self.view.center.x, self.view.center.y-20);
    //添加正三角形所有用到的点
    CGPoint topPoint = CGPointMake(circleCenter.x, circleCenter.y-kSmallCircleRadius);
    CGPoint bottomleftPoint = CGPointMake(circleCenter.x-kSmallCircleRadius*cos(M_PI/6), circleCenter.y+kSmallCircleRadius*sin(M_PI/6));
    CGPoint bottomRightPoint = CGPointMake(circleCenter.x+kSmallCircleRadius*cos(M_PI/6), circleCenter.y+kSmallCircleRadius*sin(M_PI/6));
    
    self.upTrigonPointData = [[NSMutableArray alloc] init];
    [self.upTrigonPointData addObject:[NSValue valueWithCGPoint:topPoint]];
    [self.upTrigonPointData addObject:[NSValue valueWithCGPoint:bottomleftPoint]];
    [self.upTrigonPointData addObject:[NSValue valueWithCGPoint:bottomRightPoint]];
    
    //添加倒三角形的数据
    CGPoint bottomPoint = CGPointMake(circleCenter.x, circleCenter.y+kSmallCircleRadius);
    CGPoint topLeftPoint = CGPointMake(circleCenter.x-kSmallCircleRadius*cos(M_PI/6), circleCenter.y-kSmallCircleRadius*sin(M_PI/6));
    CGPoint topRightPoint = CGPointMake(circleCenter.x+kSmallCircleRadius*cos(M_PI/6), circleCenter.y-kSmallCircleRadius*sin(M_PI/6));
    
    self.downTrigonPointData = [[NSMutableArray alloc] init];
    [self.downTrigonPointData addObject:[NSValue valueWithCGPoint:bottomPoint]];
    [self.downTrigonPointData addObject:[NSValue valueWithCGPoint:topLeftPoint]];
    [self.downTrigonPointData addObject:[NSValue valueWithCGPoint:topRightPoint]];
    
    
}

- (void)addSublayers {
    
    self.upLineData = [[NSMutableArray alloc] init];
    self.downLineData = [[NSMutableArray alloc] init];
    self.allArr = [[NSMutableArray alloc] init];
    
    //添加正三角形
    CAShapeLayer *layer1 = [self addSublayerWithData:self.upTrigonPointData[0] twoData:self.upTrigonPointData[1]];
    CAShapeLayer *layer2 = [self addSublayerWithData:self.upTrigonPointData[1] twoData:self.upTrigonPointData[2]];
    CAShapeLayer *layer3 = [self addSublayerWithData:self.upTrigonPointData[2] twoData:self.upTrigonPointData[0]];
    [self.upLineData addObject:layer1];
    [self.upLineData addObject:layer2];
    [self.upLineData addObject:layer3];
    
    //添加倒三角形
    CAShapeLayer *downLayer1 = [self addSublayerWithData:self.downTrigonPointData[2] twoData:self.downTrigonPointData[1]];
    CAShapeLayer *downLayer2 = [self addSublayerWithData:self.downTrigonPointData[1] twoData:self.downTrigonPointData[0]];
    CAShapeLayer *downLayer3 = [self addSublayerWithData:self.downTrigonPointData[0] twoData:self.downTrigonPointData[2]];
    [self.downLineData addObject:downLayer1];
    [self.downLineData addObject:downLayer2];
    [self.downLineData addObject:downLayer3];
    
    //按照动画的执行顺序添加
    [self.allArr addObject:downLayer1];
    [self.allArr addObject:downLayer3];
    [self.allArr addObject:layer1];
    [self.allArr addObject:downLayer2];
    [self.allArr addObject:layer3];
    [self.allArr addObject:layer2];
    
}

- (CAShapeLayer *)addSublayerWithData:(NSValue *)oneData twoData:(NSValue *)twoData{
    CGPoint point1 = [oneData CGPointValue];
    CGPoint point2 = [twoData CGPointValue];
    
    UIBezierPath *bezier = [UIBezierPath bezierPath];
    [bezier moveToPoint:point1];
    [bezier addLineToPoint:point2];
    
    
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.lineWidth = 2;
    shape.strokeColor = [UIColor randomFlatColor].CGColor;
    shape.path = bezier.CGPath;
    shape.strokeEnd = 0.0;
    shape.opacity = 0.0;
    [self.view.layer addSublayer:shape];
    return shape;
    
}

- (void)startAnim:(UIButton *)sender{
    
    CABasicAnimation *strokeAnim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeAnim.fromValue = @(0.0);
    strokeAnim.toValue = @(1.0);
//    strokeAnim.repeatCount = 10;
    strokeAnim.delegate = self;
    strokeAnim.duration = 3.f;
    strokeAnim.removedOnCompletion = NO;
    strokeAnim.animationKey = @"strokeAnim";
    [strokeAnim setValue:@"strokeAnim" forKey:@"animationType"];
    [self.circleOne addAnimation:strokeAnim forKey:@"ciecleOneAnim"];
    [self.circleTwo addAnimation:strokeAnim forKey:@"ciecleTwoAnim"];
    self.normalAnim = strokeAnim;
    
    
    NSLog(@"解惑一下:%@",strokeAnim.animationKey);
    
}


- (void)showAndDismissAnimWithLayer:(CAShapeLayer *)layer {
    
    CABasicAnimation *strokeBase = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeBase.fromValue = @(0.0);
    strokeBase.toValue = @(1.0);
    //    strokeAnim.repeatCount = 10;
    strokeBase.delegate = self;
    strokeBase.duration = 0.2f;
//    strokeBase.beginTime = CACurrentMediaTime();
    strokeBase.animationKey = @"strokeBase";
    strokeBase.currentLayer = layer;
    strokeBase.removedOnCompletion = NO;
    [strokeBase setValue:@"strokeBase" forKey:@"animationType"];
    [layer addAnimation:strokeBase forKey:@"strokeBase"];
    
    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnim.beginTime = CACurrentMediaTime() + 0.2;
    opacityAnim.fromValue = @(1.0);
    opacityAnim.toValue = @(0.0);
    opacityAnim.duration = 0.3;
    opacityAnim.delegate = self;
    opacityAnim.animationKey = @"opacityAnim";
    opacityAnim.currentLayer = layer;
    opacityAnim.removedOnCompletion = NO;
    [opacityAnim setValue:@"opacityAnim" forKey:@"animationType"];
    [layer addAnimation:opacityAnim forKey:@"opacityAnim"];
    
}

- (void)showAnimWithLayer:(CAShapeLayer *)layer {
    CABasicAnimation *strokeBase1 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeBase1.fromValue = @(0.0);
    strokeBase1.toValue = @(1.0);
    //    strokeAnim.repeatCount = 10;
    strokeBase1.delegate = self;
    strokeBase1.duration = 0.2f;
    strokeBase1.animationKey = @"strokeBase1";
//    strokeBase1.beginTime = CACurrentMediaTime();
    strokeBase1.currentLayer = layer;
    strokeBase1.removedOnCompletion = NO;
    [strokeBase1 setValue:@"strokeBase1" forKey:@"animationType"];
    [strokeBase1 setValue:layer forKey:@"animLayer"];
    [layer addAnimation:strokeBase1 forKey:@"strokeLast"];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSLog(@"animationKey是:%@",anim.animationKey);
    CABasicAnimation *ba = (CABasicAnimation *)anim;
    NSString *type = [ba valueForKey:@"animationType"];
    
    //最后显示,通过==来判断两个动画是否是一直的,这样不行,因为两个动画的地址不一样
//    if (anim == self.normalAnim) {
//        NSLog(@"相等的");
//    }
    if ([type isEqualToString:@"strokeAnim"]) {
        
        self.circleOne.strokeEnd = 1.0;
        self.circleTwo.strokeEnd = 1.0;
        
        //添加新的动画
//        if (self.isSecond == NO) {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                for (int i = 0; i<self.allArr.count; i++) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((i*0.5) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        CAShapeLayer *layer = self.allArr[i];
                        layer.strokeEnd = 1.0;
                        [self showAndDismissAnimWithLayer:self.allArr[i]];
                        
                        if (i == 5) {
                            self.isSecond = YES;
                        }
                    });
                }
            });
            
           
//        }
        
        
    }else if ([type isEqualToString:@"strokeBase"]){
        
    }else if ([type isEqualToString:@"opacityAnim"]){
        if (self.isSecond) {
//            if (!self.isLast) {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                for (int i = 0; i<self.allArr.count; i++) {

                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((i*0.2) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        CAShapeLayer *shape = self.allArr[i];
                        shape.opacity = 1.0;
                        [self showAnimWithLayer:self.allArr[i]];
                        if (i==5) {
                            self.isLast = YES;
                        }
                    });
                }
            });

//            }
        }
        
    }else if ([type isEqualToString:@"strokeBase1"]){
        if (self.isLast) {
            for (int i = 0; i<self.allArr.count; i++) {
                CAShapeLayer *shaper = [self.allArr objectAtIndex:i];
                shaper.strokeEnd = 1.0;
                shaper.opacity = 1.0;
            }
            
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
