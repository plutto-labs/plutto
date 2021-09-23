<template>
  <div class="flex flex-col">
    <h1 class="mx-auto text-xl">
      Confirm that you want to start charging this subscription right now
    </h1>
    <div class="flex justify-center gap-4 my-8">
      <button
        class="btn btn--cancel"
        @click="$emit('cancel')"
      >
        Cancel
      </button>
      <button
        class="btn"
        @click="$emit('confirm')"
      >
        Start subscription
      </button>
    </div>
  </div>
</template>
