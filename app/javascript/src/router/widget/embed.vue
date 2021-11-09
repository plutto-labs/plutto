<template>
  <main class="space-y-6">
    <h2 class="text-2xl">
      Design
    </h2>
    <div class="relative flex flex-wrap gap-8 z-1">
      <div
        v-for="(color, index) in colorInputs"
        :key="index"
      >
        <p class="text-sm text-temporary-gray-500">
          {{ color.label }}
        </p>
        <PluttoColorInput
          v-model="color.value"
        />
      </div>
    </div>
    <h2 class="text-2xl">
      Code
    </h2>
    <PluttoCopyableCode
      class="code"
      code-string="<div id='notifications-inbox' style='display: inline-block' />
<script type='text/javascript'>
  (function(i,s,o,g,r,a,m) {i['MagicBellObject'] = r;(i[r] =i[r] ||function() {
  (i[r].q = i[r].q || []).push(arguments);}),(i[r].l = 1 * new Date());(a = s.createElement(o)), (
  m = s.getElementsByTagName(o)[0]);a.async = 1;a.src = g;m.parentNode.insertBefore(a, m);
  })(window,document,'script','https://assets.magicbell.io/magicbell.min.js','magicbell');

  var target = document.getElementById('notifications-inbox');
  var options = {
    apiKey: '2f66fa2f2d6fd40fb0ea619ac12618a6957b4ce4',
    userEmail: 'smargozzini1@gmail.com', // @TODO Replace with the logged in user's email
    // You can use userExternalId instead of userEmail -  https://bit.ly/3oiDSAe
    onNotificationClick: function(notification) {
      if (notification.actionUrl) window.open(notification.actionUrl, '_self');
    },
    height: 500,
    theme: {'icon':{'borderColor':'#6113A3','width':'24px'},'unseenBadge':{'backgroundColor':'#DF4759'},'header':{'backgroundColor':'#6113A3','textColor':'#ffffff','borderRadius':'16px'},'footer':{'backgroundColor':'#6113A3','textColor':'#ffffff','borderRadius':'16px'},'notification':{'default':{'textColor':'#15091F','borderRadius':'8px','backgroundColor':'#6113A3'},'unseen':{'backgroundColor':'#6113A3'},'unread':{'backgroundColor':'#6113A3'}}},
  };

  magicbell('render', target, options);
</script>
"
    />
  </main>
</template>
<script>
import PluttoColorInput from '@/components/widget/plutto-color-input';
import PluttoCopyableCode from '@/components/widget/plutto-copyable-code';

export default {
  components: {
    PluttoColorInput,
    PluttoCopyableCode,
  },
  data() {
    return {
      colorInputs: [
        { key: 'primaryBackground', label: 'Primary background', value: '#FFFFFF' },
        { key: 'secondaryBackground', label: 'Secondary background', value: '#F3F3F3' },
        { key: 'primaryText', label: 'Primary text', value: '#304378' },
        { key: 'secondaryText', label: 'Secondary text', value: '#677D96' },
        { key: 'button', label: 'Button', value: '#E06B71' },
        { key: 'buttonText', label: 'Button text', value: '#FFFFFF' },
      ],
    };
  },
};
</script>
<style scoped>
.code {
  position: relative;
  z-index: -1 !important;
}
</style>
