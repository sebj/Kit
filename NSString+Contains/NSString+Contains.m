
// NSString+Contains.m

// Seb Jachec

#import "NSString+Contains.h"

@implementation NSString (Contains)

- (BOOL)containsString:(NSString *)theString options:(NSStringCompareOptions)theOptions {
    
    NSRange theRange = [self rangeOfString:theString options:theOptions];
    
    return ((theRange.location != NSNotFound) ? YES : NO);
}

- (BOOL)containsString:(NSString *)theString {
    return [self containsString:theString options:0];
}

@end