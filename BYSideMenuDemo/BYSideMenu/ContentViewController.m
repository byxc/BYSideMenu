//
//  ViewController.m
//  TestSideMenu
//
//  Created by 白云 on 2017/4/26.
//  Copyright © 2017年 白云. All rights reserved.
//

#import "ContentViewController.h"
#import "BYSideMenu.h"

@interface ContentViewController ()

@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)firstSizeButtonAction:(id)sender {
    self.sideMenuViewController.sideViewWidth = self.view.bounds.size.width*0.5;
}

- (IBAction)secondSizeButtonAction:(id)sender {
    self.sideMenuViewController.sideViewWidth = self.view.bounds.size.width*0.8;
}


- (IBAction)openButtonAction:(UIButton *)sender {
    [self.sideMenuViewController showSideMenuCompleted:nil];
}

- (IBAction)panSwitchButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.sideMenuViewController.allowPan = !sender.selected;
    NSString *title = sender.selected ? @"禁止拖动":@"使用拖动手势";
    [sender setTitle:title forState:UIControlStateNormal];
}

- (IBAction)typeLeftButtonAction:(UIButton *)sender {
    self.sideMenuViewController.sideType = ++self.sideMenuViewController.sideType%4;
    NSString *title;
    switch (self.sideMenuViewController.sideType) {
        case BYSideTypeLeft:
            title = @"左侧展开";
            break;
        case BYSideTypeRight:
            title = @"右侧展开";
            break;
        case BYSideTypeFollowLeft:
            title = @"左侧跟随展开";
            break;
        case BYSideTypeFollowRight:
            title = @"右侧跟随展开";
            break;
    }
    [sender setTitle:title forState:UIControlStateNormal];
}

- (IBAction)allowTransitionButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.sideMenuViewController.allowTransition = sender.selected;
    NSString *title = sender.selected ? @"允许透明过渡":@"禁止透明过渡";
    [sender setTitle:title forState:UIControlStateNormal];
}

- (IBAction)dismissButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
