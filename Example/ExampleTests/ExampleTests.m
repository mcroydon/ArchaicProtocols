//
//  ExampleTests.m
//  ExampleTests
//
//  Created by Matt Croydon on 5/3/14.
//  Copyright (c) 2014 Matt Croydon. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "QOTDURLProtocol.h"
#import "FingerURLProtocol.h"
#import "DaytimeURLProtocol.h"

@interface ExampleTests : XCTestCase
{
    NSURL *qotd;
    NSURL *finger;
    NSURL *daytime;
    NSURLSession *session;
}

@end

@implementation ExampleTests

- (void)setUp
{
    [super setUp];

    // QOTD
    BOOL registered = [NSURLProtocol registerClass:[QOTDURLProtocol class]];
    XCTAssertTrue(registered, @"Unable to register QOTDURLProtocol.");
    qotd = [NSURL URLWithString:@"qotd://djxmmx.net/"];

    // Finger
    registered = [NSURLProtocol registerClass:[FingerURLProtocol class]];
    XCTAssertTrue(registered, @"Unable to register FingerURLProtocol.");
    finger = [NSURL URLWithString:@"finger://bathroom.mit.edu/"];

    // Daytime
    registered = [NSURLProtocol registerClass:[DaytimeURLProtocol class]];
    XCTAssertTrue(registered, @"Unable to register DaytimeURLProtocol.");
    daytime = [NSURL URLWithString:@"daytime://time-c.nist.gov/"];

    session = [NSURLSession sharedSession];
}

- (void)tearDown
{
    [super tearDown];
}

# pragma mark - QOTDUrlProtocol

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
    XCTAssertNotEqual(previousCount, -1, @"Did not recieve any bytes.");
}

-(void)testQOTDBadHost
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

# pragma mark - FingerURLProtocol
-(void)testCanHandleFinger
{
    BOOL canHandle = [FingerURLProtocol canInitWithRequest:[NSURLRequest requestWithURL:finger]];
    XCTAssertTrue(canHandle, @"Expected FingerURLProtocol to handle finger:// URLs.");
    NSURL *notFinger = [NSURL URLWithString:@"http://postneo.com"];
    canHandle = [FingerURLProtocol canInitWithRequest:[NSURLRequest requestWithURL:notFinger]];
    XCTAssertFalse(canHandle, @"FingerURLProtocol should not be able to handle other kinds of URLs.");
}

- (void)testFinger
{
    NSURLSessionDataTask *task = [session dataTaskWithURL:finger completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        XCTAssertEqualObjects(response.URL, finger, @"Response URL did not match request URL.");
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
    XCTAssertNotEqual(previousCount, -1, @"Did not recieve any bytes.");
}

-(void)testFingerBadHost
{
    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:@"finger://postneo.com/"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        XCTAssertNotNil(error, @"Expected non-nil error.");
        XCTAssertEqual(error.code, 500, @"Expected error 500.");
        NSLog(@"Response encoded %@ with error %@.", response.MIMEType, error);
    }];
    [task resume];
    while (task.state != NSURLSessionTaskStateCompleted) {
        // Ensure that task completes.
    }
}

# pragma mark - DaytimeURLProtocol

-(void)testCanHandleDaytime
{
    BOOL canHandle = [DaytimeURLProtocol canInitWithRequest:[NSURLRequest requestWithURL:daytime]];
    XCTAssertTrue(canHandle, @"Expected DaytimeURLProtocol to handle daytime:// URLs.");
    NSURL *notDaytime = [NSURL URLWithString:@"http://time-c.nist.gov/"];
    canHandle = [DaytimeURLProtocol canInitWithRequest:[NSURLRequest requestWithURL:notDaytime]];
    XCTAssertFalse(canHandle, @"DaytimeURLProtocol should not be able to handle other kinds of URLs.");
}

- (void)testDaytime
{
    NSURLSessionDataTask *task = [session dataTaskWithURL:daytime completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
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
    XCTAssertNotEqual(previousCount, -1, @"Did not recieve any bytes.");
}

-(void)testDaytimeBadHost
{
    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:@"daytime://postneo.com/"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
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
