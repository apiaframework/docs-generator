<template lang="pug">
  div.demo__argumentContainer
    div.demo__argument(v-if="!arg.arguments")
      label.demo__argumentLabel(:for="argFullName" v-if="arg.required") {{arg.name}} (required)
      label.demo__argumentLabel(:for="argFullName" v-else) {{arg.name}}
      DemoBooleanInput(v-if="arg.boolean" :name="argFullName" :arg="arg" :value="value" v-on:change="componentChanged")
      DemoArrayInput(v-else-if="arg.array" :name="argFullName" :values="value" v-on:change="componentChanged")
      input.input.demo__argumentInput(v-else :autocomplete="inputAutocomplete" :id="argFullName" :name="argFullName" v-on:input="inputChanged")
    div(v-else)
      span.demo__argumentSetTitle(v-if="arg.required") {{arg.name}} (required)
      span.demo__argumentSetTitle(v-else) {{arg.name}}
      .demo__argumentSet
        DemoArgument(v-for="subArg in arg.arguments" :fullName="argFullName"  v-bind:arg="subArg" :value="subValue(subArg.name)" v-on:change="subArgChanged($event, subArg.name)")
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
    fullName: {
      type: String,
      default: "",
    },
  },
  computed: {
    inputAutocomplete: function() {
      return this.arg.name === "token" ? "off" : "on";
    },
    argFullName: function() {
      let name = "";
      if (this.fullName) {
        name += `${this.fullName}.`;
      }
      name += this.arg.name;
      return name;
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
      let newVals = this.value;
      newVals[argName] = e.value;
      this.$emit("change", { name: this.arg.name, value: newVals });
    },
    subValue: function(key) {
      if (this.value && this.value[key]) {
        return this.value[key];
      } else {
        return null;
      }
    },
  },
};
</script>
