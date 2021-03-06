<template>
  <div class="flex flex-col">
    <div class="inline-block min-w-full align-middle">
      <div class="rounded-xl sm:rounded-lg">
        <table class="min-w-full border">
          <thead class="bg-melon">
            <tr>
              <th
                scope="col"
                class="px-6 py-3 text-xs font-medium tracking-wider text-left text-white uppercase"
                v-for="header in headers"
                :key="header.title"
              >
                {{ $t(`message.table.headers.${header.title}`) }}
              </th>
            </tr>
          </thead>
          <tbody
            class="divide-y divide-gray-100 rounded-b-lg bg-gray-50"
            v-if="!loading"
          >
            <tr
              v-for="(row, index) in rows"
              :key="index"
            >
              <td
                class="px-6 whitespace-nowrap"
                v-for="header in headers"
                :key="header.title"
              >
                <template v-if="header.type === 'twoLinesText'">
                  <div class="text-sm font-medium text-primary">
                    {{ row[header.bigText] }}
                  </div>
                  <div class="text-sm text-gray-500">
                    {{ row[header.smallText] }}
                  </div>
                </template>
                <template v-else-if="header.type === 'oneLineText'">
                  <div class="py-4 text-sm text-primary whitespace-nowrap">
                    {{ row[header.title] }}
                  </div>
                </template>
                <template v-else-if="header.type === 'copyableLine'">
                  <div class="py-4 text-sm text-primary whitespace-nowrap">
                    <PluttoCopyableDiv :value="row[header.title]" />
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
                  <div class="py-4 text-sm text-primary whitespace-nowrap">
                    {{ formatCurrency(row[header.title], row.currency) }}
                  </div>
                </template>
                <template v-else-if="header.type === 'link'">
                  <a
                    v-if="row[header.title] !== ''"
                    class="py-4 text-sm text-blue-700 underline whitespace-nowrap"
                    :href="row[header.title]"
                    target="_blank"
                  >
                    {{ header.text }}
                  </a>
                </template>
                <template v-else-if="header.type === 'date'">
                  <div class="py-4 text-sm text-primary whitespace-nowrap">
                    {{ formatDate(row[header.title]) }}
                  </div>
                </template>
                <template v-else-if="header.type === 'action'">
                  <span
                    v-if="header.action === 'delete'"
                    class="text-2xl cursor-pointer plutto-icon text-primary"
                    @click="$emit('delete-clicked', row)"
                  >delete_outline</span>
                  <span
                    v-if="header.action === 'edit'"
                    class="text-2xl cursor-pointer plutto-icon text-primary"
                    @click="$emit('edit-clicked', row)"
                  >edit</span>
                  <span
                    v-if="header.action === 'show'"
                    class="text-2xl cursor-pointer plutto-icon text-primary"
                    @click="$emit('show-clicked', row)"
                  >chevron_right</span>
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
            class="bg-gray-50"
            v-else
          >
            <tr class="border-t-4 border-gray-50">
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
import PluttoLoader from '@/components/plutto-loader';
import PluttoCopyableDiv from '@/components/plutto-copyable-div';

export default {
  components: { PluttoLoader, PluttoCopyableDiv },
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
