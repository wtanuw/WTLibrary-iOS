////
////  WTStoreKitVerification.h
////  BushiRoadCardViewer
////
////  Created by Wat Wongtanuwat on 10/10/12.
////  Copyright (c) 2012 aim. All rights reserved.
////
//
//#import <Foundation/Foundation.h>
//#import <StoreKit/StoreKit.h>
//#import <Security/Security.h>
//
//#define WTStoreKitVerification_VERSION 0x00020000
//
//#define IS_IOS6_AWARE (__IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_5_1)
//
//#define ITMS_PROD_VERIFY_RECEIPT_URL        @"https://buy.itunes.apple.com/verifyReceipt"
//#define ITMS_SANDBOX_VERIFY_RECEIPT_URL     @"https://sandbox.itunes.apple.com/verifyReceipt";
//
//#if !DEBUG
//    #define APPLE_VERIFY_RECEIPT_URL    ITMS_PROD_VERIFY_RECEIPT_URL
//    #define APPLE_VERIFY_RECEIPT_URL_2    ITMS_SANDBOX_VERIFY_RECEIPT_URL
//#else
//    #define APPLE_VERIFY_RECEIPT_URL    ITMS_SANDBOX_VERIFY_RECEIPT_URL
//    #define APPLE_VERIFY_RECEIPT_URL_2    ITMS_PROD_VERIFY_RECEIPT_URL
//#endif
//
//
////if use Auto-Renewable Subscriptions, must define WTStoreKitSharedSecret with your Shared Secret Key from iTunesConnect
////#ifdef WTStoreKitSharedSecret
////    #define kWTStoreKitSharedSecret WTStoreKitSharedSecret
////#else
////    #define kWTStoreKitSharedSecret @"WTStoreKitSharedSecret"
////#endif
//
//
////#define skipCheckReceiptSecurity
//
////#define skipIsTransactionIdUnique
////#define skipSaveTransactionId
//
//#define kKNOWN_TRANSACTIONS_KEY             @"knownIAPTransactions"
//
//
//typedef void (^WTVerificationCompletionBlock)(BOOL valid, NSDictionary *purchaseInfo);
//
//
//@interface WTStoreKitVerification : NSObject<NSURLConnectionDelegate, NSURLConnectionDataDelegate>
//{
//    NSMutableDictionary *paymentTransactionDictionary;
//    NSMutableDictionary *dataDictionary;
//    
//    NSMutableDictionary *jsonReceiptStorageDictionary;
//    NSMutableDictionary *latestReceiptDictionary;
//    
//    NSMutableDictionary *transactionsReceiptStorageDictionary;
//    
//    BOOL switchVerifyUrl;
//}
//
//+ (instancetype) sharedManager;
//
//- (NSDictionary*)jsonReceiptStorageDictionary;
//
//// Checking the results of this is not enough.
//// The final verification happens in the connection:didReceiveData: callback within
//// this class.  So ensure IAP feaures are unlocked from there.
//- (BOOL)verifyPurchaseProduct:(SKPaymentTransaction *)transaction onComplete:(WTVerificationCompletionBlock)complete;
//- (BOOL)verifyPurchaseSubscription:(SKPaymentTransaction *)transaction onComplete:(WTVerificationCompletionBlock)complete;
//
//- (BOOL)verifyReceiptProduct:(NSData *)receipt onComplete:(WTVerificationCompletionBlock)complete;
//- (BOOL)verifyReceiptSubscription:(NSData *)receipt onComplete:(WTVerificationCompletionBlock)complete;
//
//- (NSDictionary*)purchaseInfoFromTransaction:(SKPaymentTransaction *)transaction;
//- (NSDictionary*)purchaseInfoFromProductIdentifier:(NSString*)productIdentifier;
//
//- (NSDictionary*)receiptInfoFromProductIdentifier:(NSString*)productIdentifier;
//
//@end
//
//
//@interface WTStoreKitURLConnection : NSURLConnection
//
//@property (nonatomic,retain) NSString *productIdentifier;
//@property (nonatomic,assign) BOOL useAutoRenewableSubscription;
//
//@end
