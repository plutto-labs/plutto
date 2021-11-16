<template>
  <main>
    <form
      class="relative px-4 py-16 mx-4 text-center bg-transparent md:px-8 md:m-auto top-20 rounded-2xl md:w-96"
      @submit.prevent="submitForm"
    >
      <div class="text-3xl">
        Plutto
      </div>
      <div class="mt-8 plutto-input">
        <span class="plutto-input__icon text-primary">mail_outline</span>
        <input
          required
          type="email"
          class="plutto-input__input"
          placeholder="email"
          v-model="signUp.email"
        >
      </div>
      <div class="mt-4 plutto-input">
        <span class="plutto-input__icon text-primary">home_work</span>
        <input
          required
          type="text"
          class="plutto-input__input"
          placeholder="organization"
          v-model="signUp.organizationName"
        >
      </div>
      <div class="mt-4 plutto-input">
        <span class="plutto-input__icon text-primary">password</span>
        <input
          required
          type="password"
          class="plutto-input__input"
          placeholder="password"
          v-model="signUp.password"
        >
      </div>
      <div class="mt-4 mb-8 plutto-input">
        <span class="plutto-input__icon text-primary">password</span>
        <input
          required
          type="password"
          class="plutto-input__input"
          placeholder="password confirmation"
          v-model="signUp.passwordConfirmation"
        >
      </div>
      <PluttoLoader
        v-if="sending"
      />
      <button
        class="w-full h-10 btn btn--filled"
        v-else
      >
        Sign Up
      </button>
      <div
        class="text-sm text-melon"
        v-if="error"
      >
        {{ error.data.error.detail }}
      </div>
      <a
        class="text-sm text-left text-blue-800 underline cursor-pointer"
        href="/widget#/login"
      >
        Already have an account?
      </a>
    </form>
  </main>
</template>

<script>
import PluttoLoader from '../components/plutto-loader';

export default {
  components: { PluttoLoader },
  data() {
    return {
      signUp: {
        email: null,
        password: null,
        passwordConfirmation: null,
        organizationName: null,
      },
      sending: false,
      error: null,
    };
  },
  methods: {
    async submitForm() {
      this.sending = true;
      this.error = null;

      return this.$store.dispatch('SIGN_UP_USER', this.signUp)
        .then(() => {
          this.$router.replace('/');
        })
        .catch((err) => {
          this.error = err.response;
        })
        .finally(() => {
          this.sending = false;
        });
    },
  },
};
</script>
