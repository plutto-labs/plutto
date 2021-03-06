import { camelizeKeys, decamelizeKeys } from 'humps';
import authedAxios from '../helpers/authed-http';

export function create(body) {
  return authedAxios.post('/api/internal/v1/subscriptions', decamelizeKeys(body))
    .then((res) => camelizeKeys(res.data));
}

export function editTrial(id, body) {
  return authedAxios.patch(`/api/internal/v1/subscriptions/${id}/edit_trial`, decamelizeKeys(body))
    .then((res) => camelizeKeys(res.data));
}

export function endSubscription(id) {
  return authedAxios.patch(`/api/internal/v1/subscriptions/${id}/end_subscription`)
    .then((res) => camelizeKeys(res.data));
}
