<template lang="pug">
  div
    label {{arg.name}}
    div
      input(v-if="arg.arguments === null" :name="arg.name" v-on:change="inputChanged")
      APIArgument(v-else v-for="subArg in arg.arguments" v-bind:arg="subArg" :value="value[subArg.name]" v-on:change="subArgChanged($event, subArg.name)")
</template>
<script>
export default {
  name: "APIArgument",
  props: {
    arg: {
      type: Object,
    },
    value: {
      type: [Object, String],
    },
  },
  methods: {
    inputChanged: function(e) {
      this.$emit("change", e.target.value);
    },
    subArgChanged: function(e, argName) {
      let newVals = this.value;
      newVals[argName] = e;
      this.$emit("change", { name: this.arg.name, value: newVals });
    },
  },
};
</script>
