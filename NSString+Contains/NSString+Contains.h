
// NSString+Contains.h

// Seb Jachec

@interface NSString (Contains)

- (BOOL)containsString:(NSString *)string;

- (BOOL)containsString:(NSString *)string
               options:(NSStringCompareOptions)options;

@end