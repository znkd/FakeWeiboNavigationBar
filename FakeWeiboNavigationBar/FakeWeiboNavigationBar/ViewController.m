//
//  ViewController.m
//  FakeWeiboNavigationBar
//
//  Created by zhangnan on 14/12/18.
//  Copyright (c) 2014年 zhangnan. All rights reserved.
//

#import "ViewController.h"
#import "InteractionViewController.h"

@interface ViewController ()
{
    InteractionViewController* subVC;
}
@end

@implementation ViewController
- (void)dealloc
{
    subVC = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    subVC = [[InteractionViewController alloc]initWithNibName:nil bundle:nil];
    
    UIButton* showBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    showBtn.frame = CGRectMake(100, 100, 100, 50);
    [showBtn setTitle:@"push" forState:UIControlStateNormal];
    [showBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:showBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)click:(id)sender
{
    [self.navigationController pushViewController:subVC animated:YES];
}
@end
