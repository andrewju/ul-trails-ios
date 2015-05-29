//
//  ViewController.m
//  UL Trails
//
//  Modifed Tues 10/03/2015
//  Clean code for the new release, version 2.0.
//
//  Modified Fri 20/02/2015
//  Fixed initial domain, replaced with new domain at skynet
//
//  Created by Andrew Ju on 29/06/2014.
//  Copyright (c) 2014 The University of Limerick (UL). All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "Reachability.h"

@interface ViewController ()

@end

@implementation ViewController
NSURL *tURL;
- (void)viewDidLoad
{
    _viewWeb.delegate = (id)self;
    _viewWeb.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [super viewDidLoad];
    //[[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    NSString *fullURL = @"http://www.skynet.ie/~yuki/app/index1.html";
    NSURL *url = [NSURL URLWithString:fullURL];
    tURL = url;
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:tURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
    [_viewWeb loadRequest:requestObj];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [_viewWeb.scrollView addSubview:refreshControl];
    
}
-(void)handleRefresh:(UIRefreshControl *)refresh {
    // Reload my data
    if([[tURL absoluteString] isEqualToString:@"http://www.skynet.ie/~yuki/app/newindex.html"]||[[tURL absoluteString] isEqualToString:@"http://www.skynet.ie/~yuki/app/index1.html"]) {
        if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message"
                                                            message:@"No Internet connection available!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
        }
        else {
            if([[tURL absoluteString] isEqualToString:@"http://www.ularts.org/"])
                tURL = [NSURL URLWithString:@"http://www.skynet.ie/~developer/app/newindex.html"];
            NSURLRequest *requestObj = [NSURLRequest requestWithURL:tURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
            
            [_viewWeb loadRequest:requestObj];}
    }
    else
        ;
    [refresh endRefreshing];
}

- (BOOL)webView:(UIWebView *)theWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = [request URL];
    tURL = url;
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message"
														message:@"No Internet connection available!"
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles: nil];
		[alert show];
    }
    
    if ([[url absoluteString] rangeOfString:@"google"].location != NSNotFound) {
        NSString *tmpURL1 = [[[[[url absoluteString] componentsSeparatedByString: @"?"][1] componentsSeparatedByString:@")"][0] componentsSeparatedByString:@"="][1] componentsSeparatedByString:@"("][0];
        NSString *tmpURL2 = [[[[[[url absoluteString] componentsSeparatedByString: @"?"][1] componentsSeparatedByString:@")"][0] componentsSeparatedByString:@"="][1] componentsSeparatedByString:@"("][1] stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
        
        
        double latitude = [[tmpURL1 componentsSeparatedByString:@","][0] doubleValue];
        double longitude = [[tmpURL1 componentsSeparatedByString:@","][1] doubleValue];
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(latitude, longitude) addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [mapItem setName:tmpURL2];
        [mapItem openInMapsWithLaunchOptions:nil];
        return NO;
    }
    else if ([[url absoluteString] rangeOfString:@"facebook"].location != NSNotFound) {
        NSString *tmpURL = [[url absoluteString] componentsSeparatedByString: @"www."][1];
        NSString *newURL = [@"http://" stringByAppendingString:tmpURL];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:newURL]];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end