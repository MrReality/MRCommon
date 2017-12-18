//
//  ViewController.m
//  ChangeView(切换栏)
//
//  Created by Mac on 2017/12/18.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "ViewController.h"
#import "MRCommon.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}


- (IBAction)buttonAction:(id)sender {
    [self presentViewController:kStoryBoard(@"Push") animated:YES completion:NULL];
}




@end
