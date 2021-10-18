import * as permissionGroupsApi from '../api/permission-groups';

const initialState = {
  permissionGroups: null,
  currentPermissionGroup: false,
  loading: null,
};

export const mutations = {
  setPermissionGroups(state, payload) {
    state.permissionGroups = payload;
  },
  setCurrentPermissionGroup(state, payload) {
    state.currentPermissionGroup = payload;
  },
  addPermissionGroup(state, payload) {
    state.permissionGroups.push(payload);
    state.currentPermissionGroup = payload;
  },
  updatePermissionGroup(state, payload) {
    const index = state.permissionGroups.findIndex(permissionGroup => permissionGroup.id === payload.id);
    if (index !== -1) {
      state.permissionGroups.splice(index, 1, payload);
      state.currentPermissionGroup = payload;
    }
  },
  removePermissionGroup(state, payload) {
    const index = state.permissionGroups.findIndex(permissionGroup => permissionGroup.id === payload.id);
    if (index !== -1) {
      state.permissionGroups.splice(index, 1);
      state.currentPermissionGroup = null;
    }
  },
  resetState(state) {
    Object.assign(state, initialState);
  },
  setPermissionGroupsLoading(state, payload) {
    state.loading = payload;
  },
};

export const actions = {
  GET_PERMISSION_GROUPS({ commit }) {
    commit('setPermissionGroupsLoading', true);

    return permissionGroupsApi.getPermissionGroups()
      .then((data) => {
        if (data.permissionGroups) commit('setPermissionGroups', data.permissionGroups);
      })
      .catch((err) => {
        commit('setError', err);
      })
      .finally(() => {
        commit('setPermissionGroupsLoading', false);
      });
  },
  GET_PERMISSION_GROUP({ commit }, payload) {
    commit('setPermissionGroupsLoading', true);

    return permissionGroupsApi.getPermissionGroup(payload)
      .then((data) => {
        if (data.permissionGroup) commit('setCurrentPermissionGroup', data.permissionGroup);
      })
      .catch((err) => {
        commit('setError', err);
      })
      .finally(() => {
        commit('setPermissionGroupsLoading', false);
      });
  },
  CREATE_PERMISSION_GROUP({ commit }, payload) {
    commit('setPermissionGroupsLoading', true);

    return permissionGroupsApi.create(payload)
      .then((data) => {
        if (data.permissionGroup) commit('addPermissionGroup', data.permissionGroup);
      })
      .catch((err) => {
        commit('setError', err);
      })
      .finally(() => {
        commit('setPermissionGroupsLoading', false);
      });
  },
  UPDATE_PERMISSION_GROUP({ commit }, payload) {
    commit('setPermissionGroupsLoading', true);

    return permissionGroupsApi.update(payload.id, payload)
      .then((data) => {
        if (data.permissionGroup) commit('updatePermissionGroup', data.permissionGroup);
      })
      .catch((err) => {
        commit('setError', err);
      })
      .finally(() => {
        commit('setPermissionGroupsLoading', false);
      });
  },
  DESTROY_PERMISSION_GROUP({ commit }, payload) {
    commit('setPermissionGroupsLoading', true);

    return permissionGroupsApi.destroy(payload.id)
      .then(() => {
        commit('removePermissionGroup', payload);
      })
      .catch((err) => {
        commit('setError', err);
      })
      .finally(() => {
        commit('setPermissionGroupsLoading', false);
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
