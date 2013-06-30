
// NSString+Contains.h

// Seb Jachec

@interface NSString (Contains)

- (BOOL)containsString:(NSString *)theString;

- (BOOL)containsString:(NSString *)theString options:(NSStringCompareOptions)theOptions;

@end