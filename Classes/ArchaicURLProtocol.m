#import "ArchaicURLProtocol.h"

@implementation ArchaicURLProtocol

-(void)stopLoading
{
    [self close];
}

+(NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request{
	return request;
}

-(void)startLoadingWithPort:(NSInteger)port
{
        CFReadStreamRef readStream;
        CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)self.request.URL.host, (int)port, &readStream, NULL);
        inputStream = (__bridge NSInputStream *)readStream;
        [inputStream setDelegate:self];
        [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [inputStream open];
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
			if (theStream == inputStream) {
				uint8_t buffer[1024];
				long len;
				while ([inputStream hasBytesAvailable]) {
					len = [inputStream read:buffer maxLength:sizeof(buffer)];
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
			NSLog(@"Unknown event %@", [NSNumber numberWithInt:streamEvent]);
            break;
	}
}

-(void)close
{
    [self closeInput];
    [self closeOutput];
}

-(void)closeInput {
    if (inputStream) {
        [inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        inputStream.delegate = nil;
        [inputStream close];
        inputStream = nil;
    }
}

-(void)closeOutput {
    if (outputStream) {
        [outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        outputStream.delegate = nil;
        [outputStream close];
        outputStream = nil;
    }
}
@end