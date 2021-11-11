import * as organizationApi from '../api/organization';

const initialState = {
  id: null,
  name: null,
  settings: {},
  widgetSettings: {},
};

export const mutations = {
  setOrganizationData(state, payload) {
    state.id = payload.id;
    state.name = payload.name;
    state.settings = payload.settings;
    state.widgetSettings = payload.widgetSettings;
  },
  resetState(state) {
    Object.assign(state, initialState);
  },
};

export const actions = {
  UPDATE_ORGANIZATION({ commit }, payload) {
    return organizationApi.update(payload)
      .then((res) => {
        if (res.organization) {
          commit('setOrganizationData', res.organization);
        }
      })
      .catch((err) => {
        commit('setError', err);
      });
  },
};

export default {
  state: { ...initialState },
  mutations,
  actions,
};
