import * as planSubscriptionsApi from '../api/plan_subscriptions';

const initialState = {
  loading: null,
  error: null,
};

export const mutations = {
  resetState(state) {
    Object.assign(state, initialState);
  },
  setPlanSubscriptionsLoading(state, payload) {
    state.loading = payload;
  },
  setError(state, payload) {
    state.error = payload;
  },
};

export const actions = {
  CREATE_PLAN_SUBSCRIPTION({ commit }, payload) {
    commit('setPlanSubscriptionsLoading', true);

    return planSubscriptionsApi.create(payload.customerId, payload.planVersionId)
      .catch((err) => {
        commit('setError', err);
      })
      .finally(() => {
        commit('setPlanSubscriptionsLoading', false);
      });
  },

  reset({ commit }) {
    commit('resetState');
  },
};

export default {
  state: { ...initialState },
  mutations,
  actions,
};
