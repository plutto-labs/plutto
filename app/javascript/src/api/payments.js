import { camelizeKeys } from 'humps';
import authedAxios from '../helpers/authed-http';

export function getPayments() {
  return authedAxios.get('/api/internal/v1/payments/')
    .then((res) => camelizeKeys(res.data));
}

export function getPayment(id) {
  return authedAxios.get(`/api/internal/v1/payments/${id}`)
    .then((res) => camelizeKeys(res.data));
}
