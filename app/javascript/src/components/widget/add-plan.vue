<template>
  <div class="box-border flex items-center justify-around w-64 h-auto py-3 my-3 border-2 border-dashed rounded-3xl">
    <span
      class="p-1 border-2 rounded cursor-pointer plutto-icon hover:bg-temporary-gray-100"
      @click="addPlan"
    >
      add
    </span>
  </div>
</template>
<script>
export default {
  methods: {
    addPlan() {
      this.$emit('add-plan');
    },
  },
};
</script>
