const { environment } = require('@rails/webpacker');
const { DefinePlugin } = require('webpack');
const jquery = require('./plugins/jquery');
const { VueLoaderPlugin } = require('vue-loader');
const vue = require('./loaders/vue');
const path = require('path');

environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin());
environment.loaders.prepend('vue', vue);
environment.plugins.prepend('jquery', jquery);
environment.config.merge({
  resolve: {
    alias: {
      '@': path.resolve(__dirname, '..', '..', 'app/javascript/src'),
      vue: 'vue/dist/vue.esm-bundler.js',
    },
  },
});
environment.plugins.prepend(
  'Define',
  new DefinePlugin({
    __VUE_OPTIONS_API__: true,
    __VUE_PROD_DEVTOOLS__: false,
  }),
);
module.exports = environment;
