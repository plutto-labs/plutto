import { createStore } from 'vuex';
import createPersistedState from 'vuex-persistedstate';

import apiKeys from './api-keys';
import auth from './auth';
import customers from './customers';
import meters from './meters';
import plans from './plans';
import planSubscriptions from './plan_subscriptions';
import ui from './ui';

const initialState = {
  apiKeys: apiKeys.state,
  auth: auth.state,
  customers: customers.state,
  meters: meters.state,
  plans: plans.state,
  planSubscriptions: planSubscriptions.state,
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
    meters,
    plans,
    planSubscriptions,
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
