#import <Foundation/Foundation.h>

/**
 `QOTDURLProtocol` is a subclass of `NSURLProtocol` that serves as the base of other more specific archaic protocols.
 */
@interface ArchaicURLProtocol : NSURLProtocol<NSStreamDelegate>
{
	NSInputStream *stream;
}

/**
 The `NSURLRequest` is not altered in these subclassses.
 
 @param request The `NSURLRequest` to process.
 */
+(NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request;

/**
 Stops loading the request and close the underlying screen.
 */
-(void)stopLoading;

/**
 Closes the QOTD `NSStream`. This is not meant to be called on its own but is used by `QOTDUrlProtocol`.
 */
-(void)close;

@end