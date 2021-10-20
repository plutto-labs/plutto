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
              v-model="permissionGroup.name"
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
              :selected="permissionGroup.priceCurrency"
              :options="CURRENCY_KEYS"
              @selected="(priceCurrency) => permissionGroup.priceCurrency = priceCurrency"
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
                v-model="permissionGroup.price"
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
            :checked="selectedPermissions[permission.id]"
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
      <div class="flex justify-end gap-8">
        <button
          class="btn btn--cancel"
          v-if="editingPermissionGroup"
          @click.prevent="deletePermissionGroup"
        >
          Delete
        </button>
        <button class="btn">
          {{ editingPermissionGroup ? 'Edit Group' : 'Create Group' }}
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
  props: {
    editingPermissionGroup: {
      type: Object,
      default: () => {},
    },
  },
  data() {
    return {
      selected: true,
      permissionGroup: {
        name: null,
        priceCurrency: 'CLP',
        price: null,
      },
      addingPermission: false,
      selectedPermissions: {},
      showPermissionModal: false,
    };
  },
  async beforeMount() {
    await this.$store.dispatch('GET_PERMISSIONS');

    if (this.editingPermissionGroup) {
      this.permissionGroup.name = this.editingPermissionGroup.name;
      this.permissionGroup.price = this.editingPermissionGroup.price;
      this.permissionGroup.currency = this.editingPermissionGroup.currency;

      this.editingPermissionGroup.permissions.forEach(permission => {
        this.selectedPermissions[permission.id] = {
          limit: permission.limit,
          permissionId: permission.id,
          selected: true,
        };
      });
    }
  },
  computed: {
    ...mapState({
      permissions: state => state.permissions.permissions,
    }),
  },
  methods: {
    submit() {
      const permissionGroup = {
        ...this.permissionGroup,
        permissionGroupPermissionsAttributes: Object.values(this.selectedPermissions),
      };

      if (this.editingPermissionGroup) permissionGroup.id = this.editingPermissionGroup.id;
      this.$store.dispatch(
        `${this.editingPermissionGroup ? 'UPDATE' : 'CREATE'}_PERMISSION_GROUP`,
        { permissionGroup },
      ).then((group) => this.$emit(
        'created-permission-group',
        group,
      ));
    },
    toggleChecked(permission) {
      if (this.selectedPermissions[permission.id]) {
        delete this.selectedPermissions[permission.id];
      } else {
        this.selectedPermissions[permission.id] = { permissionId: permission.id, limit: null };
      }
    },
    deletePermissionGroup() {
      this.$store.dispatch(
        'DESTROY_PERMISSION_GROUP', this.editingPermissionGroup,
      ).then(this.$emit('deleted-permission-group'));
    },
  },
};
</script>
