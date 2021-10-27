import { camelizeKeys, decamelizeKeys } from 'humps';
import authedAxios from '../helpers/authed-http';

export function getCustomers(filter) {
  return authedAxios.get(`/api/internal/v1/customers?filter=${filter}`)
    .then((res) => camelizeKeys(res.data));
}

export function getCustomer(id) {
  return authedAxios.get(`/api/internal/v1/customers/${id}`)
    .then((res) => camelizeKeys(res.data));
}

export function create(customer) {
  return authedAxios.post('/api/internal/v1/customers/', decamelizeKeys({ customer }))
    .then((res) => camelizeKeys(res.data));
}

export function update(id, customer) {
  return authedAxios.put(`/api/internal/v1/customers/${id}`, decamelizeKeys({ customer }))
    .then((res) => camelizeKeys(res.data));
}

export function destroy(id) {
  return authedAxios.delete(`/api/internal/v1/customers/${id}`)
    .then((res) => camelizeKeys(res));
}
