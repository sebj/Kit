
//  SJAddressBookAccessor.m

//  Seb Jachec

#import <AddressBook/AddressBook.h>
#import "SJAddressBookAccessor.h"

@implementation SJAddressBookAccessor

#pragma mark - Basics
+ (SJAddressBookAccessor*)shared {
    static dispatch_once_t pred;
    static SJAddressBookAccessor *shared = nil;
    
    dispatch_once(&pred, ^() {
        shared = [SJAddressBookAccessor new];
    });
    
    return shared;
}

#pragma mark - Public methods
- (NSString*)fullNameForPart:(NSString*)value {
    if ([value componentsSeparatedByString:@" "].count == 2) return value;
    
    BOOL isFirst = [self isFirstName:value];
    
    if (isFirst) {
        //It's the first name, we need the last
        return [NSString stringWithFormat:@"%@ %@",value,[self lastNameForFirstName:value]];
    } else {
        //It's the last name, we need the first
        return [NSString stringWithFormat:@"%@ %@",[self firstNameForLastName:value],value];
    }
}



- (BOOL)isFirstName:(NSString*)value {
    NSArray *people = [self searchForValue:value forProperty:kABLastNameProperty];
    ABPerson *rightPerson = nil;
    
    @try {
        rightPerson = people[0];
    }
    @catch (NSException *exception) {
        //String we've got isn't last name (search error), it's first
        return YES;
    }
    
    //String we've got is last name, search good.
    return NO;
}



- (NSString*)firstNameForLastName:(NSString*)value {
    NSArray *people = [self searchForValue:value forProperty:kABLastNameProperty];
    ABPerson *rightPerson = nil;
    
    @try {
        rightPerson = people[0];
    }
    @catch (NSException *exception) {
        return [self lastNameForFirstName:value];
    }
    
    return [rightPerson valueForProperty:kABFirstNameProperty];
}

- (NSString*)lastNameForFirstName:(NSString*)value {
    NSArray *people = [self searchForValue:value forProperty:kABFirstNameProperty];
    ABPerson *rightPerson = nil;
    
    @try {
        rightPerson = people[0];
    }
    @catch (NSException *exception) {
        return [self lastNameForFirstName:value];
    }
    
    return [rightPerson valueForProperty:kABLastNameProperty];
}



- (NSDictionary*)propertiesForPersonWithName:(NSString*)value {
    ABPerson *rightPerson = [self personWithFullName:value];
    
    NSMutableDictionary *returnProps = [NSMutableDictionary new];
    
    for (NSString *property in ABPerson.properties) {
        id valueForProperty = [rightPerson valueForProperty:property];
        if (valueForProperty) returnProps[property] = valueForProperty;
    }
    
    return (NSDictionary*)returnProps;
}

- (NSDictionary*)propertiesForPersonWithFirstName:(NSString*)value {
    return [self propertiesForPersonWithName:[self lastNameForFirstName:value]];
}

- (NSDictionary*)propertiesForPersonWithLastName:(NSString*)value {
    return [self propertiesForPersonWithName:[self firstNameForLastName:value]];
}


- (BOOL)personExistsInAddressbookWithName:(NSString*)value {
    ABPerson *thePerson;
    thePerson = [self personWithFullName:value];
    
    return (thePerson != nil);
}


- (ABPerson*)personWithFullName:(NSString*)fullName {
    ABPerson *person = nil;
    NSArray *possibles = [self searchForValue:[fullName componentsSeparatedByString:@" "][0] forProperty:kABFirstNameProperty];
    
    for (ABPerson *thePerson in possibles) {
        if (person) break;
        
        if ([[thePerson valueForProperty:kABLastNameProperty] isEqualToString:[fullName componentsSeparatedByString:@" "][1]])
            person = thePerson;
    }
    
    return person;
}



- (void)showPerson:(NSString*)name allowingEditing:(BOOL)allowEdit {
    NSString *fullName = [self fullNameForPart:name];
    ABPerson *thePerson = [self personWithFullName:fullName];
    
    NSString *args = @"";
    if (thePerson)
        args = allowEdit? [NSString stringWithFormat:@"%@?edit",thePerson.uniqueId] : thePerson.uniqueId;
    
    NSString *urlString = [NSString stringWithFormat:@"addressbook://%@", args];
    [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:urlString]];
}


#pragma mark - Private methods
- (NSArray*)searchForValue:(NSString*)value forProperty:(NSString*)property {
    ABAddressBook *book = ABAddressBook.sharedAddressBook;
    ABSearchElement *searchElement = [ABPerson searchElementForProperty:property
                                                                  label:nil key:nil
                                                                  value:value
                                                             comparison:kABPrefixMatchCaseInsensitive];
    NSArray *peopleFound = [book recordsMatchingSearchElement:searchElement];
    return peopleFound;
}

@end