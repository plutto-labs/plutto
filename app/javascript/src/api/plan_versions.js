import { camelizeKeys, decamelizeKeys } from 'humps';
import authedAxios from '../helpers/authed-http';

export function create(planId, planVersion) {
  return authedAxios.post(`/api/internal/v1/plans/${planId}/plan_versions`, decamelizeKeys({ planVersion }))
    .then((res) => camelizeKeys(res.data));
}

export function update(planId, id, planVersion) {
  return authedAxios.put(`/api/internal/v1/plans/${planId}/plan_versions/${id}`, decamelizeKeys({ planVersion }))
    .then((res) => camelizeKeys(res.data));
}

export function destroy(planId, id) {
  return authedAxios.delete(`/api/internal/v1/plans/${planId}/plan_versions/${id}`)
    .then((res) => camelizeKeys(res));
}
