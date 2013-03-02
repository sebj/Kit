
// SJADNShareController.m

// Seb Jachec

#import "SJADNShareController.h"

@implementation SJADNShareController

//Used to encode text for the App.net intent URL
- (NSString*)encodeToPercentEscapeString:(NSString *)string {
    return (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                        (CFStringRef) string,
                                                                        NULL,
                                                                        (CFStringRef) @"!*'();:@&=+$,/?%#[]",
                                                                        kCFStringEncodingUTF8);
}

//NSSharingServicePickerDelegate method to insert App.net option
- (NSArray*)sharingServicePicker:(NSSharingServicePicker *)sharingServicePicker sharingServicesForItems:(NSArray *)items proposedSharingServices:(NSArray *)proposedServices {
    
    NSMutableArray *sharingServices = [proposedServices mutableCopy];
    
    NSImage *ADNImage = [NSImage imageNamed:@"adn"];
    [ADNImage setTemplate:YES];
    
    NSSharingService *ADNService = [[NSSharingService alloc] initWithTitle:@"App.net" image:ADNImage alternateImage:ADNImage handler:^{
        [self shareItems:items];
        
    }];
    
    [sharingServices insertObject:ADNService atIndex:3];
    
    return sharingServices;
}

//All-purpose sharing method, can be called from anywhere
- (void)shareItems:(NSArray*)items {
    NSString *postText = @"";
    
    for (id theItem in items) {
        if ([theItem isKindOfClass:[NSString class]]) {
            if ([postText isEqualToString:@""]) {
                //If "postText" is empty, set it to the string
                postText = theItem;
            } else {
                //If "postText" isn't empty, append the string on a new line
                postText = [postText stringByAppendingFormat:@"\n%@",theItem];
            }
        }
    }
    
    NSString *encodedPostText = [self encodeToPercentEscapeString:postText];
    NSString *postURL = [NSString stringWithFormat:@"https://alpha.app.net/intent/post?text=%@",encodedPostText];
    
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:postURL]];
}

@end