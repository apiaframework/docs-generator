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
  data: function() {
    return {
      values: this.emptyValues(this.args),
    };
  },
  methods: {
    emptyValues: function(args) {
      let vals = {};
      args.forEach((arg) => {
        if (arg.arguments) {
          vals[arg.name] = this.emptyValues(arg.arguments);
        } else {
          vals[arg.name] = "";
        }
      });
      return vals;
    },
  },
};
</script>
