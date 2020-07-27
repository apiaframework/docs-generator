import Vue from "vue";
import APITest from "./api_test.vue";

window.addEventListener("load", () => {
  new Vue({
    el: "#api-test",
    template: "<APITest/>",
    components: { APITest },
  });
});
