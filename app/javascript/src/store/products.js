import * as productsApi from '../api/products';
import * as pricingsApi from '../api/pricings';

const initialState = {
  products: null,
  currentProduct: false,
  loading: null,
};

export const mutations = {
  setProducts(state, payload) {
    state.products = payload;
  },
  setCurrentProduct(state, payload) {
    state.currentProduct = payload;
  },
  addProduct(state, payload) {
    state.products.push(payload);
    state.currentProduct = payload;
  },
  updateProduct(state, payload) {
    const index = state.products.findIndex(product => product.id === payload.id);
    if (index !== -1) {
      state.products.splice(index, 1, payload);
      state.currentProduct = payload;
    }
  },
  removeProduct(state, payload) {
    const index = state.products.findIndex(product => product.id === payload.id);
    if (index !== -1) {
      state.products.splice(index, 1);
      state.currentProduct = null;
    }
  },
  addProductPricing(state, payload) {
    state.currentProduct.pricings.unshift(payload);
  },
  removeProductPricing(state, payload) {
    const index = state.currentProduct.pricings.findIndex(version => version.id === payload.id);
    if (index !== -1) {
      state.currentProduct.pricings.splice(index, 1);
    }
  },
  resetState(state) {
    Object.assign(state, initialState);
  },
  setProductsLoading(state, payload) {
    state.loading = payload;
  },
  setDefaultVersion(state, payload) {
    state.currentProduct.defaultVersion = payload;
  },
};

export const actions = {
  GET_PRODUCTS({ commit }) {
    commit('setProductsLoading', true);

    return productsApi.getProducts()
      .then((data) => {
        if (data.products) commit('setProducts', data.products);
      })
      .catch((err) => {
        commit('setError', err);
      })
      .finally(() => {
        commit('setProductsLoading', false);
      });
  },
  GET_PRODUCT({ commit }, payload) {
    commit('setProductsLoading', true);

    return productsApi.getProduct(payload)
      .then((data) => {
        if (data.product) commit('setCurrentProduct', data.product);
      })
      .catch((err) => {
        commit('setError', err);
      })
      .finally(() => {
        commit('setProductsLoading', false);
      });
  },
  CREATE_PRODUCT({ commit }, payload) {
    commit('setProductsLoading', true);

    return productsApi.create(payload)
      .then((data) => {
        if (data.product) commit('addProduct', data.product);
      })
      .catch((err) => {
        commit('setError', err);
      })
      .finally(() => {
        commit('setProductsLoading', false);
      });
  },
  UPDATE_PRODUCT({ commit }, payload) {
    commit('setProductsLoading', true);

    return productsApi.update(payload.id, payload)
      .then((data) => {
        if (data.product) commit('updateProduct', data.product);
      })
      .catch((err) => {
        commit('setError', err);
      })
      .finally(() => {
        commit('setProductsLoading', false);
      });
  },
  DESTROY_PRODUCT({ commit }, payload) {
    commit('setProductsLoading', true);

    return productsApi.destroy(payload.id)
      .then(() => {
        commit('removeProduct', payload);
      })
      .catch((err) => {
        commit('setError', err);
      })
      .finally(() => {
        commit('setProductsLoading', false);
      });
  },

  CREATE_PRICING({ commit }, payload) {
    commit('setProductsLoading', true);

    return pricingsApi.create(payload.productId, payload.pricing)
      .then((data) => {
        if (data.pricing) {
          commit('addProductPricing', data.pricing);
          commit('setDefaultVersion', data.pricing);
        }
      })
      .catch((err) => {
        commit('setError', err);
      })
      .finally(() => {
        commit('setProductsLoading', false);
      });
  },
  DESTROY_PRICING({ commit }, payload) {
    commit('setProductsLoading', true);

    return pricingsApi.destroy(payload.productId, payload.pricing.id)
      .then(() => {
        commit('removeProductPricing', payload.pricing);
      })
      .catch((err) => {
        commit('setError', err);
      })
      .finally(() => {
        commit('setProductsLoading', false);
      });
  },

  reset({ commit }) {
    commit('resetState');
  },
};

export const getters = {
  pricingsOptions(state) {
    return state.products.map((product) => (
      { name: `${product.name} - ${product.defaultVersion.version}`, id: product.defaultVersion.id }
    ));
  },
};

export default {
  state: { ...initialState },
  mutations,
  actions,
  getters,
};
