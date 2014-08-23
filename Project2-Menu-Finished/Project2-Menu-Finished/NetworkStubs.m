//
//  NetworkStubs.m
//  CodeSchoolBlog
//
//  Created by Jon Friskics on 08/08/2014.
//  Copyright (c) 2014 Jon Friskics. All rights reserved.
//

#import "NetworkStubs.h"
#import "OHHTTPStubs/OHHTTPStubs.h"

@implementation NetworkStubs

+ (void)load
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.host isEqualToString:@"jonfriskics.com"];
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        // Stub it with our "wsresponse.json" stub file
        NSString* fixture = OHPathForFileInBundle(@"stories.json",nil);
        NSLog(@"fixture: %@",fixture);
        return [OHHTTPStubsResponse responseWithFileAtPath:fixture
                                                statusCode:200
                                                   headers:@{@"Content-Type":@"text/json"}];
    }];
}

@end
