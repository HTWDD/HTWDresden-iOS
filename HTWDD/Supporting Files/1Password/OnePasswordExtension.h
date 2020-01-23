//
//  1Password Extension
//
//  Lovingly handcrafted by Dave Teare, Michael Fey, Rad Azzouz, and Roustem Karimov.
//  Copyright (c) 2014 AgileBits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <WebKit/WebKit.h>

#if __has_feature(nullability)
NS_ASSUME_NONNULL_BEGIN
#else
#define nullable
#define __nullable
#define nonnull
#define __nonnull
#endif

// Login Dictionary keys - Used to get or set the properties of a 1Password Login
#define AppExtensionURLStringKey                            @"url_string"
#define AppExtensionUsernameKey                             @"username"
#define AppExtensionPasswordKey                             @"password"
#define AppExtensionTOTPKey                                 @"totp"
#define AppExtensionTitleKey                                @"login_title"
#define AppExtensionNotesKey                                @"notes"
#define AppExtensionSectionTitleKey                         @"section_title"
#define AppExtensionFieldsKey                               @"fields"
#define AppExtensionReturnedFieldsKey                       @"returned_fields"
#define AppExtensionOldPasswordKey                          @"old_password"
#define AppExtensionPasswordGeneratorOptionsKey             @"password_generator_options"

// Password Generator options - Used to set the 1Password Password Generator options when saving a new Login or when changing the password for for an existing Login
#define AppExtensionGeneratedPasswordMinLengthKey           @"password_min_length"
#define AppExtensionGeneratedPasswordMaxLengthKey           @"password_max_length"
#define AppExtensionGeneratedPasswordRequireDigitsKey       @"password_require_digits"
#define AppExtensionGeneratedPasswordRequireSymbolsKey      @"password_require_symbols"
#define AppExtensionGeneratedPasswordForbiddenCharactersKey @"password_forbidden_characters"

// Errors codes
#define AppExtensionErrorDomain                             @"OnePasswordExtension"

#define AppExtensionErrorCodeCancelledByUser                    0
#define AppExtensionErrorCodeAPINotAvailable                    1
#define AppExtensionErrorCodeFailedToContactExtension           2
#define AppExtensionErrorCodeFailedToLoadItemProviderData       3
#define AppExtensionErrorCodeCollectFieldsScriptFailed          4
#define AppExtensionErrorCodeFillFieldsScriptFailed             5
#define AppExtensionErrorCodeUnexpectedData                     6
#define AppExtensionErrorCodeFailedToObtainURLStringFromWebView 7

typedef void (^OnePasswordLoginDictionaryCompletionBlock)(NSDictionary * __nullable loginDictionary, NSError * __nullable error);
typedef void (^OnePasswordSuccessCompletionBlock)(BOOL success, NSError * __nullable error);
typedef void (^OnePasswordExtensionItemCompletionBlock)(NSExtensionItem * __nullable extensionItem, NSError * __nullable error);

@interface OnePasswordExtension : NSObject

+ (OnePasswordExtension *)sharedExtension;

#ifdef __IPHONE_8_0
- (BOOL)isAppExtensionAvailable NS_EXTENSION_UNAVAILABLE_IOS("Not available in an extension. Check if org-appextension-feature-password-management:// URL can be opened by the app.");
#else
- (BOOL)isAppExtensionAvailable;
#endif

- (void)findLoginForURLString:(nonnull NSString *)URLString forViewController:(nonnull UIViewController *)viewController sender:(nullable id)sender completion:(nonnull OnePasswordLoginDictionaryCompletionBlock)completion;

- (void)storeLoginForURLString:(nonnull NSString *)URLString loginDetails:(nullable NSDictionary *)loginDetailsDictionary passwordGenerationOptions:(nullable NSDictionary *)passwordGenerationOptions forViewController:(nonnull UIViewController *)viewController sender:(nullable id)sender completion:(nonnull OnePasswordLoginDictionaryCompletionBlock)completion;

- (void)changePasswordForLoginForURLString:(nonnull NSString *)URLString loginDetails:(nullable NSDictionary *)loginDetailsDictionary passwordGenerationOptions:(nullable NSDictionary *)passwordGenerationOptions forViewController:(UIViewController *)viewController sender:(nullable id)sender completion:(nonnull OnePasswordLoginDictionaryCompletionBlock)completion;

- (void)fillItemIntoWebView:(nonnull id)webView forViewController:(nonnull UIViewController *)viewController sender:(nullable id)sender showOnlyLogins:(BOOL)yesOrNo completion:(nonnull OnePasswordSuccessCompletionBlock)completion;

- (BOOL)isOnePasswordExtensionActivityType:(nullable NSString *)activityType;

- (void)createExtensionItemForWebView:(nonnull id)webView completion:(nonnull OnePasswordExtensionItemCompletionBlock)completion;

- (void)fillReturnedItems:(nullable NSArray *)returnedItems intoWebView:(nonnull id)webView completion:(nonnull OnePasswordSuccessCompletionBlock)completion;

- (void)fillLoginIntoWebView:(nonnull id)webView forViewController:(nonnull UIViewController *)viewController sender:(nullable id)sender completion:(nonnull OnePasswordSuccessCompletionBlock)completion __attribute__((deprecated("Use fillItemIntoWebView:forViewController:sender:showOnlyLogins:completion: instead. Deprecated in version 1.5")));
@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#endif
