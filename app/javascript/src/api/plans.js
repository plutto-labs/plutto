import { camelizeKeys, decamelizeKeys } from 'humps';
import authedAxios from '../helpers/authed-http';

export function getPlans() {
  return authedAxios.get('/api/internal/v1/plans/')
    .then((res) => camelizeKeys(res.data));
}

export function getPlan(id) {
  return authedAxios.get(`/api/internal/v1/plans/${id}`)
    .then((res) => camelizeKeys(res.data));
}

export function create(plan) {
  return authedAxios.post('/api/internal/v1/plans/', decamelizeKeys({ plan }))
    .then((res) => camelizeKeys(res.data));
}

export function update(id, plan) {
  return authedAxios.put(`/api/internal/v1/plans/${id}`, decamelizeKeys(plan))
    .then((res) => camelizeKeys(res.data));
}

export function destroy(id) {
  return authedAxios.delete(`/api/internal/v1/plans/${id}`)
    .then((res) => camelizeKeys(res));
}
