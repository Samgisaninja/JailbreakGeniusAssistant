//
//  AboutViewController.m
//  jailbreakgeniusassistant
//
//  Created by Sam Gardner on 8/27/18.
//  Copyright © 2018 Sam Gardner. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:FALSE animated:TRUE];
}

- (IBAction)creatureCredit:(id)sender {
    NSDictionary *URLOptions = @{UIApplicationOpenURLOptionUniversalLinksOnly : @FALSE};
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://creaturecoding.com"] options:URLOptions completionHandler:nil];
}


@end
