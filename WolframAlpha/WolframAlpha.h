
//  WolframAlpha.h

//  Seb Jachec

#import <Foundation/Foundation.h>

@class WolframAlpha;

@protocol WolframAlphaDelegate <NSObject>

@optional

- (void)didStartQuery:(WolframAlpha *)wolframAlpha;
- (void)didFinishQuery:(WolframAlpha *)wolframAlpha;

@end


@interface WolframAlpha : NSObject

@property (strong) NSString *appID;
@property (nonatomic, assign) id <WolframAlphaDelegate> delegate;

- (id)initWithAppID:(NSString*)theID;

- (NSData*)sendQueryWithString:(NSString*)theValue metric:(BOOL)isMetric;
- (NSData*)sendQueryWithString:(NSString*)theValue;

- (BOOL)validQuery:(NSString*)theQuery;

@end