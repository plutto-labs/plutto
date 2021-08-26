/* eslint-disable no-undef */
module.exports = {
  theme: {
    extend: {
      colors: {
        'success-lightest': '#e5fff3',
        'success-lighter': '#b3ffda',
        'success-light': '#80ffc1',
        'success': '#00e676',
        'success-dark': '#008042',
        'success-darker': '#004d28',
        'success-darkest': '#001a0d',

        'warning-light': '#ffd399',
        'warning': '#ff9100',
        'warning-dark': '#995700',

        'danger-light': '#ffb3c2',
        'danger': '#ff1744',
        'danger-dark': '#800019',

        'black': '#080807',
        'gray-900': '#0d0d0c',
        'gray-800': '#1c1c17',
        'gray-700': '#39392d',
        'gray-600': '#2b2b22',
        'gray-500': '#64644f',
        'gray-400': '#72725a',
        'gray-300': '#afad9d',
        'gray-200': '#c6c5b9',
        'gray-100': '#dddcd5',
        'white-50': '#f4f3f1',
        'white': '#fafaf9',

        'primary-900': '#423d00',
        'primary-800': '#756c00',
        'primary-700': '#a89a00',
        'primary-600': '#dbc900',
        'primary': '#ffea00',
        'primary-400': '#ffef42',
        'primary-300': '#fff475',
        'primary-200': '#fff68f',
        'primary-100': '#fffac2',

        'secondary-900': '#000433',
        'secondary-800': '#000866',
        'secondary-700': '#000d99',
        'secondary-600': '#01c',
        'secondary': '#0015ff',
        'secondary-400': '#34f',
        'secondary-300': '#6673ff',
        'secondary-200': '#99a2ff',
        'secondary-100': '#ccd0ff',
      },
      fontSize: {
        '2xs': '.625rem',
        '3xs': '.5rem',
      },
    },
  },
  variants: {},
  plugins: [require('@tailwindcss/forms')({ strategy: 'class' })],
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
