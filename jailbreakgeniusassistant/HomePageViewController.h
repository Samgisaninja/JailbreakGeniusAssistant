//
//  ViewController.h
//  jailbreakgeniusassistant
//
//  Created by Sam Gardner on 8/23/18.
//  Copyright © 2018 Sam Gardner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *packageNames;
@property (strong, nonatomic) NSMutableArray *packageIDs;
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) NSString * discordTag;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@end

