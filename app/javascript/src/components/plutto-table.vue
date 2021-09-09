<template>
  <div class="flex flex-col">
    <div class="inline-block min-w-full align-middle">
      <div class="shadow sm:rounded-lg">
        <table class="min-w-full divide-y divide-gray-200">
          <thead class="bg-gray-700">
            <tr>
              <th
                scope="col"
                class="px-6 py-3 text-xs font-medium tracking-wider text-left uppercase text-gray-50"
                v-for="header in headers"
                :key="header.title"
              >
                {{ $t(`message.table.headers.${header.title}`) }}
              </th>
            </tr>
          </thead>
          <tbody
            class="bg-gray-800 rounded-b-lg"
            v-if="!loading"
          >
            <tr
              class="border-t-4 border-gray-900"
              v-for="(row, index) in rows"
              :key="index"
            >
              <td
                class="px-6 py-4 whitespace-nowrap"
                v-for="header in headers"
                :key="header.title"
              >
                <template v-if="header.type === 'twoLinesText'">
                  <div class="text-sm font-medium text-gray-50">
                    {{ row[header.bigText] }}
                  </div>
                  <div class="text-sm text-gray-400">
                    {{ row[header.smallText] }}
                  </div>
                </template>
                <template v-else-if="header.type === 'oneLineText'">
                  <div class="py-4 text-sm text-gray-50 whitespace-nowrap">
                    {{ row[header.title] }}
                  </div>
                </template>
                <template v-else-if="header.type === 'tag'">
                  <div
                    class="inline-flex px-2 text-xs font-semibold leading-5 rounded-full whitespace-nowrap"
                    :class="`tag-color--${header.tags[row[header.title]]}`"
                  >
                    {{ $t(`message.table.tags.${row[header.title]}`) }}
                  </div>
                </template>
                <template v-else-if="header.type === 'currency'">
                  <div class="py-4 text-sm text-gray-50 whitespace-nowrap">
                    {{ formatCurrency(row[header.title], row.currency) }}
                  </div>
                </template>
                <template v-else-if="header.type === 'date'">
                  <div class="py-4 text-sm text-gray-50 whitespace-nowrap">
                    {{ formatDateTime(row[header.title]) }}
                  </div>
                </template>
                <template v-else-if="header.type === 'action'">
                  <TrashIcon
                    v-if="header.action === 'delete'"
                    class="w-6 h-6 ml-auto cursor-pointer text-primary"
                    @click="$emit('delete-clicked', row)"
                  />
                </template>
                <template v-else-if="header.type === 'component'">
                  <slot
                    name="component"
                    :row="row"
                  />
                </template>
              </td>
            </tr>
          </tbody>
          <tbody
            class="bg-gray-800"
            v-else
          >
            <tr class="border-t-4 border-gray-900">
              <td
                :colspan="headers.length"
                class="py-8"
              >
                <PluttoLoader />
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script>
import { TrashIcon } from '@heroicons/vue/outline';
import PluttoLoader from '@/components/plutto-loader';

export default {
  components: { PluttoLoader, TrashIcon },
  props: {
    headers: {
      type: Array,
      required: true,
    },
    rows: {
      type: Array,
      required: true,
    },
    loading: {
      type: Boolean,
      default: true,
    },
  },
};
</script>
