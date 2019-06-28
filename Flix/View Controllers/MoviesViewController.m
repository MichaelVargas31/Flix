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
#import "DetailsViewController.h"

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

// data is actually movies
// @property (nonatomic, strong) NSArray *data;
@property (strong, nonatomic) NSArray *filteredMovies;
@property (weak, nonatomic) IBOutlet UISearchBar *movieSearchBar;
/* creates private instance variable, automatically creates getter
 and setter methods
 strong = increment reference count of movies, retain count */
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.activityIndicator startAnimating];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.movieSearchBar.delegate = self;
    
    [self fetchMovies];
    
    self.filteredMovies = self.movies;
    
    // setup UIRefreshControl, allocating and initializing object
    self.refreshControl = [[UIRefreshControl alloc] init];
    // for ~myself~, when the ControlEventValueChanges, call fetchMovies
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    // add to tableview
    // [self.tableView addSubview:self.refreshControl];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
            
//            NSDictionary *movie = self.movies[indexPath.row];
//            cell.titleLabel.text = movie[@"title"];
            // NSLog(@"%@", evaluatedObject);
            //NSDictionary *filteredMovies = self.movies[???];
            //NSString *movieTitle = filteredMovies[@"title"];
            NSLog(@"%@", evaluatedObject[@"title"]);
            return [evaluatedObject[@"title"] containsString:searchText];
            // cant do containsString with an object, so you have to get the title from the object
        }];
        self.filteredMovies = [self.movies filteredArrayUsingPredicate:predicate];
        
        NSLog(@"---------\n%@", self.filteredMovies);

    }
    else {
        self.filteredMovies = self.movies;
    }
    
    [self.tableView reloadData];
}


- (void)fetchMovies{
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            NSLog(@"You need internet connection my dude");
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Encountered an unexpected error. Check network connection and retry." preferredStyle:(UIAlertControllerStyleAlert)];
            
//            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                // handle cancel response here. Doing nothing will dismiss the view.
//            }];
            UIAlertAction *refreshAction = [UIAlertAction actionWithTitle:@"Refresh" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // handle response here.
                NSLog(@"Refresh here");
                [self fetchMovies];
            }];
            
            // [alert addAction:cancelAction];
            [alert addAction:refreshAction];
            
            [self presentViewController:alert animated:YES completion:^{
                // optional code for what happens after the alert controller has finished presenting
            }];
            
            
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
            self.filteredMovies = self.movies;
            [self.tableView reloadData];
            // TODO: Get the array of movies
            // TODO: Store the movies in a property to use elsewhere
            // TODO: Reload your table view data
            [self.activityIndicator stopAnimating];
        }
        [self.refreshControl endRefreshing];
    }];
    [task resume];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredMovies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // in java: cell = UITableViewCell()
    // have to manually call init
    // unless you do the bottom:
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    // If you get an error, its because you haven't imported MovieCell.h
    
    NSDictionary *movie = self.filteredMovies[indexPath.row];
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"overview"];
    //cell.textLabel.text = movie[@"title"];
    // cell.textLabel.text = [NSString stringWithFormat:@"row: %ld, section: %ld", (long)indexPath.row, indexPath.section];
    
    // now to get images:
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    // set it to nill so that its blank before it takes a second to load.
    cell.posterView.image = nil;
    [cell.posterView setImageWithURL:posterURL];
    
    
    return cell;
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"Tap tap tap");
    
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    NSDictionary *movie = self.movies[indexPath.row];
    
    // [segue ...] returns a view controller, left side of equation
    // casts it to a DetailsViewController
    DetailsViewController *detailsViewController = [segue destinationViewController];
    
    detailsViewController.movie = movie;

    
    
}


@end
