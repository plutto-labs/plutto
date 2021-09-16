import { camelizeKeys, decamelizeKeys } from 'humps';
import authedAxios from '../helpers/authed-http';

export function getMeters() {
  return authedAxios.get('/api/internal/v1/meters/')
    .then((res) => camelizeKeys(res.data));
}

export function getMeter(id) {
  return authedAxios.get(`/api/internal/v1/meters/${id}`)
    .then((res) => camelizeKeys(res.data));
}

export function create(meter) {
  return authedAxios.post('/api/internal/v1/meters/', decamelizeKeys({ meter }))
    .then((res) => camelizeKeys(res.data));
}

export function update(id, meter) {
  return authedAxios.put(`/api/internal/v1/meters/${id}`, decamelizeKeys({ meter }))
    .then((res) => camelizeKeys(res.data));
}

export function destroy(id) {
  return authedAxios.delete(`/api/internal/v1/meters/${id}`)
    .then((res) => camelizeKeys(res));
}
