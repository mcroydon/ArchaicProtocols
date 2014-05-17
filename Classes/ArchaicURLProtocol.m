#import "ArchaicURLProtocol.h"

@implementation ArchaicURLProtocol

-(void)stopLoading
{
    [self close];
}

+(NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request{
	return request;
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