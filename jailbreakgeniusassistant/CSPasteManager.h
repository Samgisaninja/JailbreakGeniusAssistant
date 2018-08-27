//
// Created by Dana Buehre on 6/23/17.
// Copyright (c) 2017 CreatureCoding. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CSPMPostService) {
    CSPMPostServiceGhostBin = 0,
    CSPMPostServiceHasteBin = 1
};

@interface CSPasteManager : NSObject {

}

/*
- example usage

[self makeRequestWithPostService:CSPMPostServiceHasteBin body:@"hello, ghostbin!" expiration:@"5m" completion:^(NSURL *response, NSError *error) {

    // update your UI here for task completion
    if (!error) {

        //handle task success here like copy to pasteboard
        NSLog(@"upload successful : %@", response.description);

    } else {

        // handle task failure here
        NSLog(@"upload failed with ERROR : %@", error.localizedDescription);

    }
}];

 - remember while testing to set a low expiration so your not spamming ghostbin, hastebin does not support expiration so it will default to 30 days
 - when posting using CSPMPostServiceHasteBin, you can pass nil for expiration: since its not supported by ghostbin
*/

- (void)makeRequestWithPostService:(CSPMPostService)service body:(NSString *_Nonnull)body expiration:(nullable NSString *)expiration completion:(nullable void (^)(NSURL *_Nullable , NSError *_Nullable ))completion;
@end