<template lang="pug">
  div.demo__argumentContainer
    div.demo__argument(v-if="!arg.arguments")
      label.demo__argumentLabel(:for="inputID" v-if="arg.required") {{arg.name}} (required)
      label.demo__argumentLabel(:for="inputID" v-else) {{arg.name}}
      DemoBooleanInput(v-if="arg.boolean" :id="inputID" :arg="arg" :value="currentValue" v-on:change="componentChanged")
      DemoArrayInput(v-else-if="arg.array" :id="inputID" :name="arg.name" :values="currentValue" v-on:change="componentChanged")
      input.input.demo__argumentInput(v-else :id="inputID" :name="arg.name" v-on:input="inputChanged")
    div(v-else)
      span.demo__argumentSetTitle(v-if="arg.required") {{arg.name}} (required)
      span.demo__argumentSetTitle(v-else) {{arg.name}}
      .demo__argumentSet
        DemoArgument(v-for="subArg in arg.arguments" v-bind:arg="subArg" :value="subValue(subArg.name)" v-on:change="subArgChanged($event, subArg.name)")
</template>
<script>
import DemoBooleanInput from "./demo_boolean_input";
import DemoArrayInput from "./demo_array_input";

export default {
  name: "DemoArgument",
  components: {
    DemoBooleanInput: DemoBooleanInput,
    DemoArrayInput: DemoArrayInput,
  },
  props: {
    arg: {
      type: Object,
    },
    value: {
      type: [Object, String, Boolean, Array],
    },
  },
  data: function() {
    return {
      currentValue: this.value ? this.value : null,
    };
  },
  computed: {
    inputID: function() {
      return `${this.arg.name}-${Math.random()}`;
    },
  },
  methods: {
    componentChanged: function(e) {
      this.$emit("change", e);
    },
    inputChanged: function(e) {
      this.$emit("change", { name: this.arg.name, value: e.target.value });
    },
    subArgChanged: function(e, argName) {
      let newVals = this.currentValue;
      if (!newVals) {
        newVals = {};
      }
      newVals[argName] = e.value;
      this.$emit("change", { name: this.arg.name, value: newVals });
    },
    subValue: function(key) {
      if (this.currentValue && this.currentValue[key]) {
        return this.currentValue[key];
      } else {
        return null;
      }
    },
  },
};
</script>
