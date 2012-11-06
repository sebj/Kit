
//  SJAddressBookAccessor.h

//  Seb Jachec

#import <Foundation/Foundation.h>
#import <AddressBook/ABPerson.h>

@interface SJAddressBookAccessor : NSObject

+ (SJAddressBookAccessor*)sharedAccessor;


- (NSString*)fullNameForPart:(NSString*)value;

- (BOOL)isFirstName:(NSString*)value;

- (NSString*)firstNameForLastName:(NSString*)value;
- (NSString*)lastNameForFirstName:(NSString*)value;

- (NSDictionary*)propertiesForPersonWithName:(NSString*)value;
- (NSDictionary*)propertiesForPersonWithFirstName:(NSString*)value;
- (NSDictionary*)propertiesForPersonWithLastName:(NSString*)value;

- (BOOL)personExistsInAddressbookWithName:(NSString*)value;

- (ABPerson*)personWithFullName:(NSString*)fullName;

- (void)showPerson:(NSString*)name allowingEditing:(BOOL)allowEdit;

@end