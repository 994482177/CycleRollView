//
//  ViewController.m
//  CycleRollView
//
//  Created by celink on 15/11/3.
//  Copyright © 2015年 celink. All rights reserved.
//

#import "ViewController.h"
#import "WKRollingCycleView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor grayColor];
    
    WKRollingCycleView* cycleView=[[WKRollingCycleView alloc]initWithFrame:CGRectMake(20, 100, 280, 200) callBack:^(id obj, NSInteger index) {
       
        NSLog(@"%@, %ld",obj, index);
    }];
    cycleView.imageBorderWidth=10;
    cycleView.imageBorderColor=[UIColor orangeColor];
    cycleView.imageMinY=20;
    cycleView.imageMinX=20;
    cycleView.pageViewMaxX=20;
    cycleView.pageViewMinY=-20;
    cycleView.imageStringArray=@[
                                 @"http://g.hiphotos.baidu.com/image/h%3D360/sign=528e54371f950a7b6a3548c23ad0625c/c8ea15ce36d3d539a88600c23887e950352ab073.jpg",
                                 @"http://d.hiphotos.baidu.com/image/h%3D360/sign=a219c9ebb4fd5266b82b3a129b199799/b21c8701a18b87d604ad6e1f050828381e30fdc7.jpg",
                                 @"http://h.hiphotos.baidu.com/image/h%3D360/sign=d9e0c234f91f4134ff370378151d95c1/c995d143ad4bd1130c0ee8e55eafa40f4afb0521.jpg",
                                 @"http://c.hiphotos.baidu.com/image/h%3D360/sign=f5c66c3d37fae6cd13b4ad673fb20f9e/29381f30e924b899cbecf4326c061d950b7bf6ec.jpg"];
    
    cycleView.rollingTimeInterval=2;
    cycleView.titlesGroup=@[@"第一个", @"第二个", @"第三个", @"第四个"];
    [self.view addSubview:cycleView];
}


@end
