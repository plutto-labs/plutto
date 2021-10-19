import * as organizationApi from '../api/organization';

const initialState = {
  id: null,
  name: null,
  settings: {},
};

export const mutations = {
  setOrganizationData(state, payload) {
    state.id = payload.id;
    state.name = payload.name;
    state.settings = payload.settings;
  },
  resetState(state) {
    Object.assign(state, initialState);
  },
};

export const actions = {
  UPDATE_SETTINGS({ commit }, payload) {
    return organizationApi.update(payload)
      .then((res) => {
        if (res.organization) {
          commit('setOrganizationData', res.organization);
        }
      });
  },
};

export default {
  state: { ...initialState },
  mutations,
  actions,
};
