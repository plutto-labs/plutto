const initialState = {
  loading: false,
};

export const mutations = {
  SET_LOADING(state, payload) {
    state.loading = payload;
  },
};

export const actions = {
  setLoading({ commit }, payload) {
    commit('SET_LOADING', payload);
  },
};

export default {
  state: { ...initialState },
  mutations,
  actions,
};
