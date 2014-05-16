#import "QOTDURLProtocol.h"

@implementation QOTDURLProtocol
{
	NSInputStream *stream;
}

/**
 Only responds to a `NSURLRequest` that starts with `qotd://`, case insensitive.
 
 @param request The `NSURLRequest` that might be processed.
 */
+(BOOL) canInitWithRequest:(NSURLRequest *)request
{
	if ([[[request URL] scheme] caseInsensitiveCompare:@"qotd"] == NSOrderedSame) {
		return YES;
	}
	return NO;
}

/**
 The `NSURLRequest` is not altered in this subclass.
 @param request The `NSURLRequest` to process.
 */
+(NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request{
	return request;
}

/**
 Start processing the QOTD request from the host provided in the URL.
 
 @warning Requests are sent to the host in the URL to port 17. This port cannot be overriden if specified in the URL.
    
 */
-(void)startLoading
{
	CFReadStreamRef readStream;
	CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)self.request.URL.host, 17, &readStream, NULL);
	stream = (__bridge NSInputStream *)readStream;
	[stream setDelegate:self];
	[stream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[stream open];
    NSURLResponse *response = [[NSURLResponse alloc] initWithURL:[self.request URL]
                                                        MIMEType:@"text/plain"
                                           expectedContentLength:-1
                                                textEncodingName:nil];
    [self.client URLProtocol:self didReceiveResponse:response
          cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

/**
 Handles responses from the `NSStream`, sending messages via the `NSURLProtocolClient` as the stream is processed.
 
 @param theStream The `NSStream` being handled.
 @param streamEvent The `NSStreamEvent` being handled.
 */
- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    
	switch (streamEvent) {
            
		case NSStreamEventOpenCompleted:
			NSLog(@"Opened stream.");
			break;
            
		case NSStreamEventHasBytesAvailable:
			if (theStream == stream) {
				uint8_t buffer[1024];
				long len;
				while ([stream hasBytesAvailable]) {
					len = [stream read:buffer maxLength:sizeof(buffer)];
					if (len > 0) {
						NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
						[self.client URLProtocol:self didLoadData:[output dataUsingEncoding:NSASCIIStringEncoding]];
					}
				}
			}
			break;
            
		case NSStreamEventErrorOccurred:
			NSLog(@"Can not connect to the host!");
            [self.client URLProtocol:self didFailWithError:[NSError errorWithDomain:@"com.postneo.ArchaicProtocols" code:500 userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"host", self.request.URL.host, nil]]];
            [self close];
			[self.client URLProtocolDidFinishLoading:self];
			break;
            
        case NSStreamEventEndEncountered:
        {
            NSLog(@"End of stream.");
            [self close];
			[self.client URLProtocolDidFinishLoading:self];
			break;
        }
            
        default:
			NSLog(@"Unknown event");
            break;
	}
}

/**
 Stops loading the QOTD request and closes the underlying screen.
 */
-(void)stopLoading
{
    [self close];
}

/**
 Closes the QOTD `NSStream`. This is not meant to be called on its own but is used by `QOTDUrlProtocol`.
 */
-(void)close
{
    if (stream) {
        [stream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        stream.delegate = nil;
        [stream close];
        stream = nil;
    }
}

@end