import { camelizeKeys, decamelizeKeys } from 'humps';
import authedAxios from '../helpers/authed-http';

export function getPermissions() {
  return authedAxios.get('/api/internal/v1/permissions')
    .then((res) => camelizeKeys(res.data));
}

export function create(payload) {
  return authedAxios.post('/api/internal/v1/permissions', decamelizeKeys(payload))
    .then((res) => camelizeKeys(res.data));
}

export function destroy(id) {
  return authedAxios.delete(`/api/internal/v1/permissions/${id}`)
    .then((res) => camelizeKeys(res));
}
