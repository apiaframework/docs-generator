<template lang="pug">
  div {{testVal}}
</template>
<script>
export default {
  props: {
    test: {
      type: String,
    },
  },
  data: function() {
    return {
      testVal: this.test,
    };
  },
};
</script>
