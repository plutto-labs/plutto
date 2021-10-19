<template>
  <Form
    @submit="submit"
    class="w-full px-4 space-y-8 md:max-w-xl md:px-6"
  >
    <div class="m-auto divide-gray-200">
      <div class="sm:col-span-3">
        <div class="mt-8 mb-4 text-lg">
          Permission Group
        </div>
        <div class="flex my-4">
          <div class="w-full mr-8 plutto-input">
            <label
              for="name"
              class="block text-sm font-medium text-gray-100"
            >
              {{ $t('message.global.name') }}
            </label>
            <input
              class="mt-2 plutto-input__input"
              v-model="newPermissionGroup.name"
            >
          </div>
        </div>
        <div class="flex my-4 mt-10">
          <div class="w-32 mr-8">
            <label
              for="priceCurrency"
              class="block text-sm font-medium text-gray-100"
            >
              {{ $t('message.global.currency') }}
            </label>
            <PluttoDropdown
              class="w-32 mt-2 plutto-input"
              :selected="newPermissionGroup.priceCurrency"
              :options="CURRENCY_KEYS"
              @selected="(priceCurrency) => newPermissionGroup.priceCurrency = priceCurrency"
            />
          </div>
          <div class="w-full mr-8">
            <label
              for="price"
              class="block text-sm font-medium text-gray-100"
            >
              Base {{ $t('message.global.price') }}
            </label>
            <div class="mt-2 plutto-input">
              <span class="plutto-input__icon">attach_money</span>
              <input
                class="plutto-input__input"
                v-model="newPermissionGroup.price"
              >
            </div>
          </div>
        </div>
      </div>
      <div class="mt-8 mb-4 text-lg">
        Permissions
      </div>
      <div
        class="flex items-center justify-between my-4"
        v-for="permission in permissions"
        :key="permission.id"
      >
        <div class="flex flex-row-reverse items-center justify-end w-full">
          <label
            :for="`${permission.id}`"
            class="ml-4"
          >
            {{ permission.name }}
          </label>
          <input
            type="checkbox"
            class="plutto-checkbox"
            :id="`${permission.id}`"
            @change="toggleChecked(permission)"
          >
        </div>
        <div
          class="flex items-center"
          v-if="selectedPermissions[permission.id] && permission.meterId"
        >
          <label class="mr-4 text-sm">limit:</label>
          <input
            class="w-20 h-8 px-1 text-center plutto-input__input plutto-input__input--no-icon"
            v-model="selectedPermissions[permission.id].limit"
            type="text"
          >
        </div>
      </div>
      <div
        class="flex items-center justify-between w-full border-b border-gray-800 plutto-input"
        v-if="!showPermissionModal"
        @click="showPermissionModal = true"
      >
        <label class="mr-4 text-gray-300">Add permission</label>
        <span class="plutto-icon text-primary">add</span>
      </div>
    </div>
    <div class="pt-5">
      <div class="flex justify-end">
        <button class="btn">
          Create Group
        </button>
      </div>
    </div>
    <PluttoModal
      :showing="showPermissionModal"
      @close="showPermissionModal = false"
    >
      <PermissionForm
        @created-permission="showPermissionModal = false"
      />
    </PluttoModal>
  </Form>
</template>

<script>
import { mapState } from 'vuex';
import PluttoDropdown from '@/components/plutto-dropdown';
import PluttoModal from '@/components/plutto-modal';
import PermissionForm from '@/components/forms/permission-form';
import { Form } from 'vee-validate';

export default {
  components: { Form, PluttoDropdown, PluttoModal, PermissionForm },
  data() {
    return {
      newPermissionGroup: {
        name: null,
        priceCurrency: 'CLP',
      },
      addingPermission: false,
      selectedPermissions: {},
      showPermissionModal: false,
    };
  },
  async beforeMount() {
    await this.$store.dispatch('GET_PERMISSIONS');
  },
  computed: {
    ...mapState({
      permissions: state => state.permissions.permissions,
    }),
  },
  methods: {
    submit() {
      const permissionGroup = {
        ...this.newPermissionGroup,
        permissionGroupPermissionsAttributes: Object.values(this.selectedPermissions),
      };
      this.$store.dispatch('CREATE_PERMISSION_GROUP', { permissionGroup })
        .then((newPermissionGroup) => this.$emit('created-permission-group', newPermissionGroup));
    },
    toggleChecked(permission) {
      if (this.selectedPermissions[permission.id]) {
        delete this.selectedPermissions[permission.id];
      } else {
        this.selectedPermissions[permission.id] = { permissionId: permission.id, limit: null };
      }
    },
  },
};
</script>
