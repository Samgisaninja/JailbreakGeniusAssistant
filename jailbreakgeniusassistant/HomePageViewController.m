//
//  ViewController.m
//  jailbreakgeniusassistant
//
//  Created by Sam Gardner on 8/23/18.
//  Copyright © 2018 Sam Gardner. All rights reserved.
//  
//

#import "HomePageViewController.h"
#import "PMViewController.h"

@interface HomePageViewController ()

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:TRUE animated:FALSE];
}

-(IBAction)runCheck:(id)sender{
    NSString *statusFile = [[NSString alloc]initWithContentsOfFile:@"/Library/dpkg/status" encoding:NSUTF8StringEncoding error:nil];
    NSArray *installedPackages = [statusFile componentsSeparatedByString:@"\n"];
    NSMutableArray * installedPackageBundleIDs = [[NSMutableArray alloc] init];
    int i;
    for (i=0; i < [installedPackages count]; i++) {
        if ([[installedPackages objectAtIndex:i] hasPrefix:@"Package:"]) {
            NSString *withoutPrefix = [[installedPackages objectAtIndex:i] stringByReplacingOccurrencesOfString:@"Package: " withString:@""];
            [installedPackageBundleIDs addObject:withoutPrefix];
        }
    }
    NSString * installedPackagesString = [installedPackageBundleIDs componentsJoinedByString:@"\n"];
    NSString *sourceListFile = [[NSString alloc] initWithContentsOfFile:@"/private/etc/apt/sources.list.d/cydia.list" encoding:NSUTF8StringEncoding error:nil];
    NSArray *installedSources = [sourceListFile componentsSeparatedByString:@"\n"];
    NSMutableArray *installedSourcesWithoutPrefix = [[NSMutableArray alloc] init];
    for (i=0; i < [installedSources count]; i++) {
        if ([[installedSources objectAtIndex:i] hasPrefix:@"deb"]) {
            NSString *withoutPrefix = [[installedSources objectAtIndex:i] stringByReplacingOccurrencesOfString:@"deb " withString:@""];
            NSString *withoutSuffix = [withoutPrefix stringByReplacingOccurrencesOfString:@" ./" withString:@""];
            [installedSourcesWithoutPrefix addObject:withoutSuffix];
        }
    }
    NSString * installedSourcesString = [installedSourcesWithoutPrefix componentsJoinedByString:@"\n"];
    _uploadToHastebin = [NSString stringWithFormat:@"Packages: \n %@ \n \n Sources: \n %@", installedPackagesString, installedSourcesString];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //self->_goToPasteManagerViewController = [[UIStoryboardSegue alloc] initWithIdentifier:@"goToPasteManagerViewController" source:self destination:[PasteManagerViewController self]];
        [self performSegueWithIdentifier:@"goToPasteManagerViewController" sender:self];
    });
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    PMViewController *destinationViewContoller = [segue destinationViewController];
    destinationViewContoller.uploadToHastebin = _uploadToHastebin;
}

@end
