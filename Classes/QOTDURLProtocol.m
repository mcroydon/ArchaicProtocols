#import "ArchaicURLProtocol.h"
#import "QOTDURLProtocol.h"

@implementation QOTDURLProtocol

-(instancetype)init{
    self = [super init];
    return self;
}

+(BOOL) canInitWithRequest:(NSURLRequest *)request
{
	if ([request.URL.scheme caseInsensitiveCompare:@"qotd"] == NSOrderedSame) {
		return YES;
	}
	return NO;
}

-(void)startLoading
{
	CFReadStreamRef readStream;
	CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)self.request.URL.host, 17, &readStream, NULL);
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



@end