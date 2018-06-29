//
//  TrailerViewController.m
//  flixster
//
//  Created by Roesha Nigos on 6/29/18.
//  Copyright © 2018 Roesha Nigos. All rights reserved.
//

#import "TrailerViewController.h"
#import <WebKit/WebKit.h>

@interface TrailerViewController ()
@property (weak, nonatomic) IBOutlet WKWebView *webkitView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@end

@implementation TrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.trailerWebkitView.userInteractionEnabled = YES;
   //[self.trailerWebkitView addGestureRecognizer: self.tapGesture];

    [self fetchTrailers];
    
  
}



-(void)fetchTrailers {
    //NSString *requestURLString = [NSString stringWithFormat:"@"]
    NSString *trailerURLString = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@/videos?api_key=858ba4a37f88870ed48c98af4632cf2f&language=en-US", self.movieID ];
    
    NSURL *url = [NSURL URLWithString:trailerURLString];
    
    //Place the URL in a URL Request >> sending a request
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    //set up session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    // closures and ^{} blocks
    //^(NSData *data, NSURLResponse *response, NSError *error)
    // once the network call is finished calls logic if/else
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]); //will handle this error
        }
        else {
            //if no error do this
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *trailers = dataDictionary[@"results"][0];
            NSString *ytURL = [NSString stringWithFormat:@"https://www.youtube.com/watch?v="];
            NSString *trailerAddress = [ytURL stringByAppendingString:trailers[@"key"]];
            
            
            // Convert the url String to a NSURL object.
            NSURL *url = [NSURL URLWithString:trailerAddress];
            
            // Place the URL in a URL Request.
            NSURLRequest *request = [NSURLRequest requestWithURL:url
                                                     cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                 timeoutInterval:10.0];
            // Load Request into WebView.
            [self.webkitView loadRequest:request];
            
        }
    }];
    [task resume];
}
    


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButton:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
