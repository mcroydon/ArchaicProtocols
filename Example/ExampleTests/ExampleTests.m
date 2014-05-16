//
//  ExampleTests.m
//  ExampleTests
//
//  Created by Matt Croydon on 5/3/14.
//  Copyright (c) 2014 Matt Croydon. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface ExampleTests : XCTestCase
{
    NSURL *qotd;
    NSURLSession *session;
}

@end

@implementation ExampleTests

- (void)setUp
{
    [super setUp];
    BOOL registered = [NSURLProtocol registerClass:[QOTDURLProtocol class]];
    XCTAssertTrue(registered, @"Unable to register NSURLProtocol.");
    qotd = [NSURL URLWithString:@"qotd://djxmmx.net/"];
    session = [NSURLSession sharedSession];
}

- (void)tearDown
{
    [super tearDown];
}

-(void)testCanHandleQOTD
{
    BOOL canHandle = [QOTDURLProtocol canInitWithRequest:[NSURLRequest requestWithURL:qotd]];
    XCTAssertTrue(canHandle, @"Expected QOTDURLProtocol to handle qotd:// URLs.");
    NSURL *notQOTD = [NSURL URLWithString:@"http://djxmmx.net"];
    canHandle = [QOTDURLProtocol canInitWithRequest:[NSURLRequest requestWithURL:notQOTD]];
    XCTAssertFalse(canHandle, @"QOTDURLProtocol should not be able to handle other kinds of URLs.");
}

- (void)testQOTD
{
    NSURLSessionDataTask *task = [session dataTaskWithURL:qotd completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            XCTAssertEqualObjects(response.URL, qotd, @"Resposne URL did not match request URL.");
            NSLog(@"Response encoded %@ with error %@.", response.MIMEType, error);
            NSString *responseString = [[NSString alloc] initWithData: data
                                              encoding: NSASCIIStringEncoding];
            XCTAssertTrue([responseString length] > 0, @"Expected a response string with content.");
            NSLog(@"Full response:\n%@", responseString);

    }];
    [task resume];
    long previousCount = -1;
    while (task.state != NSURLSessionTaskStateCompleted) {
        long byteCount = (long)task.countOfBytesReceived;
        if (previousCount != byteCount) {
            NSLog(@"Running in state %d with %ld bytes recieved.", task.state, byteCount);
            previousCount = byteCount;
        }
    }
}

-(void)testBadHost
{
    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:@"qotd://postneo.com/"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        XCTAssertNotNil(error, @"Expected non-nil error.");
        XCTAssertEqual(error.code, 500, @"Expected error 500.");
        NSLog(@"Response encoded %@ with error %@.", response.MIMEType, error);
    }];
    [task resume];
    while (task.state != NSURLSessionTaskStateCompleted) {
        // Ensure that task completes.
    }
}

@end
