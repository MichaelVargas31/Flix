//
//  MoviesViewController.m
//  Flix
//
//  Created by michaelvargas on 6/26/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"    // adds helper functions to UIImageView

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

/* creates private instance variable, automatically creates getter
 and setter methods
 nonatomic = uninteresting right now
 strong = increment reference count of movies, retain count */
@property (nonatomic, strong) NSArray *movies;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            // NSLog(@"%@", dataDictionary);
            
            // this makes it an instance variable of object, instead of
            // local variable NSArray *movies
            self.movies = dataDictionary[@"results"];
//            for (NSDictionary *movie in self.movies) {
//                // NSLog(@"%@", movie[@"title"]);
//            }
            
            [self.tableView reloadData];
            // TODO: Get the array of movies
            // TODO: Store the movies in a property to use elsewhere
            // TODO: Reload your table view data
        }
    }];
    [task resume];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // in java: cell = UITableViewCell()
    // have to manually call init
    // unless you do the bottom:
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    // If you get an error, its because you haven't imported MovieCell.h
    
    NSDictionary *movie = self.movies[indexPath.row];
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"overview"];
    //cell.textLabel.text = movie[@"title"];
    // cell.textLabel.text = [NSString stringWithFormat:@"row: %ld, section: %ld", (long)indexPath.row, indexPath.section];
    
    // now to get images:
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    [cell.posterView setImageWithURL:posterURL];
    
    
    return cell;
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
