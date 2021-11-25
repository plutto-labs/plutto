import { camelizeKeys, decamelizeKeys } from 'humps';
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

export function logout() {
  return authedAxios.delete('/api/internal/v1/auth')
    .then((res) => camelizeKeys(res.data));
}

export function signUp(user) {
  return axios.post('/api/internal/v1/sign_up', decamelizeKeys(user))
    .then((res) => camelizeKeys(res.data));
}
