import Vue from "vue";
import APIDemo from "./api_demo.vue";

window.addEventListener("load", () => {
  const node = document.querySelector("#api-demo");

  if (node) {
    let props = {};

    node.querySelectorAll("property").forEach((propNode) => {
      props[propNode.getAttribute("name")] = propNode.textContent;
    });

    new Vue({
      el: node,
      render: (c) =>
        c(APIDemo, {
          props: props,
        }),
    });
  }
});
