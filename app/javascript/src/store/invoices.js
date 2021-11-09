import * as invoicesApi from '../api/invoices';

const initialState = {
  invoices: [],
  currentInvoice: null,
  loading: null,
  totalPages: 1,
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
  updateInvoice(state, payload) {
    const index = state.invoices.findIndex(invoice => invoice.id === payload.id);
    if (index !== -1) {
      state.invoices.splice(index, 1, payload);
    }
  },
  setTotalPages(state, payload) {
    state.totalPages = payload;
  },
  setPage(state, payload) {
    state.page = payload;
  },
};

export const actions = {
  GET_INVOICES({ commit }, payload) {
    commit('setInvoicesLoading', true);

    return invoicesApi.getInvoices(payload)
      .then((data) => {
        console.log(data);
        if (data.invoices) commit('setInvoices', data.invoices);
        if (data.headers.xPage) commit('setTotalPages', Math.ceil(data.headers.xTotal / data.headers.xPerPage));
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
  MARK_INVOICE_AS({ commit }, payload) {
    commit('setInvoicesLoading', true);

    return invoicesApi.markInvoiceAs(payload.id, payload.event)
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
