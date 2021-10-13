import * as permissionsApi from '../api/permissions';

const initialState = {
  permissions: null,
  loading: null,
};

export const mutations = {
  setPermissions(state, payload) {
    state.permissions = payload;
  },
  addPermission(state, payload) {
    state.permissions.push(payload);
  },
  removePermission(state, payload) {
    const index = state.permissions.findIndex(permission => permission.id === payload.id);
    if (index !== -1) state.permissions.splice(index, 1);
  },
  resetState(state) {
    Object.assign(state, initialState);
  },
  setPermissionsLoading(state, payload) {
    state.loading = payload;
  },
};

export const actions = {
  GET_PERMISSIONS({ commit }) {
    commit('setPermissionsLoading', true);

    return permissionsApi.getPermissions()
      .then((data) => {
        if (data.permissions) commit('setPermissions', data.permissions);
      })
      .catch((err) => {
        commit('setError', err);
      })
      .finally(() => {
        commit('setPermissionsLoading', false);
      });
  },
  CREATE_PERMISSION({ commit }, payload) {
    commit('setPermissionsLoading', true);

    return permissionsApi.create(payload)
      .then((data) => {
        if (data.permission) commit('addPermission', data.permission);
      })
      .catch((err) => {
        commit('setError', err);
      })
      .finally(() => {
        commit('setPermissionsLoading', false);
      });
  },
  DESTROY_PERMISSION({ commit }, payload) {
    commit('setPermissionsLoading', true);

    return permissionsApi.destroy(payload.id)
      .then(() => {
        commit('removePermission', payload);
      })
      .catch((err) => {
        commit('setError', err);
      })
      .finally(() => {
        commit('setPermissionsLoading', false);
      });
  },
  reset({ commit }) {
    commit('resetState');
  },
};

export default {
  state: { ...initialState },
  mutations,
  actions,
};
