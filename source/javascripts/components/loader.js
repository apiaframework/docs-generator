import Vue from "vue";
import APIDemo from "./api_demo.vue";

window.addEventListener("load", () => {
  const node = document.querySelector("#api-demo");

  if (node) {
    let props = {};

    node.querySelectorAll("property").forEach((propNode) => {
      if (propNode.getAttribute("type") === "json") {
        props[propNode.getAttribute("name")] = JSON.parse(propNode.textContent);
      } else {
        props[propNode.getAttribute("name")] = propNode.textContent;
      }
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
