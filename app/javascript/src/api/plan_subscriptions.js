import { camelizeKeys, decamelizeKeys } from 'humps';
import authedAxios from '../helpers/authed-http';

export function create(body) {
  return authedAxios.post('/api/internal/v1/plan_subscriptions', decamelizeKeys(body))
    .then((res) => camelizeKeys(res.data));
}

export function editTrial(id, body) {
  return authedAxios.patch(`/api/internal/v1/plan_subscriptions/${id}/edit_trial`, decamelizeKeys(body))
    .then((res) => camelizeKeys(res.data));
}
