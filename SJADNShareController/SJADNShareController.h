
// SJADNShareController.h

// Seb Jachec

#import <Foundation/Foundation.h>

@interface SJADNShareController : NSObject <NSSharingServicePickerDelegate>

- (void)shareItems:(NSArray*)items;

@end
