#import "ArchaicURLProtocol.h"
#import "EchoURLProtocol.h"

@implementation EchoURLProtocol

-(instancetype)init{
    self = [super init];
    return self;
}

+(BOOL) canInitWithRequest:(NSURLRequest *)request
{
	if ([request.URL.scheme caseInsensitiveCompare:@"echo"] == NSOrderedSame) {
		return YES;
	}
	return NO;
}

/**
 Utilizes the default no payload implementation from ArchaicURLProtocol, specifying port 7, the echo port.
 */
-(void)startLoading
{
    [super startLoadingWithPort:7];
}

/**
 Handles responses from the `NSStream`, sending messages via the `NSURLProtocolClient` as the stream is processed.
 Sends querystring then disconnects.

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
                BOOL echoed = NO;
                NSData *query = [self.request.URL.query dataUsingEncoding:NSASCIIStringEncoding];
				uint8_t buffer[strlen(query.bytes)];
				long len;
				while ([inputStream hasBytesAvailable]) {
					len = [inputStream read:buffer maxLength:sizeof(buffer)];
					if (len > 0) {
						NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
						[self.client URLProtocol:self didLoadData:[output dataUsingEncoding:NSASCIIStringEncoding]];
                        echoed = YES;
					}
                    if (echoed == YES) {
                        [self closeInput];
                        [self.client URLProtocolDidFinishLoading:self];
                    }
				}
			}
			break;

        case NSStreamEventHasSpaceAvailable:
            if (theStream == outputStream) {
                NSData *query = [self.request.URL.query dataUsingEncoding:NSASCIIStringEncoding];
                [outputStream write:query.bytes maxLength:strlen(query.bytes)];
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
@end