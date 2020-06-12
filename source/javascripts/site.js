var html = document.getElementsByTagName("html")[0];

function getCookie(cname) {
  const name = cname + "=";
  const decodedCookie = decodeURIComponent(document.cookie);
  const ca = decodedCookie.split(";");
  for (let i = 0; i < ca.length; i++) {
    const c = ca[i];
    while (c.charAt(0) == " ") {
      c = c.substring(1);
    }
    if (c.indexOf(name) == 0) {
      return c.substring(name.length, c.length);
    }
  }
  return "";
}

function setDarkMode(value) {
  var d = new Date();
  d.setTime(d.getTime() + 360 * 24 * 60 * 60 * 1000);
  document.cookie =
    "dark=" + value + "; expires=" + d.toUTCString() + "; path=/";
}

var currentDarkValue = getCookie("dark");
if (currentDarkValue == "true") {
  html.classList.add("darkMode");
}

document.addEventListener("DOMContentLoaded", function () {
  var darkModeToggler = document.getElementById("darkModeToggler");
  if (html.classList.contains("darkMode")) {
    darkModeToggler.checked = true;
  }

  darkModeToggler.addEventListener("change", function (event) {
    var checkbox = event.target;
    if (checkbox.checked) {
      html.classList.add("darkMode");
      setDarkMode(true);
    } else {
      html.classList.remove("darkMode");
      setDarkMode(false);
    }
  });
});
