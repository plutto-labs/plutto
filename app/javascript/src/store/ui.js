const initialState = {
  loading: false,
};

export const mutations = {
  setLoading(state, payload) {
    state.loading = payload;
  },
};

export const actions = {
  SET_LOADING({ commit }, payload) {
    commit('setLoading', payload);
  },
};

export default {
  state: { ...initialState },
  mutations,
  actions,
};
