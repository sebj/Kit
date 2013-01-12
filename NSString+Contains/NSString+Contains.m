
// NSString+Contains.m

// Seb Jachec

#import "NSString+Contains.h"

@implementation NSString (Contains)

- (BOOL)containsString:(NSString *)string
               options:(NSStringCompareOptions)options {
    
    NSRange theRange = [self rangeOfString:string options:options];
    
    return ((theRange.location != NSNotFound) ? YES : NO);
}

- (BOOL)containsString:(NSString *)string {
    return [self containsString:string options:0];
}

@end