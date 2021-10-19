import * as authApi from '../api/auth';

const initialState = {
  id: null,
  token: null,
  email: null,
};

export const mutations = {
  setUserData(state, payload) {
    state.id = payload.id;
    state.token = payload.authenticationToken;
    state.email = payload.email;
  },
  resetState(state) {
    Object.assign(state, initialState);
  },
};

export const actions = {
  LOGIN_USER({ commit }, payload) {
    return authApi.login(payload.email, payload.password)
      .then((res) => {
        const { user } = res;
        if (user.authenticationToken) {
          commit('setUserData', user);
          commit('setOrganizationData', user.organization);
        }
      });
  },
  UPDATE_USER_DATA({ commit }, payload) {
    return authApi.getUser(payload)
      .then((data) => {
        const { user } = data;
        if (user.authenticationToken) {
          commit('setUserData', user);
          commit('setOrganizationData', user.organization);
        }
      });
  },
  LOGOUT_USER({ commit }) {
    commit('resetState');
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
