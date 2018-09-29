//
//  ViewController.m
//  jailbreakgeniusassistant
//
//  Created by Sam Gardner on 8/23/18.
//  Copyright © 2018 Sam Gardner. All rights reserved.
//  
//

#import "HomePageViewController.h"
#import "AFNetworking.framework/Headers/AFNetworking.h"
#import "AFNetworking.framework/Headers/AFHTTPSessionManager.h"
#include <sys/sysctl.h>

@interface HomePageViewController ()

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self infoLabel] setText:@"Note: we cannot and will not support devices with piracy.\nSorry for the inconvience.\nGenius™ Assistant developed by Samg_is_a_Ninja and olvrb."];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:TRUE animated:FALSE];
}

-(IBAction)startButtonAction:(id)sender{
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
    [[self startButton] setTitle:@"Uploading..." forState:UIControlStateNormal];
    [[self startButton] setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [[self startButton] setEnabled:FALSE];
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
    NSString *pathToProvisioningProfiles = @"/private/var/MobileDevice/ProvisioningProfiles";
    NSArray *provisioningProfiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:pathToProvisioningProfiles error:nil];
    NSMutableArray *sideloadedApps = [[NSMutableArray alloc] init];
    for (i=0; i < [provisioningProfiles count] - 1; i++) {
        NSString *filePathToProfile = [pathToProvisioningProfiles stringByAppendingPathComponent:[provisioningProfiles objectAtIndex:i]];
        NSString *profileData = [[NSString alloc] initWithContentsOfFile:filePathToProfile encoding:NSASCIIStringEncoding error:nil];
        NSRange prefixRange = [profileData rangeOfString:@"<string>"];
        NSString *withoutPrefix = [profileData substringFromIndex:prefixRange.location];
        NSRange suffixRange = [withoutPrefix rangeOfString:@"</string>"];
        NSString *withoutSuffix = [withoutPrefix substringToIndex:suffixRange.location];
        NSString *profileName = [withoutSuffix stringByReplacingOccurrencesOfString:@"<string>" withString:@""];
        [sideloadedApps addObject:profileName];
    }
    NSString *installedProfiles = [sideloadedApps componentsJoinedByString:@"\n"];
    NSString *uploadingAppBundleID = [[NSBundle mainBundle] bundleIdentifier];
    NSDictionary *saveToFile = @{
                                 @"Model" : deviceModel,
                                 @"Build" : deviceBuild,
                                 @"iOS" : deviceVersion,
                                 @"Packages" : installedPackageBundleIDs,
                                 @"Sources" : installedSourcesWithoutPrefix,
                                 @"DiscordTag" : _discordTag,
                                 @"UploadMethod" : uploadingAppBundleID,
                                 @"InstalledProfiles" : installedProfiles
                                 };
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
     [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
     manager.requestSerializer = [AFHTTPRequestSerializer serializer];
     [manager POST:@"https://rem.reoo.me" parameters:saveToFile progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     [self->_startButton setTitle:@"Done!" forState:UIControlStateNormal];
     [self->_startButton setEnabled:FALSE];
     [self->_startButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
     UIAlertController *uploadFailed = [UIAlertController alertControllerWithTitle:@"Uploading packages failed" message:[NSString stringWithFormat:@"%@", [error localizedDescription]] preferredStyle:UIAlertControllerStyleAlert];
     UIAlertAction *dismissAlert = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil];
     [uploadFailed addAction:dismissAlert];
     [self presentViewController:uploadFailed animated:TRUE completion:nil];
     [self->_startButton setTitle:@"Error, tap to retry" forState:UIControlStateNormal];
     [self->_startButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
     }];
}

- (IBAction)openDiscordLinkAction:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://discord.gg/jb"] options:@{} completionHandler:nil];
}

@end
