<template>
  <div
    class="w-full px-4 pb-8 mx-auto mt-20 md:max-w-xl"
  >
    <h2 class="text-2xl">
      Add card
    </h2>
    <div class="grid grid-cols-3 mt-10 gap-y-10">
      <h3 class="my-auto">
        Title
      </h3>
      <div class="h-8 col-span-2 plutto-input">
        <input
          type="text"
          class="pl-4 plutto-input__input focus:border-primary"
          v-model="formData.name"
        >
      </div>
      <h3 class="my-auto">
        Amount
      </h3>
      <div class="h-8 col-span-2 plutto-input">
        <input
          type="number"
          class="pl-4 plutto-input__input focus:border-primary"
          v-model="formData.price"
        >
      </div>
      <h3 class="mt-2">
        Features
      </h3>
      <div class="col-span-2 space-y-4">
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
            v-if="selectedPermissions[permission.id]"
          >
            <label class="mr-4 text-sm">limit:</label>
            <input
              class="w-20 h-8 px-1 text-center plutto-input__input plutto-input__input--no-icon focus:border-primary"
              v-model="selectedPermissions[permission.id].limit"
              type="number"
            >
          </div>
          <div
            v-else
            class="cursor-pointer"
            @click="destroyPermission(permission)"
          >
            <span class="plutto-icon text-melon">remove</span>
          </div>
        </div>
        <div
          class="flex items-center justify-between w-full h-8 border-b border-gray-600 plutto-input"
        >
          <input
            class="w-full h-full pl-4 bg-transparent border-0 focus:outline-none"
            placeholder="Add feature..."
            v-model="newPermission.name"
            @keyup.enter="addPermission"
          >
          <span
            class="cursor-pointer plutto-icon text-primary"
            @click="addPermission"
          >add</span>
        </div>
      </div>
    </div>
    <div class="flex justify-end gap-8">
      <button
        class="mt-10 text-white btn btn--filled bg-melon hover:bg-melon hover:opacity-80 focus:bg-melon"
        v-if="editingPermissionGroup"
        @click="deletePermissionGroup"
      >
        Delete
      </button>
      <button
        class="mt-10 btn btn--filled"
        @click="submit"
      >
        Save
      </button>
    </div>
  </div>
</template>
<script>
import { mapState } from 'vuex';

export default {
  props: {
    modelValue: {
      type: Object,
      default: () => ({}),
    },
    editingPermissionGroup: {
      type: Object,
      default: () => ({}),
    },
    theme: {
      type: Object,
      default: () => ({}),
    },
  },
  data() {
    return {
      selectedPermissions: {},
      newPermission: { name: '' },
    };
  },
  async beforeMount() {
    await this.$store.dispatch('GET_PERMISSIONS');

    if (this.editingPermissionGroup) {
      this.formData.name = this.editingPermissionGroup.name;
      this.formData.price = this.editingPermissionGroup.price;
      this.formData.currency = this.editingPermissionGroup.currency;

      this.editingPermissionGroup.permissions.forEach(permission => {
        this.selectedPermissions[permission.id] = {
          limit: permission.limit,
          permissionId: permission.id,
          name: permission.name,
        };
      });
    }
  },
  computed: {
    ...mapState({
      permissions: state => state.permissions.permissions,
    }),
    formData: {
      get() {
        return this.modelValue;
      },
      set(value) {
        this.$emit('update:modelValue', value);
      },
    },
  },
  methods: {
    toggleChecked(permission) {
      if (this.selectedPermissions[permission.id]) {
        delete this.selectedPermissions[permission.id];
      } else {
        this.selectedPermissions[permission.id] = { permissionId: permission.id, limit: null, name: permission.name };
      }
    },
    addPermission() {
      if (this.newPermission.name === '') return;

      this.$store.dispatch('CREATE_PERMISSION', this.newPermission)
        .then(() => {
          this.$store.dispatch('GET_PERMISSIONS');
          this.newPermission = { name: '' };
        });
    },
    destroyPermission(permission) {
      this.$store.dispatch('DESTROY_PERMISSION', permission)
        .then(() => {
          this.$store.dispatch('GET_PERMISSIONS');
        });
    },
    submit() {
      const permissionGroup = {
        name: this.formData.name,
        priceCurrency: 'USD',
        price: this.formData.price,
        permissionGroupPermissionsAttributes: Object.values(this.selectedPermissions),
      };

      if (this.editingPermissionGroup.id) permissionGroup.id = this.editingPermissionGroup.id;

      this.$store.dispatch(
        `${this.editingPermissionGroup.id ? 'UPDATE' : 'CREATE'}_PERMISSION_GROUP`,
        { permissionGroup },
      ).then(() => this.$emit('created-permission-group'));
    },
    deletePermissionGroup() {
      this.$store.dispatch(
        'DESTROY_PERMISSION_GROUP', this.editingPermissionGroup,
      ).then(this.$emit('deleted-permission-group'));
    },
  },
  watch: {
    selectedPermissions: {
      handler() {
        this.formData.permissions = Object.values(this.selectedPermissions);
      },
      deep: true,
    },
  },
  mounted() {
    window.plutto('init', { widgetId: 'plutto-card-widget', permissionGroups: [this.formData], theme: this.theme });
  },
};
</script>
