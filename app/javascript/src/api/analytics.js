import authedAxios from '@/helpers/authed-http';
import { camelizeKeys } from 'humps';

export function customers() {
  return authedAxios.get('/api/internal/v1/analytics/customers')
    .then((res) => camelizeKeys(res.data));
}

export function numbers() {
  return authedAxios.get('/api/internal/v1/analytics/numbers')
    .then((res) => camelizeKeys(res.data));
}

export function subscriptions(params) {
  return authedAxios.get(`/api/internal/v1/analytics/subscriptions/${params.currency}`)
    .then((res) => camelizeKeys(res.data));
}

export function mrrArr(params) {
  return authedAxios.get(`/api/internal/v1/analytics/mrr_and_arr/${params.currency}`)
    .then((res) => camelizeKeys(res.data));
}
