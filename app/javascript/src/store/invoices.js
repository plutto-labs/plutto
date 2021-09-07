import * as invoicesApi from '../api/invoices';

const initialState = {
  invoices: [],
  loading: null,
  error: null,
};

export const mutations = {
  setInvoices(state, payload) {
    state.invoices = payload;
  },
  resetState(state) {
    Object.assign(state, initialState);
  },
  setInvoicesLoading(state, payload) {
    state.loading = payload;
  },
  setError(state, payload) {
    state.error = payload;
  },
};

export const actions = {
  GET_INVOICES({ commit }) {
    commit('setInvoicesLoading', true);

    return invoicesApi.getInvoices()
      .then((data) => {
        if (data.invoices) commit('setInvoices', data.invoices);
      })
      .catch((err) => {
        commit('setError', err);
      })
      .finally(() => {
        commit('setInvoicesLoading', false);
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
