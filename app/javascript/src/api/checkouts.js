import { camelizeKeys, decamelizeKeys } from 'humps';
import axios from 'axios';

export function get(token, type) {
  return axios.get(`/api/internal/v1/checkouts/${token}?type=${type}`)
    .then((res) => camelizeKeys(res.data));
}

export function update(token, type, body) {
  return axios.put(`/api/internal/v1/checkouts/${token}?type=${type}`, { record: decamelizeKeys(body) })
    .then((res) => camelizeKeys(res.data));
}
