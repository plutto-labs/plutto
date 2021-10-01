import { camelizeKeys, decamelizeKeys } from 'humps';
import authedAxios from '../helpers/authed-http';

export function getProducts() {
  return authedAxios.get('/api/internal/v1/products')
    .then((res) => camelizeKeys(res.data));
}

export function getProduct(id) {
  return authedAxios.get(`/api/internal/v1/products/${id}`)
    .then((res) => camelizeKeys(res.data));
}

export function create(payload) {
  return authedAxios.post('/api/internal/v1/products', decamelizeKeys(payload))
    .then((res) => camelizeKeys(res.data));
}

export function update(id, product) {
  return authedAxios.put(`/api/internal/v1/products/${id}`, decamelizeKeys(product))
    .then((res) => camelizeKeys(res.data));
}

export function destroy(id) {
  return authedAxios.delete(`/api/internal/v1/products/${id}`)
    .then((res) => camelizeKeys(res));
}
