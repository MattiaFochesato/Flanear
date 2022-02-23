//
//  GMSAutocompleteFilter+Google.h
//  Google Places SDK for iOS
//
//  Copyright 2016 Google LLC
//
//  Usage of this SDK is subject to the Google Maps/Google Earth APIs Terms of
//  Service: https://developers.google.com/maps/terms
//

#import "GMSAutocompleteFilter.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * First-party extensions to GMSAutocompleteFilter, including the ability to return categorical
 * queries.
 */
@interface GMSAutocompleteFilter ()

/**
 * If this is set, the filter will restrict predictions to only individual places, i.e. excluding
 * categorical queries like [pizza in nyc]. The default value of this property is YES; it must
 * explicitly be set to NO for categorical results to be returned.
 */
@property(nonatomic, assign) BOOL restrictToPlaces;

@end

NS_ASSUME_NONNULL_END
