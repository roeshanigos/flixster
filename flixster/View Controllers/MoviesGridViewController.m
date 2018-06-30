//
//  MoviesGridViewController.m
//  flixster
//
//  Created by Roesha Nigos on 6/28/18.
//  Copyright © 2018 Roesha Nigos. All rights reserved.
//

#import "MoviesGridViewController.h"
#import "MovieCollectionCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"

@interface MoviesGridViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate>
@property (nonatomic,strong) NSArray *everyMovies;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *filteredData;


@end

@implementation MoviesGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.searchBar.delegate = self;


    [self fetchMovies];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    
  
    CGFloat postersPerLine = 2;
    CGFloat itemWidth = self.collectionView.frame.size.width/ postersPerLine;
    CGFloat itemHeight = itemWidth * 1.5;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    self.navigationItem.title = @"Movies in Grid View";
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"codepath-logo"] forBarMetrics:UIBarMetricsDefault];
    navigationBar.tintColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1];
    
    NSShadow *shadow = [NSShadow new];
    shadow.shadowColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    shadow.shadowOffset = CGSizeMake(2, 2);
    shadow.shadowBlurRadius = 4;
    navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:22],
                                          NSForegroundColorAttributeName : [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0],
                                          NSShadowAttributeName : shadow};
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)fetchMovies{
    // Start the activity indicator
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
            self.everyMovies = dataDictionary[@"results"];
            self.filteredData = self.everyMovies;
            
            // Get the array of movies *movies will get this results array
            //instance of class movies
            self.everyMovies = dataDictionary[@"results"];
            //reload to show
            [self.collectionView reloadData];
           
            // TODO: Store the movies in a property to use elsewhere
            // call data source methods again
            
        }
    }];
    
    
    [task resume];
}
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MovieCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionCell" forIndexPath:indexPath];
    
    NSDictionary *movie = self.filteredData[indexPath.item];
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

//how many items needed
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filteredData.count;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length != 0) {
        /*NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject[@"title"] containsString:searchText];
        }];
        self.filteredData = [self.everyMovies filteredArrayUsingPredicate:predicate];*/
        // finds string contains and puts it into array that has matching search text data
        self.filteredData = [self.everyMovies filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(title contains[c] %@)", searchText]];
        
        NSLog(@"%@", self.filteredData);
    }
    else {
        self.filteredData = self.everyMovies;
    }
    
    [self.collectionView reloadData];
    
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UICollectionViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
    NSDictionary *movie = self.filteredData[indexPath.row];
    DetailsViewController *detailViewController = [segue destinationViewController];
    detailViewController.movie = movie;
}

@end
