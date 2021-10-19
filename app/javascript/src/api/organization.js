/* eslint-disable import/prefer-default-export*/
import { camelizeKeys, decamelizeKeys } from 'humps';
import authedAxios from '../helpers/authed-http';

export function update(organization) {
  return authedAxios.put(`/api/internal/v1/organizations/${organization.id}`, decamelizeKeys({ organization }))
    .then((res) => camelizeKeys(res.data));
}
