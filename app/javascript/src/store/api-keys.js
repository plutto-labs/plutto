import * as apiKeysApi from '@/api/api-keys';

const initialState = {
  apiKeys: null,
  loading: null,
  error: null,
};

export const mutations = {
  setApiKeys(state, payload) {
    state.apiKeys = payload;
  },
  addApiKey(state, payload) {
    state.apiKeys.unshift(payload);
  },
  removeApiKey(state, payload) {
    const index = state.apiKeys.findIndex(apiKey => apiKey.id === payload.id);
    if (index !== -1) {
      state.apiKeys.splice(index, 1);
    }
  },
  resetState(state) {
    Object.assign(state, initialState);
  },
  setApiKeysLoading(state, payload) {
    state.loading = payload;
  },
  setError(state, payload) {
    state.error = payload;
  },
};

export const actions = {
  GET_API_KEYS({ commit }, payload) {
    commit('setApiKeysLoading', true);

    return apiKeysApi.getApiKeys(payload)
      .then((data) => {
        if (data.apiKeys) commit('setApiKeys', data.apiKeys);
      })
      .catch((err) => {
        commit('setError', err);
      })
      .finally(() => {
        commit('setApiKeysLoading', false);
      });
  },
  CREATE_API_KEY({ commit }, payload) {
    commit('setApiKeysLoading', true);

    return apiKeysApi.create(payload)
      .then((data) => {
        if (data.apiKey) commit('addApiKey', data.apiKey);
      })
      .catch((err) => {
        commit('setError', err);
      })
      .finally(() => {
        commit('setApiKeysLoading', false);
      });
  },
  DESTROY_API_KEY({ commit }, payload) {
    commit('setApiKeysLoading', true);

    return apiKeysApi.destroy(payload.id)
      .then(() => {
        commit('removeApiKey', payload);
      })
      .catch((err) => {
        commit('setError', err);
      })
      .finally(() => {
        commit('setApiKeysLoading', false);
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
