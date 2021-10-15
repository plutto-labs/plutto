import * as analyticsApi from '../api/analytics';

const initialState = {
  loading: null,
  error: null,
  customers: {},
  numbers: {},
  subscriptions: {},
  mrr: {},
  arr: {},
};

export const mutations = {
  resetState(state) {
    Object.assign(state, initialState);
  },
  setAnalyticsLoading(state, payload) {
    state.loading = payload;
  },
  setError(state, payload) {
    state.error = payload;
  },
  setCustomersAnalytics(state, payload) {
    state.customers = payload;
  },
  setNumbersAnalytics(state, payload) {
    state.numbers = payload;
  },
  setSubscriptionsAnalytics(state, payload) {
    state.subscriptions = payload;
  },
  setMrrArrAnalytics(state, payload) {
    state.mrr = payload.mrr;
    state.arr = payload.arr;
  },
};

export const actions = {
  GET_CUSTOMERS_ANALYTICS({ commit }, payload) {
    commit('setAnalyticsLoading', true);

    return analyticsApi.customers(payload)
      .then((data) => {
        if (data.data) commit('setCustomersAnalytics', data.data);
      })
      .catch((err) => {
        commit('setError', err);
      })
      .finally(() => {
        commit('setAnalyticsLoading', false);
      });
  },
  GET_NUMBERS_ANALYTICS({ commit }, payload) {
    commit('setAnalyticsLoading', true);

    return analyticsApi.numbers(payload)
      .then((data) => {
        if (data.data) commit('setNumbersAnalytics', data.data);
      })
      .catch((err) => {
        commit('setError', err);
      })
      .finally(() => {
        commit('setAnalyticsLoading', false);
      });
  },
  GET_SUBSCRIPTIONS_ANALYTICS({ commit }, payload) {
    commit('setAnalyticsLoading', true);

    return analyticsApi.subscriptions(payload)
      .then((data) => {
        if (data.data) commit('setSubscriptionsAnalytics', data.data);
      })
      .catch((err) => {
        commit('setError', err);
      })
      .finally(() => {
        commit('setAnalyticsLoading', false);
      });
  },
  GET_MRR_ARR_ANALYTICS({ commit }, payload) {
    commit('setAnalyticsLoading', true);

    return analyticsApi.mrrArr(payload)
      .then((data) => {
        if (data.data) commit('setMrrArrAnalytics', data.data);
      })
      .catch((err) => {
        commit('setError', err);
      })
      .finally(() => {
        commit('setAnalyticsLoading', false);
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
