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
//private methods
@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//reference counting -- increment the reference count of movies -- use strong to hold to movies -- always nonatomic
@property (nonatomic,strong) NSArray *movies;

@end

//implementation
@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //setting to self >> the view controller object
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    // Do any additional setup after loading the view.
    
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=858ba4a37f88870ed48c98af4632cf2f"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
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
    }];
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
