/* eslint-disable no-undef */
module.exports = {
  theme: {
    extend: {
      colors: {
        primary: '#1F2937',
        secondary: '#121C25',
      },
    },
  },
  variants: {},
  plugins: [],
  purge: {
    enabled: process.env.NODE_ENV === 'production',
    content: [
      './app/**/*.html',
      './app/**/*.vue',
      './app/**/*.js',
      './app/**/*.erb',
    ],
  },
};
