//
//  PieChartView.m
//  TakeNotes
//
//  Created by 航汇聚 on 2019/5/16.
//  Copyright © 2019 BellaZhou. All rights reserved.
//

#import "PieChartView.h"
@interface PieChartView ()
{
    NSArray *_scalesArray;
    NSArray *_colorsArray;
    NSArray *_colors;
    CGFloat _pieOutRadius;
    CGFloat _pieInRadius;
    CGPoint _centerPoint;
}
@property (weak, nonatomic) IBOutlet UILabel *outgoingsLable;

@end
@implementation PieChartView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        UIView *containerView = [[[UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil] instantiateWithOwner:self options:nil] firstObject];
        CGRect newframe = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newframe;
        [self addSubview:containerView];
        
        _scalesArray = @[@(.7), @(.15), @(.08),@(.07)];
        _colors = @[kColorWithRGB(48, 186, 216),kColorWithRGB(58, 97, 128),
                    kColorWithRGB(7, 68, 126),kColorWithRGB(237, 140, 166),
                    kColorWithRGB(44, 186, 216),kColorWithRGB(54, 97, 128),
                    kColorWithRGB(9, 68, 126),kColorWithRGB(243, 140, 166),
                    kColorWithRGB(48, 184, 216),kColorWithRGB(58, 104, 128),
                    kColorWithRGB(7, 76, 126),kColorWithRGB(237, 146, 166),
                    kColorWithRGB(48, 186, 212),kColorWithRGB(58, 97, 124),
                    kColorWithRGB(7, 68, 121),kColorWithRGB(237, 140, 160)];
        _colorsArray = _colors;
        _pieOutRadius = self.frame.size.width/2 - 40;
        _pieInRadius = 40;
        _centerPoint = CGPointMake(self.frame.size.width/2-20, self.frame.size.height/2);
        [self createPie];
    }
    return self;
}
#pragma mark - public
- (void)drawPieWithScaleArray:(nullable NSArray *)scaleArray colors:(nullable NSArray *)colors {
    if (scaleArray) {
        _scalesArray = scaleArray;
    }
    NSMutableArray *mutableColors = [@[] mutableCopy];
    for (int i = 0; i < scaleArray.count; i++) {
        [mutableColors addObject:_colors[i]];
    }
    if (colors) {
        [mutableColors removeAllObjects];
        [mutableColors addObject:[colors firstObject]];
    }
    _colorsArray = mutableColors;
    [self createPie];
}
#pragma mark - private
/*
 UIBezierPath ：画贝塞尔曲线的path类
 UIBezierPath定义 ： 贝赛尔曲线的每一个顶点都有两个控制点，用于控制在该顶点两侧的曲线的弧度。
 曲线的定义有四个点：起始点、终止点（也称锚点）以及两个相互分离的中间点。
 滑动两个中间点，贝塞尔曲线的形状会发生变化。
 UIBezierPath：对象是CGPathRef数据类型的封装，可以方便的让我们画出矩形 、 椭圆 或者 直线和曲线的组合形状.
*/
- (void)createPie {
    NSMutableArray *array = [self.layer.sublayers mutableCopy];
    for (CALayer *layer in array) {
        if ([layer isKindOfClass:[CAShapeLayer class]]) {
            [layer removeFromSuperlayer];
        }
    }
    CGFloat startAngle = 0;
    for (int index = 0; index < _scalesArray.count; index++) {
        CAShapeLayer *layer = [self createSameCenterCicleByRadius:_pieOutRadius fillColor:_colorsArray[index] startAngle:startAngle endAngle:startAngle + 2*M_PI*([_scalesArray[index] floatValue])];
        startAngle += 2*M_PI*([_scalesArray[index] floatValue]);
        [self.layer insertSublayer:layer atIndex:0];
    }
    CAShapeLayer *layer = [self createSameCenterCicleByRadius:_pieInRadius fillColor:[UIColor whiteColor] startAngle:0 endAngle:2*M_PI];
    [self.layer insertSublayer:layer atIndex:(int)(self.layer.sublayers.count-1)];
}

- (CAShapeLayer *)createSameCenterCicleByRadius:(CGFloat)radius
                            fillColor:(UIColor *)fillColor
                           startAngle:(CGFloat)startAngle
                             endAngle:(CGFloat)endAngle {
    //大圆
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:_centerPoint];
    [bezierPath addArcWithCenter:_centerPoint radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    [bezierPath closePath];
    
    // 渲染
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineWidth = 1;
    // 填充色
    shapeLayer.fillColor = fillColor.CGColor;
    shapeLayer.path = bezierPath.CGPath;
    return shapeLayer;
}

@end
