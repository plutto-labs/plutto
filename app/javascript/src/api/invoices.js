import { camelizeKeys, decamelizeKeys } from 'humps';
import authedAxios from '../helpers/authed-http';

export function getInvoices() {
  return authedAxios.get('/api/internal/v1/invoices/')
    .then((res) => camelizeKeys(res.data));
}

export function getInvoice(id) {
  return authedAxios.get(`/api/internal/v1/invoices/${id}`)
    .then((res) => camelizeKeys(res.data));
}

export function changeInvoiceStatus(id, event) {
  return authedAxios.patch(`/api/internal/v1/invoices/${id}/change_status`, decamelizeKeys({ event }))
    .then((res) => camelizeKeys(res.data));
}
