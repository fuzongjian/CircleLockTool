//
//  ViewController.m
//  CircleLockTool
//
//  Created by 陈舒澳 on 16/4/18.
//  Copyright © 2016年 xingbida. All rights reserved.
//

#import "ViewController.h"
#import "CircleLockTool.h"
@interface ViewController ()<CircleLockToolDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CircleLockTool * circle = [[CircleLockTool alloc] initWithCenter:self.view.center Radius:20 AnimationDuration:2 Lock:[UIImage imageNamed:@"locked"] Unlock:[UIImage imageNamed:@"unlocked"] RingColor:[UIColor redColor] StrokeColor:[UIColor greenColor] StrokeWith:2];
    circle.delegate = self;
    [self.view addSubview:circle];
}
- (void)CircleLockDidLock:(CircleLockTool *)circleLock{
    NSLog(@"上锁");
}
-(void)CircleLockDidUnLock:(CircleLockTool *)circleLock{
    NSLog(@"解锁");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
