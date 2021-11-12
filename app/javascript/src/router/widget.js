
import { createRouter, createWebHashHistory } from 'vue-router';
import Auth from '@/router/auth';
import store from '@/store';
import Embed from '@/router/widget/embed';

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
      component: Embed,
      meta: {
        title: 'Dashboard | Plutto',
        authRequired: true,
      },
    }, {
      path: '/widget-settings',
      name: 'widget-settings',
      component: Embed,
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
