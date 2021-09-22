import * as customersApi from '../api/customers';

const initialState = {
  customers: null,
  currentCustomer: false,
  loading: null,
  error: null,
};

export const mutations = {
  setCustomers(state, payload) {
    state.customers = payload;
  },
  setCurrentCustomer(state, payload) {
    state.currentCustomer = payload;
  },
  addCustomer(state, payload) {
    state.customers.push(payload);
  },
  updateCustomer(state, payload) {
    const index = state.customers.findIndex(customer => customer.id === payload.id);
    if (index !== -1) {
      state.customers.splice(index, 1, payload);
    }
  },
  setCustomersPlanSubscription(state, payload) {
    const customer = state.customers.find(object => object.id === payload.id);
    if (customer) {
      customer.activePlanSubscription = payload.planSubscription;
    }
  },
  removeCustomer(state, payload) {
    const index = state.customers.findIndex(customer => customer.id === payload.id);
    if (index !== -1) {
      state.customers.splice(index, 1);
    }
  },
  resetState(state) {
    Object.assign(state, initialState);
  },
  setCustomersLoading(state, payload) {
    state.loading = payload;
  },
  setError(state, payload) {
    state.error = payload;
  },
};

export const actions = {
  GET_CUSTOMERS({ commit }) {
    commit('setCustomersLoading', true);

    return customersApi.getCustomers()
      .then((data) => {
        if (data.customers) commit('setCustomers', data.customers);
      })
      .catch((err) => {
        commit('setError', err);
      })
      .finally(() => {
        commit('setCustomersLoading', false);
      });
  },
  GET_ACTIVE_CUSTOMERS({ commit }) {
    commit('setCustomersLoading', true);

    return customersApi.getActiveCustomers()
      .then((data) => {
        if (data.customers) commit('setCustomers', data.customers);
      })
      .catch((err) => {
        commit('setError', err);
      })
      .finally(() => {
        commit('setCustomersLoading', false);
      });
  },
  GET_TRIAL_CUSTOMERS({ commit }) {
    commit('setCustomersLoading', true);

    return customersApi.getTrialCustomers()
      .then((data) => {
        if (data.customers) commit('setCustomers', data.customers);
      })
      .catch((err) => {
        commit('setError', err);
      })
      .finally(() => {
        commit('setCustomersLoading', false);
      });
  },
  GET_CUSTOMER({ commit }, payload) {
    commit('setCustomersLoading', true);
    commit('setCurrentCustomer', null);

    return customersApi.getCustomer(payload)
      .then((data) => {
        if (data.customer) commit('setCurrentCustomer', data.customer);
      })
      .catch((err) => {
        commit('setError', err);
      })
      .finally(() => {
        commit('setCustomersLoading', false);
      });
  },
  CREATE_CUSTOMER({ commit }, payload) {
    commit('setCustomersLoading', true);

    return customersApi.create(payload)
      .then((data) => {
        if (data.customer) commit('addCustomer', data.customer);
      })
      .catch((err) => {
        commit('setError', err);
      })
      .finally(() => {
        commit('setCustomersLoading', false);
      });
  },
  UPDATE_CUSTOMER({ commit }, payload) {
    commit('setCustomersLoading', true);

    return customersApi.update(payload.id, payload)
      .then((data) => {
        if (data.customer) commit('updateCustomer', data.customer);
      })
      .catch((err) => {
        commit('setError', err);
      })
      .finally(() => {
        commit('setCustomersLoading', false);
      });
  },
  UPDATE_CUSTOMER_PLAN_SUBSCRIPTION({ commit }, payload) {
    commit('setCustomersPlanSubscription', payload);
  },
  DESTROY_CUSTOMER({ commit }, payload) {
    commit('setCustomersLoading', true);

    return customersApi.destroy(payload.id)
      .then(() => {
        commit('removeCustomer', payload);
      })
      .catch((err) => {
        commit('setError', err);
      })
      .finally(() => {
        commit('setCustomersLoading', false);
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
