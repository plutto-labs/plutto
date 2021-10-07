import { camelizeKeys, decamelizeKeys } from 'humps';
import authedAxios from '../helpers/authed-http';

export function getPlans() {
  return authedAxios.get('/api/internal/v1/plans')
    .then((res) => camelizeKeys(res.data));
}

export function getPlan(id) {
  return authedAxios.get(`/api/internal/v1/plans/${id}`)
    .then((res) => camelizeKeys(res.data));
}

export function create(payload) {
  return authedAxios.post('/api/internal/v1/plans', decamelizeKeys(payload))
    .then((res) => camelizeKeys(res.data));
}

export function update(id, product) {
  return authedAxios.put(`/api/internal/v1/plans/${id}`, decamelizeKeys(product))
    .then((res) => camelizeKeys(res.data));
}

export function destroy(id) {
  return authedAxios.delete(`/api/internal/v1/plans/${id}`)
    .then((res) => camelizeKeys(res));
}
