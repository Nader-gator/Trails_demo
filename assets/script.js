window.addEventListener('scroll', function () {
  localStorage.scrollX = window.scrollX;
  localStorage.scrollY = window.scrollY;
})
window.addEventListener('load', function () {
  window.scrollTo(localStorage.scrollX || 0, localStorage.scrollY || 0);
})
