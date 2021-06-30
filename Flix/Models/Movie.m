//
//  Movie.m
//  Flix
//
//  Created by Sebastian Saldana Cardenas on 30/06/21.
//

#import "Movie.h"

@implementation Movie

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];

    self.title = dictionary[@"original_title"];
    self.synopsis = dictionary[@"overview"];
    self.posterPath = dictionary[@"poster_path"];
    self.releaseDate = dictionary[@"release_date"];
    self.movieId = dictionary[@"id"];

    // set hi and low res poster urls
    NSString *lowResURLString = @"https://image.tmdb.org/t/p/w45";
    NSString *highResURLString = @"https://image.tmdb.org/t/p/original";
    NSString *fullLowResPosterURLString = [lowResURLString stringByAppendingString:self.posterPath];
    NSString *fullHighResPosterURLString = [highResURLString stringByAppendingString:self.posterPath];
    self.lowResPosterUrl = [NSURL URLWithString:fullLowResPosterURLString];
    self.hiResPosterUrl = [NSURL URLWithString:fullHighResPosterURLString];
    
    // set backdrop url
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *backdropURLString = dictionary[@"backdrop_path"];
    NSString *fullBackdropURLString = [baseURLString stringByAppendingString:backdropURLString];
    self.backdropURL = [NSURL URLWithString:fullBackdropURLString];
    
    
    return self;
}

+(NSMutableArray*)moviesWithDictionaries:(NSArray *)dictionaries {
    NSMutableArray *arr = [NSMutableArray array];
    for(NSDictionary *dictionary in dictionaries) {
        Movie *movie = [[Movie new] initWithDictionary:dictionary];
        [arr addObject:movie];
    }
    return arr;
}

@end
