<template lang="pug">
  select.demo__argumentInput(:name="arg.name" v-on:change="booleanChanged")
    option(:value="0") No
    option(:value="1") Yes
</template>
<script>
export default {
  props: {
    arg: {
      type: Object,
    },
    value: {
      type: Boolean,
    },
  },
  methods: {
    booleanChanged: function(e) {
      this.$emit("change", {
        name: this.arg.name,
        value: e.target.value === "1" ? true : false,
      });
    },
  },
};
</script>
