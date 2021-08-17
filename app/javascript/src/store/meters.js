import * as metersApi from '../api/meters';

const initialState = {
  meters: [],
  currentMeter: false,
  loading: null,
  error: null,
};

export const mutations = {
  setMeters(state, payload) {
    state.meters = payload;
  },
  setCurrentMeter(state, payload) {
    state.currentMeter = payload;
  },
  addMeter(state, payload) {
    state.meters.push(payload);
  },
  updateMeter(state, payload) {
    const index = state.meters.findIndex(meter => meter.id === payload.id);
    if (index !== -1) {
      state.meters.splice(index, 1, payload);
    }
  },
  removeMeter(state, payload) {
    const index = state.meters.findIndex(meter => meter.id === payload.id);
    if (index !== -1) {
      state.meters.splice(index, 1);
    }
  },
  resetState(state) {
    Object.assign(state, initialState);
  },
  setMetersLoading(state, payload) {
    state.loading = payload;
  },
  setError(state, payload) {
    state.error = payload;
  },
};

export const actions = {
  GET_METERS({ commit }) {
    commit('setMetersLoading', true);

    return metersApi.getMeters()
      .then((data) => {
        if (data.meters) commit('setMeters', data.meters);
      })
      .catch((err) => {
        commit('setError', err);
      })
      .finally(() => {
        commit('setMetersLoading', false);
      });
  },
  GET_METER({ commit }, payload) {
    commit('setMetersLoading', true);

    return metersApi.getMeter(payload.id)
      .then((data) => {
        if (data.meter) commit('setCurrentMeter', data.meter);
      })
      .catch((err) => {
        commit('setError', err);
      })
      .finally(() => {
        commit('setMetersLoading', false);
      });
  },
  CREATE_METER({ commit }, payload) {
    commit('setMetersLoading', true);

    return metersApi.create(payload)
      .then((data) => {
        if (data.meter) commit('addMeter', data.meter);
      })
      .catch((err) => {
        commit('setError', err);
      })
      .finally(() => {
        commit('setMetersLoading', false);
      });
  },
  UPDATE_METER({ commit }, payload) {
    commit('setMetersLoading', true);

    return metersApi.update(payload.id, payload)
      .then((data) => {
        if (data.meter) commit('updateMeter', data.meter);
      })
      .catch((err) => {
        commit('setError', err);
      })
      .finally(() => {
        commit('setMetersLoading', false);
      });
  },
  DESTROY_METER({ commit }, payload) {
    commit('setMetersLoading', true);

    return metersApi.destroy(payload.id)
      .then(() => {
        commit('removeMeter', payload);
      })
      .catch((err) => {
        commit('setError', err);
      })
      .finally(() => {
        commit('setMetersLoading', false);
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
