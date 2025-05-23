////
////  WTGoogleFetcherAuth.h
////  Pods
////
////  Created by Mac on 13/5/2564 BE.
////
//
//#import "WTGoogleFetcherAuth.h"
//
//// Until all OAuth 2 providers are up to the same spec, we'll provide a crude
//// way here to override the "Bearer" string in the Authorization header
//#ifndef GTM_OAUTH2_BEARER
//#define GTM_OAUTH2_BEARER "Bearer"
//#endif
//
//#import <QuartzCore/QuartzCore.h>
//
//
//@import AppAuth;
//@import GTMAppAuth;
//@import GTMSessionFetcher;
//#import <GTMSessionFetcher/GTMSessionFetcher.h>
//#import <GTMSessionFetcher/GTMSessionFetcherService.h>
////#import <GTMAppAuth/gt.h>
//
//@interface MyAuth ()
//@property (strong, nonatomic) NSString *accessToken;
//@end
//
//@implementation MyAuth
//
//+ (MyAuth *)initWithAccessToken:(NSString *)accessToken {
//    MyAuth *auth = [[MyAuth alloc] init];
//    auth.accessToken = [accessToken copy];
//    return auth;
//}
//
//- (void)authorizeRequest:(NSMutableURLRequest *)request
//                delegate:(id)delegate
//       didFinishSelector:(SEL)sel {
//    [self setTokeToRequest:request];
//
//    NSMethodSignature *sig = [delegate methodSignatureForSelector:sel];
//    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
//    [invocation setSelector:sel];
//    [invocation setTarget:delegate];
//    [invocation setArgument:(&self) atIndex:2];
//    [invocation setArgument:&request atIndex:3];
//    [invocation invoke];
//}
//
//- (void)authorizeRequest:(NSMutableURLRequest *)request
//   completionHandler:(void (^)(NSError *error))handler {
//    [self setTokeToRequest:request];
//}
//
//- (void)setTokeToRequest:(NSMutableURLRequest *)request {
//    if (request) {
//        NSString *value = [NSString stringWithFormat:@"%s %@", GTM_OAUTH2_BEARER, self.accessToken];
//        [request setValue:value forHTTPHeaderField:@"Authorization"];
//    }
//}
//
//- (BOOL)isAuthorizedRequest:(NSURLRequest *)request {
//    return NO;
//}
//
//- (void)stopAuthorization {
//}
//
//- (void)stopAuthorizationForRequest:(NSURLRequest *)request {
//}
//
//- (BOOL)isAuthorizingRequest:(NSURLRequest *)request {
//    return YES;
//}
//@end
//
//
//
//@interface WTGoogleFetcherAuth () <OIDAuthStateChangeDelegate,
//                                               OIDAuthStateErrorDelegate>
//@property (strong, nonatomic) NSString *clientID;
//@property (strong, nonatomic) NSString *redirect;
//@end
//
//@implementation WTGoogleFetcherAuth
//
//+ (WTGoogleFetcherAuth *)withClientID:(NSString *)clientID redirect:(NSString *)redirect
//{
//    WTGoogleFetcherAuth *auth = [[WTGoogleFetcherAuth alloc] init];
//    auth.clientID = clientID;
//    auth.redirect = redirect;
//    return auth;
//}
//
//
///*! @brief Handles inbound URLs. Checks if the URL matches the redirect URI for a pending
//        AppAuth authorization request.
// */
//- (BOOL)application:(UIApplication *)app
//            openURL:(NSURL *)url
//            options:(NSDictionary<NSString *, id> *)options {
//  // Sends the URL to the current authorization flow (if any) which will process it if it relates to
//  // an authorization response.
//  if ([_currentAuthorizationFlow resumeExternalUserAgentFlowWithURL:url]) {
//    _currentAuthorizationFlow = nil;
//    return YES;
//  }
//
//  // Your additional URL handling (if any) goes here.
//
//  return NO;
//}
//
///*! @brief Forwards inbound URLs for iOS 8.x and below to @c application:openURL:options:.
//    @discussion When you drop support for versions of iOS earlier than 9.0, you can delete this
//        method. NB. this implementation doesn't forward the sourceApplication or annotations. If you
//        need these, then you may want @c application:openURL:options to call this method instead.
// */
//- (BOOL)application:(UIApplication *)application
//              openURL:(NSURL *)url
//    sourceApplication:(NSString *)sourceApplication
//           annotation:(id)annotation {
//  return [self application:application
//                   openURL:url
//                   options:@{}];
//}
//
///*! @brief The OIDC issuer from which the configuration will be discovered.
// */
//static NSString *const kIssuer = @"https://accounts.google.com";
//
///*! @brief The OAuth client ID.
//    @discussion For Google, register your client at
//        https://console.developers.google.com/apis/credentials?project=_
//        The client should be registered with the "iOS" type.
// */
//static NSString *const kClientID = @"YOUR_CLIENT.apps.googleusercontent.com";
//
///*! @brief The OAuth redirect URI for the client @c kClientID.
//    @discussion With Google, the scheme of the redirect URI is the reverse DNS notation of the
//        client ID. This scheme must be registered as a scheme in the project's Info
//        property list ("CFBundleURLTypes" plist key). Any path component will work, we use
//        'oauthredirect' here to help disambiguate from any other use of this scheme.
// */
//static NSString *const kRedirectURI =
//    @"com.googleusercontent.apps.YOUR_CLIENT:/oauthredirect";
//
///*! @brief @c NSCoding key for the authState property.
// */
//static NSString *const kExampleAuthorizerKey = @"authorization";
//
//- (void)viewDidLoad {
////  [super viewDidLoad];
//
//#if !defined(NS_BLOCK_ASSERTIONS)
//  // NOTE:
//  //
//  // To run this sample, you need to register your own iOS client at
//  // https://console.developers.google.com/apis/credentials?project=_ and update three configuration
//  // points in the sample: kClientID and kRedirectURI constants in AppAuthExampleViewController.m
//  // and the URI scheme in Info.plist (URL Types -> Item 0 -> URL Schemes -> Item 0).
//  // Full instructions: https://github.com/openid/AppAuth-iOS/blob/master/Example/README.md
//
//  NSAssert(![kClientID isEqualToString:@"YOUR_CLIENT.apps.googleusercontent.com"],
//           @"Update kClientID with your own client ID. "
//            "Instructions: https://github.com/openid/AppAuth-iOS/blob/master/Example/README.md");
//
//  NSAssert(![kRedirectURI isEqualToString:@"com.googleusercontent.apps.YOUR_CLIENT:/oauthredirect"],
//           @"Update kRedirectURI with your own redirect URI. "
//            "Instructions: https://github.com/openid/AppAuth-iOS/blob/master/Example/README.md");
//
//  // verifies that the custom URI scheme has been updated in the Info.plist
//  NSArray *urlTypes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
//  NSAssert(urlTypes.count > 0, @"No custom URI scheme has been configured for the project.");
//  NSArray *urlSchemes = ((NSDictionary *)urlTypes.firstObject)[@"CFBundleURLSchemes"];
//  NSAssert(urlSchemes.count > 0, @"No custom URI scheme has been configured for the project.");
//  NSString *urlScheme = urlSchemes.firstObject;
//
//  NSAssert(![urlScheme isEqualToString:@"com.googleusercontent.apps.YOUR_CLIENT"],
//           @"Configure the URI scheme in Info.plist (URL Types -> Item 0 -> URL Schemes -> Item 0) "
//            "with the scheme of your redirect URI. Full instructions: "
//            "https://github.com/openid/AppAuth-iOS/blob/master/Example/README.md");
//
//#endif // !defined(NS_BLOCK_ASSERTIONS)
//
////  _logTextView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
////  _logTextView.layer.borderWidth = 1.0f;
////  _logTextView.alwaysBounceVertical = YES;
////  _logTextView.textContainer.lineBreakMode = NSLineBreakByCharWrapping;
////  _logTextView.text = @"";
//
//  [self loadState];
//  [self updateUI];
//}
//
///*! @brief Saves the @c GTMAppAuthFetcherAuthorization to @c NSUSerDefaults.
// */
//- (void)saveState {
//  if (_authorization.canAuthorize) {
//    [GTMAppAuthFetcherAuthorization saveAuthorization:_authorization
//                                    toKeychainForName:kExampleAuthorizerKey];
//  } else {
//    [GTMAppAuthFetcherAuthorization removeAuthorizationFromKeychainForName:kExampleAuthorizerKey];
//  }
//}
//
///*! @brief Loads the @c GTMAppAuthFetcherAuthorization from @c NSUSerDefaults.
// */
//- (void)loadState {
//  GTMAppAuthFetcherAuthorization* authorization =
//      [GTMAppAuthFetcherAuthorization authorizationFromKeychainForName:kExampleAuthorizerKey];
//  [self setGtmAuthorization:authorization];
//}
//
//- (void)setGtmAuthorization:(GTMAppAuthFetcherAuthorization*)authorization {
//  if ([_authorization isEqual:authorization]) {
//    return;
//  }
//  _authorization = authorization;
//  [self stateChanged];
//}
//
///*! @brief Refreshes UI, typically called after the auth state changed.
// */
//- (void)updateUI {
////  _userinfoButton.enabled = _authorization.canAuthorize;
////  _clearAuthStateButton.enabled = _authorization.canAuthorize;
////  // dynamically changes authorize button text depending on authorized state
////  if (!_authorization.canAuthorize) {
////    [_authAutoButton setTitle:@"Authorize" forState:UIControlStateNormal];
////    [_authAutoButton setTitle:@"Authorize" forState:UIControlStateHighlighted];
////  } else {
////    [_authAutoButton setTitle:@"Re-authorize" forState:UIControlStateNormal];
////    [_authAutoButton setTitle:@"Re-authorize" forState:UIControlStateHighlighted];
////  }
//}
//
//- (void)stateChanged {
//  [self saveState];
//  [self updateUI];
//}
//
//- (void)didChangeState:(OIDAuthState *)state {
//  [self stateChanged];
//}
//
//- (void)authState:(OIDAuthState *)state didEncounterAuthorizationError:(NSError *)error {
//  [self logMessage:@"Received authorization error: %@", error];
//}
//
//- (IBAction)authWithAutoCodeExchange:(nullable id)sender {
//
//    UIViewController *vct = sender;
//    NSString *clientID = self.clientID;
//  NSURL *issuer = [NSURL URLWithString:kIssuer];
//    NSURL *redirectURI = [NSURL URLWithString:self.redirect];
//
//  [self logMessage:@"Fetching configuration for issuer: %@", issuer];
//
//  // discovers endpoints
//  [OIDAuthorizationService discoverServiceConfigurationForIssuer:issuer
//      completion:^(OIDServiceConfiguration *_Nullable configuration, NSError *_Nullable error) {
//
//    if (!configuration) {
//      [self logMessage:@"Error retrieving discovery document: %@", [error localizedDescription]];
//      [self setGtmAuthorization:nil];
//      return;
//    }
//
//    [self logMessage:@"Got configuration: %@", configuration];
//      
//    // builds authentication request
//    OIDAuthorizationRequest *request =
//        [[OIDAuthorizationRequest alloc] initWithConfiguration:configuration
//                                                      clientId:clientID
//                                                        scopes:@[OIDScopeOpenID, OIDScopeProfile]
//                                                   redirectURL:redirectURI
//                                                  responseType:OIDResponseTypeCode
//                                          additionalParameters:nil];
//    // performs authentication request
////    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [self logMessage:@"Initiating authorization request with scope: %@", request.scope];
//
//    self.currentAuthorizationFlow =
//        [OIDAuthState authStateByPresentingAuthorizationRequest:request
//            presentingViewController:vct
//                            callback:^(OIDAuthState *_Nullable authState,
//                                       NSError *_Nullable error) {
//      if (authState) {
//        GTMAppAuthFetcherAuthorization *authorization =
//            [[GTMAppAuthFetcherAuthorization alloc] initWithAuthState:authState];
//
//        [self setGtmAuthorization:authorization];
//        [self logMessage:@"Got authorization tokens. Access token: %@",
//                         authState.lastTokenResponse.accessToken];
//      } else {
//        [self setGtmAuthorization:nil];
//        [self logMessage:@"Authorization error: %@", [error localizedDescription]];
//      }
//    }];
//  }];
//}
//
//- (IBAction)clearAuthState:(nullable id)sender {
//  [self setGtmAuthorization:nil];
//}
//
//- (IBAction)clearLog:(nullable id)sender {
////  _logTextView.text = @"";
//}
//
//- (IBAction)userinfo:(nullable id)sender {
//  [self logMessage:@"Performing userinfo request"];
//
//  // Creates a GTMSessionFetcherService with the authorization.
//  // Normally you would save this service object and re-use it for all REST API calls.
//  GTMSessionFetcherService *fetcherService = [[GTMSessionFetcherService alloc] init];
//  fetcherService.authorizer = self.authorization;
//
//  // Creates a fetcher for the API call.
//  NSURL *userinfoEndpoint = [NSURL URLWithString:@"https://www.googleapis.com/oauth2/v3/userinfo"];
//  GTMSessionFetcher *fetcher = [fetcherService fetcherWithURL:userinfoEndpoint];
//  [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
//    // Checks for an error.
//    if (error) {
//      // OIDOAuthTokenErrorDomain indicates an issue with the authorization.
//      if ([error.domain isEqual:OIDOAuthTokenErrorDomain]) {
//        [self setGtmAuthorization:nil];
//        [self logMessage:@"Authorization error during token refresh, clearing state. %@", error];
//      // Other errors are assumed transient.
//      } else {
//        [self logMessage:@"Transient error during token refresh. %@", error];
//      }
//      return;
//    }
//
//    // Parses the JSON response.
//    NSError *jsonError = nil;
//    id jsonDictionaryOrArray =
//        [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
//
//    // JSON error.
//    if (jsonError) {
//      [self logMessage:@"JSON decoding error %@", jsonError];
//      return;
//    }
//
//    // Success response!
//    [self logMessage:@"Success: %@", jsonDictionaryOrArray];
//  }];
//}
//
///*! @brief Logs a message to stdout and the textfield.
//    @param format The format string and arguments.
// */
//- (void)logMessage:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2) {
//  // gets message as string
//  va_list argp;
//  va_start(argp, format);
//  NSString *log = [[NSString alloc] initWithFormat:format arguments:argp];
//  va_end(argp);
//
//  // outputs to stdout
//  NSLog(@"%@", log);
//
//  // appends to output log
//  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//  dateFormatter.dateFormat = @"hh:mm:ss";
//  NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
////  _logTextView.text = [NSString stringWithFormat:@"%@%@%@: %@",
////                                                 _logTextView.text,
////                                                 ([_logTextView.text length] > 0) ? @"\n" : @"",
////                                                 dateString,
////                                                 log];
//}
//
//@end
