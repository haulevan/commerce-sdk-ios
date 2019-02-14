//
//  ViewController.m
//  Demo
//
//  Created by Cory Smith on 2019-01-18.
//  Copyright © 2019 Bidali Inc. All rights reserved.
//

#import "ViewController.h"
#import <Bidali-iOS-SDK/BidaliSDK.h>

@interface ViewController ()

@end

@implementation ViewController


- (UIButton *)buttonWithTitle:(NSString *)title selector:(SEL)selector {
    UIColor *bgColor = [UIColor whiteColor];
    UIColor *textColor = [UIColor colorWithRed:0.404 green:0.475 blue:0.859 alpha:1];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.layer.cornerRadius = 30;
//    button.layer.borderColor = bgColor.CGColor;
//    button.layer.borderWidth = 1;
    [button setBackgroundColor:textColor];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:bgColor forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat width = self.view.frame.size.width - 44;
    CGFloat height = 60;
    CGFloat x = 22;
    CGFloat y = 400;
    CGFloat spacing = 22;
    
    NSArray *buttons = @[
        [self buttonWithTitle:@"Buy Giftcards" selector:@selector(defaultOptions)],
        // [self buttonWithTitle:@"Pay via API" selector:@selector(paymentViaAPI)],
//        [self buttonWithTitle:@"Buy Giftcards with Verge" selector:@selector(vergeOnly)],        
    ];

    for(UIButton *button in buttons) {
        [button setFrame:CGRectMake(x, y, width, height)];
        [self.view addSubview:button];
        y = y + height + spacing;
    }
}

- (void)defaultOptions {
    NSDictionary *options = @{
                              @"env": @"local",
                              @"apiKey": @"1234",
                              @"onOrderCreated": ^{
                                  NSLog(@"orderCreated! in clients code!");
                              },
                              @"onPaymentRequest": ^(NSString *quote){
                                  NSLog(@"onPaymentRequest! in clients code! %@", quote);
                                  UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Buy this gift card with ETH"
                                                                                                 message:@""
                                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
                                  
                                  UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                        handler:^(UIAlertAction * action) {}];
                                  
                                  [alert addAction:defaultAction];
                                  [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
                              }
                              };
    [[BidaliSDK getInstance] show:self options:options];
}

- (void)paymentViaAPI {
    NSDictionary *options = @{
                              @"env": @"local",
                              @"apiKey": @"1234",
                              @"paymentType": @"api",
                              @"onOrderCreated": ^{
                                  NSLog(@"orderCreated! in clients code!");
                              }};
    [[BidaliSDK getInstance] show:self options:options];
}

- (void)bitcoinOnly {
    NSDictionary *options = @{
                              @"env": @"local",
                              @"apiKey": @"1234",
                              @"paymentCurrencies": @[@"BTC"],
                              @"onOrderCreated": ^{
                                  NSLog(@"orderCreated! in clients code!");
                              }};
    [[BidaliSDK getInstance] show:self options:options];
}

- (void)vergeOnly {
    NSDictionary *options = @{
                              @"env": @"local",
                              @"apiKey": @"1234",
                              @"paymentCurrencies": @[@"XVG"],
                              @"onOrderCreated": ^{
                                  NSLog(@"orderCreated! in clients code!");
                              }};
    [[BidaliSDK getInstance] show:self options:options];
}

@end
