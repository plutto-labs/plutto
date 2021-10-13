const initialState = {
  loading: false,
  error: null,
};

export const mutations = {
  setLoading(state, payload) {
    state.loading = payload;
  },
  setError(state, payload) {
    state.error = payload;
  },
};

export const actions = {
  SET_LOADING({ commit }, payload) {
    commit('setLoading', payload);
  },
  CLEAR_ERROR({ commit }) {
    commit('setError', null);
  },
};

export default {
  state: { ...initialState },
  mutations,
  actions,
};
