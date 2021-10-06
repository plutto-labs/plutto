import * as plansApi from '../api/plans';

const initialState = {
  plans: null,
  currentPlan: false,
  loading: null,
  error: null,
};

export const mutations = {
  setPlans(state, payload) {
    state.plans = payload;
  },
  setCurrentPlan(state, payload) {
    state.currentPlan = payload;
  },
  addPlan(state, payload) {
    state.plans.push(payload);
    state.currentPlan = payload;
  },
  updatePlan(state, payload) {
    const index = state.plans.findIndex(plan => plan.id === payload.id);
    if (index !== -1) {
      state.plans.splice(index, 1, payload);
      state.currentPlan = payload;
    }
  },
  removePlan(state, payload) {
    const index = state.plans.findIndex(plan => plan.id === payload.id);
    if (index !== -1) {
      state.plans.splice(index, 1);
      state.currentPlan = null;
    }
  },
  resetState(state) {
    Object.assign(state, initialState);
  },
  setPlansLoading(state, payload) {
    state.loading = payload;
  },
  setError(state, payload) {
    state.error = payload;
  },
};

export const actions = {
  GET_PLANS({ commit }) {
    commit('setPlansLoading', true);

    return plansApi.getPlans()
      .then((data) => {
        if (data.plans) commit('setPlans', data.plans);
      })
      .catch((err) => {
        commit('setError', err);
      })
      .finally(() => {
        commit('setPlansLoading', false);
      });
  },
  GET_PLAN({ commit }, payload) {
    commit('setPlansLoading', true);

    return plansApi.getPlan(payload)
      .then((data) => {
        if (data.plan) commit('setCurrentPlan', data.plan);
      })
      .catch((err) => {
        commit('setError', err);
      })
      .finally(() => {
        commit('setPlansLoading', false);
      });
  },
  CREATE_PLAN({ commit }, payload) {
    commit('setPlansLoading', true);

    return plansApi.create(payload)
      .then((data) => {
        if (data.plan) commit('addPlan', data.plan);
      })
      .catch((err) => {
        commit('setError', err);
      })
      .finally(() => {
        commit('setPlansLoading', false);
      });
  },
  UPDATE_PLAN({ commit }, payload) {
    commit('setPlansLoading', true);

    return plansApi.update(payload.id, payload)
      .then((data) => {
        if (data.plan) commit('updatePlan', data.plan);
      })
      .catch((err) => {
        commit('setError', err);
      })
      .finally(() => {
        commit('setPlansLoading', false);
      });
  },
  DESTROY_PLAN({ commit }, payload) {
    commit('setPlansLoading', true);

    return plansApi.destroy(payload.id)
      .then(() => {
        commit('removePlan', payload);
      })
      .catch((err) => {
        commit('setError', err);
      })
      .finally(() => {
        commit('setPlansLoading', false);
      });
  },
  reset({ commit }) {
    commit('resetState');
  },
};

export const getters = {
  pricingsOptions(state) {
    return state.plans.map((plan) => (
      { name: `${plan.name} - ${plan.defaultVersion.version}`, id: plan.defaultVersion.id }
    ));
  },
};

export default {
  state: { ...initialState },
  mutations,
  actions,
  getters,
};
