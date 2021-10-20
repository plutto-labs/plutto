<template>
  <main>
    <PluttoHeader
      button-text="Add Permission Group"
      @button-clicked="showPermissionGroupForm = true"
    />
    <div class="mx-auto mt-6 max-w-7xl">
      <div
        v-if="!loading"
        class="grid grid-rows-1 gap-6 sm:grid-cols-2 md:grid-cols-3 2xl:grid-cols-4"
      >
        <div
          v-for="permissionGroup in sortedPermissionGroups"
          :key="permissionGroup.id"
          class="relative px-6 py-8 border border-gray-600 rounded-lg"
        >
          <div class="flex items-center gap-4">
            <div class="text-lg underline md:text-xl text-gray-50">
              {{ permissionGroup.name }}
            </div>
            <span
              class="cursor-pointer plutto-icon text-primary"
              @click="editPermissionGroup(permissionGroup)"
            >edit</span>
          </div>
          <PluttoCopyableDiv
            class="text-xs text-gray-100"
            :value="permissionGroup.id"
          />
          <ul class="pl-4 mt-4 mb-8 text-gray-300">
            <li
              class="list-disc"
              v-for="permission in permissionGroup.permissions"
              :key="permission.key"
            >
              <PluttoTooltip v-if="permission.meterId">
                <template #trigger>
                  <div class="flex items-center">
                    <span class="text-primary">{{ permission.limit || '&infin;' }}</span>
                    <span class="flex-1 mx-2">{{ permission.name }}</span>
                    <span class="plutto-icon text-secondary-200">{{ permission.meterCountMethod === 'period_sum' ? 'autorenew' : 'trending_up' }}</span>
                  </div>
                </template>
                <template #content>
                  <p>Meter: {{ permission.meterName }} </p>
                  <p>Limit: {{ permission.limit }} </p>
                  <p>
                    Count: {{
                      permission.meterCountMethod === 'period_sum' ? 'Period information' : 'Historic information'
                    }}
                  </p>
                </template>
              </PluttoTooltip>
              <div v-else>
                <span>{{ permission.name }}</span>
              </div>
            </li>
          </ul>
          <div class="absolute bottom-0 w-full py-4 -mx-6 text-xl text-center">
            {{ formatCurrency(permissionGroup.price, permissionGroup.currency) }}
          </div>
        </div>
      </div>
      <PluttoLoader
        v-else
      />
    </div>
    <PluttoSlideover
      :showing="showPermissionGroupForm"
      @close="showPermissionGroupForm = false; editingPermissionGroup = null"
    >
      <PermissionGroupForm
        :editing-permission-group="editingPermissionGroup"
        @created-permission-group="permissionGroup => {showPermissionGroupForm = false; editingPermissionGroup = null}"
        @deleted-permission-group="showPermissionGroupForm = false; editingPermissionGroup = null"
        class="pb-8 mx-auto"
      />
    </PluttoSlideover>
  </main>
</template>

<script>
import { mapState } from 'vuex';
import PluttoHeader from '@/components/plutto-header';
import PluttoLoader from '@/components/plutto-loader';
import PluttoSlideover from '@/components/plutto-slideover';
import PluttoCopyableDiv from '@/components/plutto-copyable-div';
import PermissionGroupForm from '@/components/forms/permission-group-form';
import PluttoTooltip from '@/components/plutto-tooltip';

export default {
  components: { PluttoHeader, PluttoLoader, PluttoSlideover, PermissionGroupForm, PluttoCopyableDiv, PluttoTooltip },
  data() {
    return {
      showPermissionGroupForm: false,
      editingPermissionGroup: null,
    };
  },
  computed: {
    ...mapState({
      loading: state => state.permissionGroups.loading,
      permissionGroups: state => state.permissionGroups.permissionGroups,
    }),

    sortedPermissionGroups() {
      if (!this.permissionGroups) return [];

      return [...this.permissionGroups].sort((a, b) => (Number(a.price) < Number(b.price) ? -1 : 1));
    },
  },
  async beforeMount() {
    await this.$store.dispatch('GET_PERMISSION_GROUPS');
  },
  methods: {
    destroyPermissionGroup(permissionGroup) {
      this.$store.dispatch('DESTROY_PERMISSION_GROUP', permissionGroup);
    },
    editPermissionGroup(permissionGroup) {
      this.editingPermissionGroup = permissionGroup;
      this.showPermissionGroupForm = true;
    },
  },
};
</script>
