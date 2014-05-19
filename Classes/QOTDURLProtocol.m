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

/**
 Utilizes the default no payload implementation from ArchaicURLProtocol, specifying port 17, the QOTD port.
 */
-(void)startLoading
{
    [super startLoadingWithPort:17];
}
@end