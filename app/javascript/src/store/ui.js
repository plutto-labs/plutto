const initialState = {
  loading: false,
  environment: null,
};

export const mutations = {
  setLoading(state, payload) {
    state.loading = payload;
  },
  setEnvironment(state, payload) {
    state.environment = payload;
  },
};

export const actions = {
  SET_LOADING({ commit }, payload) {
    commit('setLoading', payload);
  },
  SET_ENVIRONMENT({ commit }, payload) {
    commit('setEnvironment', payload);
  },
};

export default {
  state: { ...initialState },
  mutations,
  actions,
};
