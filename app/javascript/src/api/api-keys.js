import authedAxios from '@/helpers/authed-http';
import { camelizeKeys, decamelizeKeys } from 'humps';

export function getApiKeys(params) {
  return authedAxios.get('/api/internal/v1/api_keys', decamelizeKeys({ params }))
    .then((res) => camelizeKeys(res.data));
}

export function create(apiKey) {
  return authedAxios.post('/api/internal/v1/api_keys', decamelizeKeys({ apiKey }))
    .then((res) => camelizeKeys(res.data));
}

export function destroy(id) {
  return authedAxios.delete(`/api/internal/v1/api_keys/${id}`)
    .then((res) => camelizeKeys(res.data));
}
