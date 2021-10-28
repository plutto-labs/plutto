<template>
  <Transition name="slide-fade">
    <div
      v-if="showing"
      class="fixed inset-0 z-10 flex items-center justify-end w-full h-screen bg-see-through"
    >
      <div class="relative right-0 flex w-full h-full max-w-3xl bg-gray-800 shadow-lg md:w-1/2">
        <button
          aria-label="close"
          class="absolute top-0 right-0 m-6 text-xl"
          @click.prevent="close"
        >
          <span class="w-6 h-6 text-gray-100 fill-current material-icons hover:text-gray-50">close</span>
        </button>
        <div class="w-full max-h-screen overflow-x-hidden overflow-y-auto">
          <slot />
        </div>
      </div>
    </div>
  </Transition>
</template>

<script>

export default {
  props: {
    showing: {
      required: true,
      type: Boolean,
    },
  },
  methods: {
    close() {
      this.$emit('close');
    },
  },
};
</script>

<style>
.slide-fade-enter-active {
  transition: all .3s;
}

.slide-fade-leave-active {
  transition: all .3s cubic-bezier(1, .5, .8, 1);
}

.slide-fade-enter,
.slide-fade-leave-to {
  transform: translateX(1000px);
  opacity: 0;
}

.bg-see-through {
  background-color: rgba(0, 0, 0, .85);
}
</style>
