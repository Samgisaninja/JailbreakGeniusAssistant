//
//  ViewController.h
//  jailbreakgeniusassistant
//
//  Created by Sam Gardner on 8/23/18.
//  Copyright © 2018 Sam Gardner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSPasteManager.h"

@interface HomePageViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *packageNames;
@property (strong, nonatomic) NSMutableArray *packageIDs;
@property (strong, nonatomic) IBOutlet UIButton *goButton;
@property (strong, nonatomic) CSPasteManager *pasteManager;
@property (strong, nonatomic) IBOutlet UIButton *completeButton;
@property (strong, nonatomic) UIStoryboardSegue *goToPasteManagerViewController;
@property (strong, nonatomic) NSString * uploadToHastebin;
@end

