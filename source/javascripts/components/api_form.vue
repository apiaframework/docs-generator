<template lang="pug">
  div
    div(v-for="arg in args") {{arg}}
</template>
<script>
export default {
  props: {
    args: {
      type: Array,
    },
  },
};
</script>
