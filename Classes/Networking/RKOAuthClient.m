//
//  RKOAuthClient.m
//  Pods
//
//  Created by Joseph Pintozzi on 11/14/13.
//
//

#import "RKOAuthClient.h"
#import "RKUser.h"
#import "RKResponseSerializer.h"
#import "RKObjectBuilder.h"

#import "RKClient+Users.h"

@interface RKOAuthClient ()

@property (nonatomic, strong) RKUser *currentUser;

@end
@implementation RKOAuthClient

- (id)initWithClientId:(NSString *)clientId clientSecret:(NSString *)clientSecret
{
    if (self = [super initWithBaseURL:[[self class] APIBaseURL]])
	{
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.responseSerializer = [RKResponseSerializer serializer];
        _clientId = clientId;
        _clientSecret = clientSecret;
	}
    
    return self;
}

// Overriding API urls

+ (NSURL *)APIBaseURL
{
    //OAuth requires HTTPS
    return [[self class] APIBaseHTTPSURL];
}

+ (NSURL *)APIBaseHTTPSURL
{
    return [NSURL URLWithString:@"https://oauth.reddit.com/"];
}

+ (NSURL *)APIBaseLoginURL
{
    return [NSURL URLWithString:@"https://ssl.reddit.com/"];
}

+ (NSString *)meURLPath
{
    return @"api/v1/me";
}

- (void)setClientId:(NSString *)clientId clientSecret:(NSString*)clientSecret{
    _clientId = [clientId copy];
    _clientSecret = [clientSecret copy];
}

- (void)setOAuthorizationHeader{
    NSAssert(_clientId != nil, @"You must first set a clientId");
    NSAssert(_clientSecret != nil, @"You must first set a clientSecret");
    [[self requestSerializer] setAuthorizationHeaderFieldWithUsername:_clientId password:_clientSecret];
}

- (NSURL *)oauthURLWithRedirectURI:(NSString *)redirectURI state:(NSString *)state scope:(NSArray*)scope {
    NSParameterAssert(redirectURI);
    NSParameterAssert(state);
    NSParameterAssert(scope);
    NSAssert(_clientId != nil, @"You must first set a clientId");
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@api/v1/authorize?response_type=code&redirect_uri=%@&client_id=%@&duration=permanent&scope=%@&state=%@", [[self class] APIBaseLoginURL], [redirectURI stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding], _clientId, [scope componentsJoinedByString:@","], state]];
}

- (NSURLSessionDataTask *)signInWithAccessCode:(NSString *)accessCode redirectURI:(NSString *)redirectURI state:(NSString *)state completion:(RKCompletionBlock)completion
{
    NSParameterAssert(accessCode);
    NSParameterAssert(redirectURI);
    NSParameterAssert(state);
    
    [self setOAuthorizationHeader];
    NSDictionary *parameters = @{@"code": accessCode, @"state": state, @"redirect_uri": redirectURI, @"grant_type": @"authorization_code"};
    
    NSURL *baseURL = [[self class] APIBaseLoginURL];
    NSString *URLString = [[NSURL URLWithString:@"api/v1/access_token" relativeToURL:baseURL] absoluteString];
    
    NSMutableURLRequest *request = [[self requestSerializer] requestWithMethod:@"POST" URLString:URLString parameters:parameters];
    
    __weak __typeof(self)weakSelf = self;
    NSURLSessionDataTask *authenticationTask = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error)
        {
            if (completion)
            {
                completion(error);
            }
        }
        else
        {
            _accessToken = responseObject[@"access_token"];
            _refreshToken = responseObject[@"refresh_token"];
            [self setBearerAccessToken:_accessToken];
            
            [weakSelf userInfoWithCompletion:^(id object, NSError *error) {
                RKUser *account = [RKObjectBuilder objectFromJSON:@{@"kind": kRKObjectTypeAccount, @"data":object}];
                if (account && !error) {
                    weakSelf.currentUser = account;
                    if (completion)
                    {
                        completion(nil);
                    }
                } else if (completion) {
                    completion(error);
                }
            }];
        }
    }];
    
    [authenticationTask resume];
    
    return authenticationTask;
}

- (NSURLSessionDataTask *)userInfoWithCompletion:(RKObjectCompletionBlock)completion
{
    
    NSURL *baseURL = [[self class] APIBaseLoginURL];
    NSString *URLString = [[NSURL URLWithString:[[self class] meURLPath] relativeToURL:baseURL] absoluteString];
    
    NSMutableURLRequest *request = [[self requestSerializer] requestWithMethod:@"GET" URLString:URLString parameters:@{}];
    
    __weak __typeof(self)weakSelf = self;
    NSURLSessionDataTask *authenticationTask = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (responseObject)
		{
			if (completion)
			{
				completion(responseObject, nil);
			}
		}
		else
		{
			if (completion)
			{
				completion(nil, error);
			}
		}
    }];
    
    [authenticationTask resume];
    
    return authenticationTask;
}

- (NSURLSessionDataTask *)refreshAccessTokenWithCompletion:(RKCompletionBlock)completion
{
    //TODO: implement a token refresh
    return nil;
}

- (BOOL)isSignedIn
{
	return self.modhash != nil || _accessToken != nil;
}


- (void)setBearerAccessToken:(NSString*)accessToken
{
    [[self requestSerializer] setValue:[@"bearer " stringByAppendingString: accessToken] forHTTPHeaderField:@"Authorization"];
}

@end
