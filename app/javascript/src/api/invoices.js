import { camelizeKeys } from 'humps';
import authedAxios from '../helpers/authed-http';

// eslint-disable-next-line import/prefer-default-export
export function getInvoices() {
  return authedAxios.get('/api/internal/v1/invoices/')
    .then((res) => camelizeKeys(res.data));
}
