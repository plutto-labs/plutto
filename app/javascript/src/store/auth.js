import login from '../api/auth';

const initialState = {
  token: null,
  email: null,
};

export const mutations = {
  saveUserData(state, payload) {
    state.token = payload.authenticationToken;
    state.email = payload.email;
  },
};

export const actions = {
  LOGIN_USER({ commit }, payload) {
    return login(payload.email, payload.password)
      .then((res) => {
        const { attributes } = res.data;
        if (attributes.authenticationToken) {
          commit('saveUserData', attributes);
        }
      });
  },
  LOGOUT_USER({ commit }) {
    commit('saveUserData', { token: null, email: null });
  },
};

export const getters = {
  isLoggedIn(state) {
    return !!state.token;
  },
};

export default {
  state: { ...initialState },
  mutations,
  actions,
  getters,
};
