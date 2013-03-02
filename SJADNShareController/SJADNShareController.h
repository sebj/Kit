
// SJADNShareController.h

// Seb Jachec

#import <Foundation/Foundation.h>

@interface SJADNShareController : NSObject <NSSharingServicePickerDelegate>

//Shares the given items on App.net
- (void)shareItems:(NSArray*)items;

@end
