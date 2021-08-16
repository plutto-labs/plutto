<template>
  <main>
    <PluttoHeader
      title="New Plan"
    />
    <div class="px-6 mt-6">
      <form
        @submit.prevent="createPlan"
        class="max-w-xs space-y-8 divide-y divide-gray-200"
      >
        <div class="w-64 m-auto space-y-8 divide-y divide-gray-200">
          <div class="pt-8">
            <div class="grid grid-cols-1 mt-6 gap-y-6 gap-x-4 sm:grid-cols-6">
              <div class="sm:col-span-3">
                <label
                  for="name"
                  class="block text-sm font-medium text-gray-300"
                >
                  Name
                </label>
                <div class="mt-1">
                  <input
                    type="text"
                    name="name"
                    id="name"
                    v-model="newPlan.name"
                    autocomplete="given-name"
                    required
                    class="block w-full px-2 text-gray-700 border-gray-700 rounded-md shadow-sm focus:primary-300 sm:text-sm"
                  >
                </div>
              </div>
            </div>
          </div>
        </div>

        <div class="pt-5">
          <div class="flex justify-end">
            <button class="btn">
              Save
            </button>
          </div>
        </div>
      </form>
    </div>
  </main>
</template>

<script>
import PluttoHeader from '../components/plutto-header';

export default {
  components: { PluttoHeader },
  data() {
    return {
      newPlan: {},
    };
  },
  methods: {
    createPlan() {
      this.$store.dispatch('CREATE_PLAN', this.newPlan)
        .then(() => this.$router.go(-1));
    },
  },
};
</script>
