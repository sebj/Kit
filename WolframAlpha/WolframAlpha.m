
//  WolframAlpha.m

//  Seb Jachec

#import "WolframAlpha.h"

@implementation WolframAlpha

@synthesize appID, delegate;

#pragma mark -
#pragma mark Basics
- (id)initWithAppID:(NSString*)value {
    if (self) {
        [self setAppID:value];
    }
    
    return self;
}

- (void)setDelegate:(id)val {
    delegate = val;
}

- (id)delegate {
    return delegate;
}

#pragma mark -
#pragma mark Useful methods
- (NSString*)encodedToPercentEscapedString:(NSString *)string {
    return (__bridge NSString *)
    CFURLCreateStringByAddingPercentEscapes(NULL,
                                            (CFStringRef) string,
                                            NULL,
                                            (CFStringRef) @"!*'();:@&=+$,/?%#[]",
                                            kCFStringEncodingUTF8);
}

- (NSData*)sendQueryWithArgs:(NSString*)args {
    if (appID != nil) {
        NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.wolframalpha.com/v2/query?%@&appid=%@",args,appID]];
        NSURLRequest *request = [NSURLRequest requestWithURL:requestURL];
        NSURLResponse *response;
        NSError *err;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
        
        if ([delegate respondsToSelector:@selector(didStartQuery:)]) {
            [delegate didStartQuery:self];
        }
        
        if (err) {
            if ([delegate respondsToSelector:@selector(didFinishQuery:)]) {
                [delegate didFinishQuery:self];
            }
            @throw ([NSException exceptionWithName:@"Unable to send request." reason:[NSString stringWithFormat:@"Error sending request: %@",err] userInfo:nil]);
        } else {
            if ([delegate respondsToSelector:@selector(didFinishQuery:)]) {
                [delegate didFinishQuery:self];
            }
            return data;
        }
    } else {
        @throw ([NSException exceptionWithName:@"Invalid App ID" reason:@"App ID must not be nil." userInfo:nil]);
    }
}

#pragma mark -
#pragma mark Public methods
- (NSData*)sendQueryWithString:(NSString*)value metric:(BOOL)isMetric {
    value = [self encodedToPercentEscapedString:value];
    if (isMetric) {
        return [self sendQueryWithArgs:[NSString stringWithFormat:@"input=%@&units=metric",value]];
    } else {
        return [self sendQueryWithArgs:[NSString stringWithFormat:@"input=%@&units=imperial",value]];
    }
}

- (NSData*)sendQueryWithString:(NSString*)value {
    value = [self encodedToPercentEscapedString:value];
    return [self sendQueryWithArgs:[NSString stringWithFormat:@"input=%@",value]];
}

- (BOOL)valideQuery:(NSString*)value {
    value = [self encodedToPercentEscapedString:value];
    NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.wolframalpha.com/v2/validatequery?input=%@&appid=%@",value,appID]];
    NSURLRequest *request = [NSURLRequest requestWithURL:requestURL];
    NSURLResponse *response;
    NSError *err;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    if (err) {
        @throw ([NSException exceptionWithName:@"Unable to send request." reason:[NSString stringWithFormat:@"Error sending request: %@",err] userInfo:nil]);
    } else {
        //Figure out if it's valid, from the data;
        //Not a very good method!
        NSString *validString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        validString = [validString stringByReplacingOccurrencesOfString:@"<?xml version='1.0' encoding='UTF-8'?>\n<validatequeryresult success='" withString:@""];
        validString = [validString componentsSeparatedByString:@"'"][0];
        
        if ([validString isEqualToString:@"true"]) {
            return YES;
        } else {
            return NO;
        }
    }
}

@end