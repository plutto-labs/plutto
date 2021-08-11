import { createStore } from 'vuex';

import auth from './auth';
import ui from './ui';

const initialState = {
  auth: auth.state,
  ui: ui.state,
};

export default createStore({
  modules: {
    auth,
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
