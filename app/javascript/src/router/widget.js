
import { createRouter, createWebHashHistory } from 'vue-router';
import Auth from '@/router/auth';
import SignUp from '@/router/sign-up';
import store from '@/store';
import Settings from '@/router/widget/settings';
import Embed from '@/router/widget/embed';
import Dashboard from '@/router/widget/dashboard';
import Customer from '@/router/widget/customer';

const router = createRouter({
  history: createWebHashHistory('/'),
  routes: [
    {
      path: '/login',
      name: 'login',
      component: Auth,
      props: { app: 'widget' },
      meta: {
        title: 'Login | Plutto',
      },
    }, {
      path: '/sign-up',
      name: 'sign-up',
      component: SignUp,
      meta: {
        title: 'Sign Up | Plutto',
      },
    }, {
      path: '/',
      name: 'home',
      redirect: {
        name: 'embed',
      },
    }, {
      path: '/embed',
      name: 'embed',
      component: Embed,
      meta: {
        title: 'Embed | Plutto',
        authRequired: true,
      },
    }, {
      path: '/dashboard',
      name: 'dashboard',
      component: Dashboard,
      meta: {
        title: 'Dashboard | Plutto',
        authRequired: true,
      },
    }, {
      path: '/dashboard/active',
      name: 'active',
      component: Dashboard,
      props: { selectedTab: 'active' },
      meta: {
        title: 'Customers | Plutto',
        authRequired: true,
      },
    }, {
      path: '/dashboard/canceled',
      name: 'canceled',
      component: Dashboard,
      props: { selectedTab: 'canceled' },
      meta: {
        title: 'Customers | Plutto',
        authRequired: true,
      },
    }, {
      path: '/dashboard/inactive',
      name: 'inactive',
      component: Dashboard,
      props: { selectedTab: 'inactive' },
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
      path: '/widget-settings',
      name: 'widget-settings',
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
