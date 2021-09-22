import { camelizeKeys, decamelizeKeys } from 'humps';
import authedAxios from '../helpers/authed-http';

// eslint-disable-next-line import/prefer-default-export
export function create(customerId, paymentMethod) {
  return authedAxios.post(
    `/api/internal/v1/customers/${customerId}/payment_methods/`,
    decamelizeKeys({ paymentMethod }),
  ).then((res) => camelizeKeys(res.data));
}

