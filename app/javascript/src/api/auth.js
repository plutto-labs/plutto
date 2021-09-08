import { camelizeKeys } from 'humps';
import axios from 'axios';
import authedAxios from '../helpers/authed-http';

export function login(email, password) {
  return axios.post('/api/internal/v1/auth.json', { auth: { email, password } })
    .then((res) => camelizeKeys(res.data));
}

export function getUser(id) {
  return authedAxios.get(`/api/internal/v1/users/${id}`)
    .then((res) => camelizeKeys(res.data));
}
