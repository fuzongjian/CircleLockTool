//
//  CircleLockTool.h
//  FZJDemo
//
//  Created by 陈舒澳 on 16/4/18.
//  Copyright © 2016年 FZJ.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CircleLockToolDelegate;
@interface CircleLockTool : UIView
//锁的两种图片
@property (nonatomic, strong) UIImage *lockedImage;
@property (nonatomic, strong) UIImage *unlockedImage;
@property (nonatomic, strong) UIColor *ringColor;
@property (nonatomic, strong) UIColor *strokeColor;
//动画时间、线条宽度
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, assign) CGFloat strokeWidth;
@property(nonatomic,assign)CGFloat  radius;
//代理
@property(nonatomic,weak,readwrite) id <CircleLockToolDelegate> delegate;
-(instancetype)initWithCenter:(CGPoint)center Radius:(CGFloat)radius AnimationDuration:(CGFloat)duration Lock:(UIImage *)lockImage Unlock:(UIImage *)unlockImage RingColor:(UIColor *)ringColor StrokeColor:(UIColor *)strokecolor StrokeWith:(CGFloat)strokeWidth;
@end
@protocol CircleLockToolDelegate <NSObject>
@optional
-(void)CircleLockWillLock:(CircleLockTool *)circleLock;
-(void)CircleLockDidLock:(CircleLockTool *)circleLock;
-(void)CircleLockWillUnLock:(CircleLockTool *)circleLock;
-(void)CircleLockDidUnLock:(CircleLockTool *)circleLock;
-(void)CircleLockCancleLock:(CircleLockTool *)circleLock;
@end
