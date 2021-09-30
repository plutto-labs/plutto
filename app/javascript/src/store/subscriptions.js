import * as subscriptionsApi from '../api/subscriptions';

const initialState = {
  loading: null,
  error: null,
};

export const mutations = {
  resetState(state) {
    Object.assign(state, initialState);
  },
  setSubscriptionsLoading(state, payload) {
    state.loading = payload;
  },
  setError(state, payload) {
    state.error = payload;
  },
};

export const actions = {
  CREATE_SUBSCRIPTION({ commit }, payload) {
    commit('setSubscriptionsLoading', true);

    return subscriptionsApi.create(payload)
      .catch((err) => {
        commit('setError', err);
      })
      .finally(() => {
        commit('setSubscriptionsLoading', false);
      });
  },

  EDIT_SUBSCRIPTION_TRIAL({ commit }, payload) {
    commit('setSubscriptionsLoading', true);

    return subscriptionsApi.editTrial(payload.id, payload)
      .then((data) => {
        if (data.subscription) commit('setCurrentCustomerSubscription', data.subscription);
      })
      .catch((err) => {
        commit('setError', err);
      })
      .finally(() => {
        commit('setSubscriptionsLoading', false);
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
