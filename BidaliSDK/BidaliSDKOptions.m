#import "BidaliSDKOptions.h"

@implementation BidaliSDKOptions {
    
}

- (id)initWithApiKey:(NSString *)apiKey {
    if (self = [super init]) {
        self.apiKey = apiKey;
    }
    return self;
}

- (void)dealloc {
    self.apiKey = nil;
    self.env = nil;
    self.url = nil;
    self.email = nil;
    self.paymentCurrencies = nil;
    self.onPaymentRequest = nil;
}

+ (instancetype)optionsWithApiKey:(NSString *)apiKey {
    BidaliSDKOptions *sdkOptions = [[BidaliSDKOptions alloc] initWithApiKey:apiKey];
    return sdkOptions;
}

@end
