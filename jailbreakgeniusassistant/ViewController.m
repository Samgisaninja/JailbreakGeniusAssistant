//
//  ViewController.m
//  jailbreakgeniusassistant
//
//  Created by Sam Gardner on 8/23/18.
//  Copyright © 2018 Sam Gardner. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

-(IBAction)runCheck:(id)sender{
    NSString *statusFile = [[NSString alloc]initWithContentsOfFile:@"/Library/dpkg/status" encoding:NSUTF8StringEncoding error:nil];
    NSArray *installedPackages = [statusFile componentsSeparatedByString:@"\n"];
    NSMutableArray *installedPackageBundleIDsWithPrefix = [[NSMutableArray alloc] init];
    int i;
    for (i=0; i < [installedPackages count]; i++) {
        if ([[installedPackages objectAtIndex:i] hasPrefix:@"Package:"]) {
         [installedPackageBundleIDsWithPrefix addObject:[installedPackages objectAtIndex:i]];
        }
    }
    NSMutableArray * installedPackageBundleIDs = [[NSMutableArray alloc] init];
    for (i=0; i < [installedPackageBundleIDsWithPrefix count]; i++) {
        NSString *withoutPrefix = [[installedPackageBundleIDsWithPrefix objectAtIndex:i] stringByReplacingOccurrencesOfString:@"Package: " withString:@""];
        [installedPackageBundleIDs addObject:withoutPrefix];
    }
    NSString * installedPackagesString = [installedPackageBundleIDs componentsJoinedByString:@"\n"];
    [installedPackagesString writeToFile:@"/var/mobile/Media/installed_packages.txt" atomically:TRUE];
}


@end
