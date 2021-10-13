
import { createRouter, createWebHashHistory } from 'vue-router';

import Auth from '@/router/auth';
import Customer from '@/router/customer';
import Checkout from '@/router/checkout';
import Customers from '@/router/customers';
import Payments from '@/router/payments';
import Plans from '@/router/plans';
import Product from '@/router/product';
import Products from '@/router/products';
import Settings from '@/router/settings';
import store from '@/store';

const router = createRouter({
  history: createWebHashHistory('/'),
  routes: [
    {
      path: '/login',
      name: 'login',
      component: Auth,
      meta: {
        title: 'Login | Plutto',
      },
    },
    {
      path: '/',
      name: 'home',
      redirect: {
        name: 'customers',
      },
    }, {
      path: '/checkout',
      name: 'checkout',
      component: Checkout,
      meta: {
        title: 'Checkout | Plutto',
      },
    }, {
      path: '/customers',
      name: 'customers',
      component: Customers,
      meta: {
        title: 'Customers | Plutto',
        authRequired: true,
      },
    }, {
      path: '/customer/:id',
      name: 'customer',
      component: Customer,
      meta: {
        title: 'Customer | Plutto',
        authRequired: true,
      },
    }, {
      path: '/payments',
      name: 'payments',
      component: Payments,
      meta: {
        title: 'Payments | Plutto',
        authRequired: true,
      },
    }, {
      path: '/plans',
      name: 'plans',
      component: Plans,
      meta: {
        title: 'Plans | Plutto',
        authRequired: true,
      },
    }, {
      path: '/products',
      name: 'products',
      component: Products,
      meta: {
        title: 'Products | Plutto',
        authRequired: true,
      },
    }, {
      path: '/product/:id',
      name: 'product',
      component: Product,
      meta: {
        title: 'Product | Plutto',
        authRequired: true,
      },
    }, {
      path: '/settings',
      name: 'settings',
      component: Settings,
      meta: {
        title: 'Settings | Plutto',
        authRequired: true,
      },
    },
  ],
});

router.beforeEach((to, from, next) => {
  const user = store.state.auth;
  if (to.meta.authRequired && !user.token) {
    next(`/login?redirect_to=${to.fullPath}`);
    document.title = 'Ingresar | Plutto';
  } else {
    if (analytics) {
      analytics.page(to.name, {
        title: to.meta.title,
        path: to.path,
        referrer: from.path,
      });
    }
    next();
    document.title = to.meta.title || 'Plutto';
  }
});

export default router;
