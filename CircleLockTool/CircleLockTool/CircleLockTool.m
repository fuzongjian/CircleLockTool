//
//  CircleLockTool.m
//  FZJDemo
//
//  Created by 陈舒澳 on 16/4/18.
//  Copyright © 2016年 FZJ.com. All rights reserved.
//

#import "CircleLockTool.h"
@interface CircleLockTool ()
@property (nonatomic, strong) CAShapeLayer *strokeLayer;
@property (nonatomic, strong) CAShapeLayer *circleLayer;
//背景图片
@property (nonatomic, strong) UIImageView *imageView;
@property(nonatomic,assign)BOOL  lockstate;//锁的状态
@end
@implementation CircleLockTool
#pragma mark --- 初始化
-(instancetype)initWithCenter:(CGPoint)center Radius:(CGFloat)radius AnimationDuration:(CGFloat)duration Lock:(UIImage *)lockImage Unlock:(UIImage *)unlockImage RingColor:(UIColor *)ringColor StrokeColor:(UIColor *)strokecolor StrokeWith:(CGFloat)strokeWidth{
    if (self = [super initWithFrame:CGRectMake(center.x - radius, center.y - radius, radius, radius)]) {
        self.layer.cornerRadius = radius;
        self.radius = radius;
        self.duration = duration;
        self.lockedImage = lockImage;
        self.unlockedImage = unlockImage;
        self.ringColor = ringColor;
        self.strokeColor = strokecolor;
        self.strokeWidth = strokeWidth;
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, radius * 2, radius * 2)];
        self.imageView.userInteractionEnabled = YES;
        self.imageView.image = self.unlockedImage;
        self.imageView.layer.cornerRadius = radius;
        self.imageView.layer.masksToBounds = YES;
        [self addSubview:self.imageView];
    }
    return self;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.lockstate) {
        [self circleLockToolUnLockAnimation];
    }else{
        [self circleLockToolLockAnimation];
    }
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self circleLockToolCancelAnimation];
}
#pragma mark --- 初始化layer
-(void)configCircleLockToolUILayer{
    [UIView animateWithDuration:.5 animations:^{
        self.imageView.alpha = 0.0;
    }];
   
    
    self.circleLayer = [CAShapeLayer layer];
    [self.circleLayer setPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.radius * 2, self.radius * 2) cornerRadius:self.radius] CGPath]];
    self.circleLayer.fillColor = [[UIColor clearColor] CGColor];
    self.circleLayer.strokeColor = [self.ringColor CGColor];
    self.circleLayer.lineWidth = self.strokeWidth;
    [self.layer addSublayer:self.circleLayer];
    
    self.strokeLayer = [CAShapeLayer layer];
    [self.strokeLayer setPath: self.circleLayer.path];
    self.strokeLayer.fillColor = [[UIColor clearColor] CGColor];
    self.strokeLayer.strokeColor = [self.strokeColor CGColor];
    self.strokeLayer.lineWidth = self.strokeWidth;
    self.strokeLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:self.strokeLayer];
}
#pragma mark --- 上锁的动作
-(void)circleLockToolLockAnimation{
    [self configCircleLockToolUILayer];
    CABasicAnimation * strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeAnimation.delegate = self;
    strokeAnimation.duration = self.duration;
    strokeAnimation.repeatCount = 1;
    strokeAnimation.fromValue = @0;
    strokeAnimation.toValue = @1;
    [self.strokeLayer addAnimation:strokeAnimation forKey:@"circleLockToolLockAnimation"];
}
#pragma mark --- 解锁的动作
-(void)circleLockToolUnLockAnimation{
    [self configCircleLockToolUILayer];
    CABasicAnimation * strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeAnimation.delegate = self;
    strokeAnimation.duration = self.duration;
    strokeAnimation.repeatCount = 1;
    strokeAnimation.fromValue = @1;
    strokeAnimation.toValue = @0;
    [self.strokeLayer addAnimation:strokeAnimation forKey:@"circleLockToolUnLockAnimation"];
}
#pragma mark --- 动画取消
-(void)circleLockToolCancelAnimation{
    [self.circleLayer removeFromSuperlayer];
    [self.strokeLayer removeFromSuperlayer];
    [UIView animateWithDuration:.5 animations:^{
        self.imageView.alpha = 1.0;
    }];
    if (self.lockstate) {
        self.imageView.image = self.lockedImage;
    }else{
        self.imageView.image = self.unlockedImage;
    }
}
#pragma mark --- 动画完成
-(void)circleLockToolFinishAnimation{
    switch (self.lockstate) {
        case 1:
            if ([self.delegate conformsToProtocol:@protocol(CircleLockToolDelegate)] && [self.delegate respondsToSelector:@selector(CircleLockDidUnLock:)]) {
                [self.delegate CircleLockDidUnLock:self];
            }
            break;
        case 0:
            if ([self.delegate conformsToProtocol:@protocol(CircleLockToolDelegate)] && [self.delegate respondsToSelector:@selector(CircleLockDidLock:)]) {
                [self.delegate CircleLockDidLock:self];
            }
            break;
        default:
            break;
    }
    self.lockstate = !self.lockstate;
    [self circleLockToolCancelAnimation];
}
#pragma mark --- 动画是否完成
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag) {
        [self circleLockToolFinishAnimation];
    }else{
        [self circleLockToolCancelAnimation];
        if ([self.delegate conformsToProtocol:@protocol(CircleLockToolDelegate)] && [self.delegate respondsToSelector:@selector(CircleLockCancleLock:)]) {
            [self.delegate CircleLockCancleLock:self];
        }
    }
}
#pragma mark --- 动画开始
-(void)animationDidStart:(CAAnimation *)anim{
    
    switch (self.lockstate) {
        case 1:
            if ([self.delegate conformsToProtocol:@protocol(CircleLockToolDelegate)] && [self.delegate respondsToSelector:@selector(CircleLockWillUnLock:)]) {
                [self.delegate CircleLockWillUnLock:self];
            }
            break;
        case 0:
            if ([self.delegate conformsToProtocol:@protocol(CircleLockToolDelegate)] && [self.delegate respondsToSelector:@selector(CircleLockWillLock:)]) {
                [self.delegate CircleLockWillLock:self];
            }
            break;
        default:
            break;
    }
}
#pragma mark --- setter方法的实现
-(void)setUnlockedImage:(UIImage *)unlockedImage{
    _unlockedImage = unlockedImage;
}
-(void)setLockedImage:(UIImage *)lockedImage{
    _lockedImage = lockedImage;
}
-(void)setRadius:(CGFloat)radius{
    _radius = radius;
}
-(void)setDuration:(CGFloat)duration{
    _duration = duration;
}
-(void)setRingColor:(UIColor *)ringColor{
    _ringColor = ringColor;
}
-(void)setStrokeColor:(UIColor *)strokeColor{
    _strokeColor = strokeColor;
}
-(void)setStrokeWidth:(CGFloat)strokeWidth{
    _strokeWidth = strokeWidth;
}
@end
