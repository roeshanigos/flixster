//
//  MoviesViewController.m
//  flixster
//
//  Created by Roesha Nigos on 6/27/18.
//  Copyright © 2018 Roesha Nigos. All rights reserved.
//
//immedietly calls viewDidLoad


#import "MoviesViewController.h"
#import "MovieCell.h"
//extension adding helper functions
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"

//private methods
@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//reference counting -- increment the reference count of movies -- use strong to hold to movies -- always nonatomic
@property (nonatomic,strong) NSArray *movies;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic,strong) UIRefreshControl *refreshControl;
@end


@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //setting to self >> the view controller object
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    // Do any additional setup after loading the view.

    //gets the function
    [self fetchMovies];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    //target action pair
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self. refreshControl atIndex:0];
    [self.tableView addSubview:self.refreshControl];
    
    self.navigationItem.title = @"Movies";
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"codepath-logo"] forBarMetrics:UIBarMetricsDefault];
    navigationBar.tintColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1];
    
    NSShadow *shadow = [NSShadow new];
    shadow.shadowColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    shadow.shadowOffset = CGSizeMake(2, 2);
    shadow.shadowBlurRadius = 2;
    navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:22],
                                          NSForegroundColorAttributeName : [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0],
                                          NSShadowAttributeName : shadow};
    
}

- (void)fetchMovies{
    // Start the activity indicator
    [self.activityIndicator startAnimating];

    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=858ba4a37f88870ed48c98af4632cf2f"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    // closures and ^{} blocks
    //^(NSData *data, NSURLResponse *response, NSError *error)
    // once the network call is finished calls logic if/else
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]); //will handle this error
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"ERROR"
                                                                           message:@"No Internet Connection!"
                                                                    preferredStyle:(UIAlertControllerStyleAlert)];
            // create a cancel action
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                                     // handle cancel response here. Doing nothing will dismiss the view.
                                                                 }];
            // add the cancel action to the alertController
            [alert addAction:cancelAction];
            
            // create an OK action
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 // handle response here.
                                                             }];
            // add the OK action to the alert controller
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:^{
                // optional code for what happens after the alert controller has finished presenting
            }];
            

        }
        else {
            //if no error do this
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSLog(@"%@", dataDictionary);
            
            // Get the array of movies *movies will get this results array
            //instance of class movies
            self.movies = dataDictionary[@"results"];
            for  (NSDictionary *movie in self.movies) {
                //printing just the titles
                NSLog(@"%@", movie[@"title"]);
            }
            // TODO: Store the movies in a property to use elsewhere
            // call data source methods again
            [self.tableView reloadData];
        }
        [self.activityIndicator stopAnimating];
    }];
    
    //WHY HERE??
    // Stop the activity indicator
    // Hides automatically if "Hides When Stopped" is enabled
    
    [self.refreshControl endRefreshing];
    [task resume];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //asks table view for a movie cell and reuses unused cells to get configued
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    NSDictionary *movie = self.movies[indexPath.row];
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"overview"];

    

    //showing a simplified version into console once table view is scrolled
     //NSLog(@"%@", [NSString stringWithFormat:@"row: %d, section %d", indexPath.row, indexPath.section] ); */
    //cell.textLabel.text = movie[@"title"];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/original/";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL  *posterURL = [NSURL URLWithString:fullPosterURLString];
    //clearing out recycled cells
    cell.posterView.image = nil;
    //[cell.posterView setImageWithURL:posterURL];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:posterURL];
    [cell.posterView setImageWithURLRequest:request placeholderImage:nil
                                    success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
                                        
                                        
                                        // imageResponse will be nil if the image is cached
                                        if (imageResponse) {
                                            NSLog(@"Image was NOT cached, fade in image");
                                            cell.posterView.alpha = 0.0;
                                            cell.posterView.image = image;
                                            
                                            //Animate UIImageView back to alpha 1 over 0.3sec
                                            [UIView animateWithDuration:0.3 animations:^{
                                                cell.posterView.alpha = 1.0;
                                            }];
                                        }
                                        else {
                                            NSLog(@"Image was cached so just update the image");
                                            cell.posterView.image = image;
                                        }
                                    }
                                    failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
                                        // do something for the failure condition
                                    }];
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Change the selected background view of the cell.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    NSDictionary *movie = self.movies[indexPath.row];
    DetailsViewController *detailViewController = [segue destinationViewController];
    detailViewController.movie = movie;
}


@end
