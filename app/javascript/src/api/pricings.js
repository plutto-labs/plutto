import { camelizeKeys, decamelizeKeys } from 'humps';
import authedAxios from '../helpers/authed-http';

export function create(productId, pricing) {
  return authedAxios.post(`/api/internal/v1/products/${productId}/pricings`, decamelizeKeys({ pricing }))
    .then((res) => camelizeKeys(res.data));
}

export function update(productId, id, pricing) {
  return authedAxios.put(`/api/internal/v1/products/${productId}/pricings/${id}`, decamelizeKeys({ pricing }))
    .then((res) => camelizeKeys(res.data));
}

export function destroy(productId, id) {
  return authedAxios.delete(`/api/internal/v1/products/${productId}/pricings/${id}`)
    .then((res) => camelizeKeys(res));
}
