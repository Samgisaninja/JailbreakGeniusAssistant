//
//  PMViewController.h
//  jailbreakgeniusassistant
//
//  Created by Sam Gardner on 8/27/18.
//  Copyright © 2018 Sam Gardner. All rights reserved.
//
//  Uses code from https://github.com/CreatureSurvive/CSPasteManager created by Dana Buehre/CreatureSurvive
//  Additional credit provided in AboutViewController. Thanks CreatureSurvive for providing this library.
//

#import <UIKit/UIKit.h>
#import "CSPasteManager.h"

@interface PMViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *completeButton;
@property (strong, nonatomic) NSString *uploadToHastebin;


@end
