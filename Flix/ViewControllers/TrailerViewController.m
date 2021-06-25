//
//  TrailerViewController.m
//  Flix
//
//  Created by Sebastian Saldana Cardenas on 25/06/21.
//

#import "TrailerViewController.h"
#import <WebKit/WebKit.h>
#import "AFNetworking/AFNetworking.h"


@interface TrailerViewController ()
@property (weak, nonatomic) IBOutlet WKWebView *webkitView;
@property (weak, nonatomic) NSString *urlString;
@property (weak,nonatomic) NSString *trailerId;
@end

@implementation TrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"Loading trailer view...");
    [self fetchTrailer];
    
   
    
}

-(void)fetchTrailer {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US", self.movieId]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               
               self.trailerId = dataDictionary[@"results"][0][@"key"]; // get the trailer id from the returned data
               
               NSString *ytUrl = @"https://www.youtube.com/watch?v=";
               self.urlString = [NSString stringWithFormat:@"%@%@", ytUrl, self.trailerId];
               
               // Convert the url String to a NSURL object.
               NSURL *url = [NSURL URLWithString:self.urlString];

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
