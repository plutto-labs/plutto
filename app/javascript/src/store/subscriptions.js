import * as subscriptionsApi from '../api/subscriptions';

const initialState = {
  loading: null,
};

export const mutations = {
  resetState(state) {
    Object.assign(state, initialState);
  },
  setSubscriptionsLoading(state, payload) {
    state.loading = payload;
  },
};

export const actions = {
  CREATE_SUBSCRIPTION({ commit }, payload) {
    commit('setSubscriptionsLoading', true);

    return subscriptionsApi.create(payload)
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

  END_SUBSCRIPTION({ commit }, payload) {
    commit('setSubscriptionsLoading', true);

    return subscriptionsApi.endSubscription(payload.id)
      .then((data) => {
        if (data.subscription) commit('setCurrentCustomerSubscription', null);
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
