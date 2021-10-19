import { camelizeKeys, decamelizeKeys } from 'humps';
import authedAxios from '../helpers/authed-http';

export function getPermissionGroups() {
  return authedAxios.get('/api/internal/v1/permission_groups')
    .then((res) => camelizeKeys(res.data));
}

export function getPermissionGroup(id) {
  return authedAxios.get(`/api/internal/v1/permission_groups/${id}`)
    .then((res) => camelizeKeys(res.data));
}

export function create(payload) {
  return authedAxios.post('/api/internal/v1/permission_groups', decamelizeKeys(payload))
    .then((res) => camelizeKeys(res.data));
}

export function update(id, product) {
  return authedAxios.put(`/api/internal/v1/permission_groups/${id}`, decamelizeKeys(product))
    .then((res) => camelizeKeys(res.data));
}

export function destroy(id) {
  return authedAxios.delete(`/api/internal/v1/permission_groups/${id}`)
    .then((res) => camelizeKeys(res));
}
