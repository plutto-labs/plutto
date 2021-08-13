import { createStore } from 'vuex';
import createPersistedState from 'vuex-persistedstate';

import auth from './auth';
import plans from './plans';
import ui from './ui';
import customers from './customers';

const initialState = {
  auth: auth.state,
  plans: plans.state,
  ui: ui.state,
  customers: customers.state,
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
    plans,
    ui,
    customers,
  },
  mutations: {
    resetState(state) {
      Object.keys(state).forEach(key => {
        Object.assign(state[key], initialState[key]);
      });
    },
  },
});
