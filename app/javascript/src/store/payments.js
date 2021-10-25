import * as paymentsApi from '../api/payments';

const initialState = {
  payments: [],
  currentPayment: null,
  loading: null,
};

export const mutations = {
  setPayments(state, payload) {
    state.payments = payload;
  },
  setCurrentPayment(state, payload) {
    state.currentPayment = payload;
  },
  resetState(state) {
    Object.assign(state, initialState);
  },
  setPaymentsLoading(state, payload) {
    state.loading = payload;
  },
};

export const actions = {
  GET_PAYMENTS({ commit }) {
    commit('setPaymentsLoading', true);

    return paymentsApi.getPayments()
      .then((data) => {
        if (data.payments) commit('setPayments', data.payments);
      })
      .catch((err) => {
        commit('setError', err);
      })
      .finally(() => {
        commit('setPaymentsLoading', false);
      });
  },
  GET_PAYMENT({ commit }, payload) {
    commit('setPaymentsLoading', true);
    commit('setCurrentPayment', null);

    return paymentsApi.getPayment(payload)
      .then((data) => {
        if (data.payment) commit('setCurrentPayment', data.payment);
      })
      .catch((err) => {
        commit('setError', err);
      })
      .finally(() => {
        commit('setPaymentsLoading', false);
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
