 //
//  DetailsViewController.m
//  Flix
//
//  Created by michaelvargas on 6/26/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

// API key: a07e22bc18f5cb106bfe4cc1f83ad8ed

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TrailerViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backdropView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIButton *posterButton;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // now to background image:
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = self.movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    [self.posterView setImageWithURL:posterURL];
    
    // now to get poster image:
    NSString *backdropURLString = self.movie[@"backdrop_path"];
    NSString *fullBackdropURLString = [baseURLString stringByAppendingString:backdropURLString];
    NSURL *backdropURL = [NSURL URLWithString:fullBackdropURLString];
    [self.backdropView setImageWithURL:backdropURL];
    
    self.titleLabel.text = self.movie[@"title"];
    self.dateLabel.text = self.movie[@"release_date"];
    self.synopsisLabel.text = self.movie[@"overview"];

    [self.titleLabel sizeToFit];
    [self.synopsisLabel sizeToFit];
}
- (IBAction)posterTapped:(id)sender {
    [self performSegueWithIdentifier:@"trailerSegue" sender:nil];
}


// #pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     TrailerViewController *trailerViewController = segue.destinationViewController;
     trailerViewController.movieID = self.movie[@"id"];
     
 }

@end
