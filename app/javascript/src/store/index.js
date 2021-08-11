import { createStore } from 'vuex';

import ui from './ui';

const initialState = {
  ui: ui.state,
};

export default createStore({
  modules: {
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
