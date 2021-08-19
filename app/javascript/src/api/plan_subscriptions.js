import { camelizeKeys, decamelizeKeys } from 'humps';
import authedAxios from '../helpers/authed-http';

// eslint-disable-next-line import/prefer-default-export
export function create(customerId, planVersionId) {
  return authedAxios.post('/api/internal/v1/plan_subscriptions', decamelizeKeys({ customerId, planVersionId }))
    .then((res) => camelizeKeys(res.data));
}
