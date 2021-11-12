<template>
  <Transition name="fade">
    <div
      v-if="showing"
      class="fixed inset-0 z-10 flex items-center justify-center w-full h-screen bg-see-through"
      @click.self="close"
    >
      <div class="relative flex w-full max-w-2xl max-h-screen pt-12 rounded-lg shadow-lg bg-gray-50">
        <button
          aria-label="close"
          class="absolute top-0 right-0 m-3 text-xl text-gray-500"
          @click.prevent="close"
        >
          <span class="w-6 h-6 text-gray-500 fill-current material-icons hover:text-gray-300">close</span>
        </button>
        <div class="w-full max-h-screen">
          <slot />
        </div>
      </div>
    </div>
  </Transition>
</template>

<script>
const ESCAPE_KEY = 27;

export default {
  props: {
    showing: {
      required: true,
      type: Boolean,
    },
  },
  watch: {
    showing(value) {
      if (value) {
        return document.querySelector('body').classList.add('overflow-hidden');
      }

      return document.querySelector('body').classList.remove('overflow-hidden');
    },
  },
  methods: {
    close() {
      this.$emit('close');
    },
  },
  mounted() {
    document.addEventListener('keydown', e => {
      if (e.keyCode === ESCAPE_KEY) {
        this.close();
      }
    });
  },
};
</script>

<style>
.fade-enter-active,
.fade-leave-active {
  transition: all .3s;
}

.fade-enter,
.fade-leave-to {
  opacity: 0;
}

.bg-see-through {
  background-color: rgba(0, 0, 0, .85);
}
</style>
