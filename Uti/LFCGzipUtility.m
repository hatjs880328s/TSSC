#import "LFCGzipUtility.h"
 
@implementation LFCGzipUtility
 
- (NSString*) replaceUnicode:(NSString*)TransformUnicodeString {
    NSString *tepStr1 = [TransformUnicodeString stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tepStr2 = [tepStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tepStr3 = [[@"\""  stringByAppendingString:tepStr2]stringByAppendingString:@"\""];
    NSData *tepData = [tepStr3  dataUsingEncoding:NSUTF8StringEncoding];
    NSString *axiba = [NSPropertyListSerialization propertyListWithData:tepData options:NSPropertyListMutableContainers format:NULL error:NULL];
    return [axiba stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

 
@end
