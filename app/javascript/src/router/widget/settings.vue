<template>
  <main class="max-w-xl">
    <div class="space-y-8">
      <h1 class="text-2xl">
        Settings
      </h1>
      <div class="flex items-center gap-4">
        <h3 class="text-lg">
          API Key:
        </h3>
        <PluttoCopyableDiv
          class="px-3 py-2 border rounded-md"
          :value="publicApiKey"
        />
      </div>
      <div class="flex items-center justify-between gap-4">
        <div>
          <h3>
            Mercado Pago:
          </h3>
          <div
            :class="{
              'text-gray-400' : !mpConnected,
              'text-aquagreen-800' : mpConnected
            }"
          >
            {{ mpConnected ? 'conectado': 'no conectado' }}
          </div>
        </div>
        <button
          :class="{
            'btn btn--cancel': mpConnected,
            'btn btn--aquagreen': !mpConnected
          }"
          @click="mpConnected ? updateMercadopagoSettings() : showMercadopagoForm = true"
        >
          {{ mpConnected ? 'Desconectar': 'Conectar' }}
        </button>
      </div>
    </div>
    <PluttoModal
      :showing="showMercadopagoForm"
      @close="showMercadopagoForm = false"
    >
      <Form
        class="mx-4 mb-10 space-y-8 md:mx-12"
        :validation-schema="schema"
        @submit="updateMercadopagoSettings"
        v-slot="{ errors }"
      >
        <h1 class="text-2xl">
          Mercado Pago
          <div class="text-sm text-gray-300">
            Encontrarás estos valores en
            <a
              class="underline"
              href="https://www.mercadopago.cl/business#from-section=menu"
              target="_blank"
            >
              Mi Negocio > Configuración > Credenciales
            </a>
          </div>
        </h1>
        <div class="items-center block gap-4 md:flex">
          <h3 class="md:w-32">
            Public Key:
          </h3>
          <div class="flex-1">
            <Field
              class="w-full px-3 py-2 border rounded-md"
              type="text"
              name="publicKey"
              placeholder="Public Key"
              v-model="publicKey"
            />
            <div
              class="text-sm text-danger-light"
              v-if="errors.publicKey"
            >
              Required
            </div>
          </div>
        </div>
        <div class="items-center block gap-4 md:flex">
          <h3 class="md:w-32">
            Access Token:
          </h3>
          <div class="flex-1">
            <Field
              class="w-full px-3 py-2 border rounded-md"
              type="text"
              name="accessToken"
              placeholder="Access Token"
              v-model="accessToken"
            />
            <div
              class="text-sm text-danger-light"
              v-if="errors.accessToken"
            >
              Required
            </div>
          </div>
        </div>
        <div class="flex items-center justify-center gap-4">
          <button
            class="btn btn--dismiss"
            @click="showMercadopagoForm = false"
          >
            Cancelar
          </button>
          <button
            class="btn btn--aquagreen"
            type="submit"
          >
            Conectar
          </button>
        </div>
      </Form>
    </PluttoModal>
  </main>
</template>
<script>
import { mapState } from 'vuex';
import { Form, Field } from 'vee-validate';
import PluttoCopyableDiv from '@/components/plutto-copyable-div';
import PluttoModal from '@/components/plutto-modal';

export default {
  components: { PluttoCopyableDiv, PluttoModal, Form, Field },
  data() {
    return {
      showMercadopagoForm: false,
      publicKey: null,
      accessToken: null,
      schema: {
        publicKey: 'required',
        accessToken: 'required',
      },
    };
  },
  methods: {
    updateMercadopagoSettings() {
      const widgetSettings = {
        ...this.organization.widgetSettings,
        mercadopagoPublicKey: this.mpConnected ? null : this.publicKey,
        mercadopagoAccessToken: this.mpConnected ? null : this.accessToken,
      };
      this.$store.dispatch('UPDATE_ORGANIZATION', { ...this.organization, widgetSettings })
        .then(() => (this.showMercadopagoForm = false));
    },
  },
  computed: {
    ...mapState({
      organization: state => state.organization,
      publicApiKey: state => state.organization.publicApiKey,
    }),
    mpConnected() {
      return !!this.organization.widgetSettings.mercadopagoPublicKey &&
        !!this.organization.widgetSettings.mercadopagoAccessToken;
    },
  },
};
</script>
