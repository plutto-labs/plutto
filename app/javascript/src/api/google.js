/* eslint-disable import/prefer-default-export */
/* global google */

import { camelizeKeys } from 'humps';

export function getCoordinates(placeId) {
  const geocoder = new google.maps.Geocoder();

  return new Promise((resolve) => {
    geocoder.geocode({ placeId }, (res, status) => {
      if (status === 'OK') {
        resolve(camelizeKeys(res[0].address_components));
      }
    });
  });
}

export function autocomplete(input) {
  const googleService = new google.maps.places.AutocompleteService();

  return new Promise((resolve) => {
    googleService.getPlacePredictions({
      input, types: ['address'], fields: ['formatted_address', 'geometry'],
    }, (res) => {
      resolve(camelizeKeys(res));
    });
  });
}
