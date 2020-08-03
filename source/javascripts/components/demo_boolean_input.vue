<template lang="pug">
  select.input.demo__argumentInput(:name="name" v-on:change="booleanChanged")
    option(:value="null") null
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
    name: {
      type: String,
      default: "",
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
