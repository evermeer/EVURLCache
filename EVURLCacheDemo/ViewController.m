//
//  ViewController.m
//  EVURLCacheTest2
//
//  Created by Gergely Nagy on 16.02.16.
//  Copyright © 2016 ElOpsis Ltd. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSURL *nsurl=[NSURL URLWithString:@"http://evict.nl"];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [self.webview loadRequest:nsrequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
