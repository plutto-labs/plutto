import * as invoicesApi from '../api/invoices';

const initialState = {
  invoices: [],
  currentInvoice: null,
  loading: null,
  error: null,
};

export const mutations = {
  setInvoices(state, payload) {
    state.invoices = payload;
  },
  setCurrentInvoice(state, payload) {
    state.currentInvoice = payload;
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
  updateInvoice(state, payload) {
    const index = state.invoices.findIndex(invoice => invoice.id === payload.id);
    if (index !== -1) {
      state.invoices.splice(index, 1, payload);
    }
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
  GET_INVOICE({ commit }, payload) {
    commit('setInvoicesLoading', true);
    commit('setCurrentInvoice', null);

    return invoicesApi.getInvoice(payload)
      .then((data) => {
        if (data.invoice) commit('setCurrentInvoice', data.invoice);
      })
      .catch((err) => {
        commit('setError', err);
      })
      .finally(() => {
        commit('setInvoicesLoading', false);
      });
  },
  CHANGE_INVOICE_STATUS({ commit }, payload) {
    commit('setInvoicesLoading', true);

    return invoicesApi.changeInvoiceStatus(payload.id, payload.event)
      .then((data) => {
        if (data.invoice) {
          commit('setCurrentInvoice', data.invoice);
          commit('updateInvoice', data.invoice);
        }
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
