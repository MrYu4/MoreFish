//
//  ViewController.m
//  MoYu
//
//  Created by yu on 2019-03-11.
//  Copyright © 2019 JingJing.com. All rights reserved.
//

#import "ViewController.h"

#import "MetalView.h"

@interface ViewController()

@end

@implementation ViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    MetalView *view = [[MetalView alloc]initWithFrame:CGRectMake(23, 23, 100, 100)];
    [self.view addSubview:view];
}


@end