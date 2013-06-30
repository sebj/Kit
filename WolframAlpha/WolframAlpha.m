
//  WolframAlpha.m

//  Seb Jachec

#import "WolframAlpha.h"

@implementation WolframAlpha

@synthesize appID, delegate;

#pragma mark - Basics
- (id)initWithAppID:(NSString*)theID {
    if (self) {
        appID = theID;
    }
    
    return self;
}

- (void)setDelegate:(id)theValue {
    delegate = theValue;
}

- (id)delegate {
    return delegate;
}

#pragma mark - Useful methods
- (NSString*)encodedToPercentEscapedString:(NSString *)theString {
    return (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)theString,NULL,(CFStringRef) @"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8);
}

- (NSData*)sendQueryWithArgs:(NSString*)args {
    if (appID) {
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

#pragma mark - Public methods
- (NSData*)sendQueryWithString:(NSString*)theValue metric:(BOOL)isMetric {
    theValue = [self encodedToPercentEscapedString:theValue];
    
    return [self sendQueryWithArgs:[NSString stringWithFormat:(isMetric? @"input=%@&units=metric" : @"input=%@&units=imperial"),theValue]];
}

- (NSData*)sendQueryWithString:(NSString*)theValue {
    return [self sendQueryWithArgs:[NSString stringWithFormat:@"input=%@",[self encodedToPercentEscapedString:theValue]]];
}

- (BOOL)validQuery:(NSString*)theQuery {
    theQuery = [self encodedToPercentEscapedString:theQuery];
    NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.wolframalpha.com/v2/validatequery?input=%@&appid=%@",theQuery,appID]];
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
        
        return [validString isEqualToString:@"true"];
    }
}

@end