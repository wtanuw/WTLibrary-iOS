////
////  WTGoogleFetcherAuth.h
////  Pods
////
////  Created by Mac on 13/5/2564 BE.
////
//
//#import <Foundation/Foundation.h>
//
//@protocol OIDExternalUserAgentSession;
//@class OIDAuthState;
//@class GTMAppAuthFetcherAuthorization;
//@class OIDServiceConfiguration;
//@class GTMSessionFetcherAuthorizer;
//
//NS_ASSUME_NONNULL_BEGIN
//
//@interface MyAuth : NSObject<GTMFetcherAuthorizationProtocol>
//+ (MyAuth *)initWithAccessToken:(NSString *)accessToken;
//@end
//
//
//@interface WTGoogleFetcherAuth : NSObject<GTMFetcherAuthorizationProtocol>
//
//+ (WTGoogleFetcherAuth *)withClientID:(NSString *)clientID redirect:(NSString *)redirect;
//- (BOOL)application:(UIApplication *)app
//            openURL:(NSURL *)url
//            options:(NSDictionary<NSString *, id> *)options;
//
//@property(nonatomic, strong, nullable) id<OIDExternalUserAgentSession> currentAuthorizationFlow;
//
///*! @brief The authorization state.
// */
//@property(nonatomic, strong, nullable) GTMAppAuthFetcherAuthorization *authorization;
//
///*! @brief Authorization code flow using @c OIDAuthState automatic code exchanges.
//    @param sender IBAction sender.
// */
//- (IBAction)authWithAutoCodeExchange:(nullable id)sender;
//
///*! @brief Performs a Userinfo API call using @c GTMAppAuthFetcherAuthorization.
//    @param sender IBAction sender.
// */
//- (IBAction)userinfo:(nullable id)sender;
//
///*! @brief Nils the @c OIDAuthState object.
//    @param sender IBAction sender.
// */
//- (IBAction)clearAuthState:(nullable id)sender;
//
///*! @brief Clears the UI log.
//    @param sender IBAction sender.
// */
//- (IBAction)clearLog:(nullable id)sender;
//
//@end
//NS_ASSUME_NONNULL_END
