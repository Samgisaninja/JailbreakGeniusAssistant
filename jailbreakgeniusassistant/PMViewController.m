//
//  PMViewController.m
//  jailbreakgeniusassistant
//
//  Created by Sam Gardner on 8/27/18.
//  Copyright © 2018 Sam Gardner. All rights reserved.
//
//  Uses code from https://github.com/CreatureSurvive/CSPasteManager created by Dana Buehre/CreatureSurvive
//  Additional credit provided in AboutViewController. Thanks CreatureSurvive for providing this library.
//

#import "PMViewController.h"

@interface PMViewController (){
    CSPasteManager *_pasteManager;
}

@end

@implementation PMViewController
@synthesize uploadToHastebin;

- (void)viewDidLoad {
    [super viewDidLoad];
    _pasteManager = [[CSPasteManager alloc] init];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:FALSE animated:TRUE];
}

- (IBAction)postToHasteBin:(id)sender {
    [_pasteManager makeRequestWithPostService:CSPMPostServiceHasteBin body:uploadToHastebin expiration:nil completion:^(NSURL *response, NSError *error) {
        
        // update your UI here for task completion
        if (!error) {
            [self updateForCompletionWithURL:response.description withSuccess:YES];
            NSLog(@"upload successful : %@", response.description);
            
        } else {
            [self updateForCompletionWithURL:error.localizedDescription withSuccess:NO];
            NSLog(@"upload failed with ERROR : %@", error.localizedDescription);
            
        }
    }];
}

- (IBAction)openPost:(id)sender {
    [[UIPasteboard generalPasteboard] setString:_uploadLocation];
    [_completeButton setTitle:@"copied" forState:UIControlStateNormal];
    [self performSelector:@selector(refreshCompletionTitle) withObject:nil afterDelay:3];
}

- (void)refreshCompletionTitle {
    [_completeButton setTitle:[[UIPasteboard generalPasteboard] string] forState:UIControlStateNormal];
}

- (void)updateForCompletionWithURL:(NSString *)URL withSuccess:(BOOL)success {
    // make sure were on the main thread for updating UI since this will be called inside a block
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->_completeButton setTitle:@"Tap to copy URL, paste into discord" forState:UIControlStateNormal];
        self->_uploadLocation = [NSString stringWithFormat:@"%@", URL];
        
    });
}
@end
