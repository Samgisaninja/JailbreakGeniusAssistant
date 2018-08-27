//
//  CSPasteManage.m
//  CSPasteManager
//
//  Created by Dana Buehre on 6/23/17.
//  Copyright © 2017 CreatureCoding. All rights reserved.
//

#import "CSPasteManager.h"

@interface CSPasteManager ()
- (NSMutableURLRequest *)urlRequestForService:(CSPMPostService)service content:(NSString *)content expiration:(NSString *)expiration;
@end

@implementation CSPasteManager : NSObject

#pragma mark Public Methods

- (void)makeRequestWithPostService:(CSPMPostService)service body:(NSString *)body expiration:(NSString *)expiration completion:(void (^)(NSURL *, NSError *))completion {
    // create our session using the default config
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];

    // fetch our request data
    NSMutableURLRequest *request = [self urlRequestForService:service content:body expiration:expiration];
    // remember our request urlRequestForService can return nil
    if (!request) {
        // generate an error if the request is nil, and return control to sender
        NSError *error = [[NSError alloc] initWithDomain:@"CSPasteManager" code:101 userInfo:@{@"ERROR": @"A request could not be created with the given parameters. Please verify that you are passing the correct information",
                @"service": @(service), @"body": body, @"expiration": expiration}];
        completion(nil, error);
        return;
    }

    // create a task with the given request
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // the task completed without error
        if (!error) {

            // no error check that the status code of the request returns a success code
            NSInteger statusCode = ((NSHTTPURLResponse *) response).statusCode;

            if (statusCode == 200) {

                // hastebin returns the URL in json format so we need to pars that
                if (service == CSPMPostServiceHasteBin) {
                    // get the json string from the response data
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                    NSURL *URL = [NSURL URLWithString:[@"https://hastebin.com/" stringByAppendingString:json[@"key"]]];
                    completion(URL, nil);
                }
                    // if the service is not hastebin then we can get the URL directly from the response
                else {
                    completion(response.URL, nil);
                }
            } else {
                // the request resulted in a non-successful statusCode
                // generate an error and return it
                error = [[NSError alloc] initWithDomain:NSURLErrorDomain code:statusCode userInfo:@{@"ERROR": response.description}];
                completion(nil, error);
            }
            // the task resulted in an error return the error
        } else {
            // error from the session
            completion(nil, error);
        }
    }] resume];
}

#pragma mark Private Utilities

- (NSMutableURLRequest *)urlRequestForService:(CSPMPostService)service content:(NSString *)content expiration:(NSString *)expiration {
    NSMutableURLRequest *request = [NSMutableURLRequest new];

    switch (service) {
        case CSPMPostServiceGhostBin: {
            // format our content string to fit ghostbin API
            content = [NSString stringWithFormat:@"text=%@&expire=%@&lang=%@", content, expiration, @"text"];
            NSString *length = [NSString stringWithFormat:@"%lu", (unsigned long) [content length]];

            // configure our request
            [request setHTTPMethod:@"POST"]; // set the request method to POST
            [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"]; // set the content type to FORM
            [request setURL:[NSURL URLWithString:@"https://ghostbin.com/paste/new"]]; // set the URL of our request
            [request setValue:length forHTTPHeaderField:@"Content-Length"]; // set the length of our content
            [request setHTTPBody:[content dataUsingEncoding:NSUTF8StringEncoding]]; // set the body of our request in UTF8 format as per ghostbin API
        }
            break;

        case CSPMPostServiceHasteBin: {
            NSString *length = [NSString stringWithFormat:@"%lu", (unsigned long) [content length]];

            // configure our request
            [request setHTTPMethod:@"POST"]; // set the request method
            [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"]; // set the content type
            [request setURL:[NSURL URLWithString:@"https://hastebin.com/documents"]]; // set the URL of our request
            [request setValue:length forHTTPHeaderField:@"Content-Length"]; // set the length of our content
            [request setHTTPBody:[content dataUsingEncoding:NSUTF8StringEncoding]]; // set the body of our request
        }
            break;


        default: {
            request = nil;
        }
            break;
    }
    return request;
}

@end
