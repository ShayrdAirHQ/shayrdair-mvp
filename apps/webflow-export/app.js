document.getElementById("ping").addEventListener("click", () => {
  const el = document.getElementById("out");
  el.textContent = `Ping @ ${new Date().toISOString()}`;
});
