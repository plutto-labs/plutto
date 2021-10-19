import { createStore } from 'vuex';
import createPersistedState from 'vuex-persistedstate';

import analytics from './analytics';
import apiKeys from './api-keys';
import auth from './auth';
import customers from './customers';
import invoices from './invoices';
import meters from './meters';
import permissionGroups from './permission-groups';
import products from './products';
import permissions from './permissions';
import subscriptions from './subscriptions';
import ui from './ui';

const initialState = {
  analytics: analytics.state,
  apiKeys: apiKeys.state,
  auth: auth.state,
  customers: customers.state,
  invoices: invoices.state,
  meters: meters.state,
  permissionGroups: permissionGroups.state,
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
    analytics,
    apiKeys,
    auth,
    customers,
    invoices,
    meters,
    permissionGroups,
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
