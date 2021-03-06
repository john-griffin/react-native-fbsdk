// Copyright (c) 2015-present, Facebook, Inc. All rights reserved.
//
// You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
// copy, modify, and distribute this software in source code or binary form for use
// in connection with the web services and APIs provided by Facebook.
//
// As with any software that integrates with the Facebook platform, your use of
// this software is subject to the Facebook Developer Principles and Policies
// [http://developers.facebook.com/policy/]. This copyright notice shall be
// included in all copies or substantial portions of the software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "RCTFBSDKAccessToken.h"

#import <RCTUtils.h>

#import "RCTConvert+FBSDKAccessToken.h"

@implementation RCTFBSDKAccessToken

RCT_EXPORT_MODULE();

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}

#pragma mark - React Native Methods

RCT_EXPORT_METHOD(getCurrentAccessToken:(RCTResponseSenderBlock)callback)
{
  FBSDKAccessToken *currentToken = [FBSDKAccessToken currentAccessToken];
  NSDictionary *token = nil;
  if (currentToken) {
    token = @{
      @"tokenString": currentToken.tokenString,
      @"permissions": currentToken.permissions.allObjects,
      @"declinedPermissions": currentToken.declinedPermissions.allObjects,
      @"appID": currentToken.appID,
      @"userID": currentToken.userID,
      @"_expirationDate": @(currentToken.expirationDate.timeIntervalSince1970 * 1000),
      @"_refreshDate": @(currentToken.refreshDate.timeIntervalSince1970 * 1000),
    };
  }
  callback(@[RCTNullIfNil(token)]);
}

RCT_EXPORT_METHOD(setCurrentAccessToken:(FBSDKAccessToken *)token)
{
  [FBSDKAccessToken setCurrentAccessToken:token];
}

RCT_EXPORT_METHOD(refreshCurrentAccessToken:(RCTResponseSenderBlock)callback)
{
  [FBSDKAccessToken refreshCurrentAccessToken:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
    callback(@[RCTBuildResponseDictionary(error, result)]);
  }];
}

#pragma mark - Helper Functions

static NSDictionary *RCTBuildResponseDictionary(NSError *error, id results)
{
  return @{
    @"error": error ? (error.localizedDescription ?: @"Unknown error") : [NSNull null],
    @"result": error ? [NSNull null] : results,
  };
}

@end
