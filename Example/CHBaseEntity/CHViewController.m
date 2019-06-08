//
//  CHViewController.m
//  CHBaseEntity
//
//  Created by 1211054926@qq.com on 06/08/2019.
//  Copyright (c) 2019 1211054926@qq.com. All rights reserved.
//

#import "CHViewController.h"
#import "CHBookInfo.h"

@interface CHViewController ()

@end

@implementation CHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"Json" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSJSONSerialization *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    CHBookInfo*info = [CHBookInfo modelWithJSON:json];
    NSLog(@"%@",[info toJSONString]);
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
