import axios from 'axios';
import { camelizeKeys } from 'humps';

export default function login(email, password) {
  return axios.post('/api/v1/auth.json', { auth: { email, password } })
    .then((res) => camelizeKeys(res.data));
}

