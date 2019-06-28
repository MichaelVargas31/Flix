//
//  TrailerViewController.m
//  Flix
//
//  Created by michaelvargas on 6/27/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import "TrailerViewController.h"

@interface TrailerViewController ()
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) NSDictionary *videoInfoDictionary;



@end


@implementation TrailerViewController

@synthesize movieID;    // from internet(?)


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"Your movie ID is %@", movieID);
    
    [self fetchMovieInformation];
    
    NSString *baseURLString = @"https://www.youtube.com/watch?v=\";
    NSString *videoKeyURLString = self.movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    
    
}
- (IBAction)doneButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void) fetchMovieInformation{
    // build the URL
    NSString *baseURLString = @"https://api.themoviedb.org/3/movie/";
    // already have movieID
    NSString *firstHalf = [baseURLString stringByAppendingString:movieID];
    NSString *restURLString = @"/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US";
    NSString *fullTrailerURLString = [firstHalf stringByAppendingString:restURLString];
    
    NSLog(@"url = %@", fullTrailerURLString);
    NSURL *trailerURL = [NSURL  URLWithString:fullTrailerURLString];
    
    // NSURL *url = [NSURL URLWithString:@"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV"];
    NSURLRequest *request = [NSURLRequest requestWithURL:trailerURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            // TODO: Get the posts and store in posts property
            // TODO: Reload the table view
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
