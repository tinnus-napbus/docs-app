(() => {
  const redirectIndex =
    window.location.pathname === "/docs" ||
    window.location.pathname === "/docs/";
  const links = document.querySelectorAll("a.library-link");
  if (!redirectIndex && links.length === 0) return;

  fetch("/docs/auth-check", {
    credentials: "same-origin",
    cache: "no-store",
  })
    .then((response) => {
      if (redirectIndex) {
        window.location.replace(
          response.ok ? "/docs/private" : "/docs/public",
        );
        return;
      }
      if (!response.ok) return;
      for (const link of links) {
        link.href = `/docs/private${link.hash}`;
      }
    })
    .catch(() => {
      if (redirectIndex) window.location.replace("/docs/public");
    });
})();
