(() => {
  const links = document.querySelectorAll("a.library-link");
  if (links.length === 0) return;

  fetch("/docs/auth-check", {
    credentials: "same-origin",
    cache: "no-store",
  })
    .then((response) => {
      if (!response.ok) return;
      for (const link of links) {
        link.href = `/docs${link.hash}`;
      }
    })
    .catch(() => {});
})();
