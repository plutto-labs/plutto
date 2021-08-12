import login from '../api/auth';

const initialState = {
  id: null,
  token: null,
  email: null,
  organizationId: null,
  organizationName: null,
};

export const mutations = {
  saveUserData(state, payload) {
    state.id = payload.id;
    state.token = payload.authenticationToken;
    state.email = payload.email;
  },
  setCompanyData(state, payload) {
    state.organizationId = payload.id;
    state.organizationName = payload.name;
  },
};

export const actions = {
  LOGIN_USER({ commit }, payload) {
    return login(payload.email, payload.password)
      .then((res) => {
        const { user } = res;
        if (user.authenticationToken) {
          commit('saveUserData', user);
          commit('setCompanyData', user.organization);
        }
      });
  },
  LOGOUT_USER({ commit }) {
    commit('saveUserData', { id: null, token: null, email: null, organizationId: null, organizationName: null });
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
