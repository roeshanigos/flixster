//
//  DetailsViewController.m
//  flixster
//
//  Created by Roesha Nigos on 6/28/18.
//  Copyright © 2018 Roesha Nigos. All rights reserved.
//

#import "DetailsViewController.h"
#import "TrailerViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backdropView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/original/";
    NSString *posterURLString = self.movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    //converting string to url
    NSURL  *posterURL = [NSURL URLWithString:fullPosterURLString];
    [self.posterView setImageWithURL:posterURL];
    NSString *backdropURLString = self.movie[@"backdrop_path"];
    NSString *fullBackdropURLString = [baseURLString stringByAppendingString:backdropURLString];
    NSURL  *backdropURL = [NSURL URLWithString:fullBackdropURLString];
    [self.backdropView setImageWithURL:backdropURL];
    self.titleLabel.text = self.movie[@"title"];
    self.synopsisLabel.text = self.movie[@"overview"];
    [self.titleLabel sizeToFit];
    [self.synopsisLabel sizeToFit];
    //[self performSegueWithIdentifier:@"posterSegue" sender:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
    CGFloat maxHeight = self.synopsisLabel.frame.origin.y+ self.synopsisLabel.frame.size.height;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, maxHeight);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//before we go to the new screen fetching the movie data to be sent to the trailer view controller
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    TrailerViewController *trailerViewController = segue.destinationViewController;
    trailerViewController.movieID = self.movie[@"id"];
}

@end
