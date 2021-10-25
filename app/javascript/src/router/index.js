
import { createRouter, createWebHashHistory } from 'vue-router';

import Auth from '@/router/auth';
import BusinessModel from '@/router/business-model';
import Customer from '@/router/customer';
import Checkout from '@/router/checkout';
import Customers from '@/router/customers';
import Payments from '@/router/payments';
import Product from '@/router/product';
import Analytics from '@/router/analytics';
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
      path: '/business-model',
      name: 'business-model',
      redirect: {
        name: 'permission-groups',
      },
    }, {
      path: '/business-model/meters',
      name: 'meters',
      component: BusinessModel,
      props: { selectedOption: 'meters' },
      meta: {
        title: 'Meters | Plutto',
        authRequired: true,
      },
    }, {
      path: '/business-model/permission-groups',
      name: 'permission-groups',
      component: BusinessModel,
      props: { selectedOption: 'permission-groups' },
      meta: {
        title: 'Permission Groups | Plutto',
        authRequired: true,
      },
    }, {
      path: '/business-model/products',
      name: 'products',
      component: BusinessModel,
      props: { selectedOption: 'products' },
      meta: {
        title: 'Products | Plutto',
        authRequired: true,
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
      path: '/customers/all',
      name: 'all',
      component: Customers,
      props: { selectedTab: 'all' },
      meta: {
        title: 'Customers | Plutto',
        authRequired: true,
      },
    }, {
      path: '/customers/active',
      name: 'active',
      component: Customers,
      props: { selectedTab: 'active' },
      meta: {
        title: 'Customers | Plutto',
        authRequired: true,
      },
    }, {
      path: '/customers/trial',
      name: 'trial',
      component: Customers,
      props: { selectedTab: 'trial' },
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
      redirect: {
        name: 'invoices',
      },
    }, {
      path: '/payments/invoices',
      name: 'invoices',
      component: Payments,
      props: { selectedOption: 'invoices' },
      meta: {
        title: 'Invoices | Plutto',
        authRequired: true,
      },
    }, {
      path: '/payments/transactions',
      name: 'transactions',
      component: Payments,
      props: { selectedOption: 'transactions' },
      meta: {
        title: 'Transactions | Plutto',
        authRequired: true,
      },
    }, {
      path: '/payments/settings',
      name: 'payment-settings',
      component: Payments,
      props: { selectedOption: 'payment-settings' },
      meta: {
        title: 'Payment Settings | Plutto',
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
      path: '/analytics',
      name: 'analytics',
      component: Analytics,
      meta: {
        title: 'Analytics | Plutto',
        authRequired: true,
      },
    }, {
      path: '/settings/api-keys',
      name: 'api-keys',
      component: Settings,
      props: { selectedOption: 'api-keys' },
      meta: {
        title: 'Api Keys | Plutto',
        authRequired: true,
      },
    }, {
      path: '/settings',
      name: 'settings',
      redirect: {
        name: 'api-keys',
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
