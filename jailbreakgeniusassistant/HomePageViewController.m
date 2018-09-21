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
#import "AFNetworking.framework/Headers/AFNetworking.h"
#import "AFNetworking.framework/Headers/AFHTTPSessionManager.h"
#include <sys/sysctl.h>

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

-(IBAction)startButton:(id)sender{
    UIAlertController *enterDiscordName = [UIAlertController alertControllerWithTitle:@"Discord Name" message:@"Please enter your discord name and discriminator" preferredStyle:UIAlertControllerStyleAlert];
    [enterDiscordName addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Samg_is_a_Ninja#6113";
    }];
    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self->_discordTag = [[[enterDiscordName textFields] firstObject] text];
        [self runCheck];
    }];
    [enterDiscordName addAction:continueAction];
    [self presentViewController:enterDiscordName animated:TRUE completion:nil];
}

-(void)runCheck{
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
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *modelChar = malloc(size);
    sysctlbyname("hw.machine", modelChar, &size, NULL, 0);
    NSString *deviceModel = [NSString stringWithUTF8String:modelChar];
    free(modelChar);
    NSString *deviceVersion = [[UIDevice currentDevice] systemVersion];
    sysctlbyname("kern.osversion", NULL, &size, NULL, 0);
    char *buildChar = malloc(size);
    sysctlbyname("kern.osversion", buildChar, &size, NULL, 0);
    NSString *deviceBuild = [NSString stringWithUTF8String:buildChar];
    free(buildChar);
    _uploadToHastebin = [NSString stringWithFormat:@"Device: %@ running %@ (iOS %@) \nPackages: \n%@ \n \nSources: \n%@", deviceModel, deviceBuild, deviceVersion, installedPackagesString, installedSourcesString];
    NSDictionary *saveToFile = @{
                                 @"Model" : deviceModel,
                                 @"Build" : deviceBuild,
                                 @"iOS" : deviceVersion,
                                 @"Packages" : installedPackageBundleIDs,
                                 @"Sources" : installedSourcesWithoutPrefix,
                                 @"DiscordTag" : _discordTag
                                 };
    [saveToFile writeToFile:@"/var/mobile/Media/genius.plist" atomically:YES];
    [self performSegueWithIdentifier:@"goToPasteManagerViewController" sender:self];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager POST:@"https://rem.reoo.me" parameters:saveToFile progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    PMViewController *destinationViewContoller = [segue destinationViewController];
    destinationViewContoller.uploadToHastebin = _uploadToHastebin;
}

@end
