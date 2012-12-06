#import <objc/runtime.h>
#import <Installous/SelectDownloadTableViewController.h>
#import <Installous/APILink.h>
#import <Installous/APILinkResponse.h>
#import <Installous/APILinkRequest.h>
#import <Installous/APIResponse.h>
#import <Installous/APIApplication.h>
#import <Installous/APICategory.h>
#import <substrate.h>
#import <JSONKit.h>
#import <Installous/APIApplicationListResponse.h>
#import <Installous/APIApplicationListRequest.h>
#import <Installous/APIApplicationListItem.h>

#include <stdlib.h>
/* How to Hook with Logos
 Hooks are written with syntax similar to that of an Objective-C @implementation.
 You don't need to #include <substrate.h>, it will be done automatically, as will
 the generation of a class list and an automatic constructor.
 */

/*%hook InstallousAppDelgate_iPad 
-(BOOL)application:(id)application didFinishLaunchingWithOptions:(id)options {
    NSLog(@"WESTARTED UPBITHEZ");
    return %orig(application, options);
}
%end
*/

%hook UIWebView

-(void) webViewDidFinishLoad:(UIWebView*)webView {
    NSString *currentURL = [webView stringByEvaluatingJavaScriptFromString:@"window.location.href"];
    NSLog(@"CURRENT URL BRAH %@", currentURL);
    NSRange 
}
%end

%hook ApptrackrAPIInternalBackendInterface
/*
// Hooking a class method
+ (id)sendRequest: (id)request {
    NSString *dastring = (NSString *)request;
    NSDictionary* json = [dastring objectFromJSONString];
    NSLog(@"apptrackr json: %@", json);
    NSDictionary* args = (NSDictionary*)[json objectForKey:@"args"];
    //urlencode
    NSString* search = (NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                           NULL,
                                                                           (CFStringRef)[args objectForKey:@"search"],
                                                                           NULL,
                                                                           (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                           kCFStringEncodingUTF8);
    if (search != nil) {
        NSLog(@"apptrackr json search string: %@", search);
        NSString *urlString = [NSString stringWithFormat:@"http://itunes.apple.com/search?term=%@&entity=software", search];
        NSLog(@"url stringGG!!!! %@", urlString);
        //request to iTunes
        NSMutableURLRequest *iTunesRequest = [[NSMutableURLRequest alloc] init];
        [iTunesRequest setURL:[NSURL URLWithString:urlString]];
        NSURLResponse *response;
        NSError* error = nil;
        NSData* result = [NSURLConnection sendSynchronousRequest:iTunesRequest returningResponse:&response error:&error];
        
        NSString* bleh = [[[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding] autorelease];
        if (bleh == nil) {
            return [NSString stringWithFormat:@"{\"code\": 404}"];
        }
        NSDictionary* iTunesJson = [bleh objectFromJSONString];
        NSLog(@"ITUNES JSON");
        NSArray *iTunesResults = [iTunesJson objectForKey:@"results"];
        NSLog(@"whooer");
        NSMutableArray *apps = [[NSMutableArray alloc] init];
        for (NSDictionary* dict in iTunesResults) {
            NSNumber *appid = [dict objectForKey:@"trackId"];
            NSString *appname = [dict objectForKey:@"trackName"];
            NSString *version = [dict objectForKey:@"version"];
            NSString *seller = [dict objectForKey:@"sellerName"];
            NSNumber *deviceid;
            NSNumber *universal;
            if ([dict objectForKey:@"ipadScreenshotUrls"] == nil) {
                deviceid = [NSNumber numberWithInt:1];
                universal = [NSNumber numberWithInt:0];
            }
            else if ([dict objectForKey:@"iphoneScreenshotUrls"] == nil) {
                deviceid = [NSNumber numberWithInt:1];
                universal = [NSNumber numberWithInt:0];
            }
            else {
                deviceid = [NSNumber numberWithInt:1];
                universal = [NSNumber numberWithInt:1];
            }
        
            //lol
            NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
            // NSTimeInterval is defined as double
            NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
        
           
            NSString *icon57 = [dict objectForKey:@"artworkUrl60"];
            NSString *icon75 = [dict objectForKey:@"artworkUrl512"];
            NSString *icon100 = [dict objectForKey:@"artworkUrl512"];
            NSArray *keys = [NSArray arrayWithObjects:@"id", @"add_date", @"last_modification", @"name", @"seller", @"category", @"latest_version", @"icon75", @"icon100", @"icon57", @"deviceid", @"universal", @"appleIcon75", @"appleIcon57", @"appleIcon100", nil];
            NSArray *objs = [NSArray arrayWithObjects: appid, timeStampObj, timeStampObj, appname, seller, [NSNumber numberWithInt:1], version, icon75, icon100, icon57, deviceid, universal, icon75, icon57, icon100, nil];
            NSMutableDictionary *appinfo = [[NSMutableDictionary alloc] initWithObjects:objs forKeys:keys];
            [apps addObject: appinfo];
        }
        NSDictionary *kimdata = [[NSDictionary alloc] initWithObjectsAndKeys:apps, @"apps", nil];
        NSString *kimjson = [kimdata JSONString];
        NSDictionary *kimjong = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:200], @"code", kimjson, @"data", nil];
        //NSLog(@"kim jong likes it %@", kimjong);
        NSLog(@"hello %@", kimjong);
        NSString *kimilsung = [kimjong JSONString];
        NSLog(@"recreated json %@", kimilsung);
        NSLog(@"request %@" , request);
        return [NSString stringWithFormat:@"{\"code\": 404}"];
    }
    else {
        id data = %orig(request);
    
        NSLog(@"data %@", data);
        return data; 
    }
}
*/

+(id)checkUpdates:(id)updates {
    NSLog(@"update array bro: %@", updates);
    id data = %orig;
    NSLog(@"datatata %@", data);
    return data;
}

+(id)getApplicationListWithRequest:(id)request {
    APIApplicationListResponse* laresponse = [[objc_getClass("APIApplicationListResponse") alloc] init];
    laresponse.responseCode = 404;
    //NSLog(@"PAOEIR0EI4903849049034903908 REQUEST %@", request);
    APIApplicationListRequest* kRequest = (APIApplicationListRequest*) request;
    NSString* search;
    NSRange whiteSpaceRange = [kRequest.searchString rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
    if (whiteSpaceRange.location != NSNotFound) {
        search = (NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                     NULL,
                                                                     (CFStringRef)kRequest.searchString,
                                                                     NULL,
                                                                     (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                     kCFStringEncodingUTF8);
    }
    else {
        search = kRequest.searchString;
    }
    if (search != nil) {
        NSLog(@"search string: %@", search);
        NSString *urlString = [NSString stringWithFormat:@"http://itunes.apple.com/search?term=%@&entity=software&limit=30", search];
        //NSLog(@"url stringGG!!!! %@", urlString);
        //request to iTunes
        NSMutableURLRequest *iTunesRequest = [[NSMutableURLRequest alloc] init];
        [iTunesRequest setURL:[NSURL URLWithString:urlString]];
        NSURLResponse *response;
        NSError* error = nil;
        NSData* result = [NSURLConnection sendSynchronousRequest:iTunesRequest returningResponse:&response error:&error];
        
        NSString* bleh = [[[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding] autorelease];
        if (bleh == nil) {
            return laresponse;
        }
        NSDictionary* iTunesJson = [bleh objectFromJSONString];
        if ([[iTunesJson objectForKey:@"resultCount"] intValue] == 0) {
            return laresponse;    
        }
       // NSLog(@"ITUNES JSON");
        NSArray *iTunesResults = [iTunesJson objectForKey:@"results"];
       // NSLog(@"whooer");
        //NSLog(@"resultcount %@", [iTunesJson objectForKey:@"resultCount"]);
        unsigned pages = ceil([[iTunesJson objectForKey:@"resultCount"] intValue]/15);
        if (pages < 1) {
            NSLog(@"pages: %@", pages);
            pages = 1;
        }
        NSMutableArray *apps = [[NSMutableArray alloc] init];
        for (NSDictionary* dict in iTunesResults) {
            APIApplicationListItem* item = [[objc_getClass("APIApplicationListItem") alloc] init];
            item.applicationID = [[dict objectForKey:@"trackId"] intValue];
            item.name = [dict objectForKey:@"trackName"];
            item.latestVersion = [dict objectForKey:@"version"];
            item.seller = [dict objectForKey:@"sellerName"];
            if ([dict objectForKey:@"ipadScreenshotUrls"] == nil) {
                item.deviceID = 1;
                item.universal =  FALSE;
            }
            else if ([dict objectForKey:@"iphoneScreenshotUrls"] == nil) {
                item.deviceID = 1;
                item.universal = FALSE;
            }
            else {
                item.deviceID = 1;
                item.universal = FALSE;
            }
            
            //lo
            NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
            // NSTimeInterval is defined as double
            item.dateAdded = [[NSNumber numberWithDouble: timeStamp] intValue];
            item.lastModified = item.dateAdded;
            item.category = 1;
            item.iconURL = [dict objectForKey:@"artworkUrl60"];
//            NSString *icon75 = [dict objectForKey:@"artworkUrl512"];
//            NSString *icon100 = [dict objectForKey:@"artworkUrl512"];
            
            
           /* NSArray *keys = [NSArray arrayWithObjects:@"id", @"add_date", @"last_modification", @"name", @"seller", @"category", @"latest_version", @"icon75", @"icon100", @"icon57", @"deviceid", @"universal", @"appleIcon75", @"appleIcon57", @"appleIcon100", nil];
            NSArray *objs = [NSArray arrayWithObjects: appid, timeStampObj, timeStampObj, appname, seller, [NSNumber numberWithInt:1], version, icon75, icon100, icon57, deviceid, universal, icon75, icon57, icon100, nil];
            NSMutableDictionary *appinfo = [[NSMutableDictionary alloc] initWithObjects:objs forKeys:keys];*/
            [apps addObject: item];
        }
        //wrap it up
        APIApplicationListResponse* laresponse = [[objc_getClass("APIApplicationListResponse") alloc] init];
        laresponse.responseCode = 200;
        laresponse.applicationList = apps;
        //NSLog(@"lol cool haha  %@", laresponse);
        //NSLog(@"yayy!! AAA %@", laresponse.applicationList);
        laresponse.numberOfPages = pages;
        //APIApplicationListResponse* laaresponse = [[objc_getClass("APIApplicationListResponse") alloc] init];
        return laresponse;

    }
    else {
        return %orig;
    }

}
%end
/*
%hook APILinkRequest
+(id)requestWithApplicationID:(unsigned)applicationID displayAllVersions:(BOOL)versions {
    id data = %orig(applicationID, versions);
    NSLog(@"request with app id: data %@", data);
    return data;
}
-(id)requestString {
    id data = %orig;
    NSLog(@"requeststring data: %@", data);
    return data;
}

%end

%hook APIApplication
-(void)downloadLinks {
    NSLog(@"DOWNLOAD LINKS %@", self.downloadLinksVersionDictionary);
}
+(id)applicationForID:(unsigned)anId {
    NSString *iconURL = MSHookIvar<NSString*>(self, "_iconURL"); 
    iconURL = @"https://lh6.googleusercontent.com/-xGEK0oY6XmA/AAAAAAAAAAI/AAAAAAAAAA8/3vLa1BUQh0k/s250-c-k/photo.jpg";
    return %orig; 
}
%end

%hook SelectDownloadTableViewController

// Hooking a class method
NSMutableDictionary* dict;
NSMutableArray* array;
/*-(void)doneLoadingDownloadLinks {
    NSLog(@"done loading download links, injecting");
    for (id ver in self.versionsArray) {
        NSLog(@"version: %@", ver);
    }
    NSDictionary *lolz = [self.linksDictionary copy];
    dict = [[NSMutableDictionary alloc] init];
    [dict addEntriesFromDictionary:lolz];
    array = [[NSMutableArray alloc] init];
    [array addEntriesFromArray: self.versionsArray];
    [array addObject: @"2.4.0"];
    
    APILink* link = [[objc_getClass("APILink") alloc] init];
    link.version = @"2.4.0";
    link.URL = @"http://slingfile.com/lolthisifaek";
    link.fileHoster = @"slingfile.com";
    link.linkID = 398329664;
    link.cracker = @"ttwj";
    link.active = TRUE;
    
    NSArray *array = [NSArray arrayWithObjects:link, nil];
    [dict setObject:array forKey:@"4.3"];
    

    for (id ver in self.versionsArray) {
        NSLog(@"version: %@", ver);
    }
    for (NSString* key in self.linksDictionary) {
        NSArray* array = [self.linksDictionary objectForKey:key];
        for (APILink *link in array) {
            NSLog(@"2we found a link!");
            NSLog(@"2version %@",link.version);
            NSLog(@"2url %@", link.URL);
            //%@, %@, %@, %@, %@, %@", link.version, link.URL, link.fileHoster, link.packageType, link.linkID, link.cracker, link.applicationID, link.active);
        }
        
    }

    %orig;
    [lolz release];
}

-(void)doneLoadingDownloadLinks {
    NSLog(@"done loading hi!!!");
    %orig;
}
-(void)loadDownloadLinks {
    %orig;
    NSLog(@"hi");
    NSLog(@"links %@", self.linksDictionary);
    for (NSString* key in self.linksDictionary) {
        NSArray* array = [self.linksDictionary objectForKey:key];
        for (APILink *link in array) {
            NSLog(@"we found a link!");
            NSLog(@"version %@",link.version);
            NSLog(@"url %@", link.URL);
            NSLog(@"filehost %@", link.fileHoster);
            NSLog(@"packagetype %@", link.packageType);
            //%@, %@, %@, %@, %@, %@", link.version, link.URL, link.fileHoster, link.packageType, link.linkID, link.cracker, link.applicationID, link.active);
        }
        
    }
}
%end

/*
// Hooking an instance method with an argument.
 - (void)messageName:(int)argument {
 %log; // Write a message about this call, including its class, name and arguments, to the system log.
 
 %orig; // Call through to the original function with its original arguments.
 %orig(nil); // Call through to the original function with a custom argument.
 
 // If you use %orig(), you MUST supply all arguments (except for self and _cmd, the automatically generated ones.)
 }
 
 // Hooking an instance method with no arguments.
 - (id)noArguments {
 %log;
 id awesome = %orig;
 [awesome doSomethingElse];
 
 return awesome;
 }
 
 // Always make sure you clean up after yourself; Not doing so could have grave consequences!
 */
 
%hook ApptrackrAPI 
+(id)getLinksWithRequest:(id)request {
    
    bool ipastorefail = FALSE, installousfail = FALSE;
    
    APIApplicationListResponse* failResponse = [[objc_getClass("APIApplicationListResponse") alloc] init];
    failResponse.responseCode = 404;
    
    //NSArray* crackers = [[NSArray alloc] initWithObjects:@"Snuupy", @"ttwj", @"Kim-Jong-Un", @"TheSexyPenguin", @"qwertyoruip", @"Hexagon", @"lyetz", @"pendo324", @"Splintr", nil];
    NSLog(@"links request %@", request);
    
    APILinkRequest* linkRequest = (APILinkRequest*) request;
    NSString *urlString = [NSString stringWithFormat:@"http://ipastore.me/links.php?itunesid=%u", linkRequest.applicationID];
    NSLog(@"YOLO URL STRING === YOLO %@", urlString);
    NSMutableURLRequest *IPAStoreRequest = [[NSMutableURLRequest alloc] init];
    
    [IPAStoreRequest setURL:[NSURL URLWithString:urlString]];
    NSData* result = [NSURLConnection sendSynchronousRequest:IPAStoreRequest returningResponse:nil error:nil];
    
    NSString* bleh = [[[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding] autorelease];
    if (bleh == nil) {
        ipastorefail = TRUE;
    }
    NSDictionary* IPAStoreJSON = [bleh objectFromJSONString];
    NSArray* linksArray = [IPAStoreJSON objectForKey:@"Links"];
    if ([linksArray count] == 0) {
        ipastorefail = TRUE;    
    }
    else {
        NSLog(@"yolo fat SWAG MAGIC %@", linksArray);
    }
    
    id data = %orig(request);
    APILinkResponse* response = (APILinkResponse*) data;
    NSLog(@"dataarer DATA %@", response.versionsArray);
    APIResponse* apiResponse = (APIResponse*) data;
    NSLog(@"responsecode: %d", apiResponse.responseCode);
    
    //check if both failed, don't waste time injecting the stuff
    if (apiResponse.responseCode != 200) {
        installousfail = TRUE;
    }
   
    
    //modified dictionary to return    
    /*for (NSString* key in response.linksDictionary) {
        NSMutableArray* array = [response.linksDictionary objectForKey: key];
        NSMutableArray* coolarray = [[NSMutableArray alloc] init];
        for (APILink* link in array) {
            int i = arc4random() % 8;
            link.cracker = [NSString stringWithFormat:@"%@ (Kim-Jong-Cracks)",[crackers objectAtIndex: i]];
            //[array removeObject: link];
            [coolarray addObject: link];
            
        }
        [cooldict setObject: coolarray forKey: key];
        
    }*/
    
    //response.linksDictionary = cooldict;

    for (NSDictionary* linkData in linksArray) {
        
        APILink* link = [[objc_getClass("APILink") alloc] init];
        NSLog(@"#### YOLO CREATING LINK ###");
        link.version = [linkData objectForKey:@"fld_version_id"];
        link.URL = [linkData objectForKey:@"fld_url"];
        link.fileHoster = [linkData objectForKey:@"fld_download_link"];
        //link.linkID = 
        link.applicationID = linkRequest.applicationID;
        link.cracker = [linkData objectForKey:@"fld_cracker"];
        link.packageType = @"ipa";
        link.active = TRUE;
        
        if (![response.versionsArray containsObject:link.version]) {
            NSLog(@"BLUE PILL");
            [response.versionsArray addObject:link.version];
            NSMutableArray *linksDictionaryArray = [[NSMutableArray alloc] init];
            [linksDictionaryArray addObject:link];
            [response.linksDictionary setObject: linksDictionaryArray forKey:link.version];
        }
        else {
            NSLog(@"RED PILL");
            NSMutableArray* linksDictionaryArray = [response.linksDictionary objectForKey:link.version];
            [linksDictionaryArray addObject:link]; 
            [response.linksDictionary removeObjectForKey:link.version];
            [response.linksDictionary setObject:linksDictionaryArray forKey: link.version];
        }
        
        
    }
   /* NSMutableArray *array = [[NSMutableArray alloc] init];
    
    APILink* link = [[objc_getClass("APILink") alloc] init];
    
    link.version = @"2.4.0";
    link.URL = @"http://www.slingfile.com/file/4i5Q4N284G/9780425247549_Kiss_the_Dead.epub";
    link.fileHoster = @"ttwj.in";
    link.linkID = 398329664;
    link.applicationID = 453051448;
    link.cracker = @"ttwj";
    link.packageType = @"ipa";
    link.active = TRUE;
    
    [array addObject: link];
    [response.linksDictionary setObject:array forKey: link.version];
    [response.versionsArray addObject:link.version];
    NSLog(@"current versions: %@", response.versionsArray);
    
    [array release];
    [link release];
    NSLog(@"data request %@",response.linksDictionary);
    NSLog(@"hi hhh");
     */
    return (id) response;

}
%end

/*
%hook APICategory
+(id)allCategories:(id*)categories {
    NSString *iconURL = MSHookIvar<NSString*>(self, "_iconURL"); 
    iconURL = @"https://lh6.googleusercontent.com/-xGEK0oY6XmA/AAAAAAAAAAI/AAAAAAAAAA8/3vLa1BUQh0k/s250-c-k/photo.jpg";
    return %orig;
}
     

%end
     */


