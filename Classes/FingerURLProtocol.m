#import "ArchaicURLProtocol.h"
#import "FingerURLProtocol.h"

@implementation FingerURLProtocol

+(BOOL) canInitWithRequest:(NSURLRequest *)request
{
	if ([request.URL.scheme caseInsensitiveCompare:@"finger"] == NSOrderedSame) {
		return YES;
	}
	return NO;
}

-(void)startLoading
{
	CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
	CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)self.request.URL.host, 79, &readStream, &writeStream);
	inputStream = (__bridge NSInputStream *)readStream;
    outputStream = (__bridge NSOutputStream *)writeStream;
	[inputStream setDelegate:self];
    [outputStream setDelegate:self];
	[inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[inputStream open];
    [outputStream open];
    NSURLResponse *response = [[NSURLResponse alloc] initWithURL:[self.request URL]
                                                        MIMEType:@"text/plain"
                                           expectedContentLength:-1
                                                textEncodingName:nil];
    [self.client URLProtocol:self didReceiveResponse:response
          cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

/**
 Handles responses from the `NSStream`, sending messages via the `NSURLProtocolClient` as the stream is processed. Customized
 to also send information via outputStream.
 
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
            
        case NSStreamEventHasSpaceAvailable:
            if (theStream == outputStream) {
                NSData *data;
                if (self.request.URL.user) {
                    NSString *request = [NSString stringWithFormat:@"%@\r\n", self.request.URL.user];
                    data = [request dataUsingEncoding:NSASCIIStringEncoding];
                    
                } else {
                    NSString *request = [NSString stringWithFormat:@"\r\n"];
                    data = [request dataUsingEncoding:NSASCIIStringEncoding];
                }
                [outputStream write:data.bytes maxLength:strlen(data.bytes)];
                [self closeOutput];
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
			NSLog(@"Unknown event %d", streamEvent);
            break;
	}
}

@end