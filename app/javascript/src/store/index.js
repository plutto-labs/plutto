import { createStore } from 'vuex';
import createPersistedState from 'vuex-persistedstate';

import auth from './auth';
import customers from './customers';
import meters from './meters';
import plans from './plans';
import ui from './ui';

const initialState = {
  auth: auth.state,
  customers: customers.state,
  meters: meters.state,
  plans: plans.state,
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
    auth,
    customers,
    meters,
    plans,
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
