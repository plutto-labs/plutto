import { createStore } from 'vuex';
import createPersistedState from 'vuex-persistedstate';

import apiKeys from './api-keys';
import auth from './auth';
import customers from './customers';
import invoices from './invoices';
import meters from './meters';
import plans from './plans';
import products from './products';
import permissions from './permissions';
import subscriptions from './subscriptions';
import ui from './ui';

const initialState = {
  apiKeys: apiKeys.state,
  auth: auth.state,
  customers: customers.state,
  invoices: invoices.state,
  meters: meters.state,
  plans: plans.state,
  products: products.state,
  permissions: permissions.state,
  subscriptions: subscriptions.state,
  ui: ui.state,
};

const persistedState = createPersistedState({
  key: 'plutto',
  storage: window.localStorage,
  modules: ['auth'],
});

export default createStore({
  plugins: [persistedState],
  modules: {
    apiKeys,
    auth,
    customers,
    invoices,
    meters,
    plans,
    products,
    permissions,
    subscriptions,
    ui,
  },
  mutations: {
    resetState(state) {
      Object.keys(state).forEach(key => {
        Object.assign(state[key], initialState[key]);
      });
    },
  },
});
