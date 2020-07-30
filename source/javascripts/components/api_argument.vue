<template lang="pug">
  div.apiDemo__argumentContainer
    div.apiDemo__argument(v-if="!arg.arguments")
      label.apiDemo__argumentLabel(:for="arg.name") {{arg.name}}
      input.apiDemo__argumentInput(:name="arg.name" v-on:change="inputChanged")
    div(v-else)
      span.apiDemo__argumentSetTitle {{arg.name}}
      APIArgument(v-for="subArg in arg.arguments" v-bind:arg="subArg" :value="value[subArg.name]" v-on:change="subArgChanged($event, subArg.name)")
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
      this.$emit("change", { name: this.arg.name, value: e.target.value });
    },
    subArgChanged: function(e, argName) {
      let newVals = this.value;
      newVals[argName] = e.value;
      this.$emit("change", { name: this.arg.name, value: newVals });
    },
  },
};
</script>
