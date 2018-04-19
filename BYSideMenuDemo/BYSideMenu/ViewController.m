//
//  MainVC.m
//  TestSideMenu
//
//  Created by 白云 on 2017/4/26.
//  Copyright © 2017年 白云. All rights reserved.
//

#import "ViewController.h"
#import "BYSideMenu.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)skipButtonAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *controllerVC = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controllerVC];
    
    UIViewController *menuVC = [storyboard instantiateViewControllerWithIdentifier:@"MenuVC"];
    
    BYSideMenu *sideMenu = [[BYSideMenu alloc] initWithContentController:nav sideViewController:menuVC];
    sideMenu.sideType = BYSideTypeLeft;
    
    [self presentViewController:sideMenu animated:YES completion:nil];
}

@end
